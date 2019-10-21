import UIKit

public protocol VAMonthHeaderViewDelegate: class {
    func didTapNextMonth()
    func didTapPreviousMonth()
}

public struct VAMonthHeaderViewAppearance {
    
    let monthFont: UIFont
    let monthTextColor: UIColor
    let monthTextWidth: CGFloat
    let dateFormat: String
    
    public init(
        monthFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .semibold),
        monthTextColor: UIColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1),
        monthTextWidth: CGFloat = 150,
        dateFormat: String = "MMMM") {
        self.monthFont = monthFont
        self.monthTextColor = monthTextColor
        self.monthTextWidth = monthTextWidth
        self.dateFormat = dateFormat
    }
    
}

public class VAMonthHeaderView: UIView {
    
    public var appearance = VAMonthHeaderViewAppearance() {
        didSet {
            formatter.dateFormat = appearance.dateFormat
            setupView()
        }
    }
    
    public weak var delegate: VAMonthHeaderViewDelegate?
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = appearance.dateFormat
        return formatter
    }()
    
    private lazy var formatterWithYearAndMonth: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "YYYY년 MM월"
        return formatter
    }()
    
    let monthLabel = UILabel()
    private let previousButton = UIButton()
    private let nextButton = UIButton()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth: CGFloat = 50.0
        monthLabel.frame = CGRect(x: 0, y: 0, width: appearance.monthTextWidth, height: frame.height)
        previousButton.frame = CGRect(x: monthLabel.frame.minX - buttonWidth, y: 0, width: buttonWidth, height: frame.height)
        nextButton.frame = CGRect(x: monthLabel.frame.maxX, y: 0, width: buttonWidth, height: frame.height)
    }
    
    private func setupView() {
        subviews.forEach{ $0.removeFromSuperview() }
        
        backgroundColor = .white
        monthLabel.font = appearance.monthFont
        monthLabel.textAlignment = .left
        monthLabel.textColor = appearance.monthTextColor
        
        addSubview(monthLabel)
        
        layoutSubviews()
    }
    
    @objc
    private func didTapNext(_ sender: UIButton) {
        delegate?.didTapNextMonth()
    }
    
    @objc
    private func didTapPrevious(_ sender: UIButton) {
        delegate?.didTapPreviousMonth()
    }
    
}

extension VAMonthHeaderView: VACalendarMonthDelegate {
    
    public func monthDidChange(_ currentMonth: Date) {
        monthLabel.text = formatterWithYearAndMonth.string(from: currentMonth)
    }
    
}
