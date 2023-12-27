import UIKit

final class LoginContainerViewController: UIViewController {
    
    // MARK: - Properties
    
    private weak var delegate: LoginViewDelegate?
    
    // MARK: - Lifecycle

    init(delegate: LoginViewDelegate?) {
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Helpers
    
    private func addChildViewController() {
        add(LoginViewController(delegate: delegate), frame: view.frame)
        
//        if #available(iOS 13, *) {
//            let loginView = LoginViewSUI(delegate: delegate)
//            add(UIHostingController<LoginViewSUI>(rootView: loginView), frame: view.frame)
//        } else {
//            add(LoginViewController(delegate: delegate), frame: view.frame)
//        }
    }
}
