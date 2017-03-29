//
//  CLLocationExtensions.swift
//
//  Created by Jonathan Engelsma on 9/24/15.
//  Copyright (c) 2015 Jonathan Engelsma. All rights reserved.
//

import Foundation
import CoreLocation

/**
    Extends CLLocation in CoreLocation with some commonly used calculations.
*/
extension CLLocation {
    
    /**
        Compute bearing in degrees between two points (in radians).

        - parameter point: The point the bearing is being computed for.

        - returns: The computed bearing in degrees. 
    */
    func bearingToPoint(point:CLLocation) -> Double {
        let p1 = (self.coordinate.latitude, self.coordinate.longitude)
        let p2 = (point.coordinate.latitude, point.coordinate.longitude)
        let x = cos(p2.0) * sin(abs(p2.1 - p1.1))
        let y = cos(p1.0) * sin(p2.0) - sin(p1.0) * cos(p2.0) * cos(abs(p2.1 - p1.1))
        
        return atan2(x,y) * 180.0 / Double.pi
    }
    
    
    /**
        Compute a destination coordinate based on a start coordinate, bearing, and distance.

        - parameter withBearing: The bearing (in decimal).
        - parameter atDistance: The distance to be traveled (in kilometers).

        - returns: the destinataion coordinate.
    */
    func findingPoint(withBearing: Double, atDistance: Double) -> CLLocation
    {
        let R = 6371.0
        
        // compute the coordinates in radians
        let p1 = (self.coordinate.latitude * Double.pi / 180.0, self.coordinate.longitude * Double.pi / 180.0)
        
        // compute angular distance
        let ad = atDistance / R
        let lat : Double = asin(sin(p1.0) * cos(ad) + cos(p1.0) * sin(ad) * cos(withBearing))
        let lon : Double = p1.1 + atan2(sin(withBearing) * sin(ad) * cos(p1.0), cos(ad) - sin(p1.0) * sin(lat))
        
        // create the CLLocation by converting from radians to decimal.
        return CLLocation(latitude: lat * 180.0 / Double.pi, longitude: lon * 180.0 / Double.pi)
    }
}
