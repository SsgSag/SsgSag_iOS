import Foundation
import UIKit

protocol SwipeCardDelegate: NSObjectProtocol {
    func cardGoesLeft(card: SwipeCard)
    func cardGoesRight(card: SwipeCard)
}
