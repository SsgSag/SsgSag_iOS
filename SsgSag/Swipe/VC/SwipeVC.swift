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
    
    lazy private var valueArray:[Posters] = []
    lazy private var likedArray:[Posters] = []
    
    private var currentIndex = 0
    private var countTotalCardIndex = 0
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosterData()
        
        countLabel.layer.cornerRadius = 10
        countLabel.layer.masksToBounds = true
        
        self.view.backgroundColor = UIColor(displayP3Red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
        
        self.view.bringSubviewToFront(viewTinderBackGround)
        
        likedButton.addTarget(self, action: #selector(touchDownLiked(_:)), for: .touchDown)
        likedButton.addTarget(self, action: #selector(touchUpLiked(_:)), for: .touchUpInside)
        
        dislikedButton.addTarget(self, action: #selector(touchDownDisLiked(_:)), for: .touchDown)
        dislikedButton.addTarget(self, action: #selector(touchUpDisLiked(_:)), for: .touchUpInside)
        
        
        setEmptyPosterAnimation()
        
        self.view.bringSubviewToFront(overLapView)
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
        guard let posterURL = URL(string: "http://52.78.86.179:8080/poster/show") else {
            return
        }
        
        guard let key = UserDefaults.standard.object(forKey: "SsgSagToken") as? String else {
            return
        }
        
        var request = URLRequest(url: posterURL)
        
        request.addValue(key, forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.getData(with: request) { (data, err, res) in
            DispatchQueue.global().async {
                
                guard let data = data else {
                    return
                }
                
                do {
                    let order = try JSONDecoder().decode(networkData.self, from: data)
                    if let posters = order.data?.posters {
                        for i in posters {
                            self.valueArray.append(i)
                            //self.likedArray.append(i)
                        }
                        
                        //main queue에서 리로드하고 카드들을 표현
                        DispatchQueue.main.async {
                            self.loadCardValues()
                            
                            //전체 카드 개수
                            self.countLabel.text = "\(self.valueArray.count)"
                        }
                        
                    }
                }catch{
                    print("JSON Parising Error")
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    //캘린더 이동
    @IBAction func moveToCalendar(_ sender: Any) {
        let calendarVC = CalenderVC()
        present(calendarVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
    }
    
    private func loadCardValueAtTopOnlyTwoCards() {
        if valueArray.count > 0 {
            
        }
    }
    
    var lastIndex:Int = 0
    
    //카드를 로드한다.
    func loadCardValues() {
        //카드에 값이 있을때
        if valueArray.count > 0 {
            if currentIndex == 0 {
                for (index,value) in valueArray.enumerated() {
                    
                    if let photoURL = value.photoUrl {
                        
                        let newCard = createSwipeCard(at: index, value: photoURL)
                        
                        if index < 2 {
                            
                            currentLoadedCardsArray.append(newCard)
                            lastIndex = index
                        }
                    }
                }
                
                for (i,_) in currentLoadedCardsArray.enumerated() {
                    if i > 0 {
                        viewTinderBackGround.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
                    } else {
                        viewTinderBackGround.addSubview(currentLoadedCardsArray[i])
                    }
                }
                
                animateCardAfterSwiping() //카드 처음로드 혹은 제거 추가 할시
            } else if currentIndex >= 1 {
                for (index,value) in valueArray.enumerated() {
                    
                    if index > lastIndex {
                        if let photoURL = value.photoUrl {
                            let newCard = createSwipeCard(at: index, value: photoURL)
                            
                            if (index - lastIndex) <= 2 {
                                currentLoadedCardsArray.append(newCard)
                            }
                            
                            lastIndex = index
                        }
                    }
                }
                
                for (i,_) in currentLoadedCardsArray.enumerated() {
                    if i > 0 {
                        viewTinderBackGround.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
                    } else {
                        viewTinderBackGround.addSubview(currentLoadedCardsArray[i])
                    }
                }
                
                animateCardAfterSwiping() //카드 처음로드 혹은 제거 추가 할시
            }
        }
    }
    
    //카드 객체 제거, 새로운 value추가
    func removeObjectAndAddNewValues() {
        
        currentLoadedCardsArray.remove(at: 0)
        
        currentIndex = currentIndex + 1
        
        if currentIndex % 2 == 1 {
            loadCardValues()
        }
        
        countLabel.text = "\(valueArray.count-currentIndex)"
        
        // 왼쪽값은 항상 같음
        //        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
        //
        //            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
        //
        //            currentLoadedCardsArray.append(card)
        //
        //            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1],
        //                                               belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2])
        //        }
        //        animateCardAfterSwiping()
        
    }
    
    //SwipeCard 생성
    func createSwipeCard(at index: Int , value :String) -> SwipeCard {
        let card = SwipeCard(frame: CGRect(x: 0, y: 0,
                                           width: viewTinderBackGround.frame.size.width,
                                           height: viewTinderBackGround.frame.size.height),
                             value : value)
        
        countTotalCardIndex += 1
        
        card.delegate = self
        
        return card
    }
    
    
    
    
    func animateCardAfterSwiping() {
        for (i,card) in currentLoadedCardsArray.enumerated() {
            let storyboard = UIStoryboard(name: "SwipeStoryBoard", bundle: nil)
            let pageVC = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
            
            pageVC.view.frame = self.currentLoadedCardsArray[i].frame
            let page = pageVC.orderedViewControllers[1] as! DetailImageSwipeCardVC
            guard let pageURL = URL(string: valueArray[i].photoUrl!) else {return}
            page.detailImageVIew.load(url: pageURL)
            
            
            let cardWidth = viewTinderBackGround.frame.width
            let cardHeight = viewTinderBackGround.frame.height
            page.imageWidth = cardWidth
            page.imageHeight = cardHeight
            page.name.text = valueArray[i].posterName!
            
            var text = ""
            if let num = valueArray[i].posterInterest {
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
            page.category.text = text
            
            let detailTextSwipe = pageVC.orderedViewControllers[0] as! DetailTextSwipeCard
            
            if let posterName = valueArray[i].posterName , let outline = valueArray[i].outline ,let target = valueArray[i].target ,let benefit = valueArray[i].benefit, let period = valueArray[i].period {
                
                detailTextSwipe.posterName.text = posterName
                
                if let hashTagArr = valueArray[i].posterInterest {
                    var text = ""
                    for i in hashTagArr{
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
                
                detailTextSwipe.hashTag.text = text
                detailTextSwipe.outline.text = outline
                detailTextSwipe.target.text = target
                detailTextSwipe.benefit.text = benefit
                detailTextSwipe.period.text = period
            }
            //            detailTextSwipe.posterName.text = valueArray[i].posterName!
            //            detailTextSwipe.hashTag.text = "\(valueArray[i].categoryIdx)"
            //
            //            detailTextSwipe.outline.text = valueArray[i].outline!
            //            detailTextSwipe.target.text = valueArray[i].target!
            //            detailTextSwipe.benefit.text = valueArray[i].benefit!
            //            detailTextSwipe.period.text = valueArray[i].period!
            
            self.addChild(pageVC)
            self.currentLoadedCardsArray[i].insertSubview(pageVC.view, at: 0)
            pageVC.didMove(toParent: self)
            if i == 0 {
                card.isUserInteractionEnabled = true
            }
        }
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        let posX: CGFloat = contextSize.width
        let posY: CGFloat = contextSize.width
        let cgwidth: CGFloat = CGFloat(width)
        let cgheight: CGFloat = CGFloat(height)
        // See what size is longer and create the center off of that
        
        let rect: CGRect = CGRect(x: posX-cgwidth/2, y: posY-cgheight/2, width: cgwidth, height: cgheight)
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
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
                for i in posterInfo {
                    if isDuplicateInLikedPoster(likedPoster, input: i) == false {//중복 되지 않을때만 넣는다.
                        likedPoster.append(i)
                    }
                }
            }
        }
        
        likedPoster.append(self.valueArray[currentIndex-1])

        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(likedPoster), forKey: "poster")
        NotificationCenter.default.post(name: NSNotification.Name("addUserDefaults"), object: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
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


//
//extension UIImage {
//    func resized(toWidth width: CGFloat) -> UIImage? {
//        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
//        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
//        defer { UIGraphicsEndImageContext() }
//        draw(in: CGRect(origin: .zero, size: canvasSize))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//}

