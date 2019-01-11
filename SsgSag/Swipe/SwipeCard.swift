
let NAMES = ["Adam Gontier","Matt Walst","Brad Walst","Neil Sanderson","Barry Stock","Nicky Patson"]
let THERESOLD_MARGIN = (UIScreen.main.bounds.size.width/2) * 0.5
let SCALE_STRENGTH : CGFloat = 4
let SCALE_RANGE : CGFloat = 0.90

import UIKit

class SwipeCard: UIView {
    
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var originalPoint = CGPoint.zero
    var imageViewStatus = UIImageView()
    var overLayImage = UIImageView()
    var isLiked = false
    
    weak var delegate: SwipeCardDelegate?
    
    public init(frame: CGRect, value: String) {
        super.init(frame: frame)
        print("1")
    
        setupView(at: value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //카드 setup
    func setupView(at value:String) {
        //layer.cornerRadius = 20
        print("setup")
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        layer.shadowColor = UIColor.darkGray.cgColor
        clipsToBounds = true
        //이거 false로 하면 첫번째 카드만 반응함
        isUserInteractionEnabled = true
        originalPoint = center
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        addGestureRecognizer(panGestureRecognizer)
        
        imageViewStatus = UIImageView(frame: CGRect(x: (frame.size.width / 2) - 37.5, y: 25, width: 75, height: 75))
        let imageURL = URL(string: value)
        imageViewStatus.load(url: imageURL!)
        //imageViewStatus = UIImageView.load(url:value)
        imageViewStatus.alpha = 0
        addSubview(imageViewStatus)
        
        overLayImage = UIImageView(frame:bounds)
        overLayImage.alpha = 0
        addSubview(overLayImage)
        //bringSubviewToFront(<#T##view: UIView##UIView#>)
    }
    
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        
        //gesture에 따라
        switch gestureRecognizer.state {
        case .began: //스와이프 시작
            print("스와이프 시작")
            originalPoint = self.center;
            break;
        case .changed: //스와이프 하는 중간
//            print("스와이프 하는 중간")
            let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
            let rotationAngel = .pi/8 * rotationStrength
            let scale = max(1 - abs(rotationStrength) / SCALE_STRENGTH, SCALE_RANGE)
            center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
            let transforms = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            updateOverlay(xCenter)
            break;
        case .ended: //스와이프 끝
            print("스와이프 끝")
            afterSwipeAction()
            break;
        case .possible:break
        case .cancelled:break
        case .failed:break
        }
        
    }
    
    //좋아요 되는동안 바뀌는 부분
    func updateOverlay(_ distance: CGFloat) {
        //imageViewStatus.image = distance > 0 ? #imageLiteral(resourceName: "btn_like_pressed") : #imageLiteral(resourceName: "btn_skip_pressed")
        overLayImage.image = distance > 0 ? #imageLiteral(resourceName: "imgMainSwipeO") : #imageLiteral(resourceName: "imgMainSwipeX")
        imageViewStatus.alpha = min(abs(distance) / 100, 1)
        overLayImage.alpha = min(abs(distance) / 100, 1)
    }
    
    //스와이프 끝남
    func afterSwipeAction() {
        //일정 부분 이상 지나면 rightAction
        if xCenter > THERESOLD_MARGIN {
            rightAction()
        }
        else if xCenter < -THERESOLD_MARGIN {
            leftAction()
        }else {
            //reseting image
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.imageViewStatus.alpha = 0
                self.overLayImage.alpha = 0
            })
        }
        
