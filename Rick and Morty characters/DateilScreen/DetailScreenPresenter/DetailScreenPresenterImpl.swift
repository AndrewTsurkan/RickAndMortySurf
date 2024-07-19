import Foundation

final class DetailScreenPresenterImpl {
    private let networkDataFetcher = NetworkDataFetcher()
    private var episodesInfo: [DetailResponse] = []
    weak var view: DetailScreenView?
}

//MARK: - Public -
extension DetailScreenPresenterImpl {
    func setView(view: DetailScreenView) {
        self.view = view
    }
}

//MARK: - DetailScreenPresenter -
extension DetailScreenPresenterImpl: DetailScreenPresenter {
    func loadData(urlString: [String]?) {
        guard let urlString else { return }
        let dispatchGroup = DispatchGroup()
        
        urlString.forEach {
            dispatchGroup.enter()
            networkDataFetcher.fetchDetailJson(urlString: $0) { [weak self] result in
                defer { dispatchGroup.leave() }
                guard let self else { return }
                switch result {
                case let .success(info):
                    self.episodesInfo.append(info)
                case let .failure(error):
                    print("Failed to get data: \(error)")
                    break
                }
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let data = self?.episodesInfo else { return }
            self?.view?.updataData(data: data)
        }
    }
}
