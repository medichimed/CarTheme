import UIKit

protocol NibDescribingProtocol: class {
    static var reuseIdentifier: String {get}
    static var nib: UINib {get}
}

extension NibDescribingProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
