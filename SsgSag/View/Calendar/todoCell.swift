
class TodoTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        
        favorite.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        
        setupCell()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        favorite.layer.cornerRadius = favorite.bounds.size.width / 2
        favorite.layer.borderWidth = 1
        favorite.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static private let weekDaySymbol = ["일", "월", "화", "수", "목", "금","토"]
    
    private func setFavoriteColor(with category: PosterCategory, posterIdx: Int) {
        
        guard let isFavorite = UserDefaults.standard.object(forKey: "favorite\(posterIdx)") as? Int else {
            
            let favoriteState: favoriteState = .notFavorite
            
            favoriteState.setColor(category,
                                   favorite: favorite,
                                   dayLefted: dayLefted,
                                   favoriteIntervalDay: favoriteIntervalDay)
        
            return
        }
        
        guard let favoriteState = favoriteState(rawValue: isFavorite) else {return}
        
        favoriteState.setColor(category,
                               favorite: favorite,
                               dayLefted: dayLefted,
                               favoriteIntervalDay: favoriteIntervalDay)
    }
    
    private func setComplted(posterIdx: Int) {
        guard let isComplted = UserDefaults.standard.object(forKey: "completed\(posterIdx)") as? Int else {
            
            let completeState: applyCompleted = .notCompleted
            
            completeState.setComplete(posterIdx: posterIdx, complete: complete, favorite: favorite, favoriteIntervalDay:favoriteIntervalDay )
            
            return
        }
        
        guard let complteState = applyCompleted(rawValue: isComplted) else {return}
        
        complteState.setComplete(posterIdx: posterIdx, complete: complete, favorite: favorite, favoriteIntervalDay:favoriteIntervalDay )
        
    }
    
    // StartDate는 없을 수도 있고 EndDate는 무조건 존재한다.
    var poster: Posters? {
        didSet {
            guard let poster = poster else { return }
            
            let dateFormatter = DateFormatter.genericDateFormatter
            
            guard let posterEndDateString = poster.posterEndDate else { return }
            
            guard let posterEndDate = dateFormatter.date(from: posterEndDateString) else { return }
            
            print("posterEndDateString \(posterEndDateString)")
            print("addingPosterEndDate \(posterEndDate)")
            
            let todoDataEndMonth = Calendar.current.component(.month, from: posterEndDate)
            
            let todoDataEndDay = Calendar.current.component(.day, from: posterEndDate)
            
            let todoDateEndWeekDay = Calendar.current.component(.weekday, from: posterEndDate)
            
            let todoDateEndHour = Calendar.current.component(.hour, from: posterEndDate)
            
            let todoDateEndminute = Calendar.current.component(.minute, from: posterEndDate)
            
            guard let posterCagegoryIdx = poster.categoryIdx else { return }
            
            guard let posterName = poster.posterName else { return }
            
            guard let posterIdx = poster.posterIdx else {return}
            
            contentLabel.text = "\(posterName)"
            
            if let category = PosterCategory(rawValue: posterCagegoryIdx) {
                categoryLabel.text = category.categoryString()
                categoryLabel.textColor = category.categoryColors()
                
                setFavoriteColor(with: category, posterIdx: posterIdx)
                setComplted(posterIdx: posterIdx)
            }
            
            if Date() < posterEndDate {
                newImage.isHidden = true
                newImage.image = #imageLiteral(resourceName: "icTaskTimeout")
                
                leftedDay.isHidden = false
                
            } else {
                newImage.isHidden = false
                leftedDay.isHidden = true
            }
            
            var dayInterval = Calendar.current.dateComponents([.day],
                                                              from: Date(),
                                                              to: posterEndDate)
            
            guard let interval = dayInterval.day else { return  }
            
            //favorite.setTitle("\(interval)일", for: .normal)
            dayLefted.text = "\(interval)일"
            
            dateLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .light)
            leftedDay.font = UIFont.systemFont(ofSize: 34.0, weight: .medium)

            let weekDaySymbol = TodoTableViewCell.weekDaySymbol[todoDateEndWeekDay-1]
            
            guard let posterStartDateString = poster.posterStartDate else {
                dateLabel.text = "\(todoDataEndMonth).\(todoDataEndDay)(\(weekDaySymbol)) \(todoDateEndHour):\(todoDateEndminute)"
                return
            }

            guard let posterStartDate = dateFormatter.date(from: posterStartDateString) else { return }
            
            let todoDataStartMonth = Calendar.current.component(.month, from: posterStartDate)
            
            let todoDataStartDay = Calendar.current.component(.day, from: posterStartDate)
            
            dateLabel.text = "\(todoDataStartMonth).\(todoDataStartDay)(\(weekDaySymbol)) ~ \(todoDataEndMonth).\(todoDataEndDay)(\(weekDaySymbol)) \(todoDateEndHour-9):\(todoDateEndminute)  "
        }
    }
    
    let complete: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icTaskComplete")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let borderView: UIView = { //셀 테두리
        let bV = UIView()
        bV.layer.cornerRadius = 4
        bV.layer.masksToBounds = true
        bV.layer.borderWidth = 1
        bV.layer.borderColor = UIColor.rgb(red: 243, green: 244, blue: 245).cgColor
        bV.translatesAutoresizingMaskIntoConstraints = false
        return bV
    }()
    
    let favorite: UIButton = { //왼쪽 카테고리색상
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //16일
    let dayLefted: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //남음
    let favoriteIntervalDay: UILabel = {
        let label = UILabel()
        label.text = "남음"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        lb.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lb.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let dateLabel: UILabel = { //날짜
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 13, weight: .light)
        lb.textColor = UIColor.rgb(red: 139, green: 139, blue: 139)
        lb.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let separatorView: UIView = {//세로선
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
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
    
    let newImage: UIImageView = { //지원완료, 기간만료
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    @objc func addFavorite() {
    
        guard let posterIdx = poster?.posterIdx else {return}
        
        guard let posterCagegoryIdx = poster?.categoryIdx else { return }
        
        guard let category = PosterCategory(rawValue: posterCagegoryIdx) else {return}
        
        //한번도 서버에 전송한적이 없다면
        guard let isFavorite = UserDefaults.standard.object(forKey: "favorite\(posterIdx)") as? Int else {
            
            let favoriteState: favoriteState = .notFavorite
            
            favoriteState.changeColor(category, favorite: favorite,
                                      dayLefted: dayLefted,
                                      favoriteIntervalDay: favoriteIntervalDay,
                                      posterIdx: posterIdx)
            
            UserDefaults.standard.setValue(1, forKey: "favorite\(posterIdx)")
            
            return
        }
        
        guard let favoriteState = favoriteState(rawValue: isFavorite) else {return}
        
        favoriteState.changeColor(category, favorite: favorite,
                                  dayLefted: dayLefted,
                                  favoriteIntervalDay: favoriteIntervalDay,
                                  posterIdx: posterIdx)
    
    }
    
    func setupCell(){
        self.selectionStyle = .none
        
        //MARK: 테두리
        addSubview(borderView)
        borderView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        borderView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        borderView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10 ).isActive = true
        borderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        borderView.backgroundColor = .white
        
        //즐겨찾기
        borderView.addSubview(favorite)
        favorite.heightAnchor.constraint(equalTo: borderView.heightAnchor, multiplier: 0.7).isActive = true
        favorite.widthAnchor.constraint(equalTo: borderView.heightAnchor, multiplier: 0.7).isActive = true
        favorite.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 13).isActive = true
        favorite.centerYAnchor.constraint(equalTo: borderView.centerYAnchor).isActive = true
        
        //지원완료
        borderView.addSubview(complete)
        complete.leadingAnchor.constraint(equalTo: favorite.leadingAnchor).isActive = true
        complete.trailingAnchor.constraint(equalTo: favorite.trailingAnchor).isActive = true
        complete.topAnchor.constraint(equalTo: favorite.topAnchor).isActive = true
        complete.bottomAnchor.constraint(equalTo: favorite.bottomAnchor).isActive = true
        
        //MARK: 남음
        favorite.addSubview(favoriteIntervalDay)
        favoriteIntervalDay.centerXAnchor.constraint(equalTo: favorite.centerXAnchor).isActive = true
        //favoriteIntervalDay.topAnchor.constraint(equalTo: favorite.titleLabel?.bottomAnchor ?? .init()).isActive = true
        
        favoriteIntervalDay.bottomAnchor.constraint(equalTo: favorite.bottomAnchor, constant: -8).isActive = true
        
        //MARK: 16일
        favorite.addSubview(dayLefted)
        dayLefted.bottomAnchor.constraint(equalTo: favoriteIntervalDay.topAnchor, constant: 1).isActive = true
        dayLefted.centerXAnchor.constraint(equalTo: favorite.centerXAnchor).isActive = true
        
        //MARK: 카테고리명(공모전, 채용..)
        borderView.addSubview(categoryLabel)
        categoryLabel.text = "Label" //공모전
        categoryLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 13).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: favorite.trailingAnchor, constant: 18).isActive = true
        
        //MARK: 제목
        borderView.addSubview(contentLabel)
        contentLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor ,constant: 3).isActive
            = true
        contentLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -25).isActive = true
        
        //MARK: 날짜
        borderView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 3).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
        
        //MARK: 세로선
        borderView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 5).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -5).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(todoListButtonAction), name: NSNotification.Name("todoListButtonAction"), object: nil)
    }
    
    @objc func todoListButtonAction() {
        leftedDay.isHidden = false
        newImage.isHidden = true
    }
    
}

