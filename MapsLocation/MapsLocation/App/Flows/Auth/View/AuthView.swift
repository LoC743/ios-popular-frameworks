//
//  AuthView.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import SnapKit
import RxSwift
import RxCocoa

final class AuthView: UIView {
    
    // MARK: - Subviews
    
    lazy var usernameTextField = UITextField()
    lazy var passwordTextField = UITextField()
    
    lazy var buttonsStackView = UIStackView()
    lazy var signInButton = UIButton(type: .system)
    lazy var signUpButton = UIButton(type: .system)
    
    lazy var securityView = UIView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - Constants
    
    enum Constants {
        static let safeArea = UIApplication.shared.windows[0].safeAreaInsets
        
        static let usernameTextFieldTopOffset = safeArea.top + 25
        static let textFieldSideOffset = 25
        static let passwordTextFiledTopOffset = 25
        static let buttonsTopOffset = 25
        static let buttonsSideOffset = 25
        static let buttonsHeight: CGFloat = 55.0
        static let buttonsSpacing: CGFloat = 15.0
        static let minimumUsernameLength = 3
        static let minimumPasswordLength = 7
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addUsernameTextField()
        self.addPasswordTextField()
        self.addButtonsStackView()
        self.addSecurityView()
    }

    private func addUsernameTextField() {
        self.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(self).offset(Constants.usernameTextFieldTopOffset)
            make.left.equalTo(self).offset(Constants.textFieldSideOffset)
            make.right.equalTo(self).offset(-Constants.textFieldSideOffset)
        }
        
        usernameTextField.placeholder = StringResources.usernameLabelPlaceholder
        usernameTextField.autocorrectionType = .no
        usernameTextField.borderStyle = .roundedRect
    }
    
    private func addPasswordTextField() {
        self.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(Constants.passwordTextFiledTopOffset)
            make.left.equalTo(self).offset(Constants.textFieldSideOffset)
            make.right.equalTo(self).offset(-Constants.textFieldSideOffset)
        }
        
        passwordTextField.placeholder = StringResources.passwordLabelPlaceholder
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocorrectionType = .no
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
    }

    private func addButtonsStackView() {
        self.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constants.buttonsTopOffset)
            make.left.equalTo(self).offset(Constants.textFieldSideOffset)
            make.right.equalTo(self).offset(-Constants.textFieldSideOffset)
            make.height.equalTo(Constants.buttonsHeight)
        }
        
        buttonsStackView.addArrangedSubview(signUpButton)
        buttonsStackView.addArrangedSubview(signInButton)
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = Constants.buttonsSpacing
        
        signUpButton.setTitle(StringResources.signUpButtonTitle, for: .normal)
        signInButton.setTitle(StringResources.signInButtonTitle, for: .normal)
        
        [signUpButton, signInButton].forEach { button in
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = Constants.buttonsHeight / 2
            button.setTitleColor(.white, for: .normal)
        }
    }
    
    private func addSecurityView() {
        addSubview(securityView)
        
        // Setup blur effect
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        securityView.addSubview(blurEffectView)
        
        securityView.isHidden = true
        
        securityView.snp.makeConstraints { make in
            make.bottom.top.left.right.equalTo(self)
        }
    }
    
    public func enableSecurity() {
        securityView.isHidden = false
    }
    
    public func disableSecurity() {
        securityView.isHidden = true
    }
    
    public func observeEmptyFields() {
        
        Observable.combineLatest(
            usernameTextField.rx.text,
            passwordTextField.rx.text
        )
        .map { (username, password) -> Bool in
            if let username = username,
               let password = password {
                return username.count >= Constants.minimumUsernameLength
                    && password.count >= Constants.minimumPasswordLength
            }
            return false
        }
        .subscribe(onNext: { [weak self] isValid in
            
            [self?.signInButton, self?.signUpButton].forEach { button in
                button?.isEnabled = isValid
                
                if isValid {
                    button?.alpha = 1.0
                } else {
                    button?.alpha = 0.5
                }
            }
        })
        .disposed(by: disposeBag)
    }
}
