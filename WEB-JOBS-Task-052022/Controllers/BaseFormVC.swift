//
//  BaseFormVC.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 01/06/2022.
//

import UIKit

class BaseScrollableFormVC: BaseVC {
    
    // MARK: - Subviews
    
    lazy var scrollView: UIScrollView! = {
        return view.subviews.first(where: { $0 is UIScrollView }) as! UIScrollView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTapGestureToDimissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observeKeyboardShowHideNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopObservingKeyboardShowHideNotification()
    }
    
    // MARK: - Keyboard Notification Methods
    
    private func observeKeyboardShowHideNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func stopObservingKeyboardShowHideNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func onKeyboardWillShow(_ notification: NSNotification) {
        guard let info = notification.userInfo,
              let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 20, right: 0)
        
        updateScrollViewInsets(insets)
    }
    
    @objc private func onKeyboardWillHide(_ notification: NSNotification) {
        updateScrollViewInsets(.zero)
    }
    
    private func updateScrollViewInsets(_ insets: UIEdgeInsets) {
        UIView.animate(withDuration: 0.1) {
            self.scrollView.contentInset = insets
            self.scrollView.scrollIndicatorInsets = insets
        }
    }
}
