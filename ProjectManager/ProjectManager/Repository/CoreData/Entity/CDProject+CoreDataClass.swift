//
//  CDProject+CoreDataClass.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/18.
//
//

import CoreData
import Foundation

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
            statusString = newValue?.rawValue
        }
    }
}

extension CDProject {
    
    func toDomain() -> Project {
        return Project(
            identifier: identifier,
            title: title,
            deadline: deadline,
            description: descriptions,
            status: status,
            hasUserNotification: hasUSerNotification)
    }
}
