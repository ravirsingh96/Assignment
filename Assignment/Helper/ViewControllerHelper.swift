//
//  ViewControllerHelper.swift


import UIKit

final class ViewControllerHelper {
    
    enum ViewControllerName: String {
        case imageVC = "ImageListVC"
        case signinVC = "SignInVC"
        case profileVC = "ProfileVC"
        
        
        func getStoryBoard() -> StoryBoardName {
            switch self {
            case .imageVC, .signinVC, .profileVC:
                return .main
                
            }
            
        }
        
    }
    
    enum StoryBoardName: String {
        case main = "Main"
    }
    
    class func getObjectOf<T: UIViewController>(of name: ViewControllerName, of type: T.Type = UIViewController.self as! T.Type ) -> T {
        
        let storyBoard = UIStoryboard.init(name: name.getStoryBoard().rawValue, bundle: nil)
        
        guard let vc = storyBoard.instantiateViewController(identifier: name.rawValue) as? T else {
            fatalError("Failed to create ViewController from storyboard")
        }
        return vc
        
    }
    
    class func setupInitialViewController() {
        
        let contentVC = ViewControllerHelper.getObjectOf(of: .signinVC)
        let contentNC = UINavigationController(rootViewController: contentVC)
        contentNC.setNavigationBarHidden(true, animated: true)
        keyWindow?.rootViewController = contentNC
    }
}
