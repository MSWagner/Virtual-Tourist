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

    var backgroundContext: NSManagedObjectContext!

    init(modelName: String) {
        persistentController = NSPersistentContainer(name: modelName)
    }

    private func configureContexts() {
        backgroundContext = persistentController.newBackgroundContext()

        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true

        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    func load(completion: (() -> Void)? = nil) {
        persistentController.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
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

        if viewContext.hasChanges {
            try? viewContext.save()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
