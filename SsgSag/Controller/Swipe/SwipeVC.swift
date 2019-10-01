import UIKit
import Lottie
import SwiftKeychainWrapper
import AdBrixRM

class SwipeVC: UIViewController {
    
    @IBOutlet weak var swipeCardView: UIView!
    
    @IBOutlet private var countLabel: UILabel!
    
    @IBOutlet private var overLapView: UIView!
    
    @IBOutlet weak var settingBoardButton: UIBarButtonItem!
    
    lazy private var posters: [Posters] = []
    private var numberOfSwipe = 0
    
    private static let numberOfTopCards = 2
    
    private var currentLoadedCardsArray = [SwipeCard]()
    
    private var lastCardIndex: Int = 0
    
    private var currentIndex = 0
    private var ssgsagCount = 0
    
    private var countTotalCardIndex = 0
    
    private var posterServiceImp: PosterService
        = DependencyContainer.shared.getDependency(key: .posterService)
    
    private var lastDeletedSwipeCard: SwipeCard?
    
    private var isOkayToUndo: Bool = false
    
    private lazy var completeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        if self.ssgsagCount == 0 {
            label.text = "오늘은 추천해드릴 포스터가 없네요.\n캘린더를 확인해볼까요?"
        } else {
            label.text = "오늘 \(self.ssgsagCount)장의 카드를\n슥삭했어요!"
        }
        
