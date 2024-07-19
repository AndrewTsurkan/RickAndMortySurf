import UIKit

class MainScreenViewController: UIViewController {
    
    //MARK: - Privatet properties -
    private var ricks: [ResponseResult] = []
    private let contentView = MainScreenContentView()
    private let presenter: MainScreenPresenter
    private var counter: Int = 1
    
    //MARK: - Life cycle - 
    init(presenter: MainScreenPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.setupDelegate(delegate: self, dataSource: self)
        presenter.loadData()
        setupNavigation()
    }
}

//MARK: - MainScreenView -
extension MainScreenViewController: MainScreenView {
    func updateData(data: [ResponseResult]) {
        ricks = data
    }
    
    func updateTableView() {
        contentView.reloadTableView()
    }
    
}
//MARK: - UITableViewDelegate, UITableViewDataSource -
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ricks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainScreenTableViewCell.identifier, for: indexPath) as? MainScreenTableViewCell else {
            return UITableViewCell()
        }
        let rick = ricks[indexPath.row]
        cell.responseResult = rick
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ricks.count - 1 {
            counter += 1
            let urlString = "https://rickandmortyapi.com/api/character?page=\(String(counter))"
            presenter.paginationLoadData(urlString: urlString)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetailViewController(indexPath: indexPath.row, viewController: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension MainScreenViewController {
    func setupNavigation() {
        let titleLabel = UILabel()
        titleLabel.text = "Rick & Morty Characters"
        titleLabel.textColor = UIColor(named: "textColor")
        titleLabel.font = UIFont(name: "IBMPlexSans-Medium", size: 24)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            appearance.shadowColor = .clear
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
