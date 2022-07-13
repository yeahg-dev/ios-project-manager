//
//  ProjectDTO.swift
//  ProjectManager
//
//  Created by 1 on 2022/07/13.
//

import Foundation

import Firebase

struct ProjectDTO {
    
    let identifier: String?
    private (set) var title: String?
    private (set) var deadline: Date?
    private (set) var description: String?
    private (set) var status: Status?
    private (set) var hasUserNotification: Bool? = false
    
    init?(dict: [String: Any]) {
        guard let deadline = dict[ProjectKey.deadline.rawValue] as? Timestamp else {
            return nil
        }
        
        let deadlineDate = Date(timeIntervalSince1970: TimeInterval(deadline.seconds))
        self.identifier = dict[ProjectKey.identifier.rawValue] as? String
        self.title = dict[ProjectKey.title.rawValue] as? String
        self.deadline = deadlineDate
        self.description = dict[ProjectKey.description.rawValue] as? String
        self.status = dict[ProjectKey.status.rawValue] as? Status
        self.hasUserNotification = dict[ProjectKey.hasUserNotification.rawValue] as? Bool
    }
    
    func toDomain() -> Project {
        return Project(identifier: self.identifier,
                       title: self.title,
                       deadline: self.deadline,
                       description: self.description,
                       status: self.status,
                       hasUserNotification: self.hasUserNotification)
    }
}
