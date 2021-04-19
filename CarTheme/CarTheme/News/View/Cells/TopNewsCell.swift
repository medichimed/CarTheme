import UIKit
import Kingfisher

class TopNewsCell: UITableViewCell, NibDescribingProtocol {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var viewContainerWidthConstraint: NSLayoutConstraint!

    var sliders: [TopNewsView]!

    var details: [NewsItem]? {
        didSet{
            configureCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        scrollView.delegate = self
        pageControl.currentPage = 0
        viewContainer.bringSubviewToFront(pageControl)
    }

    private func configureCell() {
        sliders = createSlides()
        setupSlideScrollView(slides: sliders)
        pageControl.numberOfPages = sliders.count
    }

    func createSlides() -> [TopNewsView] {

        var pages: [TopNewsView] = []

        details?.forEach({ (item) in
            let page = Bundle.main.loadNibNamed(TopNewsView.reuseIdentifier, owner: self, options: nil)?.first as! TopNewsView
            page.details = item
            pages.append(page)
        })

        return pages
    }

    func setupSlideScrollView(slides : [TopNewsView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 382)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(slides.count), height: 382)
        scrollView.isPagingEnabled = true

        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height: 382)
            scrollView.addSubview(slides[i])
        }
        viewContainerWidthConstraint.constant = UIScreen.main.bounds.width * CGFloat(slides.count)
    }
    
}

extension TopNewsCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
       pageControl.currentPage = Int(pageNumber)
   }
}
