//
//  DetailNewTextSwipeCard.swift
//  SsgSag
//
//  Created by admin on 30/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class DetailNewTextSwipeCard: UIViewController {
    
    @IBOutlet weak var overView: UIView!
    
    private var segmentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var segmentSecondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var intervalDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 33)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        return label
    }()
    
    private var categoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private var favoriteCountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_favoriteGray"), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1), for: .normal)
        button.setTitle("0", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private var calendarCountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_calendar"), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1), for: .normal)
        button.setTitle("0", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private var subjectButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_1"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.setTitleColor(#colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var subjectDetailText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var eligibilityButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_3"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.setTitleColor(#colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var eligibilityDetailText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var benefitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_2"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.setTitleColor(#colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var benefitTextField: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var poster: Posters? {
        didSet {
            
            guard let poster = poster else { return }
            
            posterCategory = poster.categoryIdx
        
            self.intervalDate.text
                = DateCaculate.getDifferenceBetweenStartAndEnd(startDate: poster.posterStartDate,
                                                               endDate: poster.posterEndDate)
            
            guard let title = poster.posterName,
                let categoryIdx = poster.categoryIdx else { return }
            
            titleLabel.text = title
            
            // json String으로 오는 경우
            if categoryIdx == 3 || categoryIdx == 5 {
                guard let columnJson = poster.outline,
                    let data = columnJson.data(using: .utf8) else {
                    return
                }
                
                do {
                    let columnData = try JSONDecoder().decode([Column].self, from: data)
                    
                    switch columnData.count {
                    case 1:
                        subjectButton.setTitle(columnData[0].columnName,
                                               for: .normal)
                        
                        subjectDetailText.text = columnData[0].columnContent
                    case 2:
                        subjectButton.setTitle(columnData[0].columnName,
                                               for: .normal)
                        benefitButton.setTitle(columnData[1].columnName,
                                               for: .normal)
                        
                        subjectDetailText.text = columnData[0].columnContent
                        benefitTextField.text = columnData[1].columnContent
                    case 3:
                        subjectButton.setTitle(columnData[0].columnName,
                                               for: .normal)
                        benefitButton.setTitle(columnData[1].columnName,
                                               for: .normal)
                        eligibilityButton.setTitle(columnData[2].columnName,
                                                   for: .normal)
                        
                        subjectDetailText.text = columnData[0].columnContent
                        benefitTextField.text = columnData[1].columnContent
                        eligibilityDetailText.text = columnData[2].columnContent
                    default:
                        return
                    }
                    return
                } catch let error {
                    print(error)
                    return
                }
            }
            
            let categoryTitle = titleStringByCategory(categoryIdx: categoryIdx)
            subjectButton.setTitle(categoryTitle[0], for: .normal)
            benefitButton.setTitle(categoryTitle[1], for: .normal)
            eligibilityButton.setTitle(categoryTitle[2], for: .normal)
            
            if categoryIdx == 2 || categoryIdx == 6 {
                subjectDetailText.text = poster.outline ?? ""
                benefitTextField.text = poster.period ?? ""
                eligibilityDetailText.text = poster.benefit ?? ""
            } else if categoryIdx == 7 {
                subjectDetailText.text = poster.outline ?? ""
                benefitTextField.text = poster.target ?? ""
                eligibilityDetailText.text = poster.period ?? ""
            } else if categoryIdx == 8 {
                subjectDetailText.text = poster.benefit ?? ""
                benefitTextField.text = poster.target ?? ""
                eligibilityDetailText.text = poster.outline ?? ""
            } else {
                subjectDetailText.text = poster.outline ?? ""
                benefitTextField.text = poster.target ?? ""
                eligibilityDetailText.text = poster.benefit ?? ""
            }
            
            benefitTextField.setLineSpacing(lineSpacing: 5.0)
            subjectDetailText.setLineSpacing(lineSpacing: 5.0)
            eligibilityDetailText.setLineSpacing(lineSpacing: 5.0)
            
        }
    }
    
    var posterCategory: Int? {
        didSet {
            guard let posterCategoryIdx = posterCategory else { return }
            
            guard let category = PosterCategory(rawValue: posterCategoryIdx) else {return}
            
            segmentSecondView.backgroundColor = category.categoryColors()
            
            self.intervalDate.textColor = category.categoryColors()
            
            var categoryString = category.categoryString()
            
            if posterCategoryIdx == 2 {
                let subCategory = poster?.subCategoryIdx == 0 ? "연합" : "교내"
                categoryString.append("(\(subCategory))")
            }
            
            self.categoryButton.setTitleColor(category.categoryColors(), for: .normal)
            self.categoryButton.backgroundColor = category.categoryColors().withAlphaComponent(0.05)
            self.categoryButton.setTitle(categoryString, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextProperty()
        
        addSubviews()
        
        setupLayout()
    }
    
    private func setTextProperty() {
        
//        circle.layer.cornerRadius = 59 / 2
//        circle.layer.masksToBounds = true
//        circle.backgroundColor = .lightGray
    }
    
    private func addSubviews() {
        overView.addSubview(segmentView)
        overView.addSubview(segmentSecondView)
        overView.addSubview(intervalDate)
        overView.addSubview(categoryButton)
        overView.addSubview(titleLabel)
        overView.addSubview(scrollView)
        
        overView.addSubview(favoriteCountButton)
        overView.addSubview(calendarCountButton)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(subjectButton)
        contentView.addSubview(subjectDetailText)
        
        contentView.addSubview(benefitButton)
        contentView.addSubview(benefitTextField)
        
        contentView.addSubview(eligibilityButton)
        contentView.addSubview(eligibilityDetailText)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            segmentView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5.5),
            segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            segmentView.heightAnchor.constraint(equalToConstant: 5),
            segmentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
        
            segmentSecondView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -11),
            segmentSecondView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5.5),
            segmentSecondView.heightAnchor.constraint(equalToConstant: 5),
            segmentSecondView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            
            intervalDate.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: 15),
            intervalDate.leadingAnchor.constraint(equalTo: overView.leadingAnchor, constant: 22),
            intervalDate.trailingAnchor.constraint(equalTo: overView.trailingAnchor, constant: -22),
            
            titleLabel.topAnchor.constraint(equalTo: intervalDate.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: overView.leadingAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: overView.trailingAnchor, constant: -22),
            
            favoriteCountButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            favoriteCountButton.trailingAnchor.constraint(equalTo: calendarCountButton.leadingAnchor, constant: -30),
            
            calendarCountButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            calendarCountButton.trailingAnchor.constraint(equalTo: overView.trailingAnchor, constant: -22),
            
            categoryButton.topAnchor.constraint(equalTo: intervalDate.topAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            
            scrollView.topAnchor.constraint(equalTo: favoriteCountButton.bottomAnchor, constant: 30),
            scrollView.leadingAnchor.constraint(equalTo: overView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: overView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: overView.bottomAnchor, constant: -10),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            subjectButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            subjectButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            
            subjectDetailText.topAnchor.constraint(equalTo: subjectButton.bottomAnchor, constant: 10),
            subjectDetailText.leadingAnchor.constraint(equalTo: subjectButton.leadingAnchor),
            subjectDetailText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            
            benefitButton.topAnchor.constraint(equalTo: subjectDetailText.bottomAnchor, constant: 30),
            benefitButton.leadingAnchor.constraint(equalTo: subjectButton.leadingAnchor),
            
            benefitTextField.topAnchor.constraint(equalTo: benefitButton.bottomAnchor, constant: 10),
            benefitTextField.leadingAnchor.constraint(equalTo: subjectButton.leadingAnchor),
            benefitTextField.trailingAnchor.constraint(equalTo: subjectDetailText.trailingAnchor),
            
            eligibilityButton.topAnchor.constraint(equalTo: benefitTextField.bottomAnchor, constant: 30),
            eligibilityButton.leadingAnchor.constraint(equalTo: subjectButton.leadingAnchor),
            
            eligibilityDetailText.topAnchor.constraint(equalTo: eligibilityButton.bottomAnchor, constant: 10),
            eligibilityDetailText.leadingAnchor.constraint(equalTo: subjectButton.leadingAnchor),
            eligibilityDetailText.trailingAnchor.constraint(equalTo: subjectDetailText.trailingAnchor),
            eligibilityDetailText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    
        segmentView.layer.cornerRadius = 3
        segmentSecondView.layer.cornerRadius = 3
    }
    
    deinit {
        print("DetailNewTextSwipe deinit")
    }
    
}


extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        
        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

