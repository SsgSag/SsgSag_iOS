let  MAX_BUFFER_SIZE = 20;
let  SEPERATOR_DISTANCE = 8;
let  TOPYAXIS = 75;

import UIKit
import Lottie

class SwipeVC: UIViewController {
    
    @IBOutlet weak var swipeCardView: UIView!
    
    @IBOutlet private var countLabel: UILabel!
    
    @IBOutlet private var overLapView: UIView!
    
    @IBOutlet private weak var dislikedButton: UIButton!
    
    @IBOutlet private weak var likedButton: UIButton!
    
    private var currentLoadedCardsArray = [SwipeCard]()
    
    private static let numberOfTopCards = 2
    
    lazy private var posters:[Posters] = []
    
    private var lastCardIndex:Int = 0
    
    private var currentIndex = 0
    
    private var countTotalCardIndex = 0
    
    private var posterServiceImp: PosterService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //resetDefaults()
        
        posterServiceImp = PosterServiceImp()
        
        initPoster()
        
        setCountLabel()
        
        setView()
        
        setButtonTarget()
        
        hideStatusBar()
        
        setEmptyPosterAnimation()
        
        UIView.appearance().isExclusiveTouch = true
    }
    
    private func hideStatusBar() {
        self.view.addSubview(overLapView)
    }
    
    private func setCountLabel() {
        
        countLabel.layer.cornerRadius = 10
        countLabel.layer.masksToBounds = true
        
        countLabel.text = "\(countTotalCardIndex)"
    }

    private func setView() {
        
        swipeCardView.layer.cornerRadius = 4
        swipeCardView.layer.masksToBounds = true
        
        self.view.backgroundColor = UIColor(displayP3Red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
        
        self.view.bringSubviewToFront(swipeCardView)
        
        
    }
    
    private func setButtonTarget() {
        likedButton.addTarget(self, action: #selector(touchDownLiked(_:)), for: .touchDown)
        
        likedButton.addTarget(self, action: #selector(touchUpLiked(_:)), for: .touchUpInside)
        
        dislikedButton.addTarget(self, action: #selector(touchDownDisLiked(_:)), for: .touchDown)
        
        dislikedButton.addTarget(self, action: #selector(touchUpDisLiked(_:)), for: .touchUpInside)
    }
    
    private func setEmptyPosterAnimation() {
        
        let animation = LOTAnimationView(name: "main_empty_hifive")
        
        view.addSubview(animation)
        view.sendSubviewToBack(animation)
        
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        animation.widthAnchor.constraint(equalToConstant: 350).isActive = true
        animation.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        animation.loopAnimation = true
        animation.play()
        
        simplerAlert(title: "저장되었습니다")
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    @objc func touchDownLiked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.likedButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func touchUpLiked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.likedButton.transform = .identity
        })
    }
    
    @objc func touchDownDisLiked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dislikedButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func touchUpDisLiked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.dislikedButton.transform = .identity
        })
    }
    
    //FIXME: - CategoryIdx가 3이거나 5일때 예외를 만든다.
    private func initPoster() {

        posterServiceImp?.requestPoster { (response) in
            
            guard response.isSuccess, let posters = response.value else { return }
            
            self.posters = posters
            self.countTotalCardIndex = self.posters.count
            
            DispatchQueue.main.async {
                self.loadCardAndSetPageVC()
                self.countLabel.text = "\(self.countTotalCardIndex)"
            }
            
        }
    }
    
    //캘린더 이동
    @IBAction func moveToCalendar(_ sender: Any) {
        let calendarVC = CalenderVC()
        present(calendarVC, animated: true, completion: nil)
    }
    
    private func loadCard() {
        
        for (index,value) in posters.enumerated() {
            
            if index < SwipeVC.numberOfTopCards {
                
                guard let photoURL = value.photoUrl else {
                    return
                }
                
                let newCard = createSwipeCard(at: index, value: photoURL)
                currentLoadedCardsArray.append(newCard)
                lastCardIndex = index
            }
            
        }
        
    }
    
    private func setSwipeCardSubview() {
        for (i,_) in currentLoadedCardsArray.enumerated() {
            if i > 0 {
                swipeCardView.insertSubview(currentLoadedCardsArray[i],
                                                   belowSubview: currentLoadedCardsArray[i - 1])
            } else {
                swipeCardView.addSubview(currentLoadedCardsArray[i])
            }
        }
        
    }
    
    
    //카드를 로드한다.
    func loadCardAndSetPageVC() {
        
        if posters.count > 0 {
            
            loadCard()
            
            setSwipeCardSubview()
            
            setPageVCAndAddToSubView()
        }
        
    }
    
    private func addNewCard() {
        let totalNumberOfPosters = posters.count-1
        
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
        currentLoadedCardsArray.remove(at: 0)
        
        countTotalCardIndex -= 1
        self.countLabel.text = "\(self.countTotalCardIndex)"
        
        currentIndex += 1
        lastCardIndex += 1
        
        //등호가 올바른 것인지 확인 바람
        addNewCard()
        
        setSwipeCardSubview()
        
        setPageVCAndAddToSubViewAfterRemove()
    }
    
    //SwipeCard 생성
    private func createSwipeCard(at index: Int , value :String) -> SwipeCard {
        let card = SwipeCard(frame: CGRect(x: 0, y: 0,
                                           width: swipeCardView.frame.size.width,
                                           height: swipeCardView.frame.size.height),
                             value : value)
        card.delegate = self
        
        return card
    }
    
    private func setPageVCAndAddToSubViewAfterRemove() {
        if currentLoadedCardsArray.count > 1 {
            
            let storyboard = UIStoryboard(name: StoryBoardName.swipe, bundle: nil)
            
            guard let pageVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.pageViewContrller) as? PageViewController else {
                return
            }
            
            guard let detailImageSwipeCardVC = pageVC.orderedViewControllers[1] as? DetailImageSwipeCardVC else {
                return
            }
            
            detailImageSwipeCardVC.delegate = self
            
            guard let detailTextSwipeCard = pageVC.orderedViewControllers[0] as? DetailNewTextSwipeCard else {
                return
            }
        
            pageVC.view.frame = self.currentLoadedCardsArray[1].frame
            
            if posters.count > lastCardIndex {
                
                detailTextSwipeCard.poster = posters[lastCardIndex]
                
                detailImageSwipeCardVC.poster = posters[lastCardIndex]
            
                self.addChild(pageVC)
                
                self.currentLoadedCardsArray[1].insertSubview(pageVC.view, at: 0)
                
                pageVC.didMove(toParent: self)
            }
            
        }
    }
    
    //처음에만 0, 1로 로드한다.
    private func setPageVCAndAddToSubView() {
        
        let storyboard = UIStoryboard(name: StoryBoardName.swipe, bundle: nil)
        
        for (i, _ ) in currentLoadedCardsArray.enumerated() {
            
            guard let pageVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.pageViewContrller) as? PageViewController else {
                return
            }
            
            guard let detailImageSwipeCardVC = pageVC.orderedViewControllers[1] as? DetailImageSwipeCardVC else {
                return
            }
            
            guard let detailTextSwipeCard = pageVC.orderedViewControllers[0] as? DetailNewTextSwipeCard else {
                return
            }
            
            detailImageSwipeCardVC.delegate = self
            
            pageVC.view.frame = self.currentLoadedCardsArray[i].frame
            
            setDetailSwipeCardAndSwipeCardVC(of: detailTextSwipeCard,
                                             of: detailImageSwipeCardVC,
                                             by: posters[i])
            
            self.addChild(pageVC)
            self.currentLoadedCardsArray[i].insertSubview(pageVC.view, at: 0)
            pageVC.didMove(toParent: self)
        }
        
    }
    
    /// show 'detailTextSwipeCard' and 'detailImageSwipeCard'
    private func setDetailSwipeCardAndSwipeCardVC(of detailTextSwipeCard:DetailNewTextSwipeCard,
                                                  of detailImageSwipeCardVC:DetailImageSwipeCardVC,
                                                  by posters:Posters ) {
    
        detailTextSwipeCard.poster = posters
        detailImageSwipeCardVC.poster = posters
    }
    
    @IBAction func disLikeButtonAction(_ sender: Any) {
        let card = currentLoadedCardsArray.first
        card?.leftClickAction()
    }
    
    @IBAction func LikeButtonAction(_ sender: Any) {
        let card = currentLoadedCardsArray.first
        card?.rightClickAction()
    }
    
    func isDuplicated(in posters:[Posters], checkValue: Posters) -> Bool {
        for poster in posters {
            if poster.posterName! == checkValue.posterName! {
                return true
            }
        }
        return false
    }
}

