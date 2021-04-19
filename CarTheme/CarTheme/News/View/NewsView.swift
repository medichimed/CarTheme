import RxCocoa
import RxSwift
import UIKit

class NewsView: UIViewController, NewsViewDelegate {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var storiesButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var searchBuntton: UIButton!
    @IBOutlet weak var slider: UISlider!


    //MARK: - Properties
    private let newsPresenter = NewsPresenter(newsModel: NewsModel())
    var dataSource: BehaviorRelay<[NewsItem]> = BehaviorRelay<[NewsItem]>(value: [])
    var topDataSource: BehaviorRelay<[NewsItem]> = BehaviorRelay<[NewsItem]>(value: [])
    var stubNewsDataSource: BehaviorRelay<[NewsItem]> = BehaviorRelay<[NewsItem]>(value: [])
    private let disposeBag = DisposeBag()

    private var currentSection:  BehaviorRelay<CurrentSection> = BehaviorRelay<CurrentSection>(value: .stories)

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        newsPresenter.setViewDelegate(newsViewDelegate: self)
        bind()
    }

    //MARK: - Methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.nib, forCellReuseIdentifier: NewsCell.reuseIdentifier)
        tableView.register(TopNewsCell.nib, forCellReuseIdentifier: TopNewsCell.reuseIdentifier)
    }

    private func bind() {
        dataSource.subscribe(onNext: {[weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)

        stubNewsDataSource.subscribe(onNext: {[weak self] _ in
            self?.tableView.backgroundView = BackgroundView(frame: self!.tableView.frame)
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)

        currentSection.subscribe(onNext: {[weak self](section) in
            switch section{
            case .stories:
                self?.newsPresenter.getNews()
                self?.newsPresenter.getTopNews()
            case .video, .favourites:
                self?.newsPresenter.getEmptyListNews()
            }
            self?.updateSliderValue(for: section.sectionAsocciatedSliderValue)
        }).disposed(by: disposeBag)

        storiesButton.rx.tap.bind{ [weak self] _ in
            self?.currentSection.accept(.stories)
        }.disposed(by: disposeBag)

        videoButton.rx.tap.bind{ [weak self] _ in
            self?.currentSection.accept(.video)
        }.disposed(by: disposeBag)

        favouritesButton.rx.tap.bind{ [weak self] _ in
            self?.currentSection.accept(.favourites)
        }.disposed(by: disposeBag)

        searchBuntton.rx.tap.bind{
            let searchVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchView") 
            self.present(searchVC, animated: true, completion: nil)
        }.disposed(by: disposeBag)

    }

    private func updateSliderValue(for value: Float) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .beginFromCurrentState, animations: {
                        self.slider.setValue(value, animated: true) },
                       completion: nil)
    }

}

extension NewsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSection.value == .stories {
            return dataSource.value.count
        } else {
            return stubNewsDataSource.value.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentSection.value == .stories {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TopNewsCell.reuseIdentifier, for: indexPath) as! TopNewsCell
                cell.details = topDataSource.value
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as! NewsCell
                cell.details = dataSource.value[indexPath.row]
                return cell
            }
        } else {
            return tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 340
        }
        return UITableView.automaticDimension
    }

}

enum CurrentSection {
    case stories, video, favourites

    var sectionAsocciatedSliderValue: Float{
        switch self{
        case .stories: return 3.0
        case .video: return 6.0
        case .favourites: return 9.0
        }
    }
}
