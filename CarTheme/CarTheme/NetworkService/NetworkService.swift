import Moya
import Foundation

let imagePath = "https://image.tmdb.org/t/p/w500/"
let smallImagePath = "https://image.tmdb.org/t/p/w300/"

enum NetworkService {
    static private let apiKey = "f910e2224b142497cc05444043cc8aa4"

    case getNewsList
    case getTopNewsList

    case getSearchResults(details: String)

}

extension NetworkService: TargetType {

    var path: String {
        switch self {
        case .getNewsList:
            return "/movie/popular"
        case .getTopNewsList:
            return "/movie/top_rated"
        case .getSearchResults:
            return "/search/company"
        }
    }

    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }

    var method: Moya.Method {
        switch self{
        case .getNewsList, .getTopNewsList, .getSearchResults:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self{
        case .getNewsList, .getTopNewsList:
            return .requestParameters(parameters: ["api_key": NetworkService.apiKey], encoding: URLEncoding.default)
        case .getSearchResults(let details):
            return .requestParameters(parameters: ["api_key": NetworkService.apiKey, "query": details], encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
