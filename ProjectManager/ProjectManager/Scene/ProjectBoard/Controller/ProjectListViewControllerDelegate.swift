//
//  ProjectListViewControllerDelegate.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/09.
//

import Foundation

protocol ProjectListViewControllerDelegate: AnyObject {
    
    func readProject(
        of status: Status,
        completion: @escaping (Result<[Project]?, Error>) -> Void)
    
    func updateProject(of project: Project, with content: [String: Any])
    
    func updateProjectStatus(of project: Project, with status: Status)
    
    func deleteProject(_ project: Project)
    
    func registerUserNotification(of project: Project)
    
    func removeUserNotification(of project: Project)
}
