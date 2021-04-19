import Foundation
import Moya

class NewsModel {
    let networkService = MoyaProvider<NetworkService>()

    func getNewsList(for type: TypeOfNews, completion: @escaping([NewsItem])->()) {
        let request: NetworkService = type == .average ? .getNewsList : .getTopNewsList
        networkService.request(request) { (result) in
            switch result {
            case .failure(let error):
                print("--------> Error: \(error)")
            case .success(let response):
                do {
                    let newsResult = try JSONDecoder().decode(NewsResponse.self, from: response.data)
                    completion(newsResult.results)
                } catch {
                    fatalError("Parsing error")
                }
            }
        }
    }
}

enum TypeOfNews{
    case average, top
}

struct NewsResponse: Decodable {
    let results: [NewsItem]
}

struct NewsItem: Decodable {
    let id: Int
    let title: String
    let releaseDate: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case image = "poster_path"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        image = try container.decode(String.self, forKey: .image)
    }
}
