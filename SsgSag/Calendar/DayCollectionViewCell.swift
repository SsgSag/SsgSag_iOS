
//날짜 하나에 해당하는 셀
class DayCollectionViewCell: UICollectionViewCell {
    
    var todoStatus = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeToUp), name: NSNotification.Name("changeToUp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeToDown), name: NSNotification.Name("changeToDown"), object: nil)
        
        //layoutSubviews()
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
        
        
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
    }
    
    @objc func changeToUp() {
        todoStatus = -1
        reloadInputViews()
    }
    
    @objc func changeToDown() {
        print("내려와")
        todoStatus = 1
    }
    
    func setupDotContentsView(events: [event]) {
        
        if events.count > 0 {
            if todoStatus == -1 {
                dotAndLineView1.backgroundColor = .clear
                
                
                dotAndLineView1WidthAnchor?.isActive = false
                dotAndLineView1HeightAnchor?.isActive = false
                
                dotAndLineView1.widthAnchor.constraint(equalToConstant: frame.width * 0.1)
                dotAndLineView1HeightAnchor = dotAndLineView1.heightAnchor.constraint(equalToConstant: frame.height * 0.1)
                
                dotAndLineView1WidthAnchor?.isActive = true
                dotAndLineView1HeightAnchor?.isActive = true
            
                dotAndLineView1.backgroundColor = .red
            }else {
                dotAndLineView1.backgroundColor = .clear
                
                dotAndLineView1WidthAnchor?.isActive = false
                dotAndLineView1HeightAnchor?.isActive = false
                
                dotAndLineView1WidthAnchor = dotAndLineView1.widthAnchor.constraint(equalToConstant: frame.width)
                dotAndLineView1HeightAnchor = dotAndLineView1.heightAnchor.constraint(equalToConstant: frame.height * 0.4)
                
                
                dotAndLineView1WidthAnchor?.isActive = true
                dotAndLineView1HeightAnchor?.isActive = true
                
                dotAndLineView1.backgroundColor = .red
            }
            dotAndLineView1.isHidden = false
        }
        
        
        
        
//
//        addSubview(dotContentsView)
//        dotContentsView.isHidden = false
//
//        dotContentsView.topAnchor.constraint(equalTo: lbl.bottomAnchor , constant: 2).isActive = true
//        dotContentsView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        dotContentsView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
//        dotContentsView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//
//        switch eventNum {
//        case 1:
//            dotContentsView.dotView1.isHidden = false
//            NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        case 2:
//            dotContentsView.dotView1.isHidden = false
//            dotContentsView.dotView2.isHidden = false
//            NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.85, constant: 0).isActive = true
//
//            NSLayoutConstraint(item: dotContentsView.dotView2, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.15, constant: 0).isActive = true
//        case 3:
//            dotContentsView.dotView1.isHidden = false
//            dotContentsView.dotView2.isHidden = false
//            dotContentsView.dotView3.isHidden = false
//            NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.7, constant: 0).isActive = true
//
//            NSLayoutConstraint(item: dotContentsView.dotView2, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//
//            NSLayoutConstraint(item: dotContentsView.dotView3, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.3, constant: 0).isActive = true
//
//        case 4:
//            dotContentsView.dotView1.isHidden = false
//            dotContentsView.dotView2.isHidden = false
//            dotContentsView.dotView3.isHidden = false
//            dotContentsView.dotView4.isHidden = false
//            NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.55, constant: 0).isActive = true
//
//            NSLayoutConstraint(item: dotContentsView.dotView2, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.85, constant: 0).isActive = true
//
//            NSLayoutConstraint(item: dotContentsView.dotView3, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.15, constant: 0).isActive = true
//
//            NSLayoutConstraint(item: dotContentsView.dotView4, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.45, constant: 0).isActive = true
//        case 5:
//            dotContentsView.dotView1.isHidden = false
//            dotContentsView.dotView2.isHidden = false
//            dotContentsView.dotView3.isHidden = false
//            dotContentsView.dotView4.isHidden = false
//            dotContentsView.dotView5.isHidden = false
//            NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.4, constant: 0).isActive = true
//
//            NSLayoutConstraint(item: dotContentsView.dotView2, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.7, constant: 0).isActive = true
//
//            NSLayoutConstraint(item: dotContentsView.dotView3, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//
//            NSLayoutConstraint(item: dotContentsView.dotView4, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.3, constant: 0).isActive = true
//
//            NSLayoutConstraint(item: dotContentsView.dotView5, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.6, constant: 0).isActive = true
//        default:
//            break
//        }
//
//
//        print("dotView Width: \(dotContentsView.dotView1.frame.width)")
//        //        dotContentsView.dotView1.circleView()
//        dotContentsView.layoutSubviews()
//        dotContentsView.layoutIfNeeded()
//        bringSubviewToFront(lbl)
    }
    
    func setupLineContentsView(eventNum: Int, categories: [Int]) {
        
        addSubview(lineContentsView)
        lineContentsView.isHidden = false
        
        lineContentsView.lineView1.isHidden = true
        lineContentsView.lineView2.isHidden = true
        lineContentsView.lineView3.isHidden = true
        lineContentsView.lineView4.isHidden = true
        lineContentsView.lineView5.isHidden = true
        
        lineContentsView.topAnchor.constraint(equalTo: lbl.bottomAnchor , constant: 2).isActive = true
        lineContentsView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineContentsView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lineContentsView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        switch eventNum {
            
        case 1:
            lineContentsView.lineView1.isHidden = false
            lineContentsView.lineTitle1.text = "테스트1"
            
        case 2:
            lineContentsView.lineView1.isHidden = false
            lineContentsView.lineView2.isHidden = false
            lineContentsView.lineTitle2.text = "테스트2222"
            
        default: break
            
        }
        bringSubviewToFront(lbl)
    }
    
    var dotAndLineView1TopAnchor: NSLayoutConstraint?
    var dotAndLineView1WidthAnchor: NSLayoutConstraint?
    var dotAndLineView1HeightAnchor: NSLayoutConstraint?
    var dotAndLineView1CenterXAnchor: NSLayoutConstraint?
    
    var dotAndLineView2TopAnchor: NSLayoutConstraint?
    var dotAndLineView2WidthAnchor: NSLayoutConstraint?
    var dotAndLineView2HeightAnchor: NSLayoutConstraint?
    var dotAndLineView2CenterXAnchor: NSLayoutConstraint?
    
    var dotAndLineView3TopAnchor: NSLayoutConstraint?
    var dotAndLineView3WidthAnchor: NSLayoutConstraint?
    var dotAndLineView3HeightAnchor: NSLayoutConstraint?
    var dotAndLineView3CenterXAnchor: NSLayoutConstraint?
    
    var dotAndLineView4TopAnchor: NSLayoutConstraint?
    var dotAndLineView4WidthAnchor: NSLayoutConstraint?
    var dotAndLineView4HeightAnchor: NSLayoutConstraint?
    var dotAndLineView4CenterXAnchor: NSLayoutConstraint?
    
    var dotAndLineView5TopAnchor: NSLayoutConstraint?
    var dotAndLineView5WidthAnchor: NSLayoutConstraint?
    var dotAndLineView5HeightAnchor: NSLayoutConstraint?
    var dotAndLineView5CenterXAnchor: NSLayoutConstraint?
    
    //날짜 텍스트
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bringSubviewToFront(lbl)
    
        addSubview(dotAndLineView1)
        addSubview(dotAndLineView2)
        addSubview(dotAndLineView3)
        addSubview(dotAndLineView4)
        addSubview(dotAndLineView5)

        if todoStatus == -1 {
            dotAndLineView1.circleView()
            dotAndLineView2.circleView()
            dotAndLineView3.circleView()
            dotAndLineView4.circleView()
            dotAndLineView5.circleView()
        } else {
            dotAndLineView1.applyRadius(radius: 0)
            dotAndLineView2.applyRadius(radius: 0)
            dotAndLineView3.applyRadius(radius: 0)
            dotAndLineView4.applyRadius(radius: 0)
            dotAndLineView5.applyRadius(radius: 0)
        }
        
    }
    
    //일
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        //label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        label.textColor=Colors.darkGray
        label.layer.cornerRadius = label.frame.height / 2
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let dotAndLineView1: UIView = {
        let dotView = UIView()
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.layer.masksToBounds = true
        dotView.backgroundColor = UIColor(displayP3Red: 96 / 255, green: 118 / 255, blue: 221 / 255, alpha: 1.0)
        return dotView
    }()
    
    let dotAndLineView2: UIView = {
        let dotView = UIView()
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.layer.masksToBounds = true
        dotView.backgroundColor = UIColor(displayP3Red: 7 / 255, green: 166 / 255, blue: 255 / 255, alpha: 1.0)
        return dotView
    }()
    
    let dotAndLineView3: UIView = {
        let dotView = UIView()
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.backgroundColor = UIColor(displayP3Red: 254 / 255, green: 109 / 255, blue: 109 / 255, alpha: 1.0)
        return dotView
    }()
    
    let dotAndLineView4: UIView = {
        let dotView = UIView()
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.backgroundColor = UIColor(displayP3Red: 255 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1.0)
        return dotView
    }()
    
    let dotAndLineView5: UIView = {
        let dotView = UIView()
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.backgroundColor = .black
        return dotView
    }()
    
    
    
    //구분선    
    let dotContentsView: DotView = {
        let dt = DotView()
        dt.translatesAutoresizingMaskIntoConstraints = false
        return dt
    }()
    
    let lineContentsView: LineView = {
        let line = LineView()
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
