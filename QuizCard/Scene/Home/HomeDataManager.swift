//
//  HomeDataManager.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import Foundation
import CoreData
import RxSwift
import RxRelay

protocol HomeDataManagable {
    typealias Data = [QuestionListMO]
    
    var dataObserver: PublishRelay<[Data]> { get }
    var fetchedData: [Data] { get }
    
    func performFetch()
    func fetch(at index: IndexPath) -> QuestionListType
    
    @discardableResult
    func delete(at indexPath: IndexPath) -> Bool
}

final class HomeDataManager: NSObject {
    private let persistenceManager = PersistenceManager.shared
    let dataObserver = PublishRelay<[HomeDataManagable.Data]>()
    
    lazy var controller: NSFetchedResultsController<QuestionListMO> = {
        let request: NSFetchRequest<QuestionListMO> = QuestionListMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "parent.date", ascending: true),
                                   NSSortDescriptor(key: "date", ascending: true)
        ]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistenceManager.context, sectionNameKeyPath: "sectionIdentifier", cacheName: nil)
        
        return controller
    }()
    
    override init() {
        super.init()
        controller.delegate = self
    }
}

extension HomeDataManager: HomeDataManagable {
    var fetchedData: [HomeDataManagable.Data] {
        guard let data = controller.sections else { return [] }
        return data.map { $0.objects as? [QuestionListMO] ?? [] }
    }
    
    func performFetch() {
        do {
            try controller.performFetch()
        } catch {
            debugPrint(error.localizedDescription)
        }
        dataObserver.accept(fetchedData)
    }
    
    func fetch(at index: IndexPath) -> QuestionListType {
        return controller.object(at: index)
    }
    
    @discardableResult
    func delete(at indexPath: IndexPath) -> Bool {
        let object = controller.object(at: indexPath)
        return persistenceManager.delete(object)
    }
}

extension HomeDataManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataObserver.accept(fetchedData)
    }
}
