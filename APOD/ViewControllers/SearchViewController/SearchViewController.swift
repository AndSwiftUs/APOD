import UIKit
import Combine
import SwiftUI

final class SearchViewController: UIViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<SearchViewModel.Section, APOD>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchViewModel.Section, APOD>
    
    private lazy var contentView = SearchView()
    private let viewModel: SearchViewModel
    private var bindings = Set<AnyCancellable>()
    
    var searchText: String = ""
    
    private var dataSource: DataSource!
    
    init(viewModel: SearchViewModel = SearchViewModel()) {
        self.viewModel = viewModel
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
        self.navigationController?.navigationBar.prefersLargeTitles = AppConstants.ViewControllers.SearchVC.largeTitles
        
        setUpTableView()
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
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    @objc func tapSearchButton() {
        self.contentView.isRandomSearch
        ? viewModel.searchRandomAPODs() : viewModel.searchAPODsForName(name: searchText)
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func setUpTableView() {
        contentView.collectionView.register(
            APODsCollectionCell.self,
            forCellWithReuseIdentifier: APODsCollectionCell.identifier)
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.apods])
        snapshot.appendItems(viewModel.apods)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController {
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: contentView.collectionView,
            cellProvider: { (collectionView, indexPath, apod) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: APODsCollectionCell.identifier,
                    for: indexPath) as? APODsCollectionCell
                cell?.viewModel = APODsCellViewModel(apod: apod)
                return cell
            })
    }
}