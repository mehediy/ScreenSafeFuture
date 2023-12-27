import UIKit
import FirebaseAnalytics

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel
    private let dataManager: LoginDataManager
    private weak var delegate: LoginViewDelegate?
    private let configurator: LoginViewControllerConfigurator = .init()
    
    lazy var scrollView: UIScrollView = .init()
    lazy var imageView: UIImageView = .init()
    lazy var contentStackView: UIStackView = .init()
    lazy var titleLabel: UILabel = .init()
    lazy var formStackView: UIStackView = .init()
    lazy var actionButton: UIButton = .init()
    
    var errorAlertView: ErrorAlertView?
    var errorAlertViewTopConstraint: NSLayoutConstraint?
    var errorAlertViewBottomConstraint: NSLayoutConstraint?
    
    private lazy var stateMachine: LoginViewControllerStateMachine = {
        .init(controller: self)
    }()
    
    lazy var emailTextEntryView: LoginTextEntryView = {
        .init(viewModel: viewModel.emailTextEntryModel)
    }()
    
    lazy var passwordTextEntryView: LoginTextEntryView = {
        .init(viewModel: viewModel.passwordTextEntryModel)
    }()
    
    lazy var viewTapGestureRecognizer: UITapGestureRecognizer = {
        .init(target: view, action: #selector(UIView.endEditing(_:)))
    }()
    
    let accountButtonView = with(AccountButtonView()) {
        $0.translatesAutoresizingMaskIntoConstraints = true
    }
    
    // MARK: - Lifecycle

    init(viewModel: LoginViewModel = LoginViewModelFactory.create(),
         dataManager: LoginDataManager = .init(),
         delegate: LoginViewDelegate?) {
        
        self.viewModel = viewModel
        self.dataManager = dataManager
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configureViews(for: self, viewModel: viewModel)
        stateMachine.setup()
        
        setupView()
        setupLayout()
    }
    
    //MARK: Helpers
    
    private func setupView() {
        view.backgroundColor = UIColor.white
        
        self.contentStackView.addArrangedSubview(accountButtonView)
        //view.addSubview(accountButtonView)

        accountButtonView.accountButton.addTarget(self, action: #selector(accountButtonTapped), for: .touchUpInside)

    }
    
    private func setupLayout() {
        
        //accountButtonView.topAnchor == view.bottomAnchor + 34.0.dynamic
//        accountButtonView.horizontalAnchors >= view.horizontalAnchors + 16.0.dynamic
//        accountButtonView.centerXAnchor == view.centerXAnchor
//        accountButtonView.bottomAnchor == view.bottomAnchor - 44.dynamic
    }

    // MARK: - Functions
    
    @objc func actionButtonTapped() {
        
        Analytics.logEvent("login_button_tapped", parameters: nil)
        guard errorAlertView == nil else { return }
        
        guard let email = emailTextEntryView.textField.text,
            let password = passwordTextEntryView.textField.text
            else { return }

        dataManager.createLogin(email: email, password: password) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let login):
                self.delegate?.didLogin(login)
                Analytics.logEvent("login_success", parameters: nil)
            case .failure(let error):
                self.configurator.configureErrorAlertView(for: self, message: error.localizedDescription)
                self.stateMachine.showErrorAlertView()
                Analytics.logEvent("login_failure", parameters: ["value": error.localizedDescription])
            }
        }
    }
    
    
    @objc func accountButtonTapped() {

        Analytics.logEvent("create_account_button_tapped", parameters: nil)
        guard errorAlertView == nil else { return }
        
        guard let email = emailTextEntryView.textField.text,
            let password = passwordTextEntryView.textField.text
            else { return }

        dataManager.createAccount(email: email, password: password) { [weak self] (result) in
            guard let self = self else { return }
            print(result)
            
            switch result {
            case .success(let login):
                Analytics.logEvent("create_account_success", parameters: nil)
                print("create_account_success")
                self.showAlert(message: "Your account has been successfully created!", withTitle: "Success", buttonTitle: "Continue") { [weak self] action in
                    if action.title == "Continue" {
                        self?.delegate?.didLogin(login)
                    }
                }
                
            case .failure(let error):
                self.configurator.configureErrorAlertView(for: self, message: error.localizedDescription)
                self.stateMachine.showErrorAlertView()
                Analytics.logEvent("create_account_failure", parameters: ["value": error.localizedDescription])
                print("create_account_failure")
            }
        }
    }

    
}
