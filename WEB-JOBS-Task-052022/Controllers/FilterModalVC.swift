//
//  FilterModalVC.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 04/06/2022.
//

import UIKit

class FilterModalVC: BaseVC {
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDismiss)))
    }
    
    @objc private func onDismiss() {
        dismiss(animated: true)
    }
}
