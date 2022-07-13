//
//  Project.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/06.
//

import Foundation
import UIKit

enum ProjectKey: String {
    
    case identifier, title, description, deadline, status, hasUserNotification
}

struct Project {
    
    // MARK: - Property
    let identifier: String?
    private (set) var title: String?
    private (set) var deadline: Date?
    private (set) var description: String?
    private (set) var status: Status?
    private (set) var hasUserNotification: Bool? = false
    
    var isExpired: Bool {
        let currentDate = Date()
        guard let deadline = self.deadline else {
           return false
        }
        return deadline < currentDate
    }
    
    var deadlineColor: UIColor {
        get {
            if status == .done {
                return .black
            }
            if isExpired == true {
                return .systemRed
            } else {
                return .black
            }
        }
    }
    
    // MARK: - Method
    mutating func updateContent(with content: [String: Any]) {
        for (key, value) in content {
            switch key {
            case ProjectKey.title.rawValue:
                self.title = value as? String
            case ProjectKey.description.rawValue:
                self.description = value as? String
            case ProjectKey.deadline.rawValue:
                self.deadline = value as? Date
            case ProjectKey.status.rawValue:
                self.status = value as? Status
            case ProjectKey.hasUserNotification.rawValue:
                self.hasUserNotification = value as? Bool
            default:
                continue
            }
        }
    }
    
    mutating func updateStatus(with status: Status) {
        self.status = status
    }
}

// MARK: - Hashable
extension Project: Hashable {
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(identifier)
       }
}

// MARK: - Codable
extension Project: Codable {
    
    enum CodingKeys: String, CodingKey {
        case identifier, title, description, deadline, status, hasUserNotification
    }
}

