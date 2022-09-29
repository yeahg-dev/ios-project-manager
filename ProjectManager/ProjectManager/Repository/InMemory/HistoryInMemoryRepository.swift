//
//  HistoryInMemoryRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/24.
//

import Foundation

final class HistoryInMemoryRepository: HistoryRepository {
    
    // MARK: - Property
    
    var updateUI: (() -> Void) = { }
    var historyCount: Int {
        return historys.count
    }
    
    private var historys: [[String?: String?]] = []
    
    // MARK: - CRUD Method
    
    func fetchHistorys() { }
    
    func readHistory(of inedx: Int) -> [String?: String?]? {
        return self.historys[inedx]
    }
    
    func createHistory(
        type: OperationType,
        of projectIdentifier: String?,
        title: String?,
        status: Status?) {
        let newHistory = OperationHistory(
            type: type,
            projectIdentifier: projectIdentifier,
            projectTitle: title,
            projectStatus: status)
        let history = ["description": newHistory.historyDescription,
                       "date": newHistory.dateDescription]
        historys.insert(history, at: 0)
    }
}
