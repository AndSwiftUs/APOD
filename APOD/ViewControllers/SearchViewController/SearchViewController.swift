import UIKit
import Combine
import SwiftUI

final class SearchViewController: UIViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<SearchViewModel.Section, APOD>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchViewModel.Section, APOD>
    
    private lazy var contentView = SearchView()
    private let viewModel: SearchViewModel
    private let storageManager: MainStorageManager
    private var bindings = Set<AnyCancellable>()
    
    var searchText: String = ""
    
    private var dataSource: DataSource!
    
    init(storageManager: MainStorageManager, viewModel: SearchViewModel = SearchViewModel()) {
        self.viewModel = viewModel
        self.storageManager = storageManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.ViewControllers.SearchVC.bgColor
        title = AppConstants.ViewControllers.SearchVC.title
        
        setUpCollectonView()
        configureDataSource()
        setUpBindings()
    }
    
    private func setUpBindings() {
        
        contentView.searchButton.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        
        func bindViewToViewModel() {
            
            contentView.searchTextField.textPublisher
                .map { $0 }
                .sink(receiveValue: { text in
                    self.contentView.isRandomSearch = text.count < 3
                    self.contentView.searchButton.setTitle(self.contentView.isRandomSearch ? "Random search" : "Search", for: .normal)
                    self.searchText = text
                    self.contentView.seachLabel.text = self.contentView.isRandomSearch ? "Enter more than TWO character to search" : "Erase all to RANDOM search"
                })
                .store(in: &bindings)
        }
        
        func bindViewModelToView() {
            viewModel.$apods
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] _ in
                    self?.updateSections()
                })
                .store(in: &bindings)
            
            viewModel.$dictionaryImageCache
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] _ in
                    self?.updateSections()
                })
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    @objc func tapSearchButton() {
        self.contentView.isRandomSearch
                ? viewModel.searchRandomAPODs() : viewModel.searchAPODsForName(name: searchText)
    }
    
    private func setUpCollectonView() {
        contentView.collectionView.register(
            APODsCollectionCell.self,
            forCellWithReuseIdentifier: APODsCollectionCell.identifier)
        
        contentView.collectionView.delegate = self
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.apods])
        snapshot.appendItems(viewModel.apods)
        dataSource.apply(snapshot, animatingDifferences: true)
        contentView.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
    
extension SearchViewController: UICollectionViewDelegate {
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: contentView.collectionView,
            cellProvider: { (collectionView, indexPath, apod) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: APODsCollectionCell.identifier, for: indexPath) as? APODsCollectionCell
                
                cell?.viewModel = APODsCellViewModel(apod: apod, apodImage: self.viewModel.dictionaryImageCache[apod.url] ?? UIImage(named: "nasa-logo")!)
                
                return cell
            })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row + 1)
        
        // Get selected hero using index path
        guard let selectedAPOD = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        print("Selected:", selectedAPOD.date, selectedAPOD.url)
            
        let detailsVC = DetailsViewController(storageManager: storageManager, apod: selectedAPOD, apodImage: (self.viewModel.dictionaryImageCache[selectedAPOD.url] ?? UIImage(named: "nasa-logo"))!)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
