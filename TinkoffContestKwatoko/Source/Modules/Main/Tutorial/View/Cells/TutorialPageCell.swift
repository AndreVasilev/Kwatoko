//
//  TutorialPageCell.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 22.05.2022.
//

import UIKit

class TutorialPageCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(model: TutorialPage) {
        textLabel.text = model.text
        if let name = model.imageName {
            imageView.image = UIImage(named: name)
        } else {
            imageView.image = nil
        }
    }
}
