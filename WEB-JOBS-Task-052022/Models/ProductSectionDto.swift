//
//  ProductSectionDto.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 02/06/2022.
//

import Foundation

struct ProductSectionDto {
    let name: String
    let products: [ProductDto]
}

extension ProductSectionDto {
    static let samples: [ProductSectionDto] = {
        [
            ProductSectionDto(
                name: "Beers & Ciders",
                products: ProductDto.samples
            ),
            ProductSectionDto(
                name: "Section 2",
                products: ProductDto.samples
            ),
            ProductSectionDto(
                name: "Section 3",
                products: ProductDto.samples
            ),
        ]
    }()
}
