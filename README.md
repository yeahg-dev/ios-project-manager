# ☀️ 해 (할 일 관리 앱)

> 기 또는 클라우드에 할 일을 저장하고 관리를 도와주는 생산성 앱

- [1. 프로젝트 소개](#1-프로젝트-소개) 
- [2. 설계 개요](#2-설계-개요)
- [3. 트러블 슈팅](#3-트러블-슈팅) 

# 1. 프로젝트 소개
##  1) 진행
- 개발자 : [릴리](https://github.com/yeahg-dev) (개인 프로젝트)
- 코드 리뷰 진행 / 리뷰어 : [엘림](https://github.com/lina0322)


##  2) 코드 리뷰
| STEP    | 구현                            | PR                                                           |
| ------- | ------------------------------- | ------------------------------------------------------------ |
| STEP1   | 기술 스택 선정                  | https://github.com/yagom-academy/ios-project-manager/pull/80 |
| STEP2-1 | Model 정의, 할 일 CRUD, UI 구현 | https://github.com/yagom-academy/ios-project-manager/pull/95 |
| STEP2-2 | Local/Remote DB구현             | https://github.com/yagom-academy/ios-project-manager/pull/112 |

## 3) 구현 기능

> **`할 일` 생성 및 상태 별 `칸반 보드`로 보기**
> - `UITableViewDiffableDataSource`의 `snapShot`을 사용해 효율적 뷰 업데이트 구현
> <img src = "https://user-images.githubusercontent.com/81469717/179402384-aaa90c00-9dca-44ab-839b-c416ab848973.gif" width = "400" >

> **`할 일` 수정**
> - `UILongPressGestureRecognizer`로 제스쳐 액션 구현
> <img src = "https://user-images.githubusercontent.com/81469717/179402470-39b1a256-9f09-4f95-a2b2-12c41daf56a5.gif" width = "400" >

> **`할 일` 삭제**
> - `UISwipeActionsConfiguration`로 스와이프 액션 구현
> <img src = "https://user-images.githubusercontent.com/81469717/179402491-fa3d30a5-efbc-4f02-b9a0-3e7f389b0fa9.gif" width = "400" >

> **`저장소` 설정**
> - `ProjectRepository`프로토콜에 저장소의 공통 행동 정의 
> <img src = "https://user-images.githubusercontent.com/81469717/179402498-656a8202-35b9-4e8a-bd3d-1e3add869126.gif" width = "400" >

> **`사용자 알림` 설정**
> - `UserNotifications`프레임워크 사용
> <img src = "https://user-images.githubusercontent.com/81469717/179402501-3339a938-5b3f-4d7a-a72e-70a437871b8d.gif" width = "400" >

> **`변경 내역` 기록**
> -  변경내역의 CRUD를 관리하는 `HistoryRepository`타입 설계
> - `Xib`로 커스텀 셀 생성
> <img src = "https://user-images.githubusercontent.com/81469717/179402507-7d95d83b-53ce-44b8-8ce8-0d7acdab50a7.gif" width = "400" >

> **`다크 모드` 지원**
> - Asset의 `ColorSet`, `traitCollection`을 사용한 모드별 컬러 설정
> <img src = "https://user-images.githubusercontent.com/81469717/179402510-6565d835-f190-4965-9f6f-77ee4bd1c25c.gif" width = "400" >


<br>

# 2. 설계 개요

## 1) 개발 환경
- 배포 타겟: iOS 14.0
- UIKit, Code base UI
- Database : CoreData, Firebase
- 의존성 관리 툴 : SPM

<br>

## 2) 프레임워크 선택 시 고려사항

### CoreData
- 애플의 first-party 프레임워크로 안정적으로 사용이 가능
- NSFetchedResultController 와 함께 사용하여 데이터 변화에 따른 뷰의 동기화 가능
- 오프라인에서도 안정적인 사용성을 지원

### Firebase - Firestore
- Cloud와 실시간 동기화를 제공
- 구글이 운영하는 라이브러리로 현재 많은 기업에서 사용, 안정적 운용 가능
- NoSQL DB로 쿼리가 빈약하여 데이터 검색이 어렵다는 단점 존재. 빅데이터를 관리해야하는 서비스의 경우 불편함이 있을 수 있으나, 이번 프로젝트의 경우 간단한 쿼리만 사용될 것이라 생각하여 포용가능 할 것이라 판단
- 현재에도 꾸준하게 업데이트 되고 있는 라이브러리. 개선, 유지보수 가능성 보장

<br>

## 3) 아키텍처
### MVC
<img width="717" alt="스크린샷 2022-07-17 오후 10 17 04" src="https://user-images.githubusercontent.com/81469717/179402665-01876e65-7be4-47d1-8845-89a3c7026e9e.png">

## 4) Framework에 독립적인 `Repository` 프로토콜 정의  
- InMemory, CoreData, Firestore 3개의 데이터 소스를 사용해야 함
- 데이터 소스의 공통 프로퍼티, CRUD 메서드 명세 `ProjectRepository` 프로토콜 정의
- 도메인은 프로토콜을 참조, 사용 (의존성 역전)
-  프레임워크와 모델간 의존성 분리 효과를 경험

### ProjectDTO로 프레임워크와 도메인의 의존성 분리
- Firebase로부터 받은 `Document`타입을 wrapping하기 위한 `ProjectDTO` 타입 정의
- `toDomain()` 을 호출하여 앱에서 사용되는  모델 `Project` 로 변환

<img width="700" alt="스크린샷 2022-07-17 오후 11 24 28" src="https://user-images.githubusercontent.com/81469717/179402882-fe6a55be-50fb-455d-8116-76bf2a7f4d76.png">

<br>

#  3. 트러블 슈팅

## 1) MVC에서 역할 분리하여 UI 재사용 하기 
### todo, doing, done 테이블뷰
**상황**

- `Todo`, `Doing`, `Done` 3개의 테이블뷰는 공동된 UI와 로직, 액션(상태 수정, 알림 설정, 수정화면으로 전환)을 가집니다.
- `ProjectListViewController`를 재사용하고자 했습니다.

**해결 방법**

- `ProjectListViewController`가 각 테이블뷰의 모델인 `Status`를 주입받도록 합니다.
- `ProjectListViewController`는 TableView를 그리고, 사용자 액션을 정의합니다.
- 사용자 액션에 따른 비즈니스 로직의 실행은 Delegate인 부모에게 위임합니다. 
-  `Todo`, `Doing`, `Done`을 주입한 3개의 `ProjectListViewController`를 생성하고, 각 상태에 해당하는 데이터 Delegate로부터 읽어와 뷰에 바인딩했습니다. 

```swift
// 부모인 MainViewController가 채택하여 구현, 비지니스 로직은 MainVC에서만 일어나도록 역할 분리
protocol ProjectListViewControllerDelegate: AnyObject {
    
    func readProject(
        of status: Status,
        completion: @escaping (Result<[Project]?, Error>)
        -> Void)
    
    func updateProject(of project: Project, with content: [String: Any])
    
    func updateProjectStatus(of project: Project, with status: Status)
    
    func deleteProject(_ project: Project)
    
    func registerUserNotification(of project: Project)
    
    func removeUserNotification(of project: Project)
}
```

**결과**

- `ProjectListViewController`에서 상태별로 다른 액션 Title을 제공하기 위해 여전히 분기처리가 필요했습니다.
- 뷰와 모델이 결합되어 역할 분리가 어려운 MVC 패턴의 단점을 이해할 수 있었습니다. 

<br>

### 할 일 생성 / 수정 뷰

<img width="778" alt="image" src="https://user-images.githubusercontent.com/81469717/218263254-51a72257-9803-45c2-9f15-5cda11973e93.png">

**상황**

`할 일 생성`, `할 일 수정` 뷰는 동일한 UI를 공유하지만, navigationBar와 버튼이 실행하는 로직이 다릅니다.


**해결 방법**

- `ProjectDetailDelegate`에 버튼의 타이틀과 버튼 액션을 정의하고, delegate가 처리하도록 구현했습니다.
- 생성 뷰와 수정 뷰의 델리게이트를 다르게 지정함으로써, `ProjectDetailVC`를 재사용할 수 있었습니다.

<br>

## 2) adaptive한 TableView 구현하기

**상황**

`HistoryTableViewController`의 popover사이즈가 history 갯수에 따라 adaptive한 높이를 가지도록 구현하고자 했습니다.


**해결 방법**

- `tableView(_: ,cellForRowAt:)`내부에서  cell을 리턴하기전 self.view.setNeedsLayout()를 호출했습니다
- 다음 드로잉사이클 때 바뀐 테이블 뷰의 사이즈를 반영하여 한번만 레이아웃을 업데이트 하도록 수정했습니다.

[해당 Issue thread](https://github.com/yeahg-dev/ios-project-manager/issues/16)
