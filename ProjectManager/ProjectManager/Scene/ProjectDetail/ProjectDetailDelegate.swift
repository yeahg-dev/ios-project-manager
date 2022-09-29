//
//  ProjectDetailDelegate.swift
//  ProjectManager
//
//  Created by 1 on 2022/07/15.
//

import UIKit

// MARK: - ProjectDetailDelegate

protocol ProjectDetailDelegate: AnyObject{
    
    func barTitle() -> String
    
    func rightBarButtonItem() -> UIBarButtonItem.SystemItem
    
    func leftBarButtonItem() -> UIBarButtonItem.SystemItem
    
    func didTappedrightBarButtonItem(
        of project: Project?,
        projectContent: [String: Any])
    
}

// MARK: - ProjectCreationDelegate

protocol ProjectCreationDelegate: ProjectDetailDelegate {

}

// MARK: - ProjectEditDelegate

protocol ProjectEditDelegate: ProjectDetailDelegate {

}
