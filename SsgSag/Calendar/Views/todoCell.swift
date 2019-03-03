class TodoTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        setupCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let borderView: UIView = { //셀 테두리
        let bV = UIView()
        bV.layer.cornerRadius = 4
        bV.layer.masksToBounds = true
        bV.layer.borderWidth = 1
        bV.layer.borderColor = UIColor.rgb(red: 243, green: 244, blue: 245).cgColor
        bV.translatesAutoresizingMaskIntoConstraints = false
        return bV
    }()
    
    let leftLineView: UIView = { //왼쪽 카테고리색상
        let leftView = UIView()
        leftView.translatesAutoresizingMaskIntoConstraints = false
        return leftView
    }()
    
    let categoryLabel:UILabel = { //공모전
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        lb.textColor = UIColor.rgb(red: 97, green: 118, blue: 221)
        lb.translatesAutoresizingMaskIntoConstraints = false
        
        return lb
    }()
    
    let contentLabel:UILabel = { //전국 창업연합 동아리
        let lb = UILabel()
        lb.numberOfLines = 1
        lb.textColor = UIColor.rgb(red: 139, green: 139, blue: 139)
        lb.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
        lb.minimumScaleFactor = 0.8
        lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let dateLabel: UILabel = { //날짜
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 13, weight: .light)
        lb.textColor = UIColor.rgb(red: 139, green: 139, blue: 139)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let separatorView: UIView = {//세로선
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        sv.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        return sv
    }()
    
    let leftedDay: UILabel = { //남은 날짜
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        lb.adjustsFontSizeToFitWidth = true
        lb.textAlignment = .center
        lb.text = "X"
        return lb
    }()
    
    let leftedDayBottom: UILabel = {//남은 날짜 밑에 (일 남음 텍스트)
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        lb.adjustsFontSizeToFitWidth = true
        lb.textColor = UIColor.rgb(red: 134, green: 134, blue: 134)
        lb.textAlignment = .center
        lb.text = "일 남음"
        return lb
    }()
    
    let newImage: UIImageView = { //지원완료, 기간만료
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    func setupCell(){
        self.selectionStyle = .none
        
        //MARK: 테두리
        addSubview(borderView)
        borderView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        borderView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        borderView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10 ).isActive = true
        borderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        borderView.backgroundColor = .white
        
        //MARK: 카테고리색
        borderView.addSubview(leftLineView)
        leftLineView.leftAnchor.constraint(equalTo: borderView.leftAnchor).isActive = true
        leftLineView.topAnchor.constraint(equalTo: borderView.topAnchor).isActive = true
        leftLineView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor).isActive = true
        leftLineView.widthAnchor.constraint(equalToConstant: 5).isActive = true
        
        //MARK: 세로선
        borderView.addSubview(separatorView)
        //separatorView.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -70).isActive = true
        NSLayoutConstraint(item: separatorView, attribute: .centerX, relatedBy: .equal, toItem: borderView, attribute: .centerX, multiplier: 1.6, constant: 0).isActive = true
        separatorView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 5).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -5).isActive = true
        
        //MARK: 카테고리명(공모전, 채용..)
        borderView.addSubview(categoryLabel)
        categoryLabel.text = "Label" //공모전
        categoryLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 18).isActive = true
        
        //MARK: 제목
        borderView.addSubview(contentLabel)
        contentLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor ,constant: 2).isActive
            = true
        contentLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 18).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: -16).isActive = true
        //contentLabel.trailingAnchor.constraint(greaterThanOrEqualTo: separatorView.leadingAnchor, constant: 8).isActive = true
        
        //MARK: 날짜
        borderView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 3).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 18).isActive = true
        
        //MARK: 남은 날짜
        borderView.addSubview(leftedDay)
        leftedDay.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor).isActive = true
        leftedDay.trailingAnchor.constraint(equalTo: borderView.trailingAnchor).isActive = true
        leftedDay.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10).isActive = true
        
        
        //MARK: 일 남음
        borderView.addSubview(leftedDayBottom)
        leftedDayBottom.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -8).isActive = true
        leftedDayBottom.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor).isActive = true
        leftedDayBottom.trailingAnchor.constraint(equalTo: borderView.trailingAnchor).isActive = true
        
        
        //MARK: 지원완료, 기간만료
        borderView.addSubview(newImage)
        newImage.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor).isActive = true
        newImage.trailingAnchor.constraint(equalTo: borderView.trailingAnchor).isActive = true
        //newImage.centerYAnchor.constraint(equalTo: borderView.centerYAnchor).isActive = true
        newImage.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10).isActive = true
        newImage.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -17).isActive = true
        //newImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        //newImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        newImage.image = UIImage(named: "icTaskComplete")
        newImage.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(todoListButtonAction), name: NSNotification.Name("todoListButtonAction"), object: nil)
    }
    
    @objc func todoListButtonAction() {
        leftedDay.isHidden = false
        leftedDayBottom.isHidden = false
        newImage.isHidden = true
    }
}
