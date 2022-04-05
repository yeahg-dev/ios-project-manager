//
//  HistoryStorage.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/05.
//

import Foundation

struct HistoryStorage {
    
    private var historys: [OperationHistory]?
    
    var numberOfHistory: Int {
        return historys?.count ?? 0
    }
    
    func readHistory(of inedx: Int) -> OperationHistory? {
        return self.historys?[inedx]
    }
    
    mutating func makeHistory(about project: Project, type: OperationType) {
        let newHistory = OperationHistory(type: type, target: project)
        self.historys?.append(newHistory)
    }
    
    mutating func deleteHistory(of index: Int) {
        historys?.remove(at: index)
    }
}
