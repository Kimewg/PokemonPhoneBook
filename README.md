# PokemonPhoneBook
연락처 앱 (PhoneBook App)
이 앱은 사용자가 연락처 정보를 추가하고, Core Data를 사용하여 연락처 데이터를 저장 및 관리하는 기능을 제공합니다. 또한, Pokémon API를 통해 랜덤 이미지를 가져와 연락처에 할당할 수 있습니다.

주요 기능
연락처 추가: 이름, 전화번호, 프로필 이미지(랜덤 이미지 생성)를 입력하여 연락처를 추가할 수 있습니다.

연락처 목록: 저장된 연락처 목록을 테이블 뷰에 표시합니다.

이미지 랜덤 생성: 버튼을 클릭하여 Pokémon API에서 랜덤 이미지를 가져와 프로필 사진으로 설정할 수 있습니다.

Core Data 사용: 연락처 데이터는 Core Data를 사용하여 영구적으로 저장됩니다.

기술 스택
UIKit: iOS 기본 UI 프레임워크

SnapKit: 레이아웃 제약을 코드로 작성하는 라이브러리

Core Data: 데이터 영속성을 위한 프레임워크

Pokémon API: 랜덤 이미지와 관련된 데이터를 가져오기 위해 사용

앱 구성
ViewController

연락처 목록을 보여주는 메인 화면입니다.

Core Data에서 저장된 연락처 데이터를 테이블 뷰로 표시합니다.

연락처 추가 버튼을 누르면 PhoneBookViewController로 이동합니다.

PhoneBookViewController

새로운 연락처를 추가하는 화면입니다.

이름, 전화번호를 입력받고, Pokémon API에서 랜덤 이미지를 가져와 연락처에 추가합니다.

연락처가 추가되면 Core Data에 저장됩니다.

TableViewCell

각 연락처를 표시하는 테이블 뷰 셀입니다.

프로필 이미지, 이름, 전화번호를 표시합니다.

Core Data Entity

PhoneBook 엔티티는 이름, 전화번호, 이미지 데이터를 저장합니다.

화면 구성
메인 화면 (ViewController): 연락처 목록이 테이블 형식으로 표시됩니다.

연락처 추가 화면 (PhoneBookViewController): 연락처 이름, 전화번호를 입력하고, 랜덤 프로필 이미지를 생성하여 추가할 수 있습니다.
