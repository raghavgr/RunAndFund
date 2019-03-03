//
//  CoreDataStack.swift
//  Run And Fund
//
//  Created by Sai Grandhi on 3/3/19.
//  Copyright © 2019 Vikas Radhakrishna Shetty. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RunAndFund")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
