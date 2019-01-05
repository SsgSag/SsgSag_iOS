let  MAX_BUFFER_SIZE = 3;
let  SEPERATOR_DISTANCE = 8;
let  TOPYAXIS = 75;

import UIKit
import Alamofire
import ObjectMapper

class SwipeVC: UIViewController {
    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet weak var viewActions: UIView!
    @IBOutlet var countLabel: UILabel!
    
    
    @IBAction func moveToMyPage(_ sender: Any) {
        
    }
    
    var currentLoadedCardsArray = [SwipeCard]()
    var allCardsArray = [SwipeCard]()
    
    //var valueArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36"]
    
    //var valueArray = ["1","2","3","4","5","6"]
    
    lazy var valueArray:[String] = []
    lazy var likedArray:[Posters] = []
    
    var abcde = "abcde"
    
    var currentIndex = 0
    var countTotalCardIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosterData()
        
        
        viewActions.isUserInteractionEnabled = true
        
        countLabel.layer.cornerRadius = 10
        countLabel.layer.masksToBounds = true
        
        
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    func getPosterData() {
        let posterURL = URL(string: "http://54.180.79.158:8080/posters/show")
        var request = URLRequest(url: posterURL!)
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoxfQ.5lCvAqnzYP4-2pFx1KTgLVOxYzBQ6ygZvkx5jKCFM08"
        request.addValue("\(key2)", forHTTPHeaderField: "Authorization")
        
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
                        //photoUrl을 valueArray에 저장
                        self.valueArray.append(i.photoUrl!)
                        self.likedArray.append(i)
                        //                        print(i.posterRegDate)
                        //                        print(i.posterStartDate)
                        //                        print(i.posterEndDate)
                        
                        //date parsing
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        guard let startdate = dateFormatter.date(from: i.posterStartDate!) else {
                            fatalError("ERROR: Date conversion failed due to mismatched format.")
                        }
                        guard let regdate = dateFormatter.date(from: i.posterRegDate!) else {
                            fatalError("ERROR: Date conversion failed due to mismatched format.")
                        }
                        guard let endtdate = dateFormatter.date(from: i.posterEndDate!) else {
                            fatalError("ERROR: Date conversion failed due to mismatched format.")
                        }
                        
                        //
                        print("\(i.posterRegDate!) \(startdate)")
                        print("\(i.posterStartDate!) \(regdate.description)")
                        print("\(i.posterEndDate!) \(endtdate)")
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
        
        viewActions.isUserInteractionEnabled = true
        //loadCardValues()
    }
    
    //카드를 로드한다.
    func loadCardValues() {
        if valueArray.count > 0 {
            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
            for (i,value) in valueArray.enumerated() {
                let newCard = createSwipeCard(at: i,value: value)
                
                allCardsArray.append(newCard)
//                print(allCardsArray)
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
        print("create")
        let card = SwipeCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 10) ,value : value)
        countTotalCardIndex += 1
        print("countTotalCardIndex: \(countTotalCardIndex)")
        print("create")
        card.delegate = self
        return card
    }
    
    //카드 객체 제거, 새로운 value추가
    func removeObjectAndAddNewValues() {
        currentLoadedCardsArray.remove(at: 0)
        print("valueArray.count: \(valueArray.count)")
        print("currentIndex: \(currentIndex)")
        currentIndex = currentIndex + 1
        countLabel.text = "\(valueArray.count-currentIndex)"
        print("카드 개수 \(currentIndex)")
        
        //마지막 카드를 사용하고나서도 앱이 꺼지지 않게 개수 조절!
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
            currentLoadedCardsArray.append(card)
            
            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2])
        }
        
        animateCardAfterSwiping()
        
    }
    
    func animateCardAfterSwiping() {
        
        print("카드가 스와이핑 되고나서")
        
        for (i,card) in currentLoadedCardsArray.enumerated() {
            //각 카드에 스와이프 카드를 등록
            let storyboard = UIStoryboard(name: "SwipeStoryBoard", bundle: nil)
            let pageVC = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
            
            //오류 있음. 2개 잇으면 2 아래로? 
            //            if i < 2 {
            print("i를 프린트 해봅시다 \(i)")
            pageVC.view.frame = self.currentLoadedCardsArray[i].frame
            var page = pageVC.orderedViewControllers[1] as! DetailImageSwipeCardVC
            guard let pageURL = URL(string: valueArray[i]) else {return}
            page.detailImageVIew.load(url: pageURL)
//            countLabel.text = "\(i+1)"
            
            print("currentLoadedCardsArray.count \(currentLoadedCardsArray.count)")
            print("allcardsArray.count \(allCardsArray.count)")
            
            self.addChild(pageVC)
            self.currentLoadedCardsArray[i].insertSubview(pageVC.view, at: 0)
            pageVC.didMove(toParent: self)
            
            //최상단의 카드만 InteractionEnabled 하게 함
            if i == 0 {
                card.isUserInteractionEnabled = true
            }
            //            }
        }
        
    }
    
    //싫어요
    @IBAction func disLikeButtonAction(_ sender: Any) {
        let card = currentLoadedCardsArray.first
        card?.leftClickAction()
    }
    
    //좋아요
    @IBAction func LikeButtonAction(_ sender: Any) {
        
        //        UserDefaults.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
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
        print("daskdkasjdlasj")
        
//        print(likedArray[currentIndex-1])
        let likedPoster: Posters = likedArray[currentIndex-1]
        
        let defaults = UserDefaults.standard
        defaults.setValue(try? PropertyListEncoder().encode(likedPoster), forKey: "poster")
        
        guard let posterData = defaults.object(forKey: "poster") as? Data else { return }
        
        guard let posterInfo = try? PropertyListDecoder().decode(Posters.self, from: posterData) else { return }
        
//        print("posterrrrrr: \(posterInfo.posterName)")
        
        
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



