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
    
    private init() {}
    
    // MARK: - Core Data stack
    private lazy var viewContext: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD methods
    func save(_ taskName: String) -> Task {
        let task = Task(context: viewContext)
        task.title = taskName
        saveContext()
        return task
    }
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try viewContext.fetch(fetchRequest)
            return taskList
        } catch {
            print(error.localizedDescription)
            return []
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

