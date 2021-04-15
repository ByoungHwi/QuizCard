//
//  PersistenceManager.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import Foundation
import CoreData

final class PersistenceManager {
    
    static let modelName: String = "QuizCardModel"
    static var shared = PersistenceManager()
    
    private init() { }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let data = try context.fetch(request)
            return data
        } catch {
            debugPrint(error.localizedDescription)
            return []
        }
    }
    
    @discardableResult
    func delete(_ object: NSManagedObject) -> Bool {
        context.delete(object)
        let result = saveContext()
        return result
    }
    
    func saveContext() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
    }
}
