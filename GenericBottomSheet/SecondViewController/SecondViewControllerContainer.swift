//
//  Container.swift
//  GenericBottomSheet
//
//  Created by Marwan Osama on 02/11/2021.
//

import Foundation

class SecondViewControllerContainer: BottomSheetContainerViewController<SecondViewController, SecondBottomSheetViewController> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
    }
    
}
