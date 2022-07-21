import UIKit

class FavouritesView: UIView {
    
    lazy var tableView = UITableView()

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
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: AppConstants.defaultPaggin),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -AppConstants.defaultPaggin)
        ])
    }
    
    private func setUpViews() {
        tableView.backgroundColor = AppConstants.ViewControllers.FavouritesVC.bgColor
    }
}
