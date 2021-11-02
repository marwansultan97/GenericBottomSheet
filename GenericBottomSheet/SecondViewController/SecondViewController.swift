//
//  SecondViewController.swift
//  GenericBottomSheet
//
//  Created by Marwan Osama on 02/11/2021.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func expandTapped(_ sender: UIButton) {
        guard let parent = self.parent as? SecondViewControllerContainer else {
            print("Invalid Parent") ; return
        }
        parent.expandSheet()
    }
    
    
    @IBAction func collapseTapped(_ sender: UIButton) {
        guard let parent = self.parent as? SecondViewControllerContainer else {
            print("Invalid Parent") ; return
        }
        parent.collapseSheet()
    }
    
}
