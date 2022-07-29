import UIKit
import Combine

class FavouritesViewController: UIViewController {
    
    private lazy var contentView = FavouritesView()
    private let viewModel: FavouritesViewModel
    private var bindings = Set<AnyCancellable>()
    
//    private let storageManager: MainStorageManager
    
    init(//storageManager: MainStorageManager,
         viewModel: FavouritesViewModel = FavouritesViewModel())
    {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setUpBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchAllFavourites()
        contentView.tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = AppConstants.ViewControllers.FavouritesVC.bgColor
        title = AppConstants.ViewControllers.FavouritesVC.title
        
        setupTableView()
    }
    
    private func setupTableView() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        contentView.tableView.estimatedRowHeight = 200
        contentView.tableView.rowHeight = UITableView.automaticDimension
        
        contentView.tableView.register(FavouritesTableViewCell.self, forCellReuseIdentifier: "FavouritesTableViewCell")
    }
    
    private func setUpBindings() {
        
        bindViewModelToView()
        
        func bindViewModelToView() {
            
            viewModel.$APODsArray
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] _ in
                    self?.contentView.tableView.reloadData()
                })
                .store(in: &bindings)
        }
    }
}

extension FavouritesViewController: UITableViewDelegate {
    
}

extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.APODsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesTableViewCell.identifier, for: indexPath) as? FavouritesTableViewCell else { return UITableViewCell()  }
        
        let apodInstance = viewModel.APODsArray[indexPath.row]
        
        cell.viewModel = FavouritesTableViewCellViewModel(apod: apodInstance)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return contentView.frame.width - AppConstants.defaultThinPadding * 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                                
        let selectedAPODInstance = viewModel.APODsArray[indexPath.row]
            
        let zoomableVC = ZoomableDetailViewController(apodInstance: selectedAPODInstance)
        navigationController?.pushViewController(zoomableVC, animated: true)
    }
    
}
