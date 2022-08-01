import UIKit
import Combine

class FavoritesViewController: UIViewController {
    
    private lazy var contentView = FavoritesView()
    private let viewModel: FavoritesViewModel
    private var bindings = Set<AnyCancellable>()
        
    init(viewModel: FavoritesViewModel = FavoritesViewModel())
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
        view.backgroundColor = AppConstants.ViewControllers.FavoritesVC.bgColor
        title = AppConstants.ViewControllers.FavoritesVC.title
        
        setupTableView()
    }
    
    private func setupTableView() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        contentView.tableView.estimatedRowHeight = 200
        contentView.tableView.rowHeight = UITableView.automaticDimension
        
        contentView.tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "FavouritesTableViewCell")
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

extension FavoritesViewController: UITableViewDelegate {
    
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.APODsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as? FavoritesTableViewCell else { return UITableViewCell()  }
        
        let apodInstance = viewModel.APODsArray[indexPath.row]
        
        cell.viewModel = FavoritesTableViewCellViewModel(apod: apodInstance)
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
