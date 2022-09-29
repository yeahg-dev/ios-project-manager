//
//  ProjectBoardScene.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/15.
//

import Foundation

enum ProjectBoardScene: String {
    
    case mainTitle =  "해"
    case historyTitle = "History"
    case projectStatus = "진도 변경"
    
    enum ErrorAlert: String {
        
        case title = "할 일을 불러올 수 없어요"
        case confirm = "확인"
        
    }
    enum UserNotificationConfig: String {
        
        case title = "알림 설정"
        case none = "없음"
        case yes = "당일(오전 9시)"
    }
    
    enum StatusModification: String {
        
        case todo = "곧 할 거에요"
        case doing = "하는 중이에요"
        case done = "다 했어요"
    }
    
}
