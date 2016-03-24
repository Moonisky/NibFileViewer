//
//  CGContext+Convenient.swift
//  NibFileViewer
//
//  Created by Semper_Idem on 16/3/23.
//  Copyright © 2016年 星夜暮晨. All rights reserved.
//

import CoreGraphics
import Foundation

private var lineWidthAssociationKey: UInt8 = 0
private var lineCapAssociationKey: UInt8 = 0
private var lineJoinAssociationKey: UInt8 = 0
private var miterLimitAssociationKey: UInt8 = 0
private var flatnessAssociationKey: UInt8 = 0
private var alphaAssociationKey: UInt8 = 0
private var blendModeAssociationKey: UInt8 = 0
private var fillColorAssociationKey: UInt8 = 0
private var strokeColorAssociationKey: UInt8 = 0
private var fillColorSpaceAssociationKey: UInt8 = 0
private var strokeColorSpaceAssociationKey: UInt8 = 0

public extension CGContext {
    
    /// Return the CFTypeID for CGContextRefs.
    public class var typeID: CFTypeID {
        return CGContextGetTypeID()
    }
    
    // MARK: Graphics state methods
    
    /* Push a copy of the current graphics state onto the graphics state stack.
     Note that the path is not considered part of the graphics state, and is
     not saved. */

    public func saveGraphicsState() {
        CGContextSaveGState(self)
    }
    
    /* Restore the current graphics state from the one on the top of the
     graphics state stack, popping the graphics state stack in the process. */

    public func restoreGraphicsState() {
        CGContextRestoreGState(self)
    }
    
    // MARK: Coordinate space transformations
    
    /* Scale the current graphics state's transformation matrix (the CTM) by
     `(sx, sy)`. */

    public func scaleCTM(sx sx: CGFloat, sy: CGFloat) {
        CGContextScaleCTM(self, sx, sy)
    }
    
    /* Scale the current graphics state's transformation matrix (the CTM) by
     `(sx, sy)`. */

    public func scaleCTM(point: CGPoint) {
        scaleCTM(sx: point.x, sy: point.y)
    }
    
    /* Translate the current graphics state's transformation matrix (the CTM) by
     `(tx, ty)'. */

    public func translateCTM(tx tx: CGFloat, ty: CGFloat) {
        CGContextTranslateCTM(self, tx, ty)
    }
    
    /* Translate the current graphics state's transformation matrix (the CTM) by
     `(tx, ty)'. */

    public func translateCTM(point: CGPoint) {
        translateCTM(tx: point.x, ty: point.y)
    }
    
    /* Rotate the current graphics state's transformation matrix (the CTM) by
     `angle' radians. */

    public func rotateCTM(angle angle: CGFloat) {
        CGContextRotateCTM(self, angle)
    }
    
    /* Concatenate the current graphics state's transformation matrix (the CTM)
     with the affine transform `transform'. */
    public func concatCTM(transform transform: CGAffineTransform) {
        CGContextConcatCTM(self, transform)
    }
    
    /* Return the current graphics state's transformation matrix. Returns
     CGAffineTransformIdentity in case of inavlid context. */
    
    public var currentTransformationMatrix: CGAffineTransform {
        return CGContextGetCTM(self)
    }
    
    // MARK: Drawing attribute functions
    
    /* The line width in the current graphics state to `width'. 
        So you can use `context.lineWidth = 4`
     */
    
