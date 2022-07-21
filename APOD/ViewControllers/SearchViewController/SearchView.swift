import Foundation
import UIKit

final class SearchView : UIView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
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
    
    private func addSubviews() {
        let subviews = [searchTextField, searchButton, seachLabel, collectionView]
        
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
            
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: defaultMargin),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

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
               
        let itemSize = NSCollectionLayoutSize(
            widthDimension:  .fractionalWidth(1/2),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/3)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
//        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
