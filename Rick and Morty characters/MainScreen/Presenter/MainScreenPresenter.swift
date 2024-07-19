import UIKit

protocol MainScreenPresenter: AnyObject {
    func loadData()
    func paginationLoadData(urlString: String)
    func showDetailViewController(indexPath: Int, viewController: UIViewController) 
}
