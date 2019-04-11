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
        setupView(at: value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //카드 setup
    func setupView(at value:String) {
        //layer.cornerRadius = 20
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
        
//        imageViewStatus = UIImageView(frame: CGRect(x: (frame.size.width / 2) - 37.5, y: 75, width: 75, height: 75))
//        let imageURL = URL(string: value)
//        imageViewStatus.load(url: imageURL!)
//        imageViewStatus.alpha = 0
//        addSubview(imageViewStatus)
        
        
        let imageURL = URL(string: value)
        overLayImage = UIImageView(frame:bounds)
        overLayImage.alpha = 0
        overLayImage.load(url: imageURL!)
        addSubview(overLayImage)
    }
    
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        
        switch gestureRecognizer.state {
        case .began:
            originalPoint = self.center;
            break;
        case .changed:
            let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
            let rotationAngel = .pi/8*rotationStrength
            let scale = max(1 - abs(rotationStrength) / SCALE_STRENGTH, SCALE_RANGE)
            center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
            let transforms = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            updateOverlay(xCenter)
            break;
        case .ended:
            afterSwipeAction()
            break;
        case .possible:break
        case .cancelled:break
        case .failed:break
        }
    }
    
    //좋아요 되는동안 바뀌는 부분
    func updateOverlay(_ distance: CGFloat) {
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
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.imageViewStatus.alpha = 0
                self.overLayImage.alpha = 0
            })
        }
    }
    
    //오른쪽 스와이프 , 좋아요
    func rightAction() {
        let finishPoint = CGPoint(x: frame.size.width * 2, y: 2 * yCenter + originalPoint.y)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            DispatchQueue.main.async {
                self.removeFromSuperview()
            }
        })
        
        isLiked = true
        
        delegate?.cardGoesRight(card: self)
        
        getPosterData()
    }
    
    //수동입력 추가 완료
    func getPosterData() {
        let posterURL = URL(string: "http://54.180.32.22:8080/posters/manualAdd")
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
        
        NetworkManager.shared.getData(with: request) { (data, err, res) in
//            guard let data = data else {
//                return
//            }
//            do {
//                //let order = try JSONDecoder().decode(networkData.self, from: data)
//            } catch {
//                print("JSON Parising Error")
//            }
        }
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
    }
    
    // right click action
    func rightClickAction() {
        overLayImage.image = UIImage(named: "imgMainSwipeO")
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
    }
    
    // left click action
    func leftClickAction() {
        overLayImage.image = UIImage(named: "imgMainSwipeX")
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
}
