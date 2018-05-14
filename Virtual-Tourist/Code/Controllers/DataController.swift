//
//  DataController.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 13.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import CoreData

class DataController {

    let persistentController: NSPersistentContainer

    static let shared = DataController(modelName: "Virtual_Tourist")

    var viewContext: NSManagedObjectContext {
        return persistentController.viewContext
    }

    init(modelName: String) {
        persistentController = NSPersistentContainer(name: modelName)
    }

    func load(completion: (() -> Void)? = nil) {
        persistentController.loadPersistentStores { storeDescription, error in
            print("LoadPersistentStores")
            print("StoreDescription: \(storeDescription.debugDescription)")
            guard error == nil else {
                fatalError("FatalError: \(error!.localizedDescription)")
            }
            self.autoSaveViewContext()
            completion?()
        }
    }

    @discardableResult
    func saveContext() -> Bool {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                return true
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                return false
            }
        }
        return true
    }
}

// TODO: save() and hasChanges for viewContext as Extension

// MARK: AutoSave
extension DataController {

    private func autoSaveViewContext(interval: TimeInterval = 30) {
        guard interval > 0 else {
            print("Error in DataController: TimeIntervall cannot be negative for autosave")
            return
        }

        saveContext()

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
