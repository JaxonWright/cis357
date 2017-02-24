//
//  GeoCalcButton.swift
//  HaversineCalculator
//
//  Created by Jaxon on 2/24/17.
//  Copyright © 2017 KJAX. All rights reserved.
//

import UIKit

class GeoCalcButton: UIButton {

    override func awakeFromNib(){
        self.backgroundColor = FOREGROUND_COLOR
        self.tintColor = BACKGROUND_COLOR
        self.layer.cornerRadius = 5.0
    }
}
