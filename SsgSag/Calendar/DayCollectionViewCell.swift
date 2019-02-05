
//날짜 하나에 해당하는 셀
class DayCollectionViewCell: UICollectionViewCell {
    
    var todoStatus = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius=5
        layer.masksToBounds=true
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeToUp), name: NSNotification.Name("changeToUp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeToDown), name: NSNotification.Name("changeToDown"), object: nil)
        
        layoutSubviews()
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
        self.layoutIfNeeded()
        
        
    }
    
    @objc func changeToDown() {
        print("내려와")
        todoStatus = 1
        self.layoutIfNeeded()
    }
    
    func setupDotContentsView(eventNum: Int, categories: [Int]) {
        
        dotContentsView.dotView1.isHidden = true
        dotContentsView.dotView2.isHidden = true
        dotContentsView.dotView3.isHidden = true
        dotContentsView.dotView4.isHidden = true
        dotContentsView.dotView5.isHidden = true
        
        addSubview(dotContentsView)
        dotContentsView.isHidden = false
        
        
        dotContentsView.topAnchor.constraint(equalTo: lbl.bottomAnchor , constant: 2).isActive = true
        dotContentsView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dotContentsView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
        dotContentsView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        
        switch eventNum {
        case 1:
            dotContentsView.dotView1.isHidden = false
            
            NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            
        case 2:
            dotContentsView.dotView1.isHidden = false
            dotContentsView.dotView2.isHidden = false
            NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.85, constant: 0).isActive = true
            
            NSLayoutConstraint(item: dotContentsView.dotView2, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.15, constant: 0).isActive = true
            
        case 3:
            dotContentsView.dotView1.isHidden = false
            dotContentsView.dotView2.isHidden = false
            dotContentsView.dotView3.isHidden = false
            NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.7, constant: 0).isActive = true
            
            NSLayoutConstraint(item: dotContentsView.dotView2, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            
            NSLayoutConstraint(item: dotContentsView.dotView3, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.3, constant: 0).isActive = true
            
        case 4:
            dotContentsView.dotView1.isHidden = false
            dotContentsView.dotView2.isHidden = false
            dotContentsView.dotView3.isHidden = false
            dotContentsView.dotView4.isHidden = false
            NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.55, constant: 0).isActive = true
            
            NSLayoutConstraint(item: dotContentsView.dotView2, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.85, constant: 0).isActive = true
            
            NSLayoutConstraint(item: dotContentsView.dotView3, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.15, constant: 0).isActive = true
            
            NSLayoutConstraint(item: dotContentsView.dotView4, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.45, constant: 0).isActive = true
            
        case 5:
            dotContentsView.dotView1.isHidden = false
            dotContentsView.dotView2.isHidden = false
            dotContentsView.dotView3.isHidden = false
            dotContentsView.dotView4.isHidden = false
            dotContentsView.dotView5.isHidden = false
            NSLayoutConstraint(item: dotContentsView.dotView1, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.4, constant: 0).isActive = true
            
            NSLayoutConstraint(item: dotContentsView.dotView2, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 0.7, constant: 0).isActive = true
            
            NSLayoutConstraint(item: dotContentsView.dotView3, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            
            NSLayoutConstraint(item: dotContentsView.dotView4, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.3, constant: 0).isActive = true
            
            NSLayoutConstraint(item: dotContentsView.dotView5, attribute: .centerX, relatedBy: .equal, toItem: dotContentsView, attribute: .centerX, multiplier: 1.6, constant: 0).isActive = true
            
        default:
            break
        }
        
        
        print("dotView Width: \(dotContentsView.dotView1.frame.width)")
        //        dotContentsView.dotView1.circleView()
        
        dotContentsView.layoutSubviews()
        dotContentsView.layoutIfNeeded()
        bringSubviewToFront(lbl)
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
    
    //날짜 텍스트
    func setupViews() {
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lbl.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.47).isActive = true
        lbl.heightAnchor.constraint(equalTo: lbl.widthAnchor).isActive = true
        
        bringSubviewToFront(lbl)
        //        dot.addSubview(lineLabel)
        //        lineLabel.leftAnchor.constraint(equalTo: line.leftAnchor).isActive = true
        //        lineLabel.rightAnchor.constraint(equalTo: line.rightAnchor).isActive = true
        //        lineLabel.topAnchor.constraint(equalTo: line.topAnchor).isActive = true
        //        lineLabel.bottomAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
    }
    
    //일
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor=Colors.darkGray
        label.layer.cornerRadius = label.frame.height / 2
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