        label.textColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var viewAllPostersButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("전체 포스터 보기", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1), for: .normal)
        button.layer.cornerRadius = 24
        button.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self,
                         action: #selector(touchUpViewAllPostersButton),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var moveToCalendarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("캘린더 바로가기", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self,
                         action: #selector(touchUpMoveToCalendarButton),
                         for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        
        let shadowSize = CGSize(width: self.view.frame.width, height: 3)
        navigationController?.navigationBar.addColorToShadow(color: #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1),
                                                             size: shadowSize)
        tabBarController?.tabBar.isHidden = false
        
        guard let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool else {
            return
        }
        
        if isTryWithoutLogin {
            settingBoardButton.image = nil
            settingBoardButton.title = "나가기"
            settingBoardButton.setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont(name: "Helvetica",
                                                     size: 15.0)],
                for: .normal
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestPoster(isFirst: true)
        
        setCountLabelText()
        
        setView()
        
        UIView.appearance().isExclusiveTouch = true
    }

    private func setView() {
        view.backgroundColor = .white
    }
    
    private func setEmptyPosterAnimation() {
        let animation = AnimationView(name: "main_empty_hifive")
        
        let completeStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 10
            return stackView
        }()
        
        let spaceView = UIView()
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        
        completeStackView.addArrangedSubview(animation)
        completeStackView.addArrangedSubview(completeLabel)
        completeStackView.addArrangedSubview(spaceView)
        completeStackView.addArrangedSubview(viewAllPostersButton)
        completeStackView.addArrangedSubview(moveToCalendarButton)
        view.addSubview(completeStackView)

        completeStackView.centerXAnchor.constraint(
            equalTo: view.centerXAnchor).isActive = true
        completeStackView.centerYAnchor.constraint(
            equalTo: view.centerYAnchor).isActive = true
        completeStackView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 40).isActive = true
        completeStackView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -40).isActive = true
        
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.widthAnchor.constraint(
            equalToConstant: 170).isActive = true
        animation.heightAnchor.constraint(
            equalToConstant: 170).isActive = true
        
        spaceView.heightAnchor.constraint(
            equalToConstant: 15).isActive = true
        
        viewAllPostersButton.heightAnchor.constraint(
            equalToConstant: 48).isActive = true
        viewAllPostersButton.widthAnchor.constraint(
            equalToConstant: 202).isActive = true
        
        moveToCalendarButton.heightAnchor.constraint(
            equalToConstant: 48).isActive = true
        moveToCalendarButton.widthAnchor.constraint(
            equalToConstant: 202).isActive = true
        
        animation.play()
    }
    
    //FIXME: - CategoryIdx가 3이거나 5일때 예외를 만든다.
    private func requestPoster(isFirst: Bool) {

        posterServiceImp.requestSwipePosters { [weak self] response in
            switch response {
            case .success(let posterdata):
                guard let posters = posterdata.posters,
                    let numberOfSwipe = posterdata.userCnt else {
                    return
                }
                self?.posters = posters
                self?.countTotalCardIndex = self?.posters.count ?? 0
                self?.ssgsagCount = numberOfSwipe
                
                DispatchQueue.main.async {
                    self?.loadCardAndSetPageVC(isFirst: isFirst)
                    self?.setCountLabelText()
                }
            case .failed(let error):
                print(error)
                return
            }
        }
    }
    
    //캘린더 이동
    @objc func touchUpMoveToCalendarButton() {
        tabBarController?.selectedIndex = 2
    }
    
    @objc func touchUpViewAllPostersButton() {
        navigationController?.pushViewController(AllPostersListViewController(), animated: true)
    }
    
    private func loadCard(isFirst: Bool) {
        if !isFirst {
            currentLoadedCardsArray.removeAll()
        }
        
        for (index, poster) in posters.enumerated() {
            if index < SwipeVC.numberOfTopCards {
                guard let photoURL = poster.photoUrl else {
                    return
                }
                
                let newCard = createSwipeCard(at: index, value: photoURL)
                currentLoadedCardsArray.append(newCard)
                lastCardIndex = index
            }
        }
    }
    
    private func setSwipeCardSubview() {
        for (i, _) in currentLoadedCardsArray.enumerated() {
            if i > 0 {
                swipeCardView.insertSubview(currentLoadedCardsArray[i],
                                            belowSubview: currentLoadedCardsArray[i - 1])
            } else {
                swipeCardView.addSubview(currentLoadedCardsArray[i])
            }
        }
    }
    
    
    //카드를 로드한다.
    private func loadCardAndSetPageVC(isFirst: Bool) {
        
        if posters.count > 0 {
            if !isFirst && swipeCardView != nil {
                swipeCardView.subviews.map({ $0.removeFromSuperview() })
            }
            
            loadCard(isFirst: isFirst)
            
            setSwipeCardSubview()
            
            setPageVCAndAddToSubView()
        } else {
            if !isFirst {
                view.subviews.map({ $0.removeFromSuperview() })
            }
            setEmptyPosterAnimation()
        }
    }
    
    private func addNewCard() {
        let totalNumberOfPosters = posters.count - 1
        
        if totalNumberOfPosters >= lastCardIndex {
            guard let photoURL = posters[lastCardIndex].photoUrl else {
                return
            }
            
            //print("\(posters[lastCardIndex].period)")
            
            let newCard = createSwipeCard(at: lastCardIndex, value: photoURL)
            currentLoadedCardsArray.append(newCard)
        }
    }
    
    private func loadCardValuesAfterRemoveObject() {
        
        setCountValue(addOrUndo: .add)
        
//        self.currentLoadedCardsArray[0]
//        self.addChild(<#T##childController: UIViewController##UIViewController#>)
        
        // MARK: - 이것을 하지 않으면 detailimage, detailtext 컨트롤러가 메모리에서 삭제되지 않는다.
        self.children.first?.removeFromParent()
        currentLoadedCardsArray.remove(at: 0)
        setCountLabelText()
        
        //등호가 올바른 것인지 확인 바람
        addNewCard()
        
        setSwipeCardSubview()
        
        setPageVCAndAddToSubViewAfterRemove()
    }
    
    //SwipeCard 생성
    private func createSwipeCard(at index: Int , value: String) -> SwipeCard {
        let card = SwipeCard(
            frame: CGRect(x: 15,
                          y: (swipeCardView.frame.size.height - swipeCardView.frame.size.height * 0.95) / 2,
                          width: swipeCardView.frame.size.width - 30,
                          height: swipeCardView.frame.size.height * 0.95),
            value: value
        )
        card.delegate = self
        
        return card
    }
    
    // FIXME: - DetailImage에서 메모리 오류를 발견했습니다.
    private func setPageVCAndAddToSubViewAfterRemove() {
        if currentLoadedCardsArray.count > 1 {
            let swipeStoryboard = UIStoryboard(name: StoryBoardName.swipe,
                                               bundle: nil)
            
            guard let pageVC = swipeStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.pageViewContrller) as? PageViewController else {
                return
            }
            
            guard let detailImageSwipeCardVC = pageVC.orderedViewControllers[1] as? DetailImageSwipeCardVC else {
                return
            }
            
            detailImageSwipeCardVC.delegate = self
            
            guard let detailTextSwipeCard = pageVC.orderedViewControllers[0] as? DetailNewTextSwipeCard else {
                return
            }
            
            let pageVCx: CGFloat = 0
            let pageVCy: CGFloat = 0
            let pageVCWidth: CGFloat = self.currentLoadedCardsArray[1].frame.width
            let pageVCHeight: CGFloat = self.currentLoadedCardsArray[1].frame.height
            
            pageVC.view.frame = CGRect(x: pageVCx, y: pageVCy, width: pageVCWidth, height: pageVCHeight)
            
            if posters.count > lastCardIndex {
                
                detailTextSwipeCard.poster = posters[lastCardIndex]
                
                detailImageSwipeCardVC.poster = posters[lastCardIndex]
        
                self.addChild(pageVC)
                
                self.currentLoadedCardsArray[1].insertSubview(pageVC.view,
                                                              at: 0)
                pageVC.didMove(toParent: self)
            }
        } else if currentLoadedCardsArray.count == 0 {
            setEmptyPosterAnimation()
        }
    }
    
    //처음에만 0, 1로 로드한다.
    private func setPageVCAndAddToSubView() {
        
        for (i, _) in currentLoadedCardsArray.enumerated() {
            
            let swipeStoryboard = UIStoryboard(name: StoryBoardName.swipe,
                                               bundle: nil)
            
            guard let pageVC
                = swipeStoryboard.instantiateViewController(
                    withIdentifier: ViewControllerIdentifier.pageViewContrller
                    ) as? PageViewController else {
                return
            }
            
            guard let detailImageSwipeCardVC
                = pageVC.orderedViewControllers[1] as? DetailImageSwipeCardVC else {
                return
            }
            
            guard let detailTextSwipeCard
                = pageVC.orderedViewControllers[0] as? DetailNewTextSwipeCard else {
                return
            }
            
            detailImageSwipeCardVC.delegate = self
            
            let pageVCx: CGFloat = 0
            let pageVCy: CGFloat = 0
            let pageVCWidth: CGFloat = currentLoadedCardsArray[i].frame.width
            let pageVCHeight: CGFloat = currentLoadedCardsArray[i].frame.height
            
            pageVC.view.frame = CGRect(x: pageVCx,
                                       y: pageVCy,
                                       width: pageVCWidth,
                                       height: pageVCHeight)
            
            setDetailSwipeCardAndSwipeCardVC(of: detailTextSwipeCard,
                                             of: detailImageSwipeCardVC,
                                             by: posters[i])
            
            addChild(pageVC)
            currentLoadedCardsArray[i].addSubview(pageVC.view)
            pageVC.didMove(toParent: self)
        }
        
    }
    
    /// show 'detailTextSwipeCard' and 'detailImageSwipeCard'
    private func setDetailSwipeCardAndSwipeCardVC(of detailTextSwipeCard: DetailNewTextSwipeCard,
                                                  of detailImageSwipeCardVC: DetailImageSwipeCardVC,
                                                  by poster: Posters) {
        detailTextSwipeCard.poster = poster
        detailImageSwipeCardVC.poster = poster
    }
    
    @IBAction func touchUpMyPageButton(_ sender: UIBarButtonItem) {
        if let isTryWithoutLogin = UserDefaults.standard.object(forKey: "isTryWithoutLogin") as? Bool {
            if isTryWithoutLogin {
                simpleAlertwithHandler(title: "마이페이지", message: "로그인 후 이용해주세요") { _ in
                    
                    KeychainWrapper.standard.removeObject(forKey: TokenName.token)
                    
                    guard let window = UIApplication.shared.keyWindow else {
                        return
                    }
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "splashVC") as! SplashViewController
                    
                    let rootNavigationController = UINavigationController(rootViewController: viewController)
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = rootNavigationController
                    
                    rootNavigationController.view.layoutIfNeeded()
                    
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                        window.rootViewController = rootNavigationController
                    }, completion: nil)
                }
                return
            }
        }
        
        let myPageStoryboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        let myPageViewController
            = myPageStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)
        
        let myPageViewNavigator = UINavigationController(rootViewController: myPageViewController)
        
        myPageViewNavigator.modalPresentationStyle = .fullScreen
        present(myPageViewNavigator,
                animated: true)
    }
    
    @IBAction func touchUpBoardSettingButton(_ sender: UIBarButtonItem) {
        if sender.title == "나가기" {
            KeychainWrapper.standard.removeObject(forKey: TokenName.token)
            
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "splashVC") as! SplashViewController
            
            let rootNavigationController = UINavigationController(rootViewController: viewController)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = rootNavigationController
            
            rootNavigationController.view.layoutIfNeeded()
            
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = rootNavigationController
            }, completion: nil)
            return
        }
        
        let storyboard = UIStoryboard(name: StoryBoardName.mypage,
                                      bundle: nil)
        guard let interestVC = storyboard.instantiateViewController(withIdentifier: "InterestBoardVC") as? InterestBoardViewController else {
            return
        }
        
        interestVC.callback = { [weak self] in
//            self?.requestPoster(isFirst: false)
        }
        
        navigationController?.pushViewController(interestVC, animated: true)
    }
    
    @IBAction func cardBackAction(_ sender: Any) {
        /*
        guard let card = lastDeletedSwipeCard else {return}
        
        if isOkayToUndo {
            isOkayToUndo = false
            setCountValue(addOrUndo: .undo)
            
            setCountLabelText()
            swipeCardView.addSubview(card)
            
            card.makeUndoAction()
            currentLoadedCardsArray.insert(card, at: 0)
            
            // TODO: - [카드 되돌리기] 좋아요 -> 되돌리기 -> 싫어요 할경우 유저디폴츠 리셋
            
            /*
            guard let posterData = UserDefaults.standard.object(forKey: UserDefaultsName.poster) as? Data else {
                addUserDefaultsWhenNoData()
                return
            }
            
            guard let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData) else {
                return
            }
            
            addUserDefautlsWhenDataIsExist(posterInfo)
             */3
        }
         */
        
    }
    
    private func setCountLabelText() {
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            
            guard countTotalCardIndex != 0 else {
                tabItem.badgeValue = nil
                return
            }

            tabItem.badgeColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
            tabItem.badgeValue = "\(self.countTotalCardIndex)"
        }
        
        for badgeView in (tabBarController?.tabBar.subviews[2].subviews)! {
            if NSStringFromClass(badgeView.classForCoder) == "_UIBadgeView" {
                badgeView.layer.transform = CATransform3DIdentity
                badgeView.layer.transform = CATransform3DMakeTranslation(-12.0, -5.0, 1.0)
            }
        }
    }
    
    private func setCountValue(addOrUndo: AddOrUndo) {
        if addOrUndo == .add {
            countTotalCardIndex -= 1
            currentIndex += 1
            lastCardIndex += 1
        } else {
            countTotalCardIndex += 1
            currentIndex -= 1
            lastCardIndex -= 1
        }
    }
    
    func isDuplicated(in posters: [Posters], checkValue: Posters) -> Bool {
        for poster in posters {
            if poster.posterName! == checkValue.posterName! {
                return true
            }
        }
        return false
    }
}

