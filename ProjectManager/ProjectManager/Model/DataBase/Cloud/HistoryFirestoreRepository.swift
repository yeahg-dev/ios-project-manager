//
//  HistoryFirestoreRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/24.
//

import Foundation

class HistoryFirestoreRepository: HistoryRepository {
 
    var historyCount: Int {
        return 0
    }
    
    func readHistory(of inedx: Int) -> [String? : String?]? {
        return nil
    }
    
    func createHistory(type: OperationType, of projectIdentifier: String?, title: String?, status: Status?) {
        //
    }
}
