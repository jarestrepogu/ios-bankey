//
//  AppDelegate.swift
//  ios-bankey
//
//  Created by Jorge Andres Restrepo Gutierrez on 5/09/22.
//

import UIKit

let appColor: UIColor = .systemTeal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let loginVC = LoginViewController()
    let onboardingContainerVC = OnboardingContainerViewController()
    let mainVC = MainViewController()
    let accountVC = AccountSummaryViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginVC.delegate = self
        onboardingContainerVC.delegate = self
        
        registerForNotifications()
        
        displayLogin()
        return true
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: .logout, object: nil)
    }
    
    private func displayLogin() {
        setRootViewController(loginVC)
    }
    
    private func displayNextScreen() {
        if LocalState.hasOnboarded {
            prepMainView()
            setRootViewController(mainVC)
        } else {
            setRootViewController(onboardingContainerVC)
        }
    }
    
    private func prepMainView() {
        mainVC.setStatusBar()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = appColor
    }
}

extension AppDelegate {
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}

// MARK: - Actions
extension AppDelegate: LoginViewControllerDelegate {
    func didLogin() {
        displayNextScreen()
    }
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnBoarding() {
        LocalState.hasOnboarded = true
        prepMainView()
        setRootViewController(mainVC)
    }
}

extension AppDelegate: LogoutDelegate {
    @objc func didLogout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.setRootViewController(self.loginVC)
        }
    }
}