// MARK: - zoom poster image
extension SwipeVC: movoToDetailPoster {
    func pressButton() {
        let swipeStoryboard = UIStoryboard(name: StoryBoardName.swipe,
                                           bundle: nil)
        guard let zoomPosterVC = swipeStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.zoomPosterViewController) as? ZoomPosterVC else {return}
        
        zoomPosterVC.urlString = self.posters[currentIndex].photoUrl

        zoomPosterVC.modalPresentationStyle = .fullScreen
        self.present(zoomPosterVC, animated: true, completion: nil)
    }
}

extension SwipeVC : SwipeCardDelegate {
    //카드가 왼쪽으로 갔을때
    func cardGoesLeft(card: SwipeCard) {
        ssgsagCount += 1
        isOkayToUndo = true
        
        loadCardValuesAfterRemoveObject()
        
        guard let disLikedCategory = likedOrDisLiked(rawValue: 0),
            let posterIdx = posters[currentIndex-1].posterIdx else { return }
        
        posterServiceImp.requestPosterStore(of: posterIdx,
                                            type: disLikedCategory) { [weak self] result in
            switch result {
            case .success(let status):
                switch status {
                case .sucess:
                    print("성공")
                case .dataBaseError:
                    self?.simplerAlert(title: "데이터베이스 에러")
                case .serverError:
                    self?.simplerAlert(title: "서버 에러")
                default:
                    print("슥/삭 실패")
                }
            case .failed(let error):
                print(error)
                return
            }
        }
    }
    
