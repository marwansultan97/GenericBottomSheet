//
//  SecondBottomSheetViewController.swift
//  GenericBottomSheet
//
//  Created by Marwan Osama on 02/11/2021.
//

import UIKit

class SecondBottomSheetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .orange
        self.view.layer.cornerRadius = 30
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    

}
