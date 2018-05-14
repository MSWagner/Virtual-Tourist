//
//  DataController.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 13.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import CoreData
import PKHUD

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
                HUD.flash(.label("Database Error, your entries cannot be saved"), delay: 1.0)

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
