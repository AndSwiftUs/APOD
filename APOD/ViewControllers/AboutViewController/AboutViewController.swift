import UIKit
import SwiftUI

class AboutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppConstants.ViewControllers.AboutVC.bgColor
        title = AppConstants.ViewControllers.AboutVC.title
        
        let hosingFile = UIHostingController(rootView: AboutSwiftUIView())
        
        addChild(hosingFile)
        
        hosingFile.view.frame = self.view.bounds
        
        self.view.addSubview(hosingFile.view)
        view.addConstrained(subview: hosingFile.view)
        hosingFile.didMove(toParent: self)
        
    }
}

extension UIView {
    func addConstrained(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
