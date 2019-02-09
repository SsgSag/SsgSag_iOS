let  MAX_BUFFER_SIZE = 20;
let  SEPERATOR_DISTANCE = 8;
let  TOPYAXIS = 75;

import UIKit
import Alamofire
import ObjectMapper
import Lottie

class SwipeVC: UIViewController {
    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var overLapView: UIView!
    @IBOutlet weak var dislikedButton: UIButton!
    @IBOutlet weak var likedButton: UIButton!
    
    @IBAction func moveToMyPage(_ sender: Any) {
        
    }
    
    var currentLoadedCardsArray = [SwipeCard]()
    var allCardsArray = [SwipeCard]()
    
    //var valueArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36"]
    
//    var valueArray = ["1","2","3","4","5","6"]
    
    lazy var valueArray:[Posters] = []
    lazy var likedArray:[Posters] = []
    
    var abcde = "abcde"
    
    var currentIndex = 0
    var countTotalCardIndex = 0
    
    fileprivate func setEmptyPosterAnimation() {
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
        //viewActions.isUserInteractionEnabled = true
        
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
        let posterURL = URL(string: "http://52.78.86.179:8080/poster/show")
        var request = URLRequest(url: posterURL!)
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
//        if let savedToken = UserDefaults.standard.object(forKey: "token") as? String {
//                request.addValue(savedToken, forHTTPHeaderField: "Authorization")
//        }
        
        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoxfQ.5lCvAqnzYP4-2pFx1KTgLVOxYzBQ6ygZvkx5jKCFM08"
        request.addValue(key2, forHTTPHeaderField: "Authorization")
        //request.allHTTPHeaderFields = ["Authorization": "9_JkQE5SPfD0k1SbplKR2cU39g-l2MfOofz2lgoqAuYAAAFosk3w-w"]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let order = try JSONDecoder().decode(Json4Swift_Base.self, from: data)
                if let posters = order.data?.posters {
                    for i in posters {
                        //print(i.posterName)
                        print(self.valueArray)
                        self.valueArray.append(i)
                        
                        self.likedArray.append(i)
                        
                        //date parsing
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        /*
                        guard let startdate = dateFormatter.date(from: i.posterStartDate!) else {
                            fatalError("ERROR: Date conversion failed due to mismatched format.")
                        }
                        guard let regdate = dateFormatter.date(from: i.posterRegDate!) else {
                            fatalError("ERROR: Date conversion failed due to mismatched format.")
                        }
                        guard let endtdate = dateFormatter.date(from: i.posterEndDate!) else {
                            fatalError("ERROR: Date conversion failed due to mismatched format.")
                        }
                        */
                        
                    }
                    
                    //main queue에서 리로드하고 카드들을 표현
                    DispatchQueue.main.async {
                        self.view.reloadInputViews()
                        self.loadCardValues()
                        self.countLabel.text = "\(self.valueArray.count)"
//                        countLabel.text = "\(valueArray.count-currentIndex)"
                    }
                }
    
            }catch{
                print("JSON Parising Error")
            }
        }
        task.resume()
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
        
        //viewActions.isUserInteractionEnabled = true
        //loadCardValues()
    }
    
    //카드를 로드한다.
    func loadCardValues() {
        if valueArray.count > 0 {
            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
            for (i,value) in valueArray.enumerated() {
                let newCard = createSwipeCard(at: i, value: value.photoUrl!)
                allCardsArray.append(newCard)
                if i < capCount {
                    currentLoadedCardsArray.append(newCard)
                }
            }
            //viewTinderBackGround의 서브뷰로 currentLoadedCardsArray를 추가 (각 스와이프 카드를 서브뷰로 추가)
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
    //SwipeCard 생성
    func createSwipeCard(at index: Int , value :String) -> SwipeCard {
       // print("create")
        let card = SwipeCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width, height: viewTinderBackGround.frame.size.height) ,value : value)
        //print("높이: \(viewTinderBackGround.frame.size.height)")
        countTotalCardIndex += 1
        //print("countTotalCardIndex: \(countTotalCardIndex)")
        //print("create")
        card.delegate = self
        return card
    }
    
    //카드 객체 제거, 새로운 value추가
    func removeObjectAndAddNewValues() {
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1
        countLabel.text = "\(valueArray.count-currentIndex)"
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
            currentLoadedCardsArray.append(card)
            
            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2])
        }
        animateCardAfterSwiping()
    }
    
    func animateCardAfterSwiping() {
        for (i,card) in currentLoadedCardsArray.enumerated() {
            let storyboard = UIStoryboard(name: "SwipeStoryBoard", bundle: nil)
            let pageVC = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
            
            pageVC.view.frame = self.currentLoadedCardsArray[i].frame
            let page = pageVC.orderedViewControllers[1] as! DetailImageSwipeCardVC
            guard let pageURL = URL(string: valueArray[i].photoUrl!) else {return}
            page.detailImageVIew.load(url: pageURL)

//            page.detailImageVIew.frame = viewTinderBackGround.frame
            let cardWidth = viewTinderBackGround.frame.width
            let cardHeight = viewTinderBackGround.frame.height
            page.imageWidth = cardWidth
            page.imageHeight = cardHeight
            
//            page.detailImageVIew.frame.size.width = cardWidth - 20
//            page.detailImageVIew.frame.size.height = cardHeight - 80
////            page.detailImageVIew.frame.offsetBy(dx: 0, dy: 30)
//            page.detailImageVIew.frame.origin.x = 10
//            page.detailImageVIew.frame.origin.y = 80

            print("image\(page.imageWidth)")

            page.name.text = valueArray[i].posterName!
//            page.category.text = valueArray[i].posterInterest
            
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

            
            
            //page.category.text = "\(valueArray[i].categoryIdx)"
            
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
        //print("카드가 오른쪽으로 갔을때")
        removeObjectAndAddNewValues()
        
        var likedPoster: [Posters] = []
        
        //add userDefaults
        let defaults = UserDefaults.standard
        if let posterData = defaults.object(forKey: "poster") as? Data {
            if let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData) {
                for i in posterInfo {
                    //유저 디폴츠에 있는 포스터중 likedPoster에 있는
                    if isDuplicateInLikedPoster(likedPoster, input: i) == false {//중복 되지 않을때만 넣는다.
                        print("중복 되지 않을때 포스터의 이름\(i.posterName!)")
                        likedPoster.append(i)
                    }
                }
            }
        }
        
        likedPoster.append(likedArray[currentIndex-1])
        
        defaults.setValue(try? PropertyListEncoder().encode(likedPoster), forKey: "poster")
        
        print("유저 디폴츠에 poster가 추가 되었습니다 \(likedPoster)")
        print("최종적으로 보내는 userdefaults의 내용을 보자")
        
        //CalendarVC, CalnedarView에 알려야 한다. (달력에 표시 , todotableview에 표시)
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
        //URLSession.shared.data
    }
    
    func load(url: URL) {
        getData(from: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                self?.image = UIImage(data: data)
//                self?.image?.withRenderingMode(.alwaysOriginal)
//                self?.image = self?.image?.resize(withWidth: 100)
                print("selfasldjasldjaslkjdlkasdj\(self?.image?.size)")
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

