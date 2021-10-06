//
//  Persistance.swift
//  CoreDataSample
//
//  Created by gdaalumno on 06/10/21.
//

import CoreData

struct PersistanceController{
    static let shared = PersistanceController()
    
    let container: NSPersistentContainer
    
    init(){
        //Core Data only:
        container = NSPersistentContainer(name: "MealsList")
        
        //iCloud only:
        //container = NSPersistentCloudKitContainer(name: "MealsList")
        
        container.loadPersistentStores{ (storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error: \(error)")
            }
        }
        
        //iCloud only:
        
        //container.viewContext.automaticallyMergesChangesFromParent = true
        //container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
    }
}