        print("카드 스와이핑 액션이 왼족 오른쪽에 따라 완전히 끝났다")
    }
    //오른쪽 스와이프 , 좋아요
    func rightAction() {
        let finishPoint = CGPoint(x: frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = true
        delegate?.cardGoesRight(card: self)
        
        getPosterData()
        //나의 userdefaults에 저장하기
        
        print("RIGHT 액션")
    }
    
    //수동입력 추가 완료
    func getPosterData() {
        let posterURL = URL(string: "http://54.180.79.158:8080/posters/manualAdd")
        var request = URLRequest(url: posterURL!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoyfQ.kl46Nyv3eGs6kW7DkgiJgmf_1u1-bce1kLXkO7mcQvw"
        request.addValue("\(key2)", forHTTPHeaderField: "Authorization")
        
        let json: [String: Any] =  [
            "categoryIdx" : 2,
            "manualName" : "민지쓰",
            "manualDetail" : "허수진 API짜주세요",
            "manualStartDate" : "2019-01-07 05:10",
            "manualEndDate" : "2019-01-09 05:10",
            "isAlarm" : 1
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                return
            }
            print("좋아요 \(data)")
            //print("reponse \(response)")
            do {
                let order = try JSONDecoder().decode(Json4Swift_Base.self, from: data)
                print("좋아요 \(order)")
            }catch{
                print("JSON Parising Error")
            }
        }
        task.resume()
    }

    //왼쪽 스와이프
    func leftAction() {
        let finishPoint = CGPoint(x: -frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = false
        delegate?.cardGoesLeft(card: self)
        print("WATCHOUT LEFT")
    }
    
    // right click action
    func rightClickAction() {
        overLayImage.image = UIImage(named: "imgMainSwipeO")
//        overLayImage.image = #imageLiteral(resourceName: "overlay_like")
        let finishPoint = CGPoint(x: center.x + frame.size.width * 2, y: center.y)
        imageViewStatus.alpha = 0.5
        overLayImage.alpha = 1.0
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: 1)
            self.imageViewStatus.alpha = 1.0
            self.overLayImage.alpha = 1.0
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        isLiked = true
        delegate?.cardGoesRight(card: self)
        print("WATCHOUT RIGHT ACTION")
    }
    
    // left click action
    func leftClickAction() {
        overLayImage.image = UIImage(named: "imgMainSwipeX")
//        overLayImage.image = #imageLiteral(resourceName: "overlay_skip")
        let finishPoint = CGPoint(x: center.x - frame.size.width * 2, y: center.y)
        imageViewStatus.alpha = 0.5
        overLayImage.alpha = 1.0
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: -1)
            self.imageViewStatus.alpha = 1.0
            self.overLayImage.alpha = 1.0
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
    
        isLiked = false
        delegate?.cardGoesLeft(card: self)
        print("WATCHOUT LEFT ACTION")
    }
    
    //뒤로가기 액션
    
    func shakeAnimationCard(){
        imageViewStatus.image = #imageLiteral(resourceName: "btn_skip_pressed")
        overLayImage.image = #imageLiteral(resourceName: "overlay_skip")
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.center = CGPoint(x: self.center.x - (self.frame.size.width / 2), y: self.center.y)
            self.transform = CGAffineTransform(rotationAngle: -0.2)
            self.imageViewStatus.alpha = 1.0
            self.overLayImage.alpha = 1.0
        }, completion: {(_) -> Void in
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.imageViewStatus.alpha = 0
                self.overLayImage.alpha = 0
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
            }, completion: {(_ complete: Bool) -> Void in
                self.imageViewStatus.image = #imageLiteral(resourceName: "btn_like_pressed")
                self.overLayImage.image =  #imageLiteral(resourceName: "overlay_like")
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.imageViewStatus.alpha = 1
                    self.overLayImage.alpha = 1
                    self.center = CGPoint(x: self.center.x + (self.frame.size.width / 2), y: self.center.y)
                    self.transform = CGAffineTransform(rotationAngle: 0.2)
                }, completion: {(_ complete: Bool) -> Void in
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        self.imageViewStatus.alpha = 0
                        self.overLayImage.alpha = 0
                        self.center = self.originalPoint
                        self.transform = CGAffineTransform(rotationAngle: 0)
                    })
                })
            })
        })
        
        print("WATCHOUT SHAKE ACTION")
    }
}


