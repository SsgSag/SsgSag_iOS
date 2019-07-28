import UIKit
import Lottie

class SwipeVC: UIViewController {
    
    @IBOutlet weak var swipeCardView: UIView!
    
    @IBOutlet private var countLabel: UILabel!
    
    @IBOutlet private var overLapView: UIView!
    
    lazy private var posters: [Posters] = []
    
    private static let numberOfTopCards = 2
    
    private var currentLoadedCardsArray = [SwipeCard]()
    
    private var lastCardIndex: Int = 0
    
    private var currentIndex = 0
    
    private var countTotalCardIndex = 0
    
    private var posterServiceImp: PosterService = DependencyContainer.shared.getDependency(key: .posterService)
    
    private var lastDeletedSwipeCard: SwipeCard?
    
    private var isOkayToUndo: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let height: CGFloat = 48
        let bounds = navigationController!.navigationBar.bounds
        navigationController?.navigationBar.frame = CGRect(x: 0,
                                                           y: 0,
                                                           width: bounds.width,
                                                           height: bounds.height + height)
        
        let shadowSize = CGSize(width: self.view.frame.width, height: 3)
        navigationController?.navigationBar.addColorToShadow(color: #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1),
                                                             size: shadowSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPoster()
        
        setCountLabelText()
        
        setView()
        
        UIView.appearance().isExclusiveTouch = true
    }

    private func setView() {
        view.backgroundColor = UIColor(displayP3Red: 242/255,
                                       green: 243/255,
                                       blue: 245/255,
                                       alpha: 1.0)
    }
    
    private func setEmptyPosterAnimation() {
        let animation = LOTAnimationView(name: "main_empty_hifive")
        
        view.addSubview(animation)

        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        animation.widthAnchor.constraint(equalToConstant: 350).isActive = true
        animation.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        animation.loopAnimation = true
        animation.play()
    }
    
    //FIXME: - CategoryIdx가 3이거나 5일때 예외를 만든다.
    private func initPoster() {

        posterServiceImp.requestPoster { [weak self] response in
            switch response {
            case .success(let posters):
                self?.posters = posters
                self?.countTotalCardIndex = self?.posters.count ?? 0
                
                DispatchQueue.main.async {
                    self?.loadCardAndSetPageVC()
                    self?.setCountLabelText()
                }
            case .failed(let error):
                print(error)
                return
            }
        }
    }
    
//    //캘린더 이동
//    @IBAction func moveToCalendar(_ sender: Any) {
//        let calendarVC = CalenderVC()
//        present(calendarVC, animated: true, completion: nil)
//    }
    
    private func loadCard() {
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
    private func loadCardAndSetPageVC() {
        if posters.count > 0 {
            
            loadCard()
            
            setSwipeCardSubview()
            
            setPageVCAndAddToSubView()
        } else {
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
        let myPageStoryboard = UIStoryboard(name: StoryBoardName.mypage, bundle: nil)
        
        let myPageViewController
            = myPageStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.mypageViewController)
        
        present(myPageViewController, animated: true)
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
            tabItem.badgeColor = #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1)
            tabItem.badgeValue = "\(self.countTotalCardIndex)"
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
        
        zoomPosterVC.urlString = self.posters[lastCardIndex-1].photoUrl

        self.present(zoomPosterVC, animated: true, completion: nil)
    }
}

extension SwipeVC : SwipeCardDelegate {
    //카드가 왼쪽으로 갔을때
    func cardGoesLeft(card: SwipeCard) {
        
        isOkayToUndo = true
        
        loadCardValuesAfterRemoveObject()
        
        guard let disLikedCategory = likedOrDisLiked(rawValue: 0) else { return }
        
        posterServiceImp.requestPosterLiked(of: self.posters[currentIndex-1], type: disLikedCategory)
    }
    
    //카드 오른쪽으로 갔을때
    func cardGoesRight(card: SwipeCard) {
        
        isOkayToUndo = true
        
        loadCardValuesAfterRemoveObject()
        
        guard let posterData = UserDefaults.standard.object(forKey: UserDefaultsName.poster) as? Data else {
            addUserDefaultsWhenNoData()
            return
        }
        
        guard let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData) else {
            return
        }
        
        addUserDefautlsWhenDataIsExist(posterInfo)
    }
    
    private func addUserDefaultsWhenNoData() {
        var likedPoster: [Posters] = []
        
        likedPoster.append(self.posters[currentIndex-1])
        
        StoreAndFetchPoster.shared.storePoster(posters: likedPoster)
        
        guard let likedCategory = likedOrDisLiked(rawValue: 1) else { return }
        
        posterServiceImp.requestPosterLiked(of: self.posters[currentIndex-1], type: likedCategory)
        
        NotificationCenter.default.post(name: NSNotification.Name(NotificationName.addUserDefaults), object: nil)
    }
    
    private func addUserDefautlsWhenDataIsExist(_ posterInfo: [Posters]) {
        var likedPoster = posterInfo
        
        if isDuplicated(in: likedPoster, checkValue: posters[currentIndex-1]) == false {
            likedPoster.append(self.posters[currentIndex-1])
        }
        
        StoreAndFetchPoster.shared.storePoster(posters: likedPoster)
        
        guard let likedCategory = likedOrDisLiked(rawValue: 1) else { return }
        
        posterServiceImp.requestPosterLiked(of: self.posters[currentIndex-1], type: likedCategory)
        
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
