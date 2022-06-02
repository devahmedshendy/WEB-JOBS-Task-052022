//
//  ProductDto.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 02/06/2022.
//

import Foundation

struct ProductDto {
    let name: String
    let imageName: String
    let price: Int
    let discount: Int
    
    var hasDiscount: Bool {
        return discount != 0
    }
    
    var hasNoDiscount: Bool {
        return discount == 0
    }
    
    var discountString: String {
        return "\(discount)%"
    }
    
    var actualPriceString: String {
        return "$\(price)"
    }
    
    var discountedPriceString: String {
        return "$\(price - (price * discount/100))"
    }
}

extension ProductDto {
    static let samples: [ProductDto] = {
        [
            ProductDto(
                name: "VOSS Plus Silver",
                imageName: "img_drink1",
                price: 600,
                discount: 50
            ),
            ProductDto(
                name: "Lemon Cucumber",
                imageName: "img_drink2",
                price: 650,
                discount: 0
            ),
            ProductDto(
                name: "Tangerine Lemongrass Big Bottles 2L",
                imageName: "img_drink3",
                price: 300,
                discount: 0
            ),
            ProductDto(
                name: "Lime Mint",
                imageName: "img_drink4",
                price: 450,
                discount: 30
            ),
        ]
    }()
}