    public var lineWidth: CGFloat {
        get {
            return objc_getAssociatedObject(self, &lineWidthAssociationKey) as? CGFloat ?? 1
        }
        set {
            CGContextSetLineWidth(self, newValue)
            objc_setAssociatedObject(self, &lineWidthAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /* Set the line cap in the current graphics state to `cap'. */
    
    public var lineCap: CGLineCap {
        get {
            guard let value = objc_getAssociatedObject(self, &lineCapAssociationKey) as? NSNumber else { return .Butt }
            return CGLineCap(rawValue: value.intValue) ?? .Butt
        }
        set {
            CGContextSetLineCap(self, newValue)
            objc_setAssociatedObject(self, &lineCapAssociationKey, NSNumber(int: newValue.rawValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /* Set the line join in the current graphics state to `join'. */
    
    public var lineJoin: CGLineJoin {
        get {
            guard let value = objc_getAssociatedObject(self, &lineJoinAssociationKey) as? NSNumber else { return .Miter }
            return CGLineJoin(rawValue: value.intValue) ?? .Miter
        }
        set {
            CGContextSetLineJoin(self, newValue)
            objc_setAssociatedObject(self, &lineJoinAssociationKey, NSNumber(int: newValue.rawValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /* Set the miter limit in the current graphics state to `limit'. */
    
    public var miterLimit: CGFloat {
        get {
            return objc_getAssociatedObject(self, &miterLimitAssociationKey) as? CGFloat ?? 0
        }
        set {
            CGContextSetMiterLimit(self, newValue)
            objc_setAssociatedObject(self, &miterLimitAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /* Set the line dash patttern in the current graphics state of `c'. */
    
    public func setLineDash(phase phase: CGFloat, lengths: CGFloat...) {
        CGContextSetLineDash(self, phase, lengths, lengths.count)
    }
    
    /* Set the path flatness parameter in the current graphics state of `c' to
     `flatness'. */
    
    public var flatness: CGFloat {
        get {
            return objc_getAssociatedObject(self, &flatnessAssociationKey) as? CGFloat ?? 0
        }
        set {
            CGContextSetFlatness(self, newValue)
            objc_setAssociatedObject(self, &flatnessAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /* Set the alpha value in the current graphics state of `c' to `alpha'. */
    
    public var alpha: CGFloat {
        get {
            return objc_getAssociatedObject(self, &alphaAssociationKey) as? CGFloat ?? 1
        }
        set {
            CGContextSetAlpha(self, newValue)
            objc_setAssociatedObject(self, &alphaAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /* Set the blend mode of `context' to `mode'. */
    
    public var blendMode: CGBlendMode {
        get {
            guard let value = objc_getAssociatedObject(self, &blendModeAssociationKey) as? NSNumber else { return .Normal }
            return CGBlendMode(rawValue: value.intValue) ?? .Normal
        }
        set {
            CGContextSetBlendMode(self, newValue)
            objc_setAssociatedObject(self, &blendModeAssociationKey, NSNumber(int: newValue.rawValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: Path construction methods
    
    /* Note that a context has a single path in use at any time: a path is not
     part of the graphics state. */
    
    /* Begin a new path. The old path is discarded. */
    
    typealias PathConstructionClosure = CGContext -> ()
    
    public func drawPaths(closure: PathConstructionClosure) {
        CGContextBeginPath(self)
        closure(self)
        CGContextClosePath(self)
    }
    
    /* Start a new subpath at point `(x, y)' in the context's path. */
    
    public func moveToPoint(point: CGPoint) {
        CGContextMoveToPoint(self, point.x, point.y)
    }
    
    /* Append a straight line segment from the current point to `(x, y)'. */
    
    public func addLineToPoint(point: CGPoint) {
        CGContextAddLineToPoint(self, point.x, point.y)
    }
    
    /* Append a cubic Bezier curve from the current point to `(x,y)', with
     control points `(cp1x, cp1y)' and `(cp2x, cp2y)'. */
    
    public func addCurveToPoint(point: CGPoint, withControlPoints cp: [CGPoint]) {
        if cp.count < 2 { fatalError("The count of control points must greatere than 2.") }
        CGContextAddCurveToPoint(self, cp[0].x, cp[0].y, cp[1].x, cp[1].y, point.x, point.y)
    }
    
    /* Append a quadratic curve from the current point to `(x, y)', with control
     point `(cpx, cpy)'. */
    
    public func addQuadCurveToPoint(point: CGPoint, withControlPoint cp: CGPoint) {
        CGContextAddQuadCurveToPoint(self, point.x, point.y, cp.x, cp.y)
    }
    
    // MARK: Path construction convenience methods
    
    /* Add a single rect to the context's path. */
    
    public func addRect(rect: CGRect) {
        CGContextAddRect(self, rect)
    }
    
    /* Add a set of rects to the context's path. */
    
    public func addRects(rects: [CGRect]) {
        CGContextAddRects(self, rects, rects.count)
    }
    
    /* Add a set of lines to the context's path. */
    
    public func addLines(lines: [CGPoint]) {
        CGContextAddLines(self, lines, lines.count)
    }
    
    /* Add an ellipse inside `rect' to the current path of `context'. See the
     function `CGPathAddEllipseInRect' for more information on how the path
     for the ellipse is constructed. */
    
    public func addEllipseInRect(rect: CGRect) {
        CGContextAddEllipseInRect(self, rect)
    }
    
    /* Add an arc of a circle to the context's path, possibly preceded by a
     straight line segment. `(x, y)' is the center of the arc; `radius' is its
     radius; `startAngle' is the angle to the first endpoint of the arc;
     `endAngle' is the angle to the second endpoint of the arc; and
     `clockwise' is 1 if the arc is to be drawn clockwise, 0 otherwise.
     `startAngle' and `endAngle' are measured in radians. */
    
    public func addArc(point: CGPoint, radius: CGFloat, angle: (CGFloat, CGFloat), isClockwise: Bool) {
        CGContextAddArc(self, point.x, point.y, radius, angle.0, angle.1, isClockwise ? 1 : 0)
    }
    
    /* Add an arc of a circle to the context's path, possibly preceded by a
     straight line segment. `radius' is the radius of the arc. The arc is
     tangent to the line from the current point to `(x1, y1)', and the line
     from `(x1, y1)' to `(x2, y2)'. */
    
    public func addArcFromPoint(point1: CGPoint, toPoint point2: CGPoint, withRadius radius: CGFloat) {
        CGContextAddArcToPoint(self, point1.x, point1.y, point2.x, point2.y, radius)
    }
    
    /* Add `path' to the path of context. The points in `path' are transformed
     by the CTM of context before they are added. */
    
    public func addPath(path: CGPath) {
        CGContextAddPath(self, path)
    }
    
    /* Replace the path in `context' with the stroked version of the path, using
     the parameters of `context' to calculate the stroked path. The resulting
     path is created such that filling it with the appropriate color will
     produce the same results as stroking the original path. You can use this
     path in the same way you can use the path of any context; for example,
     you can clip to the stroked version of a path by calling this function
     followed by a call to "CGContextClip". */
    
    public func replacePathWithStrokedPath() {
        CGContextReplacePathWithStrokedPath(self)
    }
    
    // MARK: Path information methods
    
    /* Return true if the path of `context' contains no elements, false
     otherwise. */
    
    public var isPathEmpty: Bool {
        return CGContextIsPathEmpty(self)
    }
    
    /* Return the current point of the current subpath of the path of
     `context'. */
    
    public var currentPathPoint: CGPoint {
        return CGContextGetPathCurrentPoint(self)
    }
    
    /* Return the bounding box of the path of `context'. The bounding box is the
     smallest rectangle completely enclosing all points in the path, including
     control points for Bezier and quadratic curves. */
    
    public var pathBoundingBox: CGRect {
        return CGContextGetPathBoundingBox(self)
    }
    
    /* Return a copy of the path of `context'. The returned path is specified in
     the current user space of `context'. */
    
    public var copyPath: CGPath? {
        return CGContextCopyPath(self)
    }
    
    /* Return true if `point' is contained in the current path of `context'. A
     point is contained within a context's path if it is inside the painted
     region when the path is stroked or filled with opaque colors using the
     path drawing mode `mode'. `point' is specified is user space. */
    
    public func pathContainsPoint(point: CGPoint, mode: CGPathDrawingMode) -> Bool {
        return CGContextPathContainsPoint(self, point, mode)
    }
    
    // MARK: Path drawing methods
    
    /* Draw the context's path using drawing mode `mode'. */
    
    public func drawPath(mode: CGPathDrawingMode) {
        CGContextDrawPath(self, mode)
    }
    
    // MARK: Path drawing convenience methods
    
    /* Fill the context's path using the winding-number fill rule. Any open
     subpath of the path is implicitly closed. */
    
    public func fillPath() {
        CGContextFillPath(self)
    }
    
    /* Fill the context's path using the even-odd fill rule. Any open subpath of
     the path is implicitly closed. */
    
    public func evenOddFillPath() {
        CGContextEOFillPath(self)
    }
    
    /* Stroke the context's path. */
    
    public func strokePath() {
        CGContextStrokePath(self)
    }
    
    /* Fill `rect' with the current fill color. */
    
    public func fillRect(rect: CGRect) {
        CGContextFillRect(self, rect)
    }
    
    /* Fill `rects', an array of `count' CGRects, with the current fill
     color. */
    
    public func fillRects(rects: [CGRect]) {
        CGContextFillRects(self, rects, rects.count)
    }
    
    /* Stroke `rect' with the current stroke color and the current linewidth. */
    
    public func strokeRect(rect: CGRect) {
        CGContextStrokeRect(self, rect)
    }
    
    /* Stroke `rect' with the current stroke color, using `width' as the the
     line width. */
    
    public func strokeRect(rect: CGRect, withWidth: CGFloat) {
        CGContextStrokeRectWithWidth(self, rect, withWidth)
    }
    
    /* Clear `rect' (that is, set the region within the rect to transparent). */
    
    public func clearRect(rect: CGRect) {
        CGContextClearRect(self, rect)
    }
    
    /* Fill an ellipse (an oval) inside `rect'. */
    
    public func fillEllipseInRect(rect: CGRect) {
        CGContextFillEllipseInRect(self, rect)
    }
    
    /* Stroke an ellipse (an oval) inside `rect'. */
    
    public func strokeEllipseInRect(rect: CGRect) {
        CGContextStrokeEllipseInRect(self, rect)
    }
    
    /* Stroke a sequence of line segments one after another in `context'. The
     line segments are specified by `points', an array of `count' CGPoints.
     This function is equivalent to
     
     context.drawPaths { context in
        for k = 0; k < count; k += 2 {
            context.moveToPoint(s[k])
            context.addLineToPoint(s[k+1])
        }
        context.strokePath()
        //...
     } */
    
    public func strokeLineSegments(points: [CGPoint]) {
        CGContextStrokeLineSegments(self, points, points.count)
    }
    
    // MARK: Clipping methods
    
    /* Intersect the context's path with the current clip path and use the
     resulting path as the clip path for subsequent rendering operations. Use
     the winding-number fill rule for deciding what's inside the path. */
    
    public func clip() {
        CGContextClip(self)
    }
    
    /* Intersect the context's path with the current clip path and use the
     resulting path as the clip path for subsequent rendering operations. Use
     the even-odd fill rule for deciding what's inside the path. */
    
    public func evenOddClip() {
        CGContextEOClip(self)
    }
    
    /* Add `mask' transformed to `rect' to the clipping area of `context'. The
     mask, which may be either an image mask or an image, is mapped into the
     specified rectangle and intersected with the current clipping area of the
     context.
     
     If `mask' is an image mask, then it clips in a manner identical to the
     behavior if it were used with "CGContextDrawImage": it indicates an area
     to be masked out (left unchanged) when drawing. The source samples of the
     image mask determine which points of the clipping area are changed,
     acting as an "inverse alpha": if the value of a source sample in the
     image mask is S, then the corresponding point in the current clipping
     area will be multiplied by an alpha of (1-S). (For example, if S is 1,
     then the point in the clipping area becomes clear, while if S is 0, the
     point in the clipping area is unchanged.
     
     If `mask' is an image, then it serves as alpha mask and is blended with
     the current clipping area. The source samples of mask determine which
     points of the clipping area are changed: if the value of the source
     sample in mask is S, then the corresponding point in the current clipping
     area will be multiplied by an alpha of S. (For example, if S is 0, then
     the point in the clipping area becomes clear, while if S is 1, the point
     in the clipping area is unchanged.
     
     If `mask' is an image, then it must be in the DeviceGray color space, may
     not have alpha, and may not be masked by an image mask or masking
     color. */
    
    public func clipRect(rect: CGRect, ToMask mask: CGImage?) {
        CGContextClipToMask(self, rect, mask)
    }
    
    /* Return the bounding box of the clip path of `c' in user space. The
     bounding box is the smallest rectangle completely enclosing all points in
     the clip. */
    
    public var clipBoundingBox: CGRect {
        return CGContextGetClipBoundingBox(self)
    }
    
    // MARK: Clipping convenience methods
    
    /* Intersect the current clipping path with `rect'. Note that this function
     resets the context's path to the empty path. */
    
    public func clipToRect(rect: CGRect) {
        CGContextClipToRect(self, rect)
    }
    
    /* Intersect the current clipping path with the clipping region formed by
     creating a path consisting of all rects in `rects'. Note that this
     function resets the context's path to the empty path. */
    
    public func clipToRects(rects: [CGRect]) {
        CGContextClipToRects(self, rects, rects.count)
    }
    
    // MARK: Primitive color methods
    
    /* Set the current fill color in the context `c' to `color'. */
    
    public var fillColor: CGColor? {
        get {
            return (objc_getAssociatedObject(self, &fillColorAssociationKey) as! CGColor)
        }
        set {
            CGContextSetFillColorWithColor(self, newValue)
            objc_setAssociatedObject(self, &fillColorAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /* Set the current stroke color in the context `c' to `color'. */
    
    public var strokeColor: CGColor? {
        get {
            return (objc_getAssociatedObject(self, &strokeColorAssociationKey) as! CGColor)
        }
        set {
            CGContextSetStrokeColorWithColor(self, newValue)
            objc_setAssociatedObject(self, &strokeColorAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: Color space methods
    
    /* Set the current fill color space in `context' to `space'. As a
     side-effect, set the fill color to a default value appropriate for the
     color space. */
    
    public var fillColorSpace: CGColorSpace? {
        get {
            return (objc_getAssociatedObject(self, &fillColorSpaceAssociationKey) as! CGColorSpace)
        }
        set {
            CGContextSetFillColorSpace(self, newValue)
            objc_setAssociatedObject(self, &fillColorSpaceAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /* Set the current stroke color space in `context' to `space'. As a
     side-effect, set the stroke color to a default value appropriate for the
     color space. */
    
    public var strokeColorSpace: CGColorSpace? {
        get {
            return (objc_getAssociatedObject(self, &strokeColorSpaceAssociationKey) as! CGColorSpace)
        }
        set {
            CGContextSetStrokeColorSpace(self, newValue)
            objc_setAssociatedObject(self, &strokeColorSpaceAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: Color methods
    
    /* Set the components of the current fill color in `context' to the values
     specifed by `components'. The number of elements in `components' must be
     one greater than the number of components in the current fill color space
     (N color components + 1 alpha component). The current fill color space
     must not be a pattern color space. */
    
    public func setFillColorComponents(colorComponents: CGFloat..., alphaComponent alpha: CGFloat, pattern: CGPattern? = nil) {
        let components = colorComponents + [alpha]
        if let pattern = pattern {
            CGContextSetFillPattern(self, pattern, components)
        } else {
            CGContextSetFillColor(self, components)
        }
    }
    
    /* Set the components of the current stroke color in `context' to the values
     specifed by `components'. The number of elements in `components' must be
     one greater than the number of components in the current stroke color
     space (N color components + 1 alpha component). The current stroke color
     space must not be a pattern color space. */
    
    public func setStrokeColorComponents(colorComponents: CGFloat..., alphaComponent alpha: CGFloat, pattern: CGPattern? = nil) {
        let components = colorComponents + [alpha]
        if let pattern = pattern {
            CGContextSetStrokePattern(self, pattern, components)
        } else {
            CGContextSetStrokeColor(self, components)
        }
    }
    
    // MARK: Pattern methods
    
    /* Set the pattern phase in the current graphics state of `context' to
     `phase'. */
    
    public func setPatternPhase(phase: CGSize) {
        CGContextSetPatternPhase(self, phase)
    }
    
    // MARK: Rendering intent
    
    /* Set the rendering intent in the current graphics state of `context' to
     `intent'. */
    
    public func setRenderingIntent(intent: CGColorRenderingIntent) {
        CGContextSetRenderingIntent(self, intent)
    }
    
    // MARK: Image methods
    
    /* Draw `image' in the rectangular area specified by `rect' in the context
     `c'. The image is scaled, if necessary, to fit into `rect'. */
    
    public func drawImage(image: CGImage?, inRect rect: CGRect) {
        CGContextDrawImage(self, rect, image)
    }
    
    /* Draw `image' tiled in the context `c'. The image is scaled to the size
     specified by `rect' in user space, positioned at the origin of `rect' in
     user space, then replicated, stepping the width of `rect' horizontally
     and the height of `rect' vertically, to fill the current clip region.
     Unlike patterns, the image is tiled in user space, so transformations
     applied to the CTM affect the final result. */
    
    public func drawTiledImage(image: CGImage?, inRect rect: CGRect) {
        CGContextDrawTiledImage(self, rect, image)
    }
    
    /* Return the interpolation quality for image rendering of `context'. The
     interpolation quality is a gstate parameter which controls the level of
     interpolation performed when an image is interpolated (for example, when
     scaling the image). Note that it is merely a hint to the context: not all
     contexts support all interpolation quality levels. */
    
    public var interpolationQuality: CGInterpolationQuality {
        set {
            CGContextSetInterpolationQuality(self, newValue)
        }
        get {
            return CGContextGetInterpolationQuality(self)
        }
    }
    
    // MARK: Shadow support
    
    /* Set the shadow parameters in `context'. `offset' specifies a translation
     in base-space; `blur' is a non-negative number specifying the amount of
     blur; `color' specifies the color of the shadow, which may contain a
     non-opaque alpha value. If `color' is NULL, it's equivalent to specifying
     a fully transparent color. The shadow is a gstate parameter. After a
     shadow is specified, all objects drawn subsequently will be shadowed. To
     turn off shadowing, set the shadow color to a fully transparent color (or
     pass NULL as the color), or use the standard gsave/grestore mechanism. */
    
    public func setShadowWithOffset(offset: CGSize, blur: CGFloat, color: CGColor? = CGColor.initialization(red: 0, green: 0, blue: 0, alpha: 1/3)) {
        CGContextSetShadowWithColor(self, offset, blur, color)
    }
    
    // MARK: Gradient and shading methods
    
    /* Fill the current clipping region of `context' with a linear gradient from
     `startPoint' to `endPoint'. The location 0 of `gradient' corresponds to
     `startPoint'; the location 1 of `gradient' corresponds to `endPoint';
     colors are linearly interpolated between these two points based on the
     values of the gradient's locations. The option flags control whether the
     gradient is drawn before the start point or after the end point. */
    
    public func drawLinearGradient(gradient: CGGradient?, startPoint: CGPoint, endPoint: CGPoint, options: CGGradientDrawingOptions) {
        CGContextDrawLinearGradient(self, gradient, startPoint, endPoint, options)
    }
    
    
    
}