enum applyCompleted:Int {
    case completed = 1
    case notCompleted = 0
    
    func setComplete(posterIdx: Int, complete: UIImageView, favorite: UIButton, favoriteIntervalDay: UILabel) {
        switch self {
        case .completed:
            complete.isHidden = false
            
            favorite.isHidden = true
            favoriteIntervalDay.isHidden = true
        case .notCompleted:
            complete.isHidden = true
            
            favorite.isHidden = false
            favoriteIntervalDay.isHidden = false
        }
    }
}

enum favoriteState: Int {

    case favorite = 1
    case notFavorite = 0
    
    func setColor(_ category: PosterCategory, favorite: UIButton, dayLefted: UILabel , favoriteIntervalDay: UILabel) {
        switch self {
            
        case .favorite:
            favorite.backgroundColor = category.categoryColors()
            favorite.layer.borderColor = category.categoryColors().cgColor
            favorite.setTitleColor(.white, for: .normal)
            
            favoriteIntervalDay.textColor = .white
            dayLefted.textColor = .white
        case .notFavorite:
            favorite.layer.borderColor = category.categoryColors().cgColor
            favorite.backgroundColor = .white
            favorite.setTitleColor(category.categoryColors(), for: .normal)
            
            favoriteIntervalDay.textColor = category.categoryColors()
            dayLefted.textColor = category.categoryColors()
        }
    }
    
