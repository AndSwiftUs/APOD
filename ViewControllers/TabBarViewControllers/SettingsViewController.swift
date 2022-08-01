import UIKit
import Combine
import SwiftUI

class SettingsViewController: UIViewController {
    
    @Published var isEnterValidApiKey = false
    private var cancellables = Set<AnyCancellable>()
    
    let apiKeyTextLabel = UILabel()
    let apiKeyTextField = UITextField()
    let apiKeySaveButton = UIButton()
    
    let apiKeyStartTutorialButton = UIButton()
    let tutorialView = UIImageView()
    var tutorialNubmer = 1
    
    private lazy var aboutButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                                   style: .done,
                                                   target: self,
                                                   action: #selector(aboutButtonTapped))
    override func loadView() {
        super.loadView()
        navigationItem.rightBarButtonItem = aboutButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.ViewControllers.SettingsVC.bgColor
        title = AppConstants.ViewControllers.SettingsVC.title
        
        setUpApiKeyLayout()
        setUpTutoralLayout()
        setUpBindings()
    }
    
    private func setUpApiKeyLayout() {
        [apiKeyTextLabel, apiKeyTextField, apiKeySaveButton, apiKeyStartTutorialButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        apiKeyTextLabel.numberOfLines = 2
        apiKeyTextLabel.textAlignment = .center
        apiKeyTextLabel.text = (SavedUserPrefs.shared.userAPIKey != AppConstants.NASA.defaultAPIKey)
                                ? "\nYour personal API-key is: "
                                : "You use DEMO API-key \nwith some restriction (see tutorial)"
        
        apiKeyTextField.placeholder = SavedUserPrefs.shared.userAPIKey
        
        apiKeySaveButton.setTitle((SavedUserPrefs.shared.userAPIKey != AppConstants.NASA.defaultAPIKey)
                                  ? "Save my new API-key"
                                  : "See tutorial for API-key", for: .normal)
        apiKeySaveButton.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            apiKeyTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppConstants.defaultThinPadding),
            apiKeyTextLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/10),
            apiKeyTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            apiKeyTextField.topAnchor.constraint(equalTo: apiKeyTextLabel.bottomAnchor, constant: AppConstants.defaultPadding),
            apiKeyTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/10),
            apiKeyTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            apiKeySaveButton.topAnchor.constraint(equalTo: apiKeyTextField.bottomAnchor, constant: AppConstants.defaultPadding),
            apiKeySaveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 7/10),
            apiKeySaveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setUpTutoralLayout() {
        view.addSubview(tutorialView)
        tutorialView.translatesAutoresizingMaskIntoConstraints = false
        tutorialView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            tutorialView.topAnchor.constraint(equalTo: apiKeySaveButton.bottomAnchor, constant: AppConstants.defaultPadding),
            tutorialView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tutorialView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tutorialView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: AppConstants.defaultThinPadding),
        ])
    }
    
    private func setUpBindings() {
        apiKeySaveButton.addTarget(self, action: #selector(apiKeySaveButtonTapped), for: .touchUpInside)
        
        apiKeyTextField.textPublisher
            .sink(receiveValue: { [weak self] text in
                guard let self = self else { return }
                if text.count == AppConstants.NASA.countOfApiKeySymbols {
                    self.isEnterValidApiKey = true
                } else {
                    self.isEnterValidApiKey = false
                }
                self.apiKeyTextLabel.text = (SavedUserPrefs.shared.userAPIKey == AppConstants.NASA.defaultAPIKey)
                                            ? "\nYour personal API-key is: "
                                            : "You use DEMO API-key \nwith some restriction (see tutorial)"
                self.apiKeySaveButton.setTitle(self.isEnterValidApiKey
                                               ? "Save my new API-key"
                                               : "See tutorial for API-key", for: .normal)
                self.apiKeySaveButton.backgroundColor = self.isEnterValidApiKey ? .systemRed : .systemBlue
            })
            .store(in: &cancellables)
    }
    
    @objc func apiKeySaveButtonTapped() {
        if isEnterValidApiKey {
            SavedUserPrefs.shared.userAPIKey = apiKeyTextField.text!
            apiKeyTextField.text = "Your API-key saved."
            apiKeySaveButton.setTitle("All done", for: .normal)
            apiKeySaveButton.isEnabled = false
            isEnterValidApiKey = false
        } else {
            if tutorialNubmer < 10 {
                let filename = "tutorial_\(tutorialNubmer)"
                tutorialView.image = UIImage(named: filename)
                tutorialNubmer += 1
            } else {
                tutorialNubmer = 1
                tutorialView.image = nil
            }
        }
    }
    
    @objc func aboutButtonTapped() {
        let aboutVC = AboutViewController()
        navigationController?.pushViewController(aboutVC, animated: true)
    }
}
