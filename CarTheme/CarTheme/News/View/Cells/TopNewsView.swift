import UIKit
import Kingfisher

class TopNewsView: UIView, NibDescribingProtocol {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateOfPublicationLabel: UILabel!

    var details: NewsItem? {
        didSet{
            configureView()
        }
    }

    private func configureView() {
        descriptionLabel.text = details?.title
        dateOfPublicationLabel.text = CustomDateFormatter.getFormattedDate(from: details?.releaseDate)
        newsImageView.kf.indicatorType = .activity
        newsImageView.kf.setImage(with: URL(string: "\(smallImagePath)\(self.details!.image)")!)
        layoutIfNeeded()
    }

}
