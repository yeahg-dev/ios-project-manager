//
//  ProjectPersistentContainer.swift
//  ProjectManager
//
//  Created by 1 on 2022/07/15.
//

import CoreData
import Foundation

enum ProjectPersistentContainer {
    
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Project")
        container.loadPersistentStores(
            completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    print(error.localizedDescription)
                }
            })
        return container
    }()
    
    static var context = ProjectPersistentContainer.persistentContainer.viewContext
}
