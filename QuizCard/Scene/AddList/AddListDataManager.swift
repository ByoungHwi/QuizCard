//
//  AddListDataManager.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import Foundation
import CoreData
import RxSwift
import RxRelay

protocol AddListDataManagable {
    typealias Data = FolderMO
    var dataObserver: PublishRelay<[Data]> { get }
    
    func performFetch()
    
    @discardableResult
    func create(folderTitle: String) -> Bool
    
    @discardableResult
    func create(questionListTitle: String, at folderIndexPath: IndexPath) -> Bool
    
    @discardableResult
    func delete(at indexPath: IndexPath) -> Bool
}

final class AddListDataManager: NSObject, AddListDataManagable {
    private let persistenceManager = PersistenceManager.shared
    let dataObserver = PublishRelay<[AddListDataManagable.Data]>()
    
    lazy var controller: NSFetchedResultsController<FolderMO> = {
        let request: NSFetchRequest<FolderMO> = FolderMO.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistenceManager.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    override init() {
        super.init()
        controller.delegate = self
    }
}

extension AddListDataManager {
    var fetchedData: [AddListDataManagable.Data] {
        guard let data = controller.sections?.first else { return [] }
        return data.objects as? [AddListDataManagable.Data] ?? []
    }
    
    func performFetch() {
        do {
            try controller.performFetch()
        } catch {
            debugPrint(error.localizedDescription)
        }
        dataObserver.accept(fetchedData)
    }
    
    @discardableResult
    func create(folderTitle: String) -> Bool {
        guard let enity = NSEntityDescription.entity(forEntityName: FolderMO.entityName,
                                                     in: persistenceManager.context)  else {
            return false
        }
        
        let managedObject = FolderMO(entity: enity, insertInto: persistenceManager.context)
        managedObject.initialSetUp(title: folderTitle)
        
        let result = persistenceManager.saveContext()
        return result
    }
    
    @discardableResult
    func create(questionListTitle: String, at folderIndexPath: IndexPath) -> Bool {
        guard let enity = NSEntityDescription.entity(forEntityName: QuestionListMO.entityName,
                                                     in: persistenceManager.context)  else {
            return false
        }
        let folderMO = controller.object(at: folderIndexPath)
        let managedObject = QuestionListMO(entity: enity, insertInto: persistenceManager.context)
        managedObject.initialSetUp(title: questionListTitle)
        managedObject.parent = folderMO
        
        let result = persistenceManager.saveContext()
        return result
    }
    
    @discardableResult
    func delete(at indexPath: IndexPath) -> Bool {
        let object = controller.object(at: indexPath)
        return persistenceManager.delete(object)
    }
}

extension AddListDataManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataObserver.accept(fetchedData)
    }
}
