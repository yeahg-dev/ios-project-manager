//
//  HistoryInMemoryRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/24.
//

import Foundation

class HistoryInMemoryRepository: HistoryRepository {
    
    var updateUI: (() -> Void) = {}
    
    private var historys: [[String?: String?]] = []
    
    var historyCount: Int {
        return historys.count
    }
    
    func fetchHistorys() {
        //
    }
    
    func readHistory(of inedx: Int) -> [String?: String?]? {
        return self.historys[inedx]
    }
    
    func createHistory(type: OperationType, of projectIdentifier: String?, title: String?, status: Status?) {
        let newHistory = OperationHistory(type: type, projectIdentifier: projectIdentifier, projectTitle: title, projectStatus: status)
        let history = ["description": newHistory.historyDescription,
                       "date": newHistory.dateDescription]
        historys.insert(history, at: 0)
        print(newHistory.historyDescription + newHistory.dateDescription)
    }
}
