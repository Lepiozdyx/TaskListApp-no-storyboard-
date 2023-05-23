//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Alex on 19.05.2023.
//

import Foundation
import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let viewContext: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    
    private init() {}
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD methods
    func create(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = taskName
        completion(task)
        saveContext()
    }
    
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try viewContext.fetch(fetchRequest)
            completion(.success(taskList))
        } catch {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func update(_ taskName: Task, with title: String) {
        taskName.title = title
        saveContext()
    }
    
    func delete(_ taskName: Task) {
        viewContext.delete(taskName)
        saveContext()
    }
    
}

