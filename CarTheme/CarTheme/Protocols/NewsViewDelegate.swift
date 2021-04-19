import Foundation
import RxCocoa
import RxSwift

protocol NewsViewDelegate: class {
    var dataSource: BehaviorRelay<[NewsItem]>{ get set }
    var topDataSource: BehaviorRelay<[NewsItem]>{ get set }
    var stubNewsDataSource: BehaviorRelay<[NewsItem]>{ get set }
}
