//
//  ProjectCoreDataRepository.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/17.
//

import CoreData
import UIKit
import AVFoundation

final class ProjectCoreDataRepository {
    
    // MARK: - Property
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Project")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()
    
    private lazy var context = persistentContainer.viewContext
    
    // MARK: - Method
    private func fetch<T>(of identifier: T) -> CDProject? {
        let fetchRequest = CDProject.fetchRequest()
        let identifierString = String(describing: identifier)
        let predicate = NSPredicate(format: "\(ProjectKey.identifier.rawValue) = %@", identifierString)
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest).first
        } catch  {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func fetch(of status: Status) -> [CDProject]? {
        let fetchRequest = CDProject.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: ProjectKey.deadline.rawValue, ascending: true)
        let predicate = NSPredicate(format: "statusString = %@", status.rawValue)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - ProjectRepository
extension ProjectCoreDataRepository: ProjectRepository {
   
    var type: Repository {
        get {
            return .coreData
        }
    }
    
    var historyRepository: HistoryRepository {
        return HistoryCoreDataRepository()
    }
    
    func create(_ project: Project) {
        let cdProject = CDProject(context: context)
        cdProject.identifier = project.identifier
        cdProject.title = project.title
        cdProject.descriptions = project.description
        cdProject.deadline = project.deadline
        cdProject.status = project.status
        
        self.save()
        
        self.historyRepository.createHistory(type: .add,
                                        of: project.identifier,
                                        title: project.title,
                                        status: project.status)
    }
    
    func read(of identifier: String, completion: @escaping (Result<Project?, Error>) -> Void) {
        let result = self.fetch(of: identifier)
        let project = Project(identifier: result?.identifier,
                              title: result?.title,
                              deadline: result?.deadline,
                              description: result?.descriptions,
                              status: result?.status,
                              hasUserNotification: result?.hasUSerNotification)
        completion(.success(project))
    }
    
    func read(of group: Status, completion: @escaping (Result<[Project]?, Error>) -> Void) {
        let results = self.fetch(of: group)
        let projects = results?.compactMap({ project in
            return Project(identifier: project.identifier ,
                           title: project.title,
                           deadline: project.deadline,
                           description: project.descriptions,
                           status: project.status,
                           hasUserNotification: project.hasUSerNotification)
        })
        completion(.success(projects))
    }
    
    func updateContent(of project: Project, with modifiedProject: Project) {
        guard let identifier = project.identifier else {
            return
        }
        let project = self.fetch(of: identifier)
        project?.title = modifiedProject.title
        project?.descriptions = modifiedProject.description
        project?.deadline = modifiedProject.deadline
        project?.status = modifiedProject.status
        
        self.save()
    }
    
    func updateStatus(of project: Project, with status: Status) {
        guard let identifier = project.identifier else {
            return
        }
        let project = self.fetch(of: identifier)
        let currentStatus = project?.status
        project?.status = status
        self.save()
        
        self.historyRepository.createHistory(type: .move(status),
                                        of: identifier,
                                        title: project?.title,
                                        status: currentStatus)
    }
    
    func delete(_ project: Project) {
        guard let identifier = project.identifier,
              let project = self.fetch(of: identifier),
              let title = project.title,
              let status = project.status else {
                  return
              }
        context.delete(project)
        self.save()
        
        self.historyRepository.createHistory(type: .remove,
                                        of: identifier,
                                        title: title,
                                        status: status)
    }
}
