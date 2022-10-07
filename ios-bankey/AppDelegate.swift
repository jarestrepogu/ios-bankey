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
    let dummyVC = DummyViewController()
    let mainVC = MainViewController()
    let accountVC = AccountSummaryViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginVC.delegate = self
        onboardingContainerVC.delegate = self
        dummyVC.logoutDelegate = self
        
//        window?.rootViewController = mainVC
        window?.rootViewController = accountVC
        mainVC.selectedIndex = 1
        return true
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
        LocalState.hasOnboarded ? setRootViewController(dummyVC) : setRootViewController(onboardingContainerVC)
    }
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnBoarding() {
        LocalState.hasOnboarded = true
        setRootViewController(dummyVC)
    }
}

extension AppDelegate: LogoutDelegate {
    func didLogout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.setRootViewController(self.loginVC)
        }
    }
}
