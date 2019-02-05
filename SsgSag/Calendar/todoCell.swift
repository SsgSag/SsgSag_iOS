class TodoTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.rgb(red: 251, green: 251, blue: 251)
        setupCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let borderView: UIView = {
        let bV = UIView()
        bV.layer.cornerRadius = 5
        bV.layer.masksToBounds = true
        bV.translatesAutoresizingMaskIntoConstraints = false
        return bV
    }()
    
    let leftLineView: UIView = {
        let leftView = UIView()
        leftView.translatesAutoresizingMaskIntoConstraints = false
        return leftView
    }()
    
    let categoryLabel:UILabel = { //공모전
        let lb = UILabel()
        lb.textColor = UIColor.rgb(red: 97, green: 118, blue: 221)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let contentLabel:UILabel = { //전국 창업연합 동아리
        let lb = UILabel()
        lb.numberOfLines = 2
        lb.font = UIFont.systemFont(ofSize: 17.0, weight: .light)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let dateLabel: UILabel = { //날짜
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let separatorView: UIView = {//세로선
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.widthAnchor.constraint(equalToConstant: 1).isActive = true
        sv.backgroundColor = UIColor(displayP3Red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        return sv
    }()
    
    let leftedDay: UILabel = { //남은 날짜
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "3"
        return lb
    }()
    
    let leftedDayBottom: UILabel = {//남은 날짜 밑에 (일 남음 텍스트)
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "일 남음"
        return lb
    }()
    
    let newImage: UIImageView = {//남은 날짜 밑에 (일 남음 텍스트)
        let lb = UIImageView()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    func setupCell(){
        self.selectionStyle = .none
        
        addSubview(borderView)
        borderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        borderView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        borderView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10 ).isActive = true
        borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        borderView.backgroundColor = .white
        borderView.addSubview(leftLineView)
        
        leftLineView.leftAnchor.constraint(equalTo: borderView.leftAnchor).isActive = true
        leftLineView.topAnchor.constraint(equalTo: borderView.topAnchor).isActive = true
        leftLineView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor).isActive = true
        leftLineView.widthAnchor.constraint(equalToConstant: 8.5).isActive = true
        
        borderView.addSubview(categoryLabel)
        categoryLabel.text = "Label"
        categoryLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 20).isActive = true
        categoryLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        
        borderView.addSubview(contentLabel)
        contentLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor ,constant: 2).isActive
            = true
        contentLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 20).isActive = true
        contentLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        
        borderView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 3).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 20).isActive = true
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        dateLabel.textColor = UIColor.rgb(red: 139, green: 139, blue: 139)
        
        borderView.addSubview(separatorView)
        separatorView.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -70).isActive = true
        separatorView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 5).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -5).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 3).isActive = true
        
        borderView.addSubview(leftedDay)
        leftedDay.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -28).isActive = true
        leftedDay.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10).isActive = true
        leftedDay.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        
        borderView.addSubview(leftedDayBottom)
        leftedDayBottom.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -8).isActive = true
        leftedDayBottom.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -21).isActive = true
        leftedDayBottom.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        leftedDayBottom.textColor = UIColor.rgb(red: 134, green: 134, blue: 134)
        
        borderView.addSubview(newImage)
        newImage.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -20).isActive = true
        newImage.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 17).isActive = true
        newImage.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant:-17).isActive = true
        newImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        newImage.image = UIImage(named: "icTimePassed")
        newImage.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(rightItemHidden), name: NSNotification.Name("rightItemHidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeTodoTableStatusByButton), name: NSNotification.Name("changeTodoTableStatusByButton"), object: nil)
    }
    
    @objc func rightItemHidden() {
        leftedDay.isHidden = true
        leftedDayBottom.isHidden = true
        newImage.isHidden = false
    }
    
    @objc func changeTodoTableStatusByButton() {
        leftedDay.isHidden = false
        leftedDayBottom.isHidden = false
        newImage.isHidden = true
    }
}
