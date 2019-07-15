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
        button.setImage(UIImage(named: "ic_favorite"), for: .normal)
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
    
    private var subject: UIButton = {
        let button = UIButton()
        button.setTitle("공모주제", for: .normal)
        button.setImage(UIImage(named: "ic_1"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.setTitleColor(#colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var subjectDetailText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var eligibility: UIButton = {
        let button = UIButton()
        button.setTitle("지원자격", for: .normal)
        button.setImage(UIImage(named: "ic_2"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.setTitleColor(#colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var eligibilityDetailText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var benefit: UIButton = {
        let button = UIButton()
        button.setTitle("시상내역", for: .normal)
        button.setImage(UIImage(named: "ic_3"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.setTitleColor(#colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var benefitTextField: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var poster: Posters? {
        didSet {
            
            guard let poster = poster else { return }
            
            posterCategory = poster.categoryIdx
        
            guard let posterEndDate = poster.posterEndDate else {return}
            
            let interval = DateCaculate.dayInterval(using: posterEndDate)
        
            self.intervalDate.text = DateCaculate.getDifferenceBetweenStartAndEnd(startDate: poster.posterStartDate, endDate: poster.posterEndDate)
            
            guard let title = poster.posterName else { return }
            
            guard let outline = poster.outline else { return }
            
            guard let benefit = poster.benefit else { return }
            
            guard let target = poster.target else { return }
            
            titleLabel.text = title
            subjectDetailText.text = outline
            benefitTextField.text = benefit
            eligibilityDetailText.text = target
            
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
            
            self.categoryButton.setTitleColor(category.categoryColors(), for: .normal)
            self.categoryButton.backgroundColor = category.categoryColors().withAlphaComponent(0.05)
            self.categoryButton.setTitle(category.categoryString(), for: .normal)
        }
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
        
        overView.addSubview(favoriteCountButton)
        overView.addSubview(calendarCountButton)
        
        overView.addSubview(subject)
        overView.addSubview(subjectDetailText)
        
        overView.addSubview(benefit)
        overView.addSubview(benefitTextField)
        
        overView.addSubview(eligibility)
        overView.addSubview(eligibilityDetailText)
    }
    
    private func setSegmentViews() {
        
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
            
        subject.topAnchor.constraint(equalTo: favoriteCountButton.bottomAnchor, constant: 30),
        subject.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        
        subjectDetailText.topAnchor.constraint(equalTo: subject.bottomAnchor, constant: 10),
        subjectDetailText.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        subjectDetailText.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
        eligibility.topAnchor.constraint(equalTo: subjectDetailText.bottomAnchor, constant: 30),
        eligibility.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        
        eligibilityDetailText.topAnchor.constraint(equalTo: benefit.bottomAnchor, constant: 10),
        eligibilityDetailText.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        eligibilityDetailText.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
        benefit.topAnchor.constraint(equalTo: benefitTextField.bottomAnchor, constant: 30),
        benefit.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        
        benefitTextField.topAnchor.constraint(equalTo: eligibility.bottomAnchor, constant: 10),
        benefitTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        benefitTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    
        segmentView.layer.cornerRadius = 3
        segmentSecondView.layer.cornerRadius = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextProperty()
        
        addSubviews()
        
        setSegmentViews()
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

