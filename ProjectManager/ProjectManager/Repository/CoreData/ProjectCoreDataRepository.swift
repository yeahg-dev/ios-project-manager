//
//  ProjectCoreDataRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/17.
//

import CoreData
import UIKit

final class ProjectCoreDataRepository {
    
    // MARK: - Property
    
    private let persistentContainer = ProjectPersistentContainer.persistentContainer
    private let backgroundContext = ProjectPersistentContainer.backgroundContext
    
    // MARK: - Method
    
    private func fetch<T>(
        of identifier: T,
        completion: @escaping (CDProject?) -> Void)
    {
        backgroundContext.perform {
            let fetchRequest = CDProject.fetchRequest()
            let identifierString = String(describing: identifier)
            let predicate = NSPredicate(format: "\(ProjectKey.identifier.rawValue) = %@", identifierString)
            fetchRequest.predicate = predicate
            
            do {
                let project = try self.backgroundContext.fetch(fetchRequest).first
                completion(project)
            } catch  {
                print("Error fetching project in coredata\(error.localizedDescription)")
                return
            }
        }
    }
    
    private func fetch(
        of status: Status,
        completion: @escaping ([CDProject]?) -> Void )
    {
        backgroundContext.perform {
            let fetchRequest = CDProject.fetchRequest()
            let sortDescriptor = NSSortDescriptor(
                key: ProjectKey.deadline.rawValue,
                ascending: true)
            let predicate = NSPredicate(format: "statusString = %@", status.rawValue)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.predicate = predicate
            
            do {
                let projects = try self.backgroundContext.fetch(fetchRequest)
                completion(projects)
            } catch  {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    private func save() {
        backgroundContext.perform {
            if self.backgroundContext.hasChanges {
                do {
                    try self.backgroundContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - ProjectRepository

extension ProjectCoreDataRepository: ProjectRepository {
   
    var type: Repository {
        get {
            .coreData
        }
    }
    
    var historyRepository: HistoryRepository {
        HistoryCoreDataRepository()
    }
    
    // MARK: - CRUD
    
    func create(_ project: Project) {
        backgroundContext.perform {
            let cdProject = CDProject(context: self.backgroundContext)
            cdProject.identifier = project.identifier
            cdProject.title = project.title
            cdProject.descriptions = project.description
            cdProject.deadline = project.deadline
            cdProject.status = project.status
            cdProject.hasUSerNotification = project.hasUserNotification ?? false
        }
        
        save()
        
        historyRepository.createHistory(type: .add,
                                        of: project.identifier,
                                        title: project.title,
                                        status: project.status)
    }
    
    func read(
        of identifier: String,
        completion: @escaping (Result<Project?, Error>) -> Void)
    {
        fetch(of: identifier){ (project) in
            completion(.success(project?.toDomain()))
        }
    }
    
    func read(
        of group: Status,
        completion: @escaping (Result<[Project]?, Error>) -> Void)
    {
        fetch(of: group) { results in
            let projects = results?.compactMap({ project in
                project.toDomain()
            })
            completion(.success(projects))
        }
    }
    
    func updateContent(
        of project: Project,
        with modifiedProject: Project)
    {
        guard let identifier = project.identifier else {
            return
        }
            
        fetch(of: identifier) { project in
            project?.title = modifiedProject.title
            project?.descriptions = modifiedProject.description
            project?.deadline = modifiedProject.deadline
            project?.status = modifiedProject.status
            project?.hasUSerNotification = modifiedProject.hasUserNotification ?? false
            
            self.save()
        }
    }
    
    func updateStatus(
        of project: Project,
        with status: Status)
    {
        guard let identifier = project.identifier else {
            return
        }
        fetch(of: identifier) { project in
            let currentStatus = project?.status
            project?.status = status
            
            self.save()
            
            self.historyRepository.createHistory(
                type: .move(status),
                of: identifier,
                title: project?.title,
                status: currentStatus)
        }
        
    }
    
    func delete(_ project: Project) {
        guard let identifier = project.identifier else {
                  return
              }
        
        fetch(of: identifier) { project in
            guard let project = project,
                  let title = project.title,
                  let status = project.status else {
                return
            }
            
            self.backgroundContext.delete(project)
            self.save()
            
            self.historyRepository.createHistory(type: .remove,
                                            of: identifier,
                                            title: title,
                                            status: status)
        }
    }
    
}
