//
//  FilterVC.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 04/06/2022.
//

import UIKit

class FilterVC: BaseVC {
    
    // MARK: - Subviews
    
    @IBOutlet weak var priceRangeLabel: UILabel!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func onPriceRangeChanged(_ sender: RangeSlider) {
        let lowPrice = sender.lowValue
        let highPrice = sender.highValue
        
        priceRangeLabel.text = "$\(lowPrice) - $\(highPrice)"
    }
}
