import UIKit

class BackgroundView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "No news found"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .systemGray
        return label
    }()

    private func customize() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }


}
