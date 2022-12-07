//
//  CustomSegmentControl.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 23.11.2021.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl{
    private let segmentInset: CGFloat = 5
    private var colors = [Theme.Colors.lightBlue, Theme.Colors.mainRed]
    
    override func layoutSubviews(){
        super.layoutSubviews()
        //background
        layer.cornerRadius = bounds.height / 2
        //foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = UIImage(color: colors[selectedSegmentIndex])  //substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    //this removes the weird scaling animation!
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height / 2
        }
    }
}