    //카드 오른쪽으로 갔을때
    func cardGoesRight(card: SwipeCard) {
        ssgsagCount += 1
        isOkayToUndo = true
        
        loadCardValuesAfterRemoveObject()
        
        guard posters.count > 0 else {
            addUserDefaultsWhenNoData()
            return
        }
        
        addUserDefautlsWhenDataIsExist(posters)
    }
    
    private func addUserDefaultsWhenNoData() {
        var likedPoster: [Posters] = []
        
        likedPoster.append(self.posters[currentIndex - 1])
        
        guard let likedCategory = likedOrDisLiked(rawValue: 1),
            let posterIdx = posters[currentIndex-1].posterIdx else { return }
        
        posterServiceImp.requestPosterStore(of: posterIdx,
                                            type: likedCategory) { [weak self] result in
            switch result {
            case .success(let status):
                switch status {
                case .sucess:
                    print("성공")
                    
                    let adBrix = AdBrixRM.getInstance
                    adBrix.event(eventName: "swipe_PosterComplete")
                case .dataBaseError:
                    self?.simplerAlert(title: "데이터베이스 에러")
                case .serverError:
                    self?.simplerAlert(title: "서버 에러")
                default:
                    print("슥/삭 실패")
                }
            case .failed(let error):
                print(error)
                return
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(NotificationName.addUserDefaults), object: nil)
    }
    
    private func addUserDefautlsWhenDataIsExist(_ posterInfo: [Posters]) {
        var likedPoster = posterInfo
        
        if isDuplicated(in: likedPoster, checkValue: posters[currentIndex - 1]) == false {
            likedPoster.append(self.posters[currentIndex - 1])
        }
        
        guard let likedCategory = likedOrDisLiked(rawValue: 1),
            let posterIdx = posters[currentIndex-1].posterIdx else { return }
        
        posterServiceImp.requestPosterStore(of: posterIdx,
                                            type: likedCategory) { [weak self] result in
            switch result {
            case .success(let status):
                switch status {
                case .sucess:
                    print("성공")
                case .dataBaseError:
                    self?.simplerAlert(title: "데이터베이스 에러")
                case .serverError:
                    self?.simplerAlert(title: "서버 에러")
                default:
                    print("슥/삭 실패")
                }
            case .failed(let error):
                print(error)
                return
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(NotificationName.addUserDefaults), object: nil)
    }
    
}

struct PosterFavoriteForNetwork: Codable {
    let status: Int?
    let message: String?
    let data: Int?
    
}

protocol SwipeCardDelegate: NSObjectProtocol {
    func cardGoesLeft(card: SwipeCard)
    func cardGoesRight(card: SwipeCard)
}

enum likedOrDisLiked: Int {
    case liked = 1
    case disliked = 0
}

enum AddOrUndo {
    case add
    case undo
}



extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}
