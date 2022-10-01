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
    private (set) var deadline: Timestamp?
    private (set) var description: String?
    private (set) var statusRawValue: String?
    private (set) var hasUserNotification: Bool? = false
    
    
    init(
        identifier: String?,
        title: String? = nil,
        deadline: Timestamp? = nil,
        description: String? = nil,
        statusRawValue: String? = nil,
        hasUserNotification: Bool? = false)
    {
        self.identifier = identifier
        self.title = title
        self.deadline = deadline
        self.description = description
        self.statusRawValue = statusRawValue
        self.hasUserNotification = hasUserNotification
    }
    
    init(dict: [String: Any]) {
        self.deadline = dict[ProjectKey.deadline.rawValue] as? Timestamp
        self.identifier = dict[ProjectKey.identifier.rawValue] as? String
        self.title = dict[ProjectKey.title.rawValue] as? String
        self.description = dict[ProjectKey.description.rawValue] as? String
        self.statusRawValue = dict[ProjectKey.status.rawValue] as? String
        self.hasUserNotification = dict[ProjectKey.hasUserNotification.rawValue] as? Bool
    }
    
    func toDomain() -> Project? {
        guard let deadlineTimestamp = self.deadline,
              let statusRawValue = self.statusRawValue else {
            return nil
        }
        let deadline = Date(timeIntervalSince1970: TimeInterval(deadlineTimestamp.seconds))
        return Project(
            identifier: self.identifier,
            title: self.title,
            deadline: deadline,
            description: self.description,
            status: Status(rawValue: statusRawValue),
            hasUserNotification: self.hasUserNotification)
    }
    
    func toEntity() -> [String: Any] {
        var dict = [String: Any]()
        dict.updateValue(
            identifier as Any,
            forKey: ProjectKey.identifier.rawValue)
        dict.updateValue(
            self.title as Any,
            forKey: ProjectKey.title.rawValue)
        dict.updateValue(
            self.deadline as Any,
            forKey: ProjectKey.deadline.rawValue)
        dict.updateValue(
            self.description as Any,
            forKey: ProjectKey.description.rawValue)
        dict.updateValue(
            self.statusRawValue as Any,
            forKey: ProjectKey.status.rawValue)
        dict.updateValue(
            self.hasUserNotification as Any,
            forKey: ProjectKey.hasUserNotification.rawValue)
        return dict
    }
}

// MARK: - Extension

extension Project {
    
    func toDTO() -> ProjectDTO? {
        guard let deadline = self.deadline else {
            return nil
        }
        
        return ProjectDTO(
            identifier: self.identifier,
            title: self.title,
            deadline:  Timestamp(date: deadline),
            description: self.description,
            statusRawValue: self.status?.rawValue,
            hasUserNotification: self.hasUserNotification)
    }
}
