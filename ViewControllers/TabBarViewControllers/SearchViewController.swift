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
    
    let countPickerDataSource = [2, 4, 6, 10, 20, 30]
    var currentCountOfRandomAPODs = AppConstants.defaultCountOfRandomAPODs
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.countPicker.reloadAllComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.ViewControllers.SearchVC.bgColor
        title = AppConstants.ViewControllers.SearchVC.title
        
        setUpCollectonView()
        configureDataSource()
        setUpBindings()
        
        // set default picker to 3 item
        contentView.countPicker.selectRow(2, inComponent: 0, animated: true)
    }
    
    private func setUpBindings() {
        
        contentView.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for:  .editingDidEnd)
        contentView.randomSearchButton.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        
        func bindViewToViewModel() {
            
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
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        let theAPOD = viewModel.getAPODsForDate(date: selectedDate)
        
        let detailsVC = DetailsViewController(storageManager: storageManager, apod: theAPOD, apodImage: (self.viewModel.dictionaryImageCache[theAPOD.url] ?? UIImage(named: "nasa-logo"))!)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    @objc func tapSearchButton() {
        viewModel.searchRandomAPODs(count: currentCountOfRandomAPODs)
    }
    
    private func setUpCollectonView() {
        contentView.collectionView.register(
            APODsCollectionCell.self,
            forCellWithReuseIdentifier: APODsCollectionCell.identifier)
        
        contentView.collectionView.delegate = self
        
        contentView.countPicker.delegate = self
        contentView.countPicker.dataSource = self
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
        guard let selectedAPOD = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        print("Selected:", selectedAPOD.date, selectedAPOD.url)
        
        let detailsVC = DetailsViewController(storageManager: storageManager, apod: selectedAPOD, apodImage: (self.viewModel.dictionaryImageCache[selectedAPOD.url] ?? UIImage(named: "nasa-logo"))!)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension SearchViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        
        let titleData = String(countPickerDataSource[row])
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        let myTitle = NSAttributedString(string: titleData,
                                         attributes: [
                                            NSAttributedString.Key.font:UIFont(name: "Georgia", size: 18.0)!,
                                            NSAttributedString.Key.foregroundColor:UIColor.systemBlue,
                                            NSAttributedString.Key.paragraphStyle:titleParagraphStyle,
                                         ])
        
        pickerLabel.attributedText = myTitle
        
        return pickerLabel
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        currentCountOfRandomAPODs = countPickerDataSource[row]
    }
}

extension SearchViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countPickerDataSource.count
    }
}
