import UIKit
import Kingfisher

class NewsCell: UITableViewCell, NibDescribingProtocol {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var timeOfPublicationLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        timeOfPublicationLabel.text = nil
        newsImageView.image = nil
    }

    var details: NewsItem? {
        didSet{
            configureCell()
        }
    }

    private func configureCell() {
        newsTitleLabel.text = details?.title
        timeOfPublicationLabel.text = CustomDateFormatter.getFormattedDate(from: details?.releaseDate)
        newsImageView.kf.indicatorType = .activity
        newsImageView.kf.setImage(with: URL(string: "\(imagePath)\(details!.image)")!)
    }
}
