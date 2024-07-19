import UIKit

final class DetailScreenViewController: UIViewController {
    
    //MARK: - Prvate properties -
    private var response: ResponseResult
    private var detailResponse: [DetailResponse] = [] {
        didSet {
            contenView.configuretion(response: response, episodes: detailResponse)
        }
    }
    private let contenView = DetailScreenContentView()
    private let presenter: DetailScreenPresenter
    
    //MARK: - Life cycle -
    init(response: ResponseResult,
         presenter: DetailScreenPresenter) {
        self.response = response
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.loadData(urlString: response.episode)
        setupNavigation()
        setupBackButton()

    }
}

//MARK: - DetailScreenView - 
extension DetailScreenViewController: DetailScreenView {
    func updataData(data: [DetailResponse]) {
        detailResponse = data
    }
}

//MARK: - Private -
private extension DetailScreenViewController {
    func setupNavigation() {
        let titleLabel = UILabel()
        guard let name = response.name else { return }
        titleLabel.text = name
        titleLabel.textColor = UIColor(named: "textColor")
        titleLabel.font = UIFont(name: "IBMPlexSans-Medium", size: 24)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
    func setupBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .label
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
