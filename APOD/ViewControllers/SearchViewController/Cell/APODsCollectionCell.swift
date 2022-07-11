import UIKit
import Combine

final class APODsCollectionCell: UICollectionViewCell {
    static let identifier = "APODsTableViewCell"
    
    var viewModel: APODsCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    lazy var apodDateLabel = UILabel()
    lazy var apodTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubiews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        let subviews = [apodDateLabel, apodTitleLabel]
        
        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        
        apodDateLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        apodTitleLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        
        NSLayoutConstraint.activate([
            apodDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            apodDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            apodDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
            
            apodTitleLabel.centerYAnchor.constraint(equalTo: apodDateLabel.centerYAnchor),
            apodTitleLabel.leadingAnchor.constraint(equalTo: apodDateLabel.trailingAnchor, constant: 10.0),
            apodTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            apodTitleLabel.heightAnchor.constraint(equalTo: apodDateLabel.heightAnchor)
        ])
    }
    
    private func setUpViewModel() {
        apodDateLabel.text = viewModel.apodDate
        apodTitleLabel.text = viewModel.apodTile
    }
}
