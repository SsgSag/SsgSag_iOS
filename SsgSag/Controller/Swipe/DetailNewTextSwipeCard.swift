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
    
    @IBOutlet weak var dayLefted: UILabel!
    
    @IBOutlet weak var hashTag: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var days: UILabel!
    
    @IBOutlet weak var circle: UILabel!
    
    
    private var intervalDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 33)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var categoryText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var subject: UILabel = {
        let label = UILabel()
        label.text = "주제"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.alpha = 0.85
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var subjectDetailText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var benefit: UILabel = {
        let label = UILabel()
        label.text = "시상내역"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.alpha = 0.85
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var benefitTextField: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var eligibility: UILabel = {
        let label = UILabel()
        label.text = "지원자격"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.alpha = 0.85
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var eligibilityDetailText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var poster: Posters? {
        didSet {
            
            guard let poster = poster else { return }
            
            name.text = poster.posterName
            hashTag.text = poster.keyword
            posterCategory = poster.categoryIdx
        
            guard let posterEndDate = poster.posterEndDate else {return}
            
            let interval = DateCaculate.dayInterval(using: posterEndDate)
            
            days.text = "\(interval)일"
            dayLefted.text = "남음"
        
            self.intervalDate.text = DateCaculate.getDifferenceBetweenStartAndEnd(startDate: poster.posterStartDate, endDate: poster.posterEndDate)
            
            guard let outline = poster.outline else {return}
            
            guard let benefit = poster.benefit else {return}
            
            guard let target = poster.target else {return}
            
            subjectDetailText.text = outline
            benefitTextField.text = benefit
            eligibilityDetailText.text = target
        }
    }
    
    var posterCategory: Int? {
        didSet {
            guard let posterCategoryIdx = posterCategory else { return }
            
            guard let category = PosterCategory(rawValue: posterCategoryIdx) else {return}
            
            segmentSecondView.backgroundColor = category.categoryColors()
            
            dayLefted.backgroundColor = .lightGray
            
            self.category.text = category.categoryString()
            
            self.category.textColor = .lightGray
            
            self.hashTag.textColor = .lightGray
            
            self.name.textColor = .lightGray
            
            self.intervalDate.textColor = category.categoryColors()
            
            self.categoryText.textColor = category.categoryColors()
            
            self.categoryText.text = category.categoryString()
            
            self.subject.textColor = category.categoryColors()
            
            self.benefit.textColor = category.categoryColors()
            
            self.eligibility.textColor = category.categoryColors()
        }
    }
    
    private var segmentView: UIView = {
        let segmentView = UIView()
        segmentView.backgroundColor = .lightGray
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
    
    private var segmentSecondView: UIView = {
        let segmentView = UIView()
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
    
    private func setTextProperty() {
        
        circle.layer.cornerRadius = 59 / 2
        circle.layer.masksToBounds = true
        circle.backgroundColor = .lightGray
    }
    
    private func addSubviews() {
        overView.addSubview(segmentView)
        overView.addSubview(segmentSecondView)
        overView.addSubview(intervalDate)
        overView.addSubview(categoryText)
        
        overView.addSubview(subject)
        overView.addSubview(subjectDetailText)
        
        overView.addSubview(benefit)
        overView.addSubview(benefitTextField)
        
        overView.addSubview(eligibility)
        overView.addSubview(eligibilityDetailText)
    }
    
    private func setSegmentViews() {
        
        NSLayoutConstraint.activate([
        segmentView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -3),
        segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3),
        segmentView.heightAnchor.constraint(equalToConstant: 5),
        segmentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 9),
    
        segmentSecondView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),
        segmentSecondView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 3),
        segmentSecondView.heightAnchor.constraint(equalToConstant: 5),
        segmentSecondView.topAnchor.constraint(equalTo: view.topAnchor, constant: 9),
        
        intervalDate.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: 15),
        intervalDate.leadingAnchor.constraint(equalTo: segmentView.leadingAnchor, constant: 13),
        
        categoryText.topAnchor.constraint(equalTo: intervalDate.topAnchor),
        categoryText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            
        subject.topAnchor.constraint(equalTo: intervalDate.bottomAnchor, constant: 20),
        subject.leadingAnchor.constraint(equalTo: intervalDate.leadingAnchor),
        
        subjectDetailText.topAnchor.constraint(equalTo: subject.bottomAnchor, constant: 3),
        subjectDetailText.leadingAnchor.constraint(equalTo: intervalDate.leadingAnchor),
        subjectDetailText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        benefit.topAnchor.constraint(equalTo: subjectDetailText.bottomAnchor, constant: 14),
        benefit.leadingAnchor.constraint(equalTo: intervalDate.leadingAnchor),
        
        benefitTextField.topAnchor.constraint(equalTo: benefit.bottomAnchor, constant: 3),
        benefitTextField.leadingAnchor.constraint(equalTo: intervalDate.leadingAnchor),
        benefitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        eligibility.topAnchor.constraint(equalTo: benefitTextField.bottomAnchor, constant: 14),
        eligibility.leadingAnchor.constraint(equalTo: intervalDate.leadingAnchor),
        
        eligibilityDetailText.topAnchor.constraint(equalTo: eligibility.bottomAnchor, constant: 3),
        eligibilityDetailText.leadingAnchor.constraint(equalTo: intervalDate.leadingAnchor),
        eligibilityDetailText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        
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
}



