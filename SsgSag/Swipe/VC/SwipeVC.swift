let  MAX_BUFFER_SIZE = 3;
let  SEPERATOR_DISTANCE = 8;
let  TOPYAXIS = 75;

import UIKit
import Alamofire
import ObjectMapper

class SwipeVC: UIViewController {
    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var overLapView: UIView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosterData()
        
       // viewActions.isUserInteractionEnabled = true
        
        countLabel.layer.cornerRadius = 10
        countLabel.layer.masksToBounds = true
        
        
        self.view.backgroundColor = UIColor(displayP3Red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
        self.view.bringSubviewToFront(viewTinderBackGround)
        
        
        for i in view.subviews {
            print(i.description)
        }
        print("\(view.subviews.count) 개수")
        
        self.view.bringSubviewToFront(overLapView)
    }

    func getPosterData() {
        let posterURL = URL(string: "http://54.180.79.158:8080/posters/show")
        var request = URLRequest(url: posterURL!)
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoyfQ.kl46Nyv3eGs6kW7DkgiJgmf_1u1-bce1kLXkO7mcQvw"
        request.addValue("\(key2)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                return
            }
            //print("data \(data)")
            print("reponse \(response)")
            do {
                
                let order = try JSONDecoder().decode(Json4Swift_Base.self, from: data)
                print("order \(order)")
                if let posters = order.data?.posters {
                    for i in posters {
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
                let newCard = createSwipeCard(at: i,value: value.photoUrl!)
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
        let card = SwipeCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 10) ,value : value)
        print("높이: \(viewTinderBackGround.frame.size.height)")
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
            page.name.text = valueArray[i].posterName!
            //page.category.text = "\(valueArray[i].categoryIdx)"
            
            let detailTextSwipe = pageVC.orderedViewControllers[0] as! DetailTextSwipeCard
            
            if let posterName = valueArray[i].posterName , let outline = valueArray[i].outline ,let target = valueArray[i].target ,let benefit = valueArray[i].benefit,let period = valueArray[i].period {
                
                detailTextSwipe.posterName.text = posterName
                detailTextSwipe.hashTag.text = "\(valueArray[i].categoryIdx)"
                
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
    
}

extension SwipeVC : SwipeCardDelegate {
    //카드가 왼쪽으로 갔을때
    func cardGoesLeft(card: SwipeCard) {
        removeObjectAndAddNewValues()
    }
    //카드 오른쪽으로 갔을때
    func cardGoesRight(card: SwipeCard) {
        removeObjectAndAddNewValues()
        
        let defaults = UserDefaults.standard
        guard let posterData = defaults.object(forKey: "poster") as? Data else { return }
        
        guard let posterInfo2 = try? PropertyListDecoder().decode([Posters].self, from: posterData) else { return }
        
        var likedPoster: [Posters] = []
        
        for i in posterInfo2 {
            likedPoster.append(i)
        }
        
        likedPoster.append(likedArray[currentIndex-1])
        
        //let defaults = UserDefaults.standard
        defaults.setValue(try? PropertyListEncoder().encode(likedPoster), forKey: "poster")
        
        //guard let posterData = defaults.object(forKey: "poster") as? Data else { return }
        
        guard let posterInfo = try? PropertyListDecoder().decode([Posters].self, from: posterData) else { return }
        
        

        for k in posterInfo {
            print(k)
        }
        
        //print("posterrrrrr: \(posterInfo)")

        
        
        //        }
//        print(valueArray)
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
            }
        }
    }
    
}



