//
//  HomeVC.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 02/06/2022.
//

import UIKit

enum ProductsLayoutMode {
    case onePerRow
    case twoPerRow
}

class HomeVC: BaseVC {
    
    // MARK: - Properties
    
    private var sections: [ProductSectionDto] = ProductSectionDto.samples
    private var mode: ProductsLayoutMode = .twoPerRow {
        didSet {
            switch mode {
            case .onePerRow:
//                applyOnePerRowLayout()
                break
            case .twoPerRow:
//                applyTwoRowLayout()
                productsCollection.setCollectionViewLayout(
                    createTwoPerRowLayout(),
                    animated: true
                )
                break
            }
        }
    }
    
    // MARK: - Subviews
    
    @IBOutlet weak var productsCollection: UICollectionView!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupProductsCollection()
    }
    
    @IBAction func applyTwoPerRowLayout(_ sender: UIButton) {
        productsCollection.setCollectionViewLayout(
            createTwoPerRowLayout(),
            animated: true
        )
    }
    
    @IBAction func applyOnePerRowLayout(_ sender: UIButton) {
        productsCollection.setCollectionViewLayout(
            createOnePerRowLayout(),
            animated: true
        )
    }
    
    // MARK: - Subviews

    private func setupProductsCollection() {
        productsCollection.register(
            ProductsSectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProductsSectionView.reuseIdentifier
        )
        
        productsCollection.collectionViewLayout = createTwoPerRowLayout()
    }
    
    // MARK: - Products Layouts
    
    private func createOnePerRowLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
                
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(425)
            ),
            subitem: item, count: 1
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 25,
            bottom: 0,
            trailing: 25
        )
                
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 25
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 25,
            leading: 0,
            bottom: 25,
            trailing: 0
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createTwoPerRowLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
                
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(330)
            ),
            subitem: item, count: 2
        )
        group.interItemSpacing = .fixed(25)
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 25,
            bottom: 0,
            trailing: 25
        )
                
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 25
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 25,
            leading: 0,
            bottom: 25,
            trailing: 0
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}

// MARK: - UICollectionViewDataSource

extension HomeVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
//        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductsSectionView.reuseIdentifier, for: indexPath) as! ProductsSectionView
        
        view.name = sections[indexPath.section].name
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwoRowProductCell.reuseIdentifier, for: indexPath) as! TwoRowProductCell
        
        let product = sections[indexPath.section].products[indexPath.item]
        
        cell.dto = product
        
        return cell
    }
    
}
