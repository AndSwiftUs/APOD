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
        apiKeyTextLabel.text = (Prefs.shared.userAPIKey != AppConstants.NASA.defaultAPIKey) ? "\nYour personal API-key is: " : "You use DEMO API-key \nwith some restriction (see tutorial)"
        
        apiKeyTextField.placeholder = Prefs.shared.userAPIKey
        
        apiKeySaveButton.setTitle((Prefs.shared.userAPIKey == AppConstants.NASA.defaultAPIKey) ? "Save my new API-key" : "See tutorial for API-key", for: .normal)
        apiKeySaveButton.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            apiKeyTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppConstants.defaultThinPaggin),
            apiKeyTextLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/10),
            apiKeyTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            apiKeyTextField.topAnchor.constraint(equalTo: apiKeyTextLabel.bottomAnchor, constant: AppConstants.defaultPaggin),
            apiKeyTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/10),
            apiKeyTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            apiKeySaveButton.topAnchor.constraint(equalTo: apiKeyTextField.bottomAnchor, constant: AppConstants.defaultPaggin),
            apiKeySaveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 7/10),
            apiKeySaveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    func setUpTutoralLayout() {
        view.addSubview(tutorialView)
        tutorialView.translatesAutoresizingMaskIntoConstraints = false
        tutorialView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            tutorialView.topAnchor.constraint(equalTo: apiKeySaveButton.bottomAnchor, constant: AppConstants.defaultPaggin),
            tutorialView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tutorialView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tutorialView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setUpBindings() {
        
        apiKeySaveButton.addTarget(self, action: #selector(apiKeySaveButtonTapped), for: .touchUpInside)
        
        apiKeyTextField.textPublisher
            .sink(receiveValue: { [weak self] text in
                if text.count == AppConstants.NASA.countOfApiKeySymbols {
                    self?.isEnterValidApiKey = true
                    
                } else {
                    self?.isEnterValidApiKey = false
                }
                self?.apiKeyTextLabel.text = (Prefs.shared.userAPIKey == AppConstants.NASA.defaultAPIKey) ? "\nYour personal API-key is: " : "You use DEMO API-key \nwith some restriction (see tutorial)"
                self?.apiKeySaveButton.setTitle(self!.isEnterValidApiKey ? "Save my new API-key" : "See tutorial for API-key", for: .normal)
                self?.apiKeySaveButton.backgroundColor = self!.isEnterValidApiKey ? .systemRed : .systemBlue

            })
            .store(in: &cancellables)
    }
    
    @objc func apiKeySaveButtonTapped() {
        if isEnterValidApiKey {
            print(#function, "Save API-key: ", apiKeyTextField.text!)
            Prefs.shared.userAPIKey = apiKeyTextField.text!
            apiKeyTextField.text = "Your API-key saved."
            apiKeySaveButton.setTitle("All done", for: .normal)
            apiKeySaveButton.isEnabled = false
            isEnterValidApiKey = false
        } else {
            print(#function, "Need to Show tutorial ", tutorialNubmer)
            if tutorialNubmer < 6 {
                let filename = "tutorial_0\(tutorialNubmer)"
                tutorialView.image = UIImage(named: filename)
                print(#function, "Show tutorial ", tutorialNubmer, filename)
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
