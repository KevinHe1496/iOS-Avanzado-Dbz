//
//  HeroDetailCell.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 26/10/24.
//

import UIKit

class HeroDetailCell: UICollectionViewCell {
    
    static var identifier: String{
        String(describing: HeroDetailCell.self)
    }
    
    @IBOutlet weak var transformationImageView: UIImageView!
    
    @IBOutlet weak var transformationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
