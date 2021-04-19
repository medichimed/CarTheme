import Foundation
import RxCocoa
import RxSwift

class SearchPresenter {

    private let searchModel: SearchModel
    weak private var searchViewDelegate: SearchViewDelegate?

    init(searchModel: SearchModel) {
        self.searchModel = searchModel
    }

    func setViewDelegate(newsViewDelegate: SearchViewDelegate?){
        self.searchViewDelegate = newsViewDelegate
    }

    func getSearchResult(request: String) {
        searchModel.getSearchResult(request: request) { [weak self](result) in
            self?.searchViewDelegate?.searchResults.accept(result)
        }
    }

}
