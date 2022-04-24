//
//  HistoryRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/05.
//

import Foundation

protocol HistoryRepository {
    
    var numberOfHistory: Int { get }
    
    func readHistory(of inedx: Int) -> OperationHistory?
    
    mutating func createHistory(type: OperationType,
                              of projectIdentifier: String?,
                              title: String?,
                              status: Status?)
}
