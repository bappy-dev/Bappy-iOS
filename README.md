<br/>
<div align="center">
<h1 align="center">💛  Welcome to BAPPY's iOS APP  💛</h1>
<br/><br/><br/><br/>
<a href="https://www.newrience.site/">
  <img src="https://user-images.githubusercontent.com/87062014/182357266-06a3f66e-43fd-4d55-9651-801ff4c6179b.png" alt="Logo" height="200">
</a>
<br/>
</div>
<br/><br/><br/><br/>

## 🌼 Project
### Create the new shared experience with new freinds!   
Join hangouts and make friends wherever you are!
>
> Project Duration: 2022.05.10 ~ 
>
> App Release : Soon

<br/><br/><br/><br/>
## 🌼 Architecture

__1. UIKit + RxSwift를 이용한 MVVM 디자인 패턴__

View를 담당하는 UIViewController나 UIView에 ViewModelType 프로토콜을 준수하는 ViewModel이 1:1 대응하는 구조

View에 있는 bind() 함수에서 View에서 발생한 다양한 이벤트를 소유하고 있는 ViewModel의 Input에 Binding하고 입력 받은 이벤트를 ViewModel에서 처리하고 ViewModel의 Output을 다시 View에 Binding하여 유저에게 보여질 데이터를 표시
<br/><br/>

  ```swift
  protocol ViewModelType {
  
      associatedtype Dependency
      associatedtype Input
      associatedtype Output
    
      var dependency: Dependency { get }
      var disposeBag: DisposeBag { get set }
  
      var input: Input { get }
      var output: Output { get }
  
      init(dependency: Dependency)
  }
  ```
  
  ```swift
  class ViewModel: ViewModelType {
  
      struct Dependency {}
      struct Input {}
      struct Output {}
      
      let dependency: Dependency
      var disposeBag = DisposeBag()
      let input: Input
      let output: Output
      
      init(dependency: Dependency) {
          self.dependency = dependency
          
          // MARK: Streams
          /*
          input & output 등 로직을 위해 필요한 스트림 생성
          */
          
          // MARK: Input & Output
          self.input = Input()
          self.output = Output()
          
          // MARK: Binding
          /*
          비즈니스 로직
          */
      }
  }
  ```
  
  ```swift
  class ViewController: UIViewController {
  
      // MARK: Properties
      private let viewModel: ViewModel
      private let disposeBag = DisposeBag()
      
      // MARK: Lifecycle
      init(viewModel: ViewModel) {
          self.viewModel = viewModel
          super.init(nibName: nil, bundle: nil)
          
          bind()
      }
      
      // MARK: Bind
      private func bind() {
          /*
          1. View에서 발생하는 Event를 ViewModel의 Input에 바인딩
          2. 이벤트 처리 후 유저에게 보여질 데이터를 ViewModel의 Output에서 UI Component에 바인딩
          */
      }
  }
  
  ```
  <br/><br/>
  
  __2. 전체적인 Layer 설계__
  
|***Layer***|***Components***|***Description***|
|:----:|:----:|:----:|
|__Presentation*__|View + ViewModel|MVVM|
|__Domain*__|ViewModel + Repository(Interface) + Entity|Business Logic|
|__Data*__|Repository(Implementation) + Network + DB|Data Repository|

앱의 전반적인 Layer는 "[Clean Architecture + MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)"를 참고하여 설계하였습니다.

참고한 자료에서는 ViewModel과 UseCase를 분리하여 <br/>
ViewModel은 View를 그리는 Presentation 영역에 <br/>
UseCase는 비즈니스로직과 관련된 Domain영역에 로직을 분리하고 있지만,

이 프로젝트에서는 ViewModel이 두 로직을 모두 담당하고 있습니다.
  
<br/><br/>
  
  __3. 네트워크 Layer 설계__
  
  네트워크 관련 Layer는 "[Testable한 URLSession 설계](https://ios-development.tistory.com/719)"를 참고하여 설계하였습니다.
  
  높은 빈도로 반복적으로 네트워크 함수를 호출해야하기 때문에 재사용성과 가독성이 좋은 네트워크 Layer를 만들고 싶었습니다.<br/> 또한, API 호출은 서버에 대한 의존성을 높여 Unit Test를 불가능하게 만들기 때문에 URLSession이 아닌 URLSessionable이라는 프로토콜에 의존하여 Mock 데이터를 이용하여 Test 가능한 위 네트워크 Layer 방식을 채택하였습니다.
  
  
  
