import Foundation
//MARK: - Main Screen -
struct Response: Codable {
    var results: [ResponseResult]?
}

struct ResponseResult: Codable {
    var name: String?
    var status: String?
    var species: String?
    var gender: String?
    var image: String?
    var location: Location?
    var episode: [String]?
}

struct Location: Codable {
    var name: String?
}

//MARK: - Dateil Screen -
struct DetailResponse: Codable {
    var name: String?
}
