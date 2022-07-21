import UIKit

final class FavouritesTableViewCell: UITableViewCell {
    
    static let identifier = "FavouritesTableViewCell"
    
    var viewModel: FavouritesTableViewCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    var apodDateLabel = UILabel()
    var apodTitleLabel = UILabel()
    var apodImageView = UIImageView()
    var deleteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        apodImageView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
                        
            apodImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppConstants.defaultPaggin),
            apodImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            apodImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            apodImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            apodImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            apodDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: AppConstants.defaultPaggin),
            apodDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.defaultPaggin),
            
            apodTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppConstants.defaultPaggin),
            apodTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppConstants.defaultPaggin),
            
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppConstants.defaultPaggin),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.defaultPaggin),
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
        apodImageView.layer.cornerRadius = 8
        apodImageView.layer.shadowRadius = 8
        apodImageView.contentMode = .scaleToFill

        deleteButton.imageView?.image = UIImage(systemName: "trash.fill")
        deleteButton.backgroundColor = .systemRed
        deleteButton.titleColor(for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.apodDateLabel.text = nil
        self.apodTitleLabel.text = nil
        self.apodImageView.image = nil
    }
}
