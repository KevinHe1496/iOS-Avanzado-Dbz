//
//  HeroCollectionViewCell.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 22/10/24.
//

import UIKit

final class HeroCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Identifier
    static let identifier = String(describing: HeroCollectionViewCell.self)
    
    //MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stackView.backgroundColor = .systemOrange
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true 

        
    }
    

}
