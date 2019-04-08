let  MAX_BUFFER_SIZE = 20;
let  SEPERATOR_DISTANCE = 8;
let  TOPYAXIS = 75;

import UIKit
import Lottie

class SwipeVC: UIViewController {
    
    @IBOutlet private weak var viewTinderBackGround: UIView!
    
    @IBOutlet private var countLabel: UILabel!
    
    @IBOutlet private var overLapView: UIView!
    
    @IBOutlet private weak var dislikedButton: UIButton!
    
    @IBOutlet private weak var likedButton: UIButton!
    
    private var currentLoadedCardsArray = [SwipeCard]()
    
    private var allCardsArray = [SwipeCard]()
    
    private static let numberOfTopCards = 2
    
    lazy private var valueArray:[Posters] = []
    
    private var lastCardIndex:Int = 0
    
    private var currentIndex = 0
    
    private var countTotalCardIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //resetDefaults()
        
        getPosterData()
        
        setCountLabel()
        setView()
        setButtonTarget()
        
        hideStatusBar()
        
        setEmptyPosterAnimation()
    }
    
    private func hideStatusBar() {
        self.view.addSubview(overLapView)
    }
    
    private func setCountLabel() {
        countLabel.layer.cornerRadius = 10
        countLabel.layer.masksToBounds = true
    }
    
    private func setView() {
        self.view.backgroundColor = UIColor(displayP3Red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
        self.view.bringSubviewToFront(viewTinderBackGround)
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
    
    func getPosterData() {
        
        let urlString = UserAPI.sharedInstance.getURL("/poster/show")
        
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        guard let tokenKey = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else {
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.addValue(tokenKey, forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.getData(with: request) { (data, err, res) in
            DispatchQueue.global().async {
                guard let data = data else {
                    return
                }
                
                do {
                    let order = try JSONDecoder().decode(networkData.self, from: data)
                    
                    guard let posters = order.data?.posters else {
                        return
                    }
                    
                    for poster in posters {
                        self.valueArray.append(poster)
                    }
                    
                    DispatchQueue.main.async {
                        self.loadCardValues()
                        self.countLabel.text = "\(self.valueArray.count)"
                    }
                    
                } catch{
                    print("JSON Parising Error")
                }
            }
        }
    }
    
    //캘린더 이동
    @IBAction func moveToCalendar(_ sender: Any) {
        let calendarVC = CalenderVC()
        present(calendarVC, animated: true, completion: nil)
    }

    //카드를 로드한다.
    func loadCardValues() {
        if valueArray.count > 0 {
            
            for (index,value) in valueArray.enumerated() {
                
                if index < SwipeVC.numberOfTopCards {
                    
                    guard let photoURL = value.photoUrl else {
                        return
                    }
                    
                    let newCard = createSwipeCard(at: index, value: photoURL)
                    
                    currentLoadedCardsArray.append(newCard)
                    
                    lastCardIndex = index
                }
            }
            
            for (i,_) in currentLoadedCardsArray.enumerated() {
                if i > 0 {
                    viewTinderBackGround.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
                } else {
                    viewTinderBackGround.addSubview(currentLoadedCardsArray[i])
                }
            }
            
            setPageVCAndAddToSubView()
        }
        
    }
    
    private func loadCardValuesAfterRemoveObject() {
        currentLoadedCardsArray.remove(at: 0)
        
        currentIndex += 1
        lastCardIndex += 1
        
        //등호가 올바른 것인지 확인 바람
        if valueArray.count-1 >= lastCardIndex {
            guard let photoURL = valueArray[lastCardIndex].photoUrl else {
                return
            }
            
            let newCard = createSwipeCard(at: lastCardIndex, value: photoURL)
            currentLoadedCardsArray.append(newCard)
        }
        
        for (i,_) in currentLoadedCardsArray.enumerated() {
            if i > 0 {
                viewTinderBackGround.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
            } else {
                viewTinderBackGround.addSubview(currentLoadedCardsArray[i])
            }
        }
        
        setPageVCAndAddToSubViewAfterRemove()
    }
    
    //카드 객체 제거, 새로운 value추가
    private func removeObjectAndAddNewValues() {
        loadCardValuesAfterRemoveObject()
        countLabel.text = "\(valueArray.count-currentIndex)"
    }
    
    //SwipeCard 생성
    private func createSwipeCard(at index: Int , value :String) -> SwipeCard {
        let card = SwipeCard(frame: CGRect(x: 0, y: 0,
                                           width: viewTinderBackGround.frame.size.width,
                                           height: viewTinderBackGround.frame.size.height),
                             value : value)
        
        countTotalCardIndex += 1
        
        card.delegate = self
        
        return card
    }
    
    private func setCategoryText(_ posterInterest:[Int]?) -> String {
        var text = ""
        if let num = posterInterest {
            for i in num{
                switch i {
                case 0:
                    text = text + "#기획/아이디어"
                    break
                case 1:
                    text = text + "#금융/경제"
                    break
                case 2:
                    text = text + "#디자인"
                    break
                case 3:
                    text = text + "#문학/글쓰기"
                    break
                case 4:
                    text = text + "#문화/예술"
                    break
                case 5:
                    text = text + "#브랜딩/마케팅"
                    break
                case 6:
                    text = text + "#봉사/사회활동"
                    break
                case 7:
                    text = text + "#사진/영상"
                    break
                case 8:
                    text = text + "#창업/스타트업"
                    break
                case 9:
                    text = text + "#체육/건강"
                    break
                case 10:
                    text = text + "#학술/교양"
                    break
                case 11:
                    text = text + "#IT/기술"
                    break
                default: break
                }
            }
        }
        return text
    }
    
    private func setPageVCAndAddToSubViewAfterRemove() {
        if currentLoadedCardsArray.count > 1 {
            
        let storyboard = UIStoryboard(name: "SwipeStoryBoard", bundle: nil)
        
        let cardWidth = viewTinderBackGround.frame.width
            
        let cardHeight = viewTinderBackGround.frame.height
        
            guard let pageVC = storyboard.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController else {
                return
            }
            
            guard let detailImageSwipeCardVC = pageVC.orderedViewControllers[1] as? DetailImageSwipeCardVC else {
                return
            }
            
            guard let detailTextSwipeCard = pageVC.orderedViewControllers[0] as? DetailTextSwipeCard else {
                return
            }
            
            guard let posterURLString = valueArray[lastCardIndex].photoUrl else {
                return
            }
            
            guard let posterURL = URL(string: posterURLString) else {
                return
            }
        
            pageVC.view.frame = self.currentLoadedCardsArray[1].frame
            
            if valueArray.count > lastCardIndex {
                
            if let posterName = valueArray[lastCardIndex].posterName,
                let outline = valueArray[lastCardIndex].outline,
                let target = valueArray[lastCardIndex].target,
                let benefit = valueArray[lastCardIndex].benefit {
                
                detailTextSwipeCard.posterName.text = posterName
                detailTextSwipeCard.hashTag.text = setCategoryText(valueArray[lastCardIndex].posterInterest)
                detailTextSwipeCard.outline.text = outline
                detailTextSwipeCard.target.text = target
                detailTextSwipeCard.benefit.text = benefit
                
                detailImageSwipeCardVC.detailImageVIew.load(url: posterURL)
                detailImageSwipeCardVC.imageWidth = cardWidth
                detailImageSwipeCardVC.imageHeight = cardHeight
                detailImageSwipeCardVC.name.text = posterName
                detailImageSwipeCardVC.category.text = setCategoryText(valueArray[lastCardIndex].posterInterest)
            }
                
            detailTextSwipeCard.period.text = valueArray[lastCardIndex].period ?? ""
            
            self.addChild(pageVC)
            
            self.currentLoadedCardsArray[1].insertSubview(pageVC.view, at: 0)
            
            pageVC.didMove(toParent: self)
                
            }
        }
    }
    
    //처음에만 0, 1로 로드한다.
    private func setPageVCAndAddToSubView() {
        let storyboard = UIStoryboard(name: "SwipeStoryBoard", bundle: nil)
        
        for (i, _ ) in currentLoadedCardsArray.enumerated() {
            
            guard let pageVC = storyboard.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController else {
                return
            }
            
            guard let detailImageSwipeCardVC = pageVC.orderedViewControllers[1] as? DetailImageSwipeCardVC else {
                return
            }
            
            guard let detailTextSwipeCard = pageVC.orderedViewControllers[0] as? DetailTextSwipeCard else {
                return
            }
            
            pageVC.view.frame = self.currentLoadedCardsArray[i].frame
            
            setDetailSwipeCardAndSwipeCardVC(detailTextSwipeCard, detailImageSwipeCardVC , valueArray[i])
            
            self.addChild(pageVC)
            self.currentLoadedCardsArray[i].insertSubview(pageVC.view, at: 0)
            pageVC.didMove(toParent: self)
        }
    }
    
    func setDetailSwipeCardAndSwipeCardVC(_ detailTextSwipeCard:DetailTextSwipeCard,
                                          _ detailImageSwipeCardVC:DetailImageSwipeCardVC,
                                          _ posters:Posters ) {
        
        let cardWidth = viewTinderBackGround.frame.width
        let cardHeight = viewTinderBackGround.frame.height
        
        guard let posterURLString = posters.photoUrl else {
            return
        }
        
        guard let posterURL = URL(string: posterURLString) else {
            return
        }
        
        if let posterName = posters.posterName,
            let outline = posters.outline,
            let target = posters.target,
            let benefit = posters.benefit {
            
            detailTextSwipeCard.posterName.text = posterName
            detailTextSwipeCard.hashTag.text = setCategoryText(posters.posterInterest)
            detailTextSwipeCard.outline.text = outline
            detailTextSwipeCard.target.text = target
            detailTextSwipeCard.benefit.text = benefit
            //detailTextSwipeCard.period.text = period
            
            detailImageSwipeCardVC.detailImageVIew.load(url: posterURL)
            detailImageSwipeCardVC.imageWidth = cardWidth
            detailImageSwipeCardVC.imageHeight = cardHeight
            detailImageSwipeCardVC.name.text = posterName
            detailImageSwipeCardVC.category.text = setCategoryText(posters.posterInterest)
        }
    }

    //싫어요
    @IBAction func disLikeButtonAction(_ sender: Any) {
        let card = currentLoadedCardsArray.first
        card?.leftClickAction()
    }
    
    //좋아요
    @IBAction func LikeButtonAction(_ sender: Any) {
        let card = currentLoadedCardsArray.first
        card?.rightClickAction()
    }
    
    func isDuplicateInLikedPoster(_ likedPoster:[Posters], input: Posters) -> Bool {
        for i in likedPoster {
            //겹칠때 true 리턴
            if i.posterName! == input.posterName! {
                return true
            }
        }
        //안겹치면 false
        return false
    }
}

extension SwipeVC : SwipeCardDelegate {
    //카드가 왼쪽으로 갔을때
    func cardGoesLeft(card: SwipeCard) {
        removeObjectAndAddNewValues()
    }
    
    //카드 오른쪽으로 갔을때
    func cardGoesRight(card: SwipeCard) {
        
        removeObjectAndAddNewValues()
        
        var likedPoster: [Posters] = []
        
        let defaults = UserDefaults.standard
        
        if let posterData = defaults.object(forKey: "poster") as? Data {
            if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData) {
                for poster in posterInfo {
                    if isDuplicateInLikedPoster(likedPoster, input: poster) == false {//중복 되지 않을때만 넣는다.
                        likedPoster.append(poster)
                    }
                }
            }
        }
        
        likedPoster.append(self.valueArray[currentIndex-1])
        
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(likedPoster), forKey: "poster")
        
        NotificationCenter.default.post(name: NSNotification.Name("addUserDefaults"), object: nil)
    }
}


extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func load(url: URL) {
        getData(from: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self?.image = UIImage(data: data)
            }
        }
    }
    
}




