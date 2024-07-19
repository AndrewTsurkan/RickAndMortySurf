import Foundation

class NetworkDataFetcher {
    private let networkService = NetworkService()
    
    func fetchJson(urlString: String, closure: @escaping (Result<[ResponseResult], Error>) ->Void) {
        networkService.request(urlString: urlString) { result in
            switch result {
            case.success(let data):
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    closure(.success(response.results ?? []))
                } catch let error {
                    closure(.failure(error))
                }
            case.failure(let error):
                closure(.failure(error))
            }
        }
    }
    
    func fetchDetailJson(urlString: String, closure: @escaping (Result<DetailResponse, Error>) ->Void) {
        networkService.request(urlString: urlString) { result in
            switch result {
            case.success(let data):
                do {
                    let response = try JSONDecoder().decode(DetailResponse.self, from: data)
                    closure(.success(response))
                } catch let error {
                    closure(.failure(error))
                }
            case.failure(let error):
                closure(.failure(error))
            }
        }
    }
}
