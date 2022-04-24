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
    private var historyStorage = HistoryStorage()
}

// MARK: - ProjectRepository
extension ProjectInMemoryRepository: ProjectRepository {
    
    var type: Repository {
        get {
            return .inMemory
        }
    }
    
    func create(_ project: Project) {
        guard let identifier = project.identifier else {
            return
        }
        self.projects.updateValue(project, forKey: identifier)
        
        self.makeHistory(of: project, type: .add)
    }
    
    func read(of identifier: String, completion: @escaping (Result<Project?, Error>) -> Void) {
        completion(.success(projects[identifier]))
    }
    
    func read(of group: Status, completion: @escaping (Result<[Project]?, Error>) -> Void) {
        let projects = projects.values.filter { project in project.status == group }
        completion(.success(projects))
    }
    
    func updateContent(of project: Project, with modifiedProject: Project) {
        guard let identifier = project.identifier else {
            return
        }
        
        self.projects.updateValue(modifiedProject, forKey: identifier)
    }
    
    func updateStatus(of project: Project, with status: Status) {
        guard let identifier = project.identifier,
              var updatingProject = projects[identifier] else {
            return
        }
        
        updatingProject.updateStatus(with: status)
        self.projects.updateValue(updatingProject, forKey: identifier)
        
        self.makeHistory(of: project, type: .move(status))
    }
   
    func delete(_ project: Project) {
        guard let identifier = project.identifier else {
            return
        }
        
        self.projects.removeValue(forKey: identifier)
        
        self.makeHistory(of: project, type: .remove)
    }
    
    private func makeHistory(of project: Project, type: OperationType) {
        self.historyStorage.makeHistory(type: type,
                                        of: project.identifier,
                                        title: project.title,
                                        status: project.status)
    }
}
