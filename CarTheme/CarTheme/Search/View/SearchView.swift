import UIKit
import RxCocoa
import RxSwift

class SearchView: UIViewController, SearchViewDelegate {

    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!

    //MARK: - Properties
    private let searchPresenter = SearchPresenter(searchModel: SearchModel())
    var searchResults: BehaviorRelay<[NewsItem]> = BehaviorRelay<[NewsItem]>(value: [])
    var searchDetails: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bind()
    }

    //MARK: - Methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.nib, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    }

    private func bind() {
        searchResults.subscribe(onNext: { [weak self]_ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)

        searchBar.rx.text
            .bind(to: searchDetails.self)
            .disposed(by: disposeBag)

        searchDetails.subscribe(onNext: {[weak self](value) in
            guard let value = value, let self = self else { return }
            self.searchPresenter.getSearchResult(request: value)
        }).disposed(by: disposeBag)

        closeButton.rx.tap.bind{ [weak self] in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }

}

extension SearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as! NewsCell
        cell.details = searchResults.value[indexPath.row]
        return cell
    }

}