<br/><br/><br/><br/>

## 🌼 Dependency

### &nbsp;&nbsp;1. OAtuh
&nbsp;&nbsp;&nbsp;🔘&nbsp; __FirebaseAuth:__ &nbsp;Firebase JWT토큰 인증

&nbsp;&nbsp;&nbsp;🔘&nbsp; __GoogleSignIn:__ &nbsp;Google 소셜 로그인

&nbsp;&nbsp;&nbsp;🔘&nbsp; __FacebookLogin:__ &nbsp;Facebook 소셜 로그인

&nbsp;&nbsp;&nbsp;🔘&nbsp; __AuthenticationServices:__ &nbsp;Apple 소셜 로그인

<br/>

### &nbsp;&nbsp;2. Push Notification
&nbsp;&nbsp;&nbsp;🔘&nbsp; __FirebaseMessaging:__ &nbsp;Firebase Cloud Messaging 알림

<br/>

### &nbsp;&nbsp;3. Remote Configuration
&nbsp;&nbsp;&nbsp;🔘&nbsp; __FirebaseRemoteConfig:__ &nbsp;Firebase Remote Config, 긴급 공지 팝업, 앱 최소버전 확인

<br/>

### &nbsp;&nbsp;4. Log Analysis
&nbsp;&nbsp;&nbsp;🔘&nbsp; __FirebaseAnalytics:__ &nbsp;Firebase Analytics, 로그 수집

<br/>

### &nbsp;&nbsp;5. Reactive Programming
&nbsp;&nbsp;&nbsp;🔘&nbsp; __RxSwift:__ &nbsp;Data Stream을 관찰하며 반응형 프로그래밍 제공

&nbsp;&nbsp;&nbsp;🔘&nbsp; __RxDataSources:__ &nbsp;Animatable UITableViewCell과 UICollectionViewCell의 Binding

&nbsp;&nbsp;&nbsp;🔘&nbsp; __RxCLLocationManager:__ &nbsp;위치 정보를 처리하는 CLLocationManager의 Rx Wrapper

&nbsp;&nbsp;&nbsp;🔘&nbsp; __RxKeyboard:__ &nbsp;키보드 높이를 Rx의 이벤트로 방출

<br/>

### &nbsp;&nbsp;6. AutoLayout
&nbsp;&nbsp;&nbsp;🔘&nbsp; __SnapKit:__ &nbsp;코드 기반 UI 설계

<br/>

### &nbsp;&nbsp;7. ImageCaching
&nbsp;&nbsp;&nbsp;🔘&nbsp; __Kignfishier:__ &nbsp;네트워크 비동기 이미지 불러오기 및 이미지 캐싱

<br/>

### &nbsp;&nbsp;8. Animation
&nbsp;&nbsp;&nbsp;🔘&nbsp; __Lottie:__ &nbsp;JSON 애니메이션

<br/>

### &nbsp;&nbsp;9. Progress
&nbsp;&nbsp;&nbsp;🔘&nbsp; __ProgressHUD:__ &nbsp;네트워크 통신 중 인디케이터 표시

<br/>

### &nbsp;&nbsp;10. PhotoPicker
&nbsp;&nbsp;&nbsp;🔘&nbsp; __YPImagePicker:__ &nbsp;멀티이미지 및 Crop 기능 지원 


<br/><br/><br/><br/>

## 🌼 Notice

해당 Commit 시점에서는 서버 개발이 완료되지 않아 완료 시점 이전에 동작 확인을 원하시는 경우, <br/>
"Data - Repository 구현체 실제 API 모드 전환" Commit 이전 <br/>  Mock Data를 반환하는  Commit을 Clone하여 사용해주시길 바랍니다.

또한, 미리 협의한 내용으로 API Endpoint를 제작하였기 때문에 실제 연동 확인이 필요하고,<br/>
필요시 EndPoint 수정이 필요할 것입니다.

수정은 해당 프로젝트 디렉토리 Bappy - Data - Network의 APIEndpoints.swift 및 하위 디렉토리<br/> DataMapping의 각 RequestDTO 및 ResponseDTO들의 내용 일부를 수정해주시면 됩니다.

로그인, 회원가입, 프로필 수정, 이미지 불러오기 API는 서버와 연동을 확인하였습니다.

<br/>
