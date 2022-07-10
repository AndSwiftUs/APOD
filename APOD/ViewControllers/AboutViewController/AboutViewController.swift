import UIKit
import SwiftUI

class AboutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppConstants.ViewControllers.AboutVC.bgColor
        title = AppConstants.ViewControllers.AboutVC.title
//        self.navigationController?.navigationBar.prefersLargeTitles = AppConstants.ViewControllers.AboutVC.largeTitles
        
        let hosingFile = UIHostingController(rootView: AboutSwiftUIView())
        addChild(hosingFile)
        hosingFile.view.frame = self.view.frame
        self.view.addSubview(hosingFile.view)
        hosingFile.didMove(toParent: self)
        
    }
}
