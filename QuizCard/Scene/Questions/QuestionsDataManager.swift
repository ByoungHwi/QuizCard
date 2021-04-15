//
//  QuestionsDataManager.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import Foundation
import CoreData
import RxSwift
import RxRelay

protocol QuestionsDataManagable {
    typealias Data = QuestionMO
    var dataObserver: PublishRelay<[Data]> { get }
    var fetchedData: [Data] { get }
    
    func performFetch()
    
    @discardableResult
    func delete(at indexPath: IndexPath) -> Bool
    
    @discardableResult
    func create(question: String, answer: String) -> Bool
}

final class QuestionsDataManager: NSObject {
    private let persistenceManager = PersistenceManager.shared
    let dataObserver = PublishRelay<[QuestionsDataManagable.Data]>()
    var questionList: QuestionListType?
    private var listMO: QuestionListMO? {
        questionList as? QuestionListMO
    }
    
    init(targetList: QuestionListType?) {
        questionList = targetList
        super.init()
        controller.delegate = self
    }
    
    lazy var controller: NSFetchedResultsController<QuestionMO> = {
        let request: NSFetchRequest<QuestionMO> = QuestionMO.fetchRequest()
        if let questionListID = questionList?.id {
            request.predicate = NSPredicate(format: "parent.id == %@", questionListID as CVarArg)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistenceManager.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
}

extension QuestionsDataManager: QuestionsDataManagable {
    var fetchedData: [QuestionsDataManagable.Data] {
        guard let data = controller.sections?.first else { return [] }
        return data.objects as? [QuestionsDataManagable.Data] ?? []
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
    func delete(at indexPath: IndexPath) -> Bool {
        let object = controller.object(at: indexPath)
        return persistenceManager.delete(object)
    }
    
    @discardableResult
    func create(question: String, answer: String) -> Bool {
        guard let enity = NSEntityDescription.entity(forEntityName: QuestionMO.entityName,
                                                     in: persistenceManager.context)  else {
            return false
        }
        
        let managedObject = QuestionMO(entity: enity, insertInto: persistenceManager.context)
        managedObject.initialSetUp(questionText: question, answerText: answer)
        managedObject.parent = listMO
        
        let result = persistenceManager.saveContext()
        return result
    }
}

extension QuestionsDataManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataObserver.accept(fetchedData)
    }
}
