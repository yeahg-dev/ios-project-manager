# 🏁프로젝트 관리 앱

목차
- [STEP 1️⃣ : 기술스택 선정](#step-1️⃣)
- [STEP 2️⃣-1 : MVC설계 및 UI구현](#step-2️⃣-1)

## About

### contributors
👩🏻‍💻개발 @yeahg-dev

🙌🏻리뷰어 @lina0322

### schedule
2022년 2월 28일 ~ 2022년 2월 13일

### commit message convention
Karma스타일을 기본으로 `project`타입 추가

- feat : 새로운 기능 추가 
- fix : bug fix 
- docs : 문서 수정 
- style : 코드의 스타일 변화
- refactor : 리팩터링
- test : 테스트 코드 추가. 수정
- chore : 중요하지 않은 일
- project : Xcode project, info-plist 설정

### Tech  stack

구분 | 적용 기술
:---: | :---:
아키텍처 | MVC
UI | UIKit
Local DB | Core Data
Cloud DB | Firestore, FirebaseAuth, FirebaseAnaylitcs   
의존성 관리 툴 | SPM

<br>

# STEP 1️⃣ 

### 🙌🏻 PR
[STEP1 PR](https://github.com/yagom-academy/ios-project-manager/pull/80)

<br>

### 📝 학습 개념
- DB 구현 위한 다양한 라이브러리 및 프레임워크 분석
- Xcode의 project와 target의 개념과 차이점

<br>

### ✅ 로컬 DB, 클라우드 DB 구현을 위한 기술 스택 선정
구분 | 적용 기술
:---: | :---:
로컬 DB | Core Data
클라우드 DB | Firebase - Firestore

#### 선정 이유 -  Firestore

- Cloud와 실시간 동기화를 제공합니다.
- 다양한 기술을 지원합니다 (PushNotification, Analytics...)
- 클라이언트 접속 상태를 지원합니다.
클라이언트 연결 상태를 기록하고 클라이언트의 연결 상태가 변경될 때마다 업데이트를 제공할 수 있습니다. (realtimeDatabase와 함께 사용시 가능)
- 컬렉션으로 정리된 document 단위로 데이터 관리를 합니다. 계층적 데이터를 구조화하기엔 document 방식이 더 용이하고, 확장성이 좋을 것 같아 JSON트리로 데이터를 관리하는 realtime database 대신 firestore를 선택했습니다.
- Firestore외 FirebaseAuth, FirebaseAnaylitcs를 추가적으로 설치함으로서 인증을 위한 구현 비용을 줄이고, 사용자 앱 사용에 대한 데이터를 모니터링이 가능해졌습니다.

#### 선정 이유 -  Core data
2. Core Data
- 애플의 first-party 프레임워크로 안정적으로 사용이 가능합니다.
- NSFetchedResultController 와 함께 사용하여 데이터 변화에 따른 뷰의 동기화를 처리할 수 있습니다.

Firestore가 앱에서 자주 사용하는 데이터를 캐싱함으로서 오프라인 데이터 접근성을 지원한다고하여, LocalDB도 Firestore로 구현할까 고민이 되었었습니다. 그런데 로컬 캐싱의 메모리는 제한적이므로 데이터가 삭제될 수 있는 리스크가 있을거라 생각했습니다. 오프라인에서도 안정적인 사용성을 지원하고 싶어 LocalDB는 CoreData로 따로 구현하게 되었습니다.

<br>

### 🤔 고민한 점
**1. 이 앱의 요구기능에 적절한 선택인가?**

Firestore: 리모트와 실시간 동기화를 지원합니다. 더불어 프로젝트를 여럿이 공유할 경우, 여러 사용자가 동시에 접근하여 데이터를 수정 관리 가능합니다.

Coredata: persistence data를 저장하기 위한  애플의 프레임워크로 로컬 DB를 구현하기에 적합합니다.

**2. 하위 버전 호환성에는 문제가 없는가?**

Firestore: iOS10 이상 지원하고 있으며, [2022년 기준 OS점유율](https://developer.apple.com/kr/support/app-store/)로 보았을 때 무리없이 하위 버전의 OS와 호환이 가능할 것이라 판단했습니다. (타겟 버전은 14.0으로 설정했습니다)

Coredata: iOS 3.0 이상 지원하므로 문제 없습니다!

**3. 안정적으로 운용 가능한가?**

Firestore: 구글이 운영하는 라이브러리로 현재 많은 기업에서 사용하고 있는 것으로 알고 있습니다.

Coredata: iOS의 first-party DB이므로 iOS와 운명을 함께 합니다.

**4. 미래 지속가능성이 있는가?**

Firestore: 현재에도 꾸준하게 업데이트 되고 있는 라이브러리로, 앞으로도 개선, 유지보수가 될 것이라 생각합니다.

Coredata: 애플이 제공하는 Framework로 WWDC와 함께 꾸준히 업데이트될 것이라 생각합니다.

**5. 리스크를 최소화 할 수 있는가? 알고있는 리스크는 무엇인가?**

Firebase: NoSQL DB로 쿼리가 빈약하여 데이터 검색이 어렵다는 글들을 보았습니다. 빅데이터를 관리해야하는 서비스의 경우 불편함이 있을 수 있으나, 이번 프로젝트의 경우 간단한 쿼리만 사용될 것이라 생각하여 포용가능 할 것 같습니다.

Coredata: 아직 찾지 못하였습니다

**6. 어떤 의존성 관리도구를 사용하여 관리할 수 있는가?**

Firebase: Cocoapods, SPM, Carthage으로 사용할 수 있습니다. 이전 프로젝트에서 Cocoapod을 사용해본 적이 있어서, first-party인 도구를 사용해보고 싶어서 SPM을 선택했습니다.

<br>

# STEP 2️⃣-1
## 🗺 MVC 설계

![157486108-856bcca4-ba0a-4d30-8225-0176978228c5](https://user-images.githubusercontent.com/81469717/160266978-e62e802a-3312-4751-aa1c-7868aff6f524.jpeg)


#### 설계 설명, 의도

- MVC 아키텍쳐 적용
- 비지니스 로직을 구현한 `ProjectManager`를 rootViewController인 `ProjectBoardViewController`만 참조하도록 설계
- `ProjectBoardViewController`의 자식 뷰컨트롤러에서 받은 사용자 이벤트는 델리게이트 패턴을 통해 모델인 `ProjectManager`에게 알림
- 위와 같이 설계한 의도는 컨트롤러는 데이터를 뷰에게 전달하고, 사용자 이벤트를 모델에게 전달하는 역할만하도록 통제함으로써 컨트롤러의 역할을 줄여주게 함 + 비지니스로직을 최대한 한 곳에서만 관리하도록 함

#### 문제점

- `ProjectBoardViewController`가 결국 자식 뷰컨들의 델리게이트가 되면서 루트 뷰컨의 역할이 비대해지는 문제 발생
- 중첩 델리게이트 패턴으로 한눈에 앱의 흐름을 파악하기 어려운 문제 발생



#### 개선 방안

- 모델을 자식뷰컨에게 넘겨줌으로써 중첩델리게이트를 줄임
  - 모델이 클래스이고 참조 객체라면 자식 뷰컨에게 넘겨주는 방법 또한 괜찮다고 피드백을 받음
- 모델의 역할을 프로토콜로 분리하여, 자식 뷰컨에서 필요한 기능만 사용할 수 있도록 제한

<br>

## 🔨 구현 기능
1.  Array로 구현한 CRUD	
    - `+`버튼으로 프로젝트 생성화면 표시, `DONE`탭하면 새로운 프로젝트 객체 생성
    -  프로젝트 탭하면 프로젝트 수정화면 표시, `DONE`탭하면 프로젝트 업데이트
    -  프로젝트 길게 터치시 프로젝트 상태 수정 popover 표시
    -  프로젝트 셀 왼쪽으로 스와이프시 삭제 
2. 지역화(Localization)를 적용, 언어/지역에 따라 날짜 변환
3. 데드라인 경과한 프로젝트 날짜는 빨간글자로 표시

<br>

## 📝 학습 개념
1. `UIDatePicker`
2. 날짜 표기법과 Localization
3. `inset` `offset`
4. `UIWindow` `UIScreen` `UIScene` 의 차이점
5. `UITableViewDiffableDataSource`, `NSDiffableDataSourceSnapshot`
6. `UITableViewHeaderFooterView`
7. `UINavigationBarDelegate`
8. `CALayer`로 그림자 효과 주기
9. `UILongPressGestureRecognizer`


<br>

## 🚀 Trouble Shooting
### 1. `UITableViewDiffableDataSource` 사용 시 `HeaderView`업데이트
[해당 Issue](https://github.com/yeahg-dev/ios-project-manager/issues/8)

**문제 상황**

<img width="736" alt="스크린샷 2022-03-27 오후 1 08 48" src="https://user-images.githubusercontent.com/81469717/160266981-cf9e3975-f9df-4b65-a72c-8556e55c8539.png">


TableView의 Header를 커스텀하게 만들기 위해 UITableViewHeaderFooterView를 서브클래스를 만들어서,
tableViewDelegate에서 지정.
Project의 CRUD가 일어날 때 마다 프로젝트 갯수를 카운팅하는 Header의 projectCountLabel을 업데이트 해주어야함.

TableViewDelegate의 `tableView(_:viewForHeaderInSection:)`메서드 내에서 CountLabel을 설정해주었지만,
CRUD가 일어날 때 위 메서드가 호출되지 않음. 


**시도 1️⃣**

UITableViewDiffableDataSource 레벨에서 처리해주기 위해 API를 찾아봤지만,
UITableViewDiffableDataSource에서는 UICollectionViewDiffableDataSource와는 달리 SupplementaryView를 설정해주는 API가 제공되지 않고 있음

**시도 2️⃣**

UITableView의 reloadData( )로 Header를 업데이트 할 수 있었지만, reloadData( )는 모든 Section과 Row를 그리는 무거운 작업이고,
diff만 계산해서 효율적으로 뷰를 그려주는 UIDiffableDataSource의 이점을 살리지 못하는 방법이라고 생각

**✅ 해결 방법**

UITableViewDelegate로 UITableViewHeaderFooterView를 리턴하는 방법 포기
HeaderView를 뷰 컨트롤러의 프로퍼티로 구현한 뒤, UITableView위에 배치했습니다.
Cell의 CRUD가 일어날 때마다 HeaderView의 updateProjectCells() 를 업데이트

<br>

### 2. `UITextView`에 `shadow`적용시 Contents가 이탈하는 문제

[해당 Issue](https://github.com/yeahg-dev/ios-project-manager/issues/9)

**문제 상황**

UITextView에 그림자를 넣기 위해 `layer.masksToBound = false` 를 하면
bound영역 밖의 text들도 보여지는 문제가 발생

**✅ 해결 방법**

bounds를 벗어난 TextView의 textContainer에 대해서만 invisible하게 하는 방법을 찾는 것을 시도 했도했지만 가능한 API가 없었음

따라서 TextView를 담는 Container View를 만들고, Container View에 그림자효과를 줌으로써  해결


<br>


## 🙌🏻 PR후 개선 사항

[STEP2 PR](https://github.com/yagom-academy/ios-project-manager/pull/95)

#### 1. `TodoViewController` `DoingViewController` `DoneViewController`를`ListViewController` 구현하여 중복 코드 최소화

 `TodoViewController` `DoingViewController` `DoneViewController`는 현재 동일한 UI로 그려지기 때문에 중복되는 코드가 많았다. 따라서 현재 중복되는 코드를 최소화하기 위해  `ListViewController` 상위 클래스를 생성하고, 초기자에서 `projectStatus`를 주입하여 주었다.

#### 2. `DetailViewController` `CreatorViewController`의 상위 클래스 `ProjectViewController`구현하여 중복 코드 최소화

프로젝트 수정화면과 생성화면을 담당하는  `DetailViewController` `CreatorViewController`의 UI는 구조는 동일하지만, `BarButton`과 제공하는 기능이 다름.

UI 관련 동일 코드의 중복을 줄이기 위해 `ProjectViewController`에 공통된 기능을 구현하고,  다른 행동은 `EditDelegate` `CreatorDelegate`를 각각 구현

#### PR후 수정된 UML

<br>

