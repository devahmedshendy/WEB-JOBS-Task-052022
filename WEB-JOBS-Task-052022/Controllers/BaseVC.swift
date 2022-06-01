//
//  BaseVC.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 31/05/2022.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Helpers
    
    func setupTapGestureToDimissKeyboard() {
        setupTapGestureToDimissKeyboard(onView: view)
    }
    
    func setupTapGestureToDimissKeyboard(onView view: UIView) {
        let tapGesture = UITapGestureRecognizer(
            target: self.view,
            action: #selector(UIView.endEditing(_:))
        )
        
        tapGesture.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tapGesture)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
