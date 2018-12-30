let  MAX_BUFFER_SIZE = 3;
let  SEPERATOR_DISTANCE = 8;
let  TOPYAXIS = 75;

import UIKit

class SwipeVC: UIViewController {
    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet weak var buttonUndo: UIButton!
    @IBOutlet weak var viewActions: UIView!

    var currentIndex = 0
    var currentLoadedCardsArray = [SwipeCard]()
    var allCardsArray = [SwipeCard]()
    
    var valueArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewActions.alpha = 0
        buttonUndo.alpha = 0
    }

    //캘린더 이동
    @IBAction func moveToCalendar(_ sender: Any) {
        let calendarVC = CalenderVC()
        present(calendarVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        loadCardValues()
    }
    
    //
    func loadCardValues() {
        if valueArray.count > 0 {
            //currentLoadedCardsArray 에 스와이프 카드 추가.
            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
            
            for (i,value) in valueArray.enumerated() {
                let newCard = createSwipeCard(at: i,value: value)
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
            perform(#selector(loadInitialDummyAnimation), with: nil, afterDelay: 0.0)
        }
    }
    
    @objc func loadInitialDummyAnimation() {
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveLinear, animations: {
            self.viewActions.alpha = 1.0
        }, completion: nil)
    }
    
    //SwipeCard 생성
    func createSwipeCard(at index: Int , value :String) -> SwipeCard {
        let card = SwipeCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 10) ,value : value)
        card.delegate = self
        return card
    }
    
    //카드 제거 혹은 추가
    func removeObjectAndAddNewValues() {
        UIView.animate(withDuration: 0.5) {
            self.buttonUndo.alpha = 0
        }
        
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1
        
        //뒤로가기 버튼 필요할 시 사용
        Timer.scheduledTimer(timeInterval: 1.01, target: self, selector: #selector(enableUndoButton), userInfo: currentIndex, repeats: false)
        
        let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
        
        //뒤에카드 표시 해주기 위함
//        var frame = card.frame
//        frame.origin.y = CGFloat(MAX_BUFFER_SIZE * SEPERATOR_DISTANCE)
//        card.frame = frame
        
        currentLoadedCardsArray.append(card)
        
        viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2])
        
//        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
//            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
//            var frame = card.frame
//            frame.origin.y = CGFloat(MAX_BUFFER_SIZE * SEPERATOR_DISTANCE)
//            card.frame = frame
//            currentLoadedCardsArray.append(card)
//            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2])
//        }
        
        animateCardAfterSwiping()
    }
    
    func animateCardAfterSwiping() {
        //모든 스와이프 카드에서
        for (i,card) in currentLoadedCardsArray.enumerated() {
            //각 카드에 스와이프 카드를 등록
            let storyboard = UIStoryboard(name: "SwipeStoryBoard", bundle: nil)
            let pageVC = storyboard.instantiateViewController(withIdentifier: "PageViewController")
            
            pageVC.view.frame = self.currentLoadedCardsArray[i].frame
            self.addChild(pageVC)
            self.currentLoadedCardsArray[i].insertSubview(pageVC.view, at: 0)
            pageVC.didMove(toParent: self)
            
            UIView.animate(withDuration: 0.5, animations: {
                if i == 0 {
                    card.isUserInteractionEnabled = true
                }
//                var frame = card.frame
//                frame.origin.y = CGFloat(i * SEPERATOR_DISTANCE)
//                card.frame = frame
            })
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
    
    //포스터 뒤로가기 버튼
    @IBAction func undoButtonAction(_ sender: Any) {
        currentIndex =  currentIndex - 1
        if currentLoadedCardsArray.count == MAX_BUFFER_SIZE {
            
            let lastCard = currentLoadedCardsArray.last
            lastCard?.rollBackCard()
            currentLoadedCardsArray.removeLast()
        }
        let undoCard = allCardsArray[currentIndex]
        undoCard.layer.removeAllAnimations()
        viewTinderBackGround.addSubview(undoCard)
        undoCard.makeUndoAction() //--> 뒤로가기 액션
        
        currentLoadedCardsArray.insert(undoCard, at: 0)
        animateCardAfterSwiping()
        if currentIndex == 0 {
            UIView.animate(withDuration: 0.5) {
                self.buttonUndo.alpha = 0
            }
        }
    }
    
    //이전 포스터 보기 버튼 (지금은 필요 x)
    @objc func enableUndoButton(timer: Timer){
        let cardIntex = timer.userInfo as! Int
        if (currentIndex == cardIntex) {
            UIView.animate(withDuration: 0.5) {
                self.buttonUndo.alpha = 1.0
            }
        }
    }
    
    
}

extension SwipeVC : SwipeCardDelegate {
    // action called when the card goes to the left.
    func cardGoesLeft(card: SwipeCard) {
        removeObjectAndAddNewValues()
    }
    // action called when the card goes to the right.
    func cardGoesRight(card: SwipeCard) {
        removeObjectAndAddNewValues()
    }
    
    func currentCardStatus(card: SwipeCard, distance: CGFloat) {
        if distance == 0 {
        } else {
            let value = Float(min(abs(distance/100), 1.0) * 5)
//            let sorted = distance > 0  ? 2.5 + (value * 5) / 10  : 2.5 - (value * 5) / 10
        }
    }
}



