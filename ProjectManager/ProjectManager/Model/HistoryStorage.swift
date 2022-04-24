//
//  HistoryStorage.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/05.
//

import Foundation

struct HistoryStorage {
    
    private var historys: [OperationHistory] = []
    
    var numberOfHistory: Int {
        return historys.count
    }
    
    func readHistory(of inedx: Int) -> OperationHistory? {
        return self.historys[inedx]
    }
    
    mutating func makeHistory(type: OperationType, of projectIdentifier: String?, title: String?, status: Status?) {
        let newHistory = OperationHistory(type: type, projectIdentifier: projectIdentifier, projectTitle: title, projectStatus: status)
        historys.append(newHistory)
        print(newHistory.historyDescription + newHistory.dateDescription)
    }
}
