import UIKit

final class MainScreenContentView: UIView {
//MARK: Private properties
    private let tableView = UITableView()
    
//MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Public -
extension MainScreenContentView {
    func setupDelegate(delegate: UITableViewDelegate, dataSource: UITableViewDataSource){
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

//MARK: - UI -
private extension MainScreenContentView {
    func setupUI() {
        addSubviews()
        setupTableView()
    }
    
    func addSubviews() {
        addSubview(tableView)
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MainScreenTableViewCell.self, forCellReuseIdentifier: MainScreenTableViewCell.identifier)
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate(
            [tableView.topAnchor.constraint(equalTo: topAnchor, constant: 121),
             tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
             tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
             tableView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}
