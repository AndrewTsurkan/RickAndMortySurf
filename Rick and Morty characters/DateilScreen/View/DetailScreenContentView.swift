import UIKit

final class DetailScreenContentView: UIView {
    //MARK: - Private properties -
    private let detailMainStackView = UIStackView()
    private let coverImageView = UIImageView()
    private let statusView = UIView()
    private let statusLabel = UILabel()
    private let speciesLabel = UILabel()
    private let genderLabel = UILabel()
    private let episodesLabel = UILabel()
    private let locationLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Public -
extension DetailScreenContentView {
    func configuretion(response: ResponseResult, episodes: [DetailResponse]) {
        guard let status = response.status,
              let species = response.species,
              let gender = response.gender,
              let location = response.location?.name else { return }
                
        statusLabel.text = status
        speciesLabel.text = "Species: \(species)"
        genderLabel.text = "Gender: \(gender)"
        let allEpisodesArray = episodes.compactMap { $0.name }
        let allEpisodesString = allEpisodesArray.joined(separator: ", ")
        episodesLabel.text = "Episodes: \(allEpisodesString)"
        locationLabel.text = "Last know location: \(location)"
        dowloadCover(url: response.image)
        switch statusLabel.text {
        case "Alive":
            statusView.backgroundColor = #colorLiteral(red: 0.1000826135, green: 0.5293918848, blue: 0.2168778181, alpha: 1)
        case "Dead":
            statusView.backgroundColor = #colorLiteral(red: 0.7642759085, green: 0.1245482042, blue: 0.008821484633, alpha: 1)
        default:
            statusView.backgroundColor = UIColor(red: 104/255, green: 104/255, blue: 116/255, alpha: 1)

  
        }
    }
}

//MARK: - UI -
private extension DetailScreenContentView {
    func setupUI() {
        addSubviews()
        setupDetailMainStackView()
        setupCoverImageView()
        setupStatusView()
        setupLabel()
        makeConstraints()
        backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        addSubview(detailMainStackView)
        detailMainStackView.addArrangedSubview(coverImageView)
        detailMainStackView.addArrangedSubview(statusView)
        statusView.addSubview(statusLabel)
        detailMainStackView.addArrangedSubview(speciesLabel)
        detailMainStackView.addArrangedSubview(genderLabel)
        detailMainStackView.addArrangedSubview(episodesLabel)
        detailMainStackView.addArrangedSubview(locationLabel)
    }
    
    func setupDetailMainStackView() {
        detailMainStackView.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        detailMainStackView.layer.cornerRadius = 24
        detailMainStackView.translatesAutoresizingMaskIntoConstraints = false
        detailMainStackView.axis = .vertical
        detailMainStackView.spacing = 10
        
        detailMainStackView.isLayoutMarginsRelativeArrangement = true
        detailMainStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func setupCoverImageView() {
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 24
    }
    
    func setupStatusView() {
        statusView.layer.cornerRadius = 16
    }
    
    func setupLabel() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        let label = [speciesLabel, genderLabel, episodesLabel, locationLabel]
        
        label.forEach{
            $0.textColor = .label
            $0.textAlignment = .left
            $0.font = UIFont(name: "IBMPlexSans-Medium", size: 16)
        }
        statusLabel.textColor = .label
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont(name: "IBMPlexSans-Medium", size: 16)
        episodesLabel.numberOfLines = 3
        locationLabel.numberOfLines = 2
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate(
             //StackView
            [detailMainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 121),
             detailMainStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
             detailMainStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
             //StatusView
             statusView.heightAnchor.constraint(equalToConstant: 42),
             //Cover
             coverImageView.heightAnchor.constraint(equalToConstant: 320),
             coverImageView.widthAnchor.constraint(equalToConstant: 320),
             //Status label
             statusLabel.leftAnchor.constraint(equalTo: statusView.leftAnchor),
             statusLabel.rightAnchor.constraint(equalTo: statusView.rightAnchor),
             statusLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor)])
    }
}

private extension DetailScreenContentView {
    func dowloadCover(url: String?) {
        guard let url else { return }
        let urlImage = URL(string:url)
        if let cachedImage = CoverCache.shared.getImage(url: url) {
            coverImageView.image = cachedImage
        } else {
            guard let urlImage else { return }
            NetworkService().request(urlString: urlImage.absoluteString) { [weak self] result in
                switch result {
                case let .success(data):
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.coverImageView.image = image
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.coverImageView.image = UIImage(named: "play.slash")
                    }
                }
            }
        }
    }
}
