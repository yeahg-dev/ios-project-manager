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
    
    private let type: OperationType
    private let target: Project
    private let date: Date
    
    init(type: OperationType, target: Project) {
        self.type = type
        self.target = target
        self.date = Date()
    }
    
    var historyDescription: String {
        let title = self.target.title ?? "제목없음"
        let currentStatus = self.target.status?.description ?? ""
        
        switch type {
        case .add:
            return "Added '\(title)'."
        case .move(let status):
            return "Moved '\(title)' from \(currentStatus) to \(status.description)."
        case .remove:
            return "Removed '\(title)' from \(currentStatus)."
        }
    }
    
    var dateDescription: String {
        return "\(date.localeString()) \(self.date.formattedTimeString)"
    }
}

