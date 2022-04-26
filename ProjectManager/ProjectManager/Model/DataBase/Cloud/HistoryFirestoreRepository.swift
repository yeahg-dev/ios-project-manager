//
//  HistoryFirestoreRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/24.
//

import Foundation

struct HistoryFirestoreRepository: HistoryRepository {
    
    var historyCount: Int {
        return 0
    }
    
    func readHistory(of inedx: Int) -> OperationHistory? {
        <#code#>
    }
    
    mutating func createHistory(type: OperationType, of projectIdentifier: String?, title: String?, status: Status?) {
        <#code#>
    }
}
