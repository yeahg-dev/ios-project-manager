//
//  HistoryRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/04/05.
//

import Foundation

protocol HistoryRepository: AnyObject {
    
    var historyCount: Int { get }
    
    func readHistory(of inedx: Int) -> [String?: String?]?
    
    func createHistory(type: OperationType,
                              of projectIdentifier: String?,
                              title: String?,
                              status: Status?)
}
