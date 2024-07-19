import UIKit

final class MainScreenPresenterImpl {
    //MARK: - Private properties -
    private let networkDataFetcher = NetworkDataFetcher()
    private var ricks: [ResponseResult] = []
    weak var view: MainScreenView?
}

//MARK: - Public -
extension MainScreenPresenterImpl {
    func setView(view: MainScreenView) {
        self.view = view
    }
}
//MARK: - MainScreenPresenter -
extension MainScreenPresenterImpl: MainScreenPresenter  {
    func showDetailViewController(indexPath: Int, viewController: UIViewController) {
        //TODO: - create router
        let presenter = DetailScreenPresenterImpl()
        let detailController = DetailScreenViewController(response: ricks[indexPath], presenter: presenter)
        presenter.setView(view: detailController)
        viewController.navigationController?.pushViewController(detailController, animated: true)
    }
    
    func loadData(){
        let urlString: String = "https://rickandmortyapi.com/api/character"
        networkDataFetcher.fetchJson(urlString: urlString) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(info):
                self.ricks = info
                self.view?.updateData(data: self.ricks)
                DispatchQueue.main.async {
                    self.view?.updateTableView()
                }
            case .failure:
                // TODO: Error handling
                break
            }
        }
    }
    
    func paginationLoadData(urlString: String) {
        networkDataFetcher.fetchJson(urlString: urlString) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(info):
                self.ricks.append(contentsOf: info)
                self.view?.updateData(data: self.ricks)
                DispatchQueue.main.async {
                    self.view?.updateTableView()
                }
            case .failure:
                // TODO: Error handling
                break
            }
        }
    }
}
