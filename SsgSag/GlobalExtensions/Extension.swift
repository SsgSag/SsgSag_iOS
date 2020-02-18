//
//  GradientColor.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 4..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit
import SearchTextField
import RxSwift

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

extension UIView {
    func setGradientBackGround(colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor, colorThree.cgColor]
        gradientLayer.locations = [0.1, 0.8, 1.2]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.3, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBackGround(colorOne: UIColor, colorTwo: UIColor, frame: CGRect) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}


extension UIButton {
    func myButtonTapped(myButton: UIButton){
        if myButton.isSelected == true {
            myButton.isSelected = false
        } else {
            myButton.isSelected = true
        }
    }
    
    func deviceSetSize() {
        // 아이폰 노치바대응
        // 제출하기, 완료하기, 등 하단의 긴버튼 크기조절
        if UIScreen.main.bounds.height >= 812 {
            self.constraints.forEach { layout in
                if layout.firstAttribute == .height {
                    layout.constant = 83
                }
            }
        } else {
            self.contentVerticalAlignment = .center
            self.titleEdgeInsets.top = 0
            self.constraints.forEach { layout in
                if layout.firstAttribute == .height {
                    layout.constant = 49
                }
            }
        }
        
    }
}


extension NSObject {
    
    //스토리보드 idetifier
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


enum AlertType {
    case ok
    case warning
    case cancel
}

extension UIViewController {
    func simpleActionSheet(title: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        actions.forEach{ alert.addAction($0) }
        present(alert, animated: true)
    }
    
    //확인 팝업
    func simpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        alert.modalPresentationStyle = .fullScreen
        present(alert, animated: true)
    }
    
    func simplerAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        alert.modalPresentationStyle = .fullScreen
        present(alert, animated: true, completion: nil)
    }
    
    func simplerAlertWithTimer(title: String, after time: Double) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.modalPresentationStyle = .fullScreen
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            alert.dismiss(animated: true)
        }
    }
    
    //확인, 취소 팝업
    func simpleAlertwithHandler(title: String,
                                message: String,
                                okHandler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.modalPresentationStyle = .fullScreen
        present(alert, animated: false, completion: nil)
    }
    
    func simpleAlertWithHandlers(title: String,
                                 message: String,
                                 okHandler: ((UIAlertAction) -> Void)?,
                                 cancelHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인",
                                     style: .default,
                                     handler: okHandler)
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: cancelHandler)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.modalPresentationStyle = .fullScreen
        present(alert, animated: false, completion: nil)
    }
    
    func makeAlertObservable(title: String, message: String? = nil) -> Observable<AlertType> {
        let alertObservable = Observable<AlertType>.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }
            if let message = message {
                self.simpleAlertWithHandlers(title: title,
                                             message: message,
                                             okHandler: { _ in
                                                observer.onNext(.ok)
                                                observer.onCompleted() },
                                             cancelHandler: { _ in
                                                observer.onNext(.cancel)
                                                observer.onCompleted()
                })
            } else {
                self.simplerAlertWithTimer(title: title, after: 1)
            }
            return Disposables.create()
        }
        return alertObservable
    }
    
    func simpleAlertwithOKButton(title: String, message: String, okHandler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default, handler: okHandler)
        alert.addAction(okAction)
        alert.modalPresentationStyle = .fullScreen
        present(alert, animated: true, completion: nil)
    }
    
    func simplerAlertwhenSave(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: dismissView)
        alert.addAction(action)
        alert.modalPresentationStyle = .fullScreen
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func dismissView(action: UIAlertAction) {
        dismiss(animated: true, completion: nil)
    }
    
    // navigationBar 컬러 설정하는 메소드
    func setNavigationBar(color: UIColor) {
        let bar: UINavigationBar! = self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = color
    }
    
    // navigationbar 투명하게 하는 메소드
    func setNavigationBar() {
        let bar: UINavigationBar! = self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    func setLeftBtn(title: String, color : UIColor){
        
        let leftBTN = UIBarButtonItem(title: title, //백버튼 이미지 파일 이름에 맞게 변경해주세요.
            style: .plain,
            target: self,
            action: #selector(self.pop))
        navigationItem.leftBarButtonItem = leftBTN
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    
    //커스텀 백버튼 설정
    func setBackBtn(color: UIColor) {
        
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"), //백버튼 이미지 파일 이름에 맞게 변경해주세요.
            style: .plain,
            target: self,
            action: #selector(self.pop))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //커스텀 팝업 띄우기 애니메이션
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    //커스텀 팝업 끄기 애니메이션
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
}

extension UIView {
    func applyShadow(radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float) {
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
    }
    
    func applyRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func applyBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}


extension UIView {
    
    func circleView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.layer.frame.width / 2
    }
    
    //뷰 라운드 처리 설정
    func makeRounded(cornerRadius : CGFloat?){
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        self.layer.masksToBounds = true
    }
    
    //뷰 그림자 설정
    //color: 색상, opacity: 그림자 투명도, offset: 그림자 위치, radius: 그림자 크기
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIImageView {
    
    //이미지뷰 동그랗게 설정
    func circleImageView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
    }
}

extension UITextView {
    
    //텍스트뷰 스크롤 상단으로 초기화
    //따로 메소드를 호출하지 않아도 이 메소드가 extension에 선언된 것만으로 적용이 됩니다.
    override open func draw(_ rect: CGRect)
    {
        super.draw(rect)
        setContentOffset(CGPoint.zero, animated: false)
    }
}

extension CALayer {
    
    //뷰 테두리 설정
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}


extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
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

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

extension UINavigationBar {
    func addColorToShadow(color: UIColor, size: CGSize) {
        self.clipsToBounds = false
        self.shadowImage = color.image(size)
    }
}

extension Date {
    func getDaysInMonth() -> Int {
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self),
                                            month: calendar.component(.month, from: self))
        
        guard let date = calendar.date(from: dateComponents),
            let range = calendar.range(of: .day, in: .month, for: date) else { return 0 }
        
        let numDays = range.count
        
        return numDays
    }
    
    func changeDaysBy(days : Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}

enum FontType {
    case regular, bold, medium, light, semibold
}

extension UIFont {
    static func fontWithName(type: FontType, size: CGFloat) -> UIFont {
        var fontName = ""
        switch type {
        case .regular:
            fontName = "AppleSDGothicNeo-Regular"
        case .light:
            fontName = "AppleSDGothicNeo-Light"
        case .medium:
            fontName = "AppleSDGothicNeo-Medium"
        case .semibold:
            fontName = "AppleSDGothicNeo-SemiBold"
        case .bold:
            fontName = "AppleSDGothicNeo-Bold"
        }
        
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

extension SearchTextField {
    open override func awakeFromNib() {
        self.theme.bgColor = .white
        self.theme.font = UIFont.systemFont(ofSize: 13)
    }
}
