//
//  CDProject+CoreDataClass.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/18.
//
//

import Foundation
import CoreData

@objc(CDProject)
public class CDProject: NSManagedObject {
    
    var status: Status? {
        get {
            guard let statusString = statusString else {
                return nil
            }
            return Status(rawValue: statusString)
        }
        set {
            self.statusString = newValue?.rawValue
        }
    }
}

extension CDProject {
    
    func toDomain() -> Project {
        return Project(identifier: self.identifier,
                       title: self.title,
                       deadline: self.deadline,
                       description: self.descriptions,
                       status: self.status,
                       hasUserNotification: self.hasUSerNotification)
    }
}
