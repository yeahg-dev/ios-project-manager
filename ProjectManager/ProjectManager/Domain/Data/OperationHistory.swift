//
//  OperationHistory.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/05.
//

import Foundation

// MARK: - OperationType

enum OperationType {
    
    case add
    case move(Status)
    case remove
    
}

// MARK: - OperationHistory

struct OperationHistory {
    
    // MARK: - Property
    
    private let type: OperationType
    private let projectIdentifier: String?
    private let projectTitle: String?
    private let projectStatus: Status?
    private let date: Date
    
    var historyDescription: String {
        guard let projectTitle = self.projectTitle,
              let projectStatus = self.projects else {
            return "오류 발생"
        }
        
        switch type {
        case .add:
            return "Added '\(projectTitle)'."
        case .move(let status):
            return "Moved '\(projectTitle)' from \(projectStatus.description) to \(status.description)."
        case .remove:
            return "Removed '\(projectTitle)' from \(projectStatus.description)."
        }
    }
    
    var dateDescription: String {
        "\(date.localeString()) \(date.formattedTimeString)"
    }
    
    // MARK: - Initializer
    
    init(
        type: OperationType,
        projectIdentifier: String?,
        projectTitle: String?,
        projectStatus: Status?)
    {
        self.type = type
        self.projectIdentifier = projectIdentifier
        self.projectTitle = projectTitle
        self.projectStatus = projectStatus
        self.date = Date()
    }
    
}
