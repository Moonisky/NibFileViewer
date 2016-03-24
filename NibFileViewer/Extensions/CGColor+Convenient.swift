//
//  CGColor+Convenient.swift
//  NibFileViewer
//
//  Created by Semper_Idem on 16/3/24.
//  Copyright © 2016年 星夜暮晨. All rights reserved.
//

import CoreGraphics

public extension CGColor {
    
    /* Create a color in the color space `space' with color components
     (including alpha) specified by `components'. `space' may be any color
     space except a pattern color space. */
    
    public class func initialization(colorComponents color: CGFloat..., alphaComponents alpha: CGFloat, space: CGColorSpace? = nil, pattern: CGPattern?) -> CGColor? {
        return CGColorCreateWithPattern(space, pattern, color + [alpha])
    }
    
    /* Create a color in the "Generic" gray color space. */
    
    public class func initialization(gray gray: CGFloat, alpha: CGFloat) -> CGColor {
        return CGColorCreateGenericGray(gray, alpha)
    }
    
    /* Create a color in the "Generic" RGB color space. */
    
    public class func initialization(red red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> CGColor {
        return CGColorCreateGenericRGB(red, green, blue, alpha)
    }
    
    /* Create a color in the "Generic" CMYK color space. */
    
    public class func initialization(cyan cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat, alpha: CGFloat) -> CGColor {
        return CGColorCreateGenericCMYK(cyan, magenta, yellow, black, alpha)
    }
    
    /* Return a constant color. As `CGColorGetConstantColor' is not a "Copy" or
     "Create" function, it does not necessarily return a new reference each
     time it's called. As a consequence, you should not release the returned
     value. However, colors returned from `CGColorGetConstantColor' can be
     retained and released in a properly nested fashion, just like any other
     CF type. */
    
    public class func getConstantColor(colorName: CFString?) -> CGColor? {
        return CGColorGetConstantColor(colorName)
    }
    
    /* Create a copy of `color'. */
    public func copy() -> CGColor? {
        return CGColorCreateCopy(self)
    }
    
    /* Create a copy of `color' with alpha set to `alpha'. */
    public func copyWithAlpha(alpha: CGFloat) -> CGColor? {
        return CGColorCreateCopyWithAlpha(self, alpha)
    }
    
    /* Create a copy of `color' by matching existing color to destination color space. */
    
    @available(OSX 10.11, *)
    public func copyByMatchingToColorSpace(space: CGColorSpace?, intent: CGColorRenderingIntent, options: CFDictionary?) -> CGColor? {
        return CGColorCreateCopyByMatchingToColorSpace(space, intent, self, options)
    }
    
    /* Return the color components (including alpha) associated with `color'. */
    public var components: [CGFloat] {
        return unsafeBitCast(CGColorGetComponents(self), [CGFloat].self)
    }
    
    /* Return the alpha component associated with `color'. */
    public var alpha: CGFloat {
        return CGColorGetAlpha(self)
    }
    
    /* Return the color space associated with `color'. */
    public var colorSpace: CGColorSpace? {
        return CGColorGetColorSpace(self)
    }
    
    /* Return the pattern associated with `color', if it's a color in a pattern
     color space; NULL otherwise. */
    
    public var pattern: CGPattern? {
        return CGColorGetPattern(self)
    }
    
    /* Return the CFTypeID for CGColors. */
    public class var typeID: CFTypeID {
        return CGColorGetTypeID()
    }
}

extension CGColor: Equatable { }

/* Return true if `color1' is equal to `color2'; false otherwise. */
public func ==(lhs: CGColor, rhs: CGColor) -> Bool {
    return CGColorEqualToColor(lhs, rhs)
}

/* Colors in the "Generic" gray color space. */

/*** Names of colors for use with `CGColorGetConstantColor'. ***/

enum CGColorName {
    case White
    case Black
    case Clear
    
    var string: CFString {
        switch self {
        case .White: return kCGColorWhite
        case .Black: return kCGColorBlack
        case .Clear: return kCGColorClear
        }
    }
}