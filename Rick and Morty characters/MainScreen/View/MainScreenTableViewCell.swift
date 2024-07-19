import UIKit

class MainScreenTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: - Private properties -
    private let mainStackView = UIStackView()
    private let coverImageView = UIImageView()
    private let separationLabel = UILabel()
    private let verticalStackView = UIStackView()
    private let nameLabel = UILabel()
    private let statusAndRaceLabel = UILabel()
    private let genderLabel = UILabel()
    private let backgroundCellView = UIView()
    
    var responseResult: ResponseResult? {
        didSet{
            reloadData()
        }
    }
    
    //MARK: - Init -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override -
    override func prepareForReuse() {
        nameLabel.text = nil
        statusAndRaceLabel.text = nil
        coverImageView.image = nil
        genderLabel.text = nil
    }
}

//MARK: - UI -
private extension MainScreenTableViewCell {
    func setupUI() {
        addSubviews()
        makeConstraints()
        setupBackgroundCellView()
        setupMainStackView()
        setupVerticalStackView()
        setupCoverImageView()
        setupNameLabel()
        setupStatusAndRaceLabel()
        setupSeparationLabel()
        setupGenderLabel()
        layer.cornerRadius = 16
        backgroundColor = .clear
    }
    
    
    func addSubviews() {
        addSubview(backgroundCellView)
        backgroundCellView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(coverImageView)
        mainStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(statusAndRaceLabel)
        verticalStackView.addArrangedSubview(genderLabel)
        
    }
    
    func setupBackgroundCellView() {
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundCellView.layer.cornerRadius = 24
        backgroundCellView.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
    }
    
    func setupMainStackView() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.spacing = 16
    }
    
    func setupVerticalStackView() {
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 6
    }
    
    func setupCoverImageView() {
        coverImageView.layer.cornerRadius = 16
        coverImageView.clipsToBounds = true
    }
    
    func setupNameLabel() {
        nameLabel.font = UIFont(name: "IBMPlexSans-Medium", size: 18)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .left
    }
    
    func setupStatusAndRaceLabel() {
        statusAndRaceLabel.font = UIFont(name: "IBMPlexSans-Medium", size: 12)
        statusAndRaceLabel.textColor = .label
        statusAndRaceLabel.textAlignment = .left
    }
    
    func setupSeparationLabel() {
        separationLabel.text = ""
        separationLabel.font = UIFont(name: "IBMPlexSans-Medium", size: 12)
        separationLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        separationLabel.textColor = .label
    }
    
    func setupGenderLabel() {
        genderLabel.font = UIFont(name: "IBMPlexSans", size: 12)
        genderLabel.textColor = .label
        genderLabel.textAlignment = .left
    }
    
    func makeConstraints() {
        //MainStackViewConstraint
        NSLayoutConstraint.activate(
            [backgroundCellView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
             backgroundCellView.leftAnchor.constraint(equalTo: leftAnchor),
             backgroundCellView.rightAnchor.constraint(equalTo: rightAnchor),
             backgroundCellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
             
             mainStackView.topAnchor.constraint(equalTo: backgroundCellView.topAnchor, constant: 16),
             mainStackView.leftAnchor.constraint(equalTo: backgroundCellView.leftAnchor, constant: 15),
             mainStackView.rightAnchor.constraint(equalTo: backgroundCellView.rightAnchor, constant: -15),
             mainStackView.bottomAnchor.constraint(equalTo: backgroundCellView.bottomAnchor, constant: -16),
             
             coverImageView.heightAnchor.constraint(equalToConstant: 64),
             coverImageView.widthAnchor.constraint(equalToConstant: 84)])
    }
}

//MARK: - Private func -
private extension MainScreenTableViewCell {
    
    func downloadPoster() {
        guard let url = responseResult?.image else {
            return
        }
        
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
    
    func reloadData() {
        guard let responseResult else {
            return
        }
        
        downloadPoster()
        nameLabel.text = responseResult.name
        guard let status = responseResult.status,
              let race = responseResult.species else { return }
        
        statusAndRaceLabel.attributedText = createAttributedStatusAndRaceText(status: status, race: race)
        genderLabel.text = responseResult.gender
    }
    
    func createAttributedStatusAndRaceText(status: String, race: String) -> NSAttributedString {
        let statusColor: UIColor
        if let statusEnum = Status(rawValue: status) {
            statusColor = statusEnum.textColor
        } else {
            statusColor = .label
        }
        
        let fullText = "\(status) • \(race)"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let statusRange = NSRange(location: 0, length: status.count)
        attributedString.addAttribute(.foregroundColor, value: statusColor, range: statusRange)
        
        let raceRange = NSRange(location: status.count + 3, length: race.count)
        attributedString.addAttribute(.foregroundColor, value: UIColor.label, range: raceRange)
        
        return attributedString
    }
}

//MARK: - Colors Enum -
    private extension MainScreenTableViewCell {
    enum Status: String {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
        
        var textColor: UIColor {
            switch self {
            case .alive:
                return UIColor(red: 49/255, green: 159/255, blue: 22/255, alpha: 1)
            case .dead:
                return UIColor(red: 233/255, green: 56/255, blue: 0/255, alpha: 1)
            case .unknown:
                return UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
            }
        }
    }
}
