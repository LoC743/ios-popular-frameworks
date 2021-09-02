//
//  AuthViewController.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var authView: AuthView {
        return self.view as! AuthView
    }
    
    private let presenter: AuthViewOutput
    
    // MARK: - Lifecycle
    
    init(presenter: AuthViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = AuthView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideScreen),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showScreen),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        authView.disableSecurity()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authView.observeEmptyFields()
        
        self.authView.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        self.authView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        self.addTapGestureRecognizer()
    }
    
    @objc private func hideScreen() {
        authView.enableSecurity()
    }
    
    @objc private func showScreen() {
        authView.disableSecurity()
    }
    
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        authView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        authView.endEditing(true)
    }
    
    
    
    @objc private func signInButtonTapped() {
        let username: String = authView.usernameTextField.text ?? ""
        let password: String = authView.passwordTextField.text ?? ""
        
        guard username != "" && password != "" else {
            presenter.viewHaveEmptyFields()
            return
        }
        
        presenter.viewDidSignIn(username: username, password: password)
    }
    
    @objc private func signUpButtonTapped() {
        let username: String = authView.usernameTextField.text ?? ""
        let password: String = authView.passwordTextField.text ?? ""
        
        guard username != "" && password != "" else {
            presenter.viewHaveEmptyFields()
            return
        }
        
        presenter.viewDidSignUp(username: username, password: password)
    }
    
}

extension AuthViewController: AuthViewInput { }
