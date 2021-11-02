//
//  FirstViewController.swift
//  GenericBottomSheet
//
//  Created by Marwan Osama on 02/11/2021.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func navigateTapped(_ sender: UIButton) {
        guard let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else { return }
        let container = SecondViewControllerContainer(contentViewController: secondVC,
                                                      bottomSheetViewController: SecondBottomSheetViewController(),
                                                      configuration: .init(height: UIScreen.main.bounds.height * 0.7, initialOffset: 100))
        navigationController?.pushViewController(container, animated: true)
    }
    

}

