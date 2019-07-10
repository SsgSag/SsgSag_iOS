//
//  VADayView.swift
//  VACalendar
//
//  Created by Anton Vodolazkyi on 20.02.18.
//  Copyright © 2018 Vodolazkyi. All rights reserved.
//

import UIKit

@objc
public protocol VADayViewAppearanceDelegate: class {
    @objc optional func font(for state: VADayState) -> UIFont
    @objc optional func textColor(for state: VADayState) -> UIColor
    @objc optional func textBackgroundColor(for state: VADayState) -> UIColor
    @objc optional func backgroundColor(for state: VADayState) -> UIColor
    @objc optional func borderWidth(for state: VADayState) -> CGFloat
    @objc optional func borderColor(for state: VADayState) -> UIColor
    @objc optional func dotBottomVerticalOffset(for state: VADayState) -> CGFloat
    @objc optional func shape() -> VADayShape
    // percent of the selected area to be painted
}

protocol VADayViewDelegate: class {
    func dayStateChanged(_ day: VADay)
}

class VADayView: UIView {
    
    var day: VADay
    
    weak var delegate: VADayViewDelegate?
    
    weak var dayViewAppearanceDelegate: VADayViewAppearanceDelegate? {
        return (superview as? VAWeekView)?.dayViewAppearanceDelegate
    }
    
    var stackViewHeightAnchor: NSLayoutConstraint?
    
    private var dotStackView: UIStackView {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = dotSpacing
        return stack
    }
    
    private var lineStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 1.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let separateView: UIView = {
        let separateView = UIView()
        separateView.translatesAutoresizingMaskIntoConstraints = false
        separateView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        return separateView
    }()
    
    private let dotSpacing: CGFloat = 5
    private let dotSize: CGFloat = 5
    private var supplementaryViews = [UIView]()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    init(day: VADay) {
        self.day = day
        super.init(frame: .zero)
        
        self.day.stateChanged = { [weak self] state in
            self?.setState(state)
        }
        
        self.day.supplementariesDidUpdate = { }
        
        drawSeparateView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSelect))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawSeparateView() {
        addSubview(separateView)
        separateView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        separateView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        separateView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        separateView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    var count: CGFloat = 0
    
    private func drawEvent(_ state: VADay) {
        for todo in TodoData.shared.getMonthTodoDatasAfterAllChangedConfirm() {
            
            let monthTodoDate = DateCaculate.stringToDateWithGenericFormatter(using: todo.posterEndDate)
            
            let category = PosterCategory(rawValue: todo.categoryIdx)
            
            if DateCaculate.isSameDate(self.day.date, monthTodoDate) {
                if count < 5 {
                    
                    let lineView = VALineView(color: category?.categoryColors() ?? .clear,
                                              text: todo.posterName)
                    if state.state == .out {
                        lineView.backgroundColor = .lightGray
                    }
                    lineStackView.addArrangedSubview(lineView)
                    count += 1
                }
            }
        }
        
        addSubview(lineStackView)
        lineStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1).isActive = true
        lineStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1).isActive = true
        lineStackView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 2).isActive = true
        stackViewHeightAnchor = lineStackView.heightAnchor.constraint(equalToConstant: count * self.frame.height * 0.115)
        
        stackViewHeightAnchor?.isActive = true
    }
    
    func setupDay() {
        
        dateLabel.text = VAFormatters.dayFormatter.string(from: day.date)
        
        addSubview(dateLabel)
        dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: dateLabel.widthAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        setState(day.state)
        drawEvent(day)
    }
    
    func drawEventWithSelectedIndex(_ selectedIndex: [Int] ) {
        
        for i in lineStackView.subviews {
            i.removeFromSuperview()
        }
        
        count = 0
        
        for poster in StoreAndFetchPoster.shared.getPostersAfterAllChangedConfirm() {
            
            let posterDate = DateCaculate.stringToDateWithGenericFormatter(using: poster.posterEndDate ?? .init())
            
            let category = PosterCategory(rawValue: poster.categoryIdx!)
            
            if selectedIndex.contains(0) {
                if DateCaculate.isSameDate(self.day.date, posterDate) {
                    if count < 5 {
                        
                        let lineView = VALineView(color: category?.categoryColors() ?? .clear,
                                                  text: poster.posterName!)
                        if day.state == .out {
                            lineView.backgroundColor = .lightGray
                        }
                        
                        lineStackView.addArrangedSubview(lineView)
                        
                        count += 1
                    }
                }
            } else if selectedIndex.contains(category?.calendarFilterNumber ?? 0) {
                if DateCaculate.isSameDate(self.day.date, posterDate) {
                    if count < 5 {
                        
                        let lineView = VALineView(color: category?.categoryColors() ?? .clear,
                                                  text: poster.posterName!)
                        if day.state == .out {
                            lineView.backgroundColor = .lightGray
                        }
                        
                        lineStackView.addArrangedSubview(lineView)
                        
                        count += 1
                    }
                }
            }
            
        }
        
        stackViewHeightAnchor?.constant = count * self.frame.height * 0.115
    }
    
    @objc
    private func didTapSelect() {
        guard day.state != .out && day.state != .unavailable else { return }
        delegate?.dayStateChanged(day)
    }
    
    private func setState(_ state: VADayState) {
        backgroundColor = dayViewAppearanceDelegate?.backgroundColor?(for: state) ?? backgroundColor
        layer.borderColor = dayViewAppearanceDelegate?.borderColor?(for: state).cgColor ?? layer.borderColor
        layer.borderWidth = dayViewAppearanceDelegate?.borderWidth?(for: state) ?? dateLabel.layer.borderWidth
        
        let component = Calendar.current.dateComponents([.weekday], from: day.date)
        
        dateLabel.textColor = dayViewAppearanceDelegate?.textColor?(for: state) ?? dateLabel.textColor
        dateLabel.backgroundColor = dayViewAppearanceDelegate?.textBackgroundColor?(for: state) ?? dateLabel.backgroundColor
        
        if component.weekday! == 1 && state == .available{
            dateLabel.textColor = #colorLiteral(red: 1, green: 0.1647058824, blue: 0.2588235294, alpha: 1)
        }
        
        if component.weekday! == 7 && state == .available {
            dateLabel.textColor = #colorLiteral(red: 0.2784313725, green: 0.4862745098, blue: 1, alpha: 1)
        }
        
        dateLabel.layer.borderColor = UIColor.white.cgColor
        dateLabel.layer.borderWidth = 0
        dateLabel.clipsToBounds = true
        dateLabel.layer.cornerRadius = self.frame.width * 0.3
    }
    
    private func removeAllSupplementaries() {
        supplementaryViews.forEach { $0.removeFromSuperview() }
        supplementaryViews = []
    }
    
}
