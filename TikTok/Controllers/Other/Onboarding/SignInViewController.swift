//
//  SignInViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import SafariServices
import UIKit

class SignInViewController: UIViewController {
    
    // For user auth, this variable takes nothing and returns nothing
    public var completion: (() -> Void)?
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
    
    private let signInButton = AuthButton(type: .signIn, title: nil)
    private let signUpButton = AuthButton(type: .signUp, title: "Create Account")
    private let forgotPasswordButton = AuthButton(type: .plain, title: "Forgot Password")

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        
        addSubviews()
        configureField()
        configureButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // add frames
        addFrames()
        
    }
    
    // MARK: - Methods
    
    private func addSubviews() {
        
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(forgotPasswordButton)
    }
    
    private func configureField() {
        emailField.delegate = self
        passwordField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTouchKeyboardDone))
        ]
        
        toolBar.sizeToFit()
        emailField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
    }
    
    private func configureButton() {
        signInButton.addTarget(self,
                               action: #selector(didTouchSignIn),
                               for: .touchUpInside)
        
        signUpButton.addTarget(self,
                               action: #selector(didTouchSignUp),
                               for: .touchUpInside)
        
        forgotPasswordButton.addTarget(self,
                               action: #selector(didTouchForgotPassword),
                               for: .touchUpInside)
    }
    
    private func addFrames() {
        let imageSize = view.width / 2
        
        logoImageView.frame = CGRect(
            x: (view.width-imageSize)/2,
            y: view.safeAreaInsets.top + 5,
            width: imageSize,
            height: imageSize
        )
        
        emailField.frame = CGRect(
            x: 20,
            y: logoImageView.bottom + 20,
            width: view.width - 40,
            height: 50
        )
        
        passwordField.frame = CGRect(
            x: 20,
            y: emailField.bottom + 10,
            width: view.width - 40,
            height: 50
        )
        
        signInButton.frame = CGRect(
            x: 20,
            y: passwordField.bottom + 10,
            width: view.width - 40,
            height: 50
        )
        
        signUpButton.frame = CGRect(
            x: 20,
            y: signInButton.bottom + 10,
            width: view.width - 40,
            height: 50
        )
        
        forgotPasswordButton.frame = CGRect(
            x: 20,
            y: signUpButton.bottom + 10,
            width: view.width - 40,
            height: 50
        )
    }
    
    // MARK: - @objc Methods
    
    @objc private func didTouchSignIn() {
        didTouchKeyboardDone()
        
        guard let email = emailField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty,
           let password = passwordField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty, password.count >= 6
        else {
            let alert = UIAlertController(title: "Error", message: "Please check email and password field", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        AuthManager.shared.SignIn(with: .email, email: email, password: password) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let email):
                    self?.dismiss(animated: true, completion: nil)
                    print(email)
                    // success
                break
                case . failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Sign In Error", message: "Please check email and password field again", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self?.present(alert, animated: true, completion: nil)
                    self?.passwordField.text = nil
                }
            }
            
        }
    }
    
    @objc private func didTouchSignUp() {
        didTouchKeyboardDone()
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func didTouchForgotPassword() {
        didTouchKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com/") else { return }
        
        // on the safariVC, you can't push but present on it
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTouchKeyboardDone() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }

}

// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTouchSignIn()
        }
        return true
    }
}
