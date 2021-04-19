import Foundation
import RxCocoa
import RxSwift

protocol SearchViewDelegate: class {
    var searchResults: BehaviorRelay<[NewsItem]>{ get set }
}
