import Foundation
import Moya

class SearchModel {
    let networkService = MoyaProvider<NetworkService>()

    func getSearchResult(request: String, completion: @escaping([NewsItem])->()){
        networkService.request(.getSearchResults(details: request)) { (result) in
            switch result{
            case .failure(let error):
                print("--------> Error: \(error)")
            case .success(let response):
                do {
                    let newsResult = try JSONDecoder().decode(NewsResponse.self, from: response.data)
                    completion(newsResult.results)
                } catch {
                    print("----> Parsing issue")
                }
            }
        }
    }
}

