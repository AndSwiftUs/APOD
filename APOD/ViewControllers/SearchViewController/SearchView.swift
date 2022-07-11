import Foundation
import UIKit

final class SearchView : UIView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    lazy var activityIndicationView = ActivityIndicatorView(style: .medium)
    lazy var searchTextField = UITextField()
    lazy var searchButton = UIButton()
    lazy var seachLabel = UILabel()
    
    var isRandomSearch = true
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        collectionView.isUserInteractionEnabled = false
        searchTextField.isUserInteractionEnabled = false
        
        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    
    func finishLoading() {
        collectionView.isUserInteractionEnabled = true
        searchTextField.isUserInteractionEnabled = true
        
        activityIndicationView.stopAnimating()
    }
    
    private func addSubviews() {
        let subviews = [searchTextField, searchButton, seachLabel, collectionView, activityIndicationView]
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        let defaultMargin: CGFloat = 8.0
        
        NSLayoutConstraint.activate([
            
            seachLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: defaultMargin),
            seachLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 8/10),
            seachLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: seachLabel.bottomAnchor, constant: defaultMargin),
            searchTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 9/10),
            searchTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: defaultMargin),
            searchButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 8/10),
            searchButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: defaultMargin),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicationView.heightAnchor.constraint(equalToConstant: 50),
            activityIndicationView.widthAnchor.constraint(equalToConstant: 50.0)
            
        ])
    }
    
    private func setUpViews() {
        
        collectionView.backgroundColor = .systemBackground
        
        searchTextField.autocorrectionType = .no
        searchTextField.backgroundColor = .systemBackground
        searchTextField.backgroundColor = .systemGray6
        searchTextField.borderStyle = .roundedRect
        searchTextField.placeholder = "enter keyword for search..."
        
        searchButton.setTitle(isRandomSearch ? "Random search" : "Search", for: .normal)
        searchButton.backgroundColor = .blue
        searchButton.layer.cornerRadius = 5.0
        searchButton.layer.masksToBounds = true
        
        seachLabel.numberOfLines = 1
        seachLabel.textColor = .systemGray
        seachLabel.font = .systemFont(ofSize: 12)
        seachLabel.textAlignment = .right
        seachLabel.text = "Enter more than TWO character to search"
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(40))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.interGroupSpacing = 5
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