extension SwipeVC: movoToDetailPoster {
    func pressButton() {
        let storyboard = UIStoryboard(name: StoryBoardName.swipe, bundle: nil)

        guard let zoomPosterVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.zoomPosterViewController) as? ZoomPosterVC else {return}
        
        zoomPosterVC.urlString = self.posters[lastCardIndex-1].photoUrl

        self.present(zoomPosterVC, animated: true, completion: nil)
    }
}

extension SwipeVC : SwipeCardDelegate {
    //카드가 왼쪽으로 갔을때
    func cardGoesLeft(card: SwipeCard) {
        loadCardValuesAfterRemoveObject()
        
        guard let disLikedCategory = likedOrDisLiked(rawValue: 0) else { return }
        
        posterServiceImp?.requestPosterLiked(of: self.posters[currentIndex-1], type: disLikedCategory)
    }
    
    private func addUserDefaultsWhenNoData() {
        var likedPoster: [Posters] = []
        
        likedPoster.append(self.posters[currentIndex-1])
        
        StoreAndFetchPoster.storePoster(posters: likedPoster)
        
        guard let likedCategory = likedOrDisLiked(rawValue: 1) else { return }
        
        posterServiceImp?.requestPosterLiked(of: self.posters[currentIndex-1], type: likedCategory)
        
        NotificationCenter.default.post(name: NSNotification.Name("addUserDefaults"), object: nil)
    }
    
    private func addUserDefautlsWhenDataIsExist(_ posterInfo: [Posters]) {
        var likedPoster = posterInfo
        
        if isDuplicated(in: likedPoster, checkValue: posters[currentIndex-1]) == false {
            likedPoster.append(self.posters[currentIndex-1])
        }
        
        StoreAndFetchPoster.storePoster(posters: likedPoster)
        
        guard let likedCategory = likedOrDisLiked(rawValue: 1) else { return }
        
        posterServiceImp?.requestPosterLiked(of: self.posters[currentIndex-1], type: likedCategory)
        
        NotificationCenter.default.post(name: NSNotification.Name("addUserDefaults"), object: nil)
    }
    
    //카드 오른쪽으로 갔을때
    func cardGoesRight(card: SwipeCard) {
        
        loadCardValuesAfterRemoveObject()
        
        guard let posterData = UserDefaults.standard.object(forKey: "poster") as? Data else {
            addUserDefaultsWhenNoData()
            return
        }
        
        guard let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData) else {
            return
        }
        
        addUserDefautlsWhenDataIsExist(posterInfo)
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


