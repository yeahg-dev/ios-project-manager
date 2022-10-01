//
//  ProjectRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/22.
//

import Foundation

protocol ProjectRepository: AnyObject {
    
    var type: Repository { get }
    
    var historyRepository: HistoryRepository { get }

    func create(_ project: Project)
        
    func read(
        of identifier: String,
        completion: @escaping (Result<Project?, Error>) -> Void)
    
    func read(
        of group: Status,
        completion: @escaping (Result<[Project]?, Error>) -> Void)
    
    func updateContent(of project: Project, with modifiedProject: Project)
    
    func updateStatus(of project: Project, with status: Status)
        
    func delete(_ project: Project)
}

