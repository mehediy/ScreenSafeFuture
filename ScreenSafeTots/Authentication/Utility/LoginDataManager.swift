import Foundation
import FirebaseAuth

final class LoginDataManager {
    
    // MARK: - Properties
    
    private let validator: LoginValidator
    
    // MARK: - Lifecycle
    
    init(validator: LoginValidator = .init()) {
        self.validator = validator
    }
    
    // MARK: - Functions
    
    func createLogin(email: String, password: String, completion: @escaping (Result<UserLogin, Error>) -> Void) {
        let error: Error? = validateLogin(email: email, password: password)
        
        if let error = error {
            completion(.failure(error))
        } else {
            
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                
                if let error = error {
                    completion(.failure(error))
                } else {
                    
                    let user = result!.user
                    let userLogin = UserLogin(user: user, email: email)
                    completion(.success(userLogin))
                }
                
            }
            
        }
    }
    
    
    func createAccount(email: String, password: String, completion: @escaping (Result<UserLogin, Error>) -> Void) {
        let error: Error? = validateLogin(email: email, password: password)
        
        if let error = error {
            completion(.failure(error))
        } else {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let error = error {
                    completion(.failure(error))
                } else {
                    
                    let user = authResult!.user
                    let userLogin = UserLogin(user: user, email: email)
                    completion(.success(userLogin))
                    
                    
                    //self.delegate?.loginDidOccur()
                    //let userLogin = UserLogin(email: email, password: password)
                    //completion(.success(userLogin))
                }
            }
        }
    }
    
    // MARK: Private
    
    private func validateLogin(email: String, password: String) -> LoginError? {
        let isValidEmail = validator.validate(email: email)
        let isValidPassword = validator.validate(password: password)
        
        if !isValidEmail && !isValidPassword {
            return .invalidEmailAndPassword
        } else if !isValidEmail {
            return .invalidEmail
        } else if !isValidPassword {
            return .invalidPassword
        } else {
            return nil
        }
    }
    
}
