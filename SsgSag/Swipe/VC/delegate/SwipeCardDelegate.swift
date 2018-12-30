import Foundation
import UIKit

protocol SwipeCardDelegate: NSObjectProtocol {
    func cardGoesLeft(card: SwipeCard)
    func cardGoesRight(card: SwipeCard)
    func currentCardStatus(card: SwipeCard, distance: CGFloat)
}
