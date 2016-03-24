//
//  DragView.swift
//  NibFileViewer
//
//  Created by Semper_Idem on 16/3/23.
//  Copyright © 2016年 星夜暮晨. All rights reserved.
//

import AppKit

class DragView: NSView {
    
    private var isHighlight = false
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let rect = frame.insetBy(dx: 5, dy: 5)
        guard let context = NSGraphicsContext.currentContext()?.CGContext else { return }
        context.lineWidth = 8
        context.setLineDash(phase: 0, lengths: 55, 25)
        context.strokeColor = CGColor.initialization(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        context.strokeRect(NSRectToCGRect(rect))
        
        let text = isHighlight ? "Release and it will be opened by Xcode" : "Drag nib files here"
        let style = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as? NSMutableParagraphStyle
        style?.alignment = .Center
        
        (text as NSString).drawInRect(
            NSRect(x: 0, y: rect.origin.y / 2 + 30, width: rect.width, height: rect.height / 2),
            withAttributes: [
                NSFontAttributeName: NSFont(name: "Helvetica", size: 30)!,
                NSParagraphStyleAttributeName: style!,
                NSForegroundColorAttributeName: NSColor.grayColor()
            ])
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        super.draggingEntered(sender)
        
        isHighlight = true
        needsDisplay = true
        
        return .Generic
    }
    
    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
        super.draggingUpdated(sender)
        
        return .Generic
    }
    
    override func draggingExited(sender: NSDraggingInfo?) {
        super.draggingExited(sender)
        
        isHighlight = false
        needsDisplay = true
    }
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        isHighlight = false
        needsDisplay = true
        
        return true
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        let pasteBoard = sender.draggingPasteboard()
        
        if let types = pasteBoard.types where types.contains(NSFilenamesPboardType) {
            guard let files = pasteBoard.propertyListForType(NSFilenamesPboardType) as? [String] else { return false }
            for file in files {
                FileManager.openNibFile(file)
            }
        }
        return true
    }
}
