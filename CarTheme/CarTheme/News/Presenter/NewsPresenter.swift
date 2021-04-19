import Foundation
import RxCocoa
import RxSwift


class NewsPresenter {

    private let newsModel: NewsModel
    weak private var newsViewDelegate: NewsViewDelegate?

    init(newsModel: NewsModel) {
        self.newsModel = newsModel
    }

    func setViewDelegate(newsViewDelegate: NewsViewDelegate?){
        self.newsViewDelegate = newsViewDelegate
    }

    func getNews() {
        newsModel.getNewsList(for: .average) { [weak self] (newsItems) in
            self?.newsViewDelegate?.dataSource.accept(newsItems)
        }
    }

    func getTopNews() {
        newsModel.getNewsList(for: .top) { [weak self] (newsItems) in
            self?.newsViewDelegate?.topDataSource.accept(newsItems)
        }
    }

    func getEmptyListNews() {
        newsViewDelegate?.stubNewsDataSource.accept([])
    }

    func goToSearchScreen() {
        

    }

}
