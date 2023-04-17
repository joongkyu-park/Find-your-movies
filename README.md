# 영화 검색 앱 토이 프로젝트
- [OMDb(Open Movie Database) API](https://www.omdbapi.com/)를 이용한 앱입니다.  
영화를 검색하고 즐겨찾기를 추가하여 관리할 수 있습니다.  
즐겨찾기의 영화들은 드래그&드롭으로 순서를 조정할 수 있습니다.
- 프로젝트 기간 : 22.12.13 ~ 22.12.19
- *커밋 이력은 Private 저장소에 따로 기록되어 있습니다.* 

## 개발 환경
- Xcode 13.4
- Swift 5.6
- Deployment Target : iOS 12.0
- 써드파티 라이브러리 관리 : CocoaPods

## 기술
- 라이브러리
    - Alamofire
    - Reusable
    - RxSwift, RxCocoa, RxDataSources
    - SnapKit
    - SwiftLint
- 로컬 데이터 관리
    - Core Data

## 실행 방법
- ```pod install```이 필요합니다.

## 기능 소개
- 검색
    - 검색을 통해 관련된 영화를 가져올 수 있습니다.
    - 검색 창에서 새로운 검색어를 입력할 때 스크롤이 맨 위로 올라갑니다.
    - 검색 중(키보드가 올라온 상태) 키보드는 다음 상황에 내려갑니다.
        - 검색(enter) 버튼을 누를 때
        - 검색 중 키보드 바깥 화면을 터치할 때
- 즐겨찾기
    - 영화는 즐겨찾기가 가능합니다.
    - 즐겨찾기에 등록된 영화이면, 셀 우측 상단에 '하트' 아이콘이 표시됩니다.
    - 즐겨찾기 목록은 Core Data를 통해 디바이스에 저장됩니다.  
    따라서 앱 재실행 시에도 즐겨찾기 목록은 유지되며, 검색 화면에서도 즐겨찾기된 영화는 '하트' 아이콘 표시가 유지됩니다.
    - 즐겨찾기 등록/해제는 영화 클릭 시 Alert을 통해 진행할 수 있습니다.
    - 즐겨찾기 목록에서 영화들의 순서를 Drag&Drop으로 조절할 수 있습니다.   
    이 순서는 Core Data를 통해 디바이스에 저장되므로, 앱 재실행 시에도 조절된 순서를 유지합니다.

## 사용 예시
![](https://user-images.githubusercontent.com/60916423/231805393-4521fb25-db08-46c4-ba7b-a01442e79031.gif)
![](https://user-images.githubusercontent.com/60916423/231805456-f712927e-5635-40e8-be22-ac1276d1c8bc.gif)

