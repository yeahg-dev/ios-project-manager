//
//  HistoryInMemoryRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/24.
//

import Foundation

struct HistoryInMemoryRepository {
    
    private var historys: [[String: String]] = []
    
    var numberOfHistory: Int {
        return historys.count
    }
    
    func readHistory(of inedx: Int) -> [String: String] {
        return self.historys[inedx]
    }
    
    mutating func makeHistory(type: OperationType, of projectIdentifier: String?, title: String?, status: Status?) {
        let newHistory = OperationHistory(type: type, projectIdentifier: projectIdentifier, projectTitle: title, projectStatus: status)
        let history = ["description": newHistory.historyDescription,
                       "date": newHistory.dateDescription]
        historys.append(history)
        print(newHistory.historyDescription + newHistory.dateDescription)
    }
}
