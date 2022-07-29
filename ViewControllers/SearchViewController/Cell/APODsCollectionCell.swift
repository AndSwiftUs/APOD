import UIKit
import Combine

final class APODsCollectionCell: UICollectionViewCell {
    static let identifier = "APODsTableViewCell"
    
    var viewModel: APODsCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    var apodDateLabel = UILabel()
    var apodTitleLabel = UILabel()
    var apodImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubiews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        
        contentView.addSubview(apodImageView)
        apodImageView.translatesAutoresizingMaskIntoConstraints = false
        
        apodImageView.addSubview(apodDateLabel)
        apodDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        apodImageView.addSubview(apodTitleLabel)
        apodTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
//            apodImageView.topAnchor.constraint(equalTo: topAnchor),
//            apodImageView.widthAnchor.constraint(equalTo: widthAnchor),
//            apodImageView.heightAnchor.constraint(equalTo: widthAnchor),
//            apodImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            apodImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: apodImageView.topAnchor),
            contentView.centerXAnchor.constraint(equalTo: apodImageView.centerXAnchor),
            contentView.bottomAnchor.constraint(equalTo: apodImageView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: apodImageView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: apodImageView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            apodDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            apodDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            
            apodTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            apodTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
        ])
    }
    
    private func setUpViewModel() {
        apodDateLabel.font  = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        apodDateLabel.textAlignment = .center
        apodDateLabel.backgroundColor = .black.withAlphaComponent(0.4)
        apodDateLabel.textColor = .systemGray3
        
        apodTitleLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        apodTitleLabel.numberOfLines = 2
        apodTitleLabel.textColor = .systemGray3
        apodTitleLabel.backgroundColor = .black.withAlphaComponent(0.4)
        apodTitleLabel.adjustsFontSizeToFitWidth = true
        
        apodDateLabel.text = "Date: " + viewModel.apodDate
        apodTitleLabel.text = viewModel.apodTile
        
        apodImageView.image = viewModel.apodImage
        apodImageView.clipsToBounds = true
        apodImageView.layer.cornerRadius = 4
        apodImageView.layer.shadowRadius = 4
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.apodDateLabel.text = nil
        self.apodTitleLabel.text = nil
        self.apodImageView.image = nil
    }
}
