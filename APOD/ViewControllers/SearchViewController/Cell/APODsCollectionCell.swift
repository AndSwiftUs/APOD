import UIKit
import Combine

final class APODsCollectionCell: UICollectionViewCell {
    static let identifier = "APODsTableViewCell"
    
    var viewModel: APODsCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    lazy var apodDateLabel = UILabel()
    lazy var apodTitleLabel = UILabel()
    lazy var apodImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubiews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        let subviews = [apodDateLabel, apodTitleLabel, apodImageView]
        
        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        
        apodDateLabel.font  = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        apodDateLabel.textAlignment = .center
        
        apodTitleLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        apodTitleLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            
            apodImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            apodImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            apodImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            apodImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            apodImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            apodDateLabel.topAnchor.constraint(equalTo: apodImageView.bottomAnchor, constant: 4),
            apodDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            apodDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            apodTitleLabel.topAnchor.constraint(equalTo: apodDateLabel.bottomAnchor),
            apodTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            apodTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setUpViewModel() {
        apodDateLabel.text = "Date: " + viewModel.apodDate
        apodTitleLabel.text = viewModel.apodTile
        apodImageView.image = viewModel.apodImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.apodDateLabel.text = nil
        self.apodTitleLabel.text = nil
        self.apodImageView.image = nil
    }
}
