//
//  ProjectInMemoryRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/06.
//

import Foundation

final class ProjectInMemoryRepository {
    
    // MARK: - Property
    
    private var projects: [String: Project] = [:]
    let history = HistoryInMemoryRepository()
}

// MARK: - ProjectRepository

extension ProjectInMemoryRepository: ProjectRepository {
    
    var type: Repository {
        get {
            return .inMemory
        }
    }
    
    var historyRepository: HistoryRepository {
        history
    }
    
    // MARK: - CRUD Method
    
    func create(_ project: Project) {
        guard let identifier = project.identifier else {
            return
        }
        projects.updateValue(project, forKey: identifier)
        
        makeHistory(of: project, type: .add)
    }
    
    func read(
        of identifier: String,
        completion: @escaping (Result<Project?, Error>)-> Void)
    {
        completion(.success(projects[identifier]))
    }
    
    func read(
        of group: Status,
        completion: @escaping (Result<[Project]?, Error>) -> Void)
    {
        let projects = projects.values.filter { project in project.status == group }
        completion(.success(projects))
    }
    
    func updateContent(of project: Project, with modifiedProject: Project) {
        guard let identifier = project.identifier else {
            return
        }
        
        projects.updateValue(modifiedProject, forKey: identifier)
    }
    
    func updateStatus(of project: Project, with status: Status) {
        guard let identifier = project.identifier,
              var updatingProject = projects[identifier] else {
            return
        }
        
        updatingProject.updateStatus(with: status)
        projects.updateValue(updatingProject, forKey: identifier)
        
        makeHistory(of: project, type: .move(status))
    }
    
    func delete(_ project: Project) {
        guard let identifier = project.identifier else {
            return
        }
        
        projects.removeValue(forKey: identifier)
        
        makeHistory(of: project, type: .remove)
    }
    
    private func makeHistory(of project: Project, type: OperationType) {
        self.historyRepository.createHistory(
            type: type,
            of: project.identifier,
            title: project.title,
            status: project.status)
    }
    
}
