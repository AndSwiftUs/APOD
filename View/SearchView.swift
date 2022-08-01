import Foundation
import UIKit

final class SearchView : UIView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    lazy var randomSearchButton = UIButton()
    lazy var randomSeachLabel = UILabel()
    lazy var datePicker = UIDatePicker()
    lazy var datePickerLabel = UILabel()
    lazy var countPicker = UIPickerView()
            
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
        let subviews = [countPicker, datePicker, datePickerLabel, randomSearchButton, randomSeachLabel, collectionView]
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            datePickerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: AppConstants.defaultThinPadding),
            datePickerLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: AppConstants.defaultThinPadding),
            datePickerLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/3),
            datePickerLabel.heightAnchor.constraint(equalTo: datePicker.heightAnchor),
            
            datePicker.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: AppConstants.defaultThinPadding),
            datePicker.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -AppConstants.defaultThinPadding),
                        
            randomSeachLabel.topAnchor.constraint(equalTo: datePickerLabel.bottomAnchor, constant: AppConstants.defaultPadding),
            randomSeachLabel.widthAnchor.constraint(equalTo: datePickerLabel.widthAnchor, constant: -56 - AppConstants.defaultThinPadding),
            randomSeachLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: AppConstants.defaultThinPadding),
                        
            countPicker.topAnchor.constraint(equalTo: datePickerLabel.bottomAnchor, constant: AppConstants.defaultThinPadding),
            countPicker.leadingAnchor.constraint(equalTo: randomSeachLabel.trailingAnchor, constant: AppConstants.defaultPadding),
            countPicker.trailingAnchor.constraint(equalTo: randomSearchButton.leadingAnchor, constant: -AppConstants.defaultPadding),
            countPicker.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
            countPicker.widthAnchor.constraint(lessThanOrEqualToConstant: 56),
            countPicker.centerYAnchor.constraint(equalTo: randomSearchButton.centerYAnchor),
            
            randomSearchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.defaultThinPadding),
            randomSearchButton.centerYAnchor.constraint(equalTo: randomSeachLabel.centerYAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: randomSeachLabel.bottomAnchor, constant: AppConstants.defaultPadding),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setUpViews() {
        collectionView.backgroundColor = .systemBackground
        
        datePicker.datePickerMode = .date
        datePickerLabel.numberOfLines = 1
        datePickerLabel.textColor = .systemGray
        datePickerLabel.text = "Choose date to search"
        
        countPicker.clipsToBounds = true
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        let customButtonTitle = NSMutableAttributedString(string: "Random\nsearch", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: titleParagraphStyle
        ])

        randomSearchButton.setAttributedTitle(customButtonTitle, for: .normal)
        randomSearchButton.backgroundColor = .systemBlue
        randomSearchButton.layer.cornerRadius = 5.0
        randomSearchButton.layer.masksToBounds = true
        randomSearchButton.titleLabel?.numberOfLines = 2
                
        randomSeachLabel.numberOfLines = 2
        randomSeachLabel.textColor = .systemGray
        randomSeachLabel.text = "Choose number of APODs\nto random search:"
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

        //horizontal: 
//        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
