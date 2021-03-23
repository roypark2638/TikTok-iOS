//
//  SignUpViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit
import SafariServices

class SignUpViewController: UIViewController {

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
    private let usernameField = AuthField(type: .username)
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
        
    private let signUpButton = AuthButton(type: .signUp, title: nil)
    private let TermsOfService = AuthButton(type: .plain, title: "Terms of Service")

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        
        addSubviews()
        configureField()
        configureButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // add frames
        setUpLayout()
        
    }
    
    // MARK: - Methods
    
    private func addSubviews() {
        
        view.addSubview(logoImageView)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(TermsOfService)
    }
    
    private func configureField() {
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTouchKeyboardDone))
        ]
        
        toolBar.sizeToFit()
        usernameField.inputAccessoryView = toolBar
        emailField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
    }
    
    private func configureButton() {
        
        signUpButton.addTarget(self,
                               action: #selector(didTouchSignUp),
                               for: .touchUpInside)
        
        TermsOfService.addTarget(self,
                               action: #selector(didTouchTermsOfService),
                               for: .touchUpInside)
    }
    
    private func setUpLayout() {
        let imageSize = view.width / 2
        
        logoImageView.frame = CGRect(
            x: (view.width-imageSize)/2,
            y: view.safeAreaInsets.top + 5,
            width: imageSize,
            height: imageSize
        )
        
        usernameField.frame = CGRect(
            x: 20,
            y: logoImageView.bottom + 20,
            width: view.width - 40,
            height: 50
        )
        
        emailField.frame = CGRect(
            x: 20,
            y: usernameField.bottom + 10,
            width: view.width - 40,
            height: 50
        )
        
        passwordField.frame = CGRect(
            x: 20,
            y: emailField.bottom + 10,
            width: view.width - 40,
            height: 50
        )
        
        signUpButton.frame = CGRect(
            x: 20,
            y: passwordField.bottom + 10,
            width: view.width - 40,
            height: 50
        )
        
        TermsOfService.frame = CGRect(
            x: 20,
            y: signUpButton.bottom + 10,
            width: view.width - 40,
            height: 50
        )
    }
    
    // MARK: - @objc Methods
    
    @objc private func didTouchSignUp() {
        didTouchKeyboardDone()
        
        guard let username = usernameField.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !username.contains(" "),
              !username.contains("."),
              let email = emailField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              let password = passwordField.text,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6
        else {
            let alert = UIAlertController(title: "Error Message",
                                          message: "Please check if it's valid username, email, and password.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        AuthManager.shared.SignUp(with: username, email: email, password: password) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result  {
                case .success:
                    self?.dismiss(animated: true, completion: nil)
                    print("signed up")
                
                case .failure(let error):
                    print(error)
                    
                    let alert = UIAlertController(title: "Error Message",
                                                  message: "Something went wrong, Please check username, email, and password again.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @objc private func didTouchTermsOfService() {
        didTouchKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com/") else { return }
        
        // on the safariVC, you can't push but present on it
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTouchKeyboardDone() {
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }

}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTouchSignUp()
        }
        return true
    }
}
