// Copyright (c) 2016 Chris Kau
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit

typealias interpolateFunctionType = (AnyObject) -> AnyObject

func interpolate(a: AnyObject, _ b: AnyObject) -> interpolateFunctionType {
    if a is UIColor {
        return interpolateRGB(a, b)
    } else if a is Array<Double> {
        return interpolateArray(a, b)
    } else {
        return interpolateDouble(a, b)
    }
}

func interpolateDouble(a: AnyObject, _ b: AnyObject) -> interpolateFunctionType {
    func interpolateDouble(t: AnyObject) -> AnyObject {
        let a_d = a as! Double
        let b_d = b as! Double
        let t_d = t as! Double
        return a_d * (1.0 - t_d) + b_d * t_d
    }
    return interpolateDouble
}

func interpolateRGB(a: AnyObject, _ b: AnyObject) -> interpolateFunctionType {
    func interpolateRGB(t: AnyObject) -> AnyObject {
        let a_d = a as! UIColor
        let b_d = b as! UIColor
        let t_d = t as! CGFloat

        var red_a: CGFloat = 0
        var green_a: CGFloat = 0
        var blue_a: CGFloat = 0
        var alpha_a: CGFloat = 0
        a_d.getRed(&red_a, green: &green_a, blue:&blue_a, alpha:&alpha_a)

        var red_b: CGFloat = 0
        var green_b: CGFloat = 0
        var blue_b: CGFloat = 0
        var alpha_b: CGFloat = 0
        b_d.getRed(&red_b, green: &green_b, blue:&blue_b, alpha:&alpha_b)

        let red = red_a * (1.0 - t_d) + red_b * t_d
        let green = green_a * (1.0 - t_d) + green_b * t_d
        let blue = blue_a * (1.0 - t_d) + blue_b * t_d
        let alpha = alpha_a * (1.0 - t_d) + alpha_b * t_d

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    return interpolateRGB
}

/*
 Returns an interpolator between the two arrays a and b. Internally, an array template is created that is the same length in b. For each element in b, if there exists a corresponding element in a, a generic interpolator is created for the two elements using interpolate. If there is no such element, the static value from b is used in the template. Then, for the given parameter t, the template’s embedded interpolators are evaluated. The updated array template is then returned.
 */
func interpolateArray(a: AnyObject, _ b: AnyObject) -> InterpolateFunctionType {
    func interpolateArray(t: AnyObject) -> AnyObject {
        var ary = [Double]()
        
        let a_ary = a as! Array<Double>
        let b_ary = b as! Array<Double>
        let t_d = t as! Double
        
        for var i = 0; i < b_ary.count; i++ {
            var a_d = 0.0
            if i >= a_ary.count {
                a_d = b_ary[i]
            } else {
                a_d = a_ary[i]
            }
            let b_d = b_ary[i]
            let x = a_d * (1.0 - t_d) + b_d * t_d
            ary.append(x)
        }
        
        return ary
    }
    return interpolateArray
}