    func changeColor(_ category: PosterCategory, favorite: UIButton, dayLefted: UILabel ,favoriteIntervalDay: UILabel, posterIdx: Int) {
        
        let calendarServiceImp = CalendarServiceImp()
        calendarServiceImp.requestFavorite(self, posterIdx) { (dataResponse) in
            guard let statusCode = dataResponse.value?.status else {return}
            
            guard let httpStatus = HttpStatusCode(rawValue: statusCode) else {return}
            
            switch httpStatus {
            case .favoriteSuccess:
                print("성공적으로 즐겨찾기를 등록하였습니다")
            case .dataBaseError:
                print("Favorite Database Error")
            case .serverError:
                print("Favorite Server Error")
            default:
                break
            }
            
        }
        
        switch self {
        case .favorite:
            
            UserDefaults.standard.setValue(0, forKey: "favorite\(posterIdx)")
            
            favorite.layer.borderColor = category.categoryColors().cgColor
            favorite.backgroundColor = .white
            favorite.setTitleColor(category.categoryColors(), for: .normal)
            
            favoriteIntervalDay.textColor = category.categoryColors()
            dayLefted.textColor = category.categoryColors()
            
        case .notFavorite:
            UserDefaults.standard.setValue(1, forKey: "favorite\(posterIdx)")
            
            favorite.backgroundColor = category.categoryColors()
            favorite.setTitleColor(.white, for: .normal)
            
            favoriteIntervalDay.textColor = .white
            dayLefted.textColor = .white
        }
    }
}

protocol CalendarService: class {
    func requestFavorite(_ favorite: favoriteState, _ posterIdx: Int,completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void)
    
    func requestDelete(_ posterIdx: Int, completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void)
    
    func reqeustComplete(_ posterIdx: Int, completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void)
    
    func requestEachPoster(_ posterIdx: Int, completionHandler: @escaping (DataResponse<networkPostersData>) -> Void)
}




