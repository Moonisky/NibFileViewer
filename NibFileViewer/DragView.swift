//
//  DragView.swift
//  NibFileViewer
//
//  Created by Semper_Idem on 16/3/23.
//  Copyright © 2016年 星夜暮晨. All rights reserved.
//

import AppKit

class DragView: NSView {
  
  fileprivate var isHighlight = false
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    
    let rect = frame.insetBy(dx: 5, dy: 5)
    guard let context = NSGraphicsContext.current()?.cgContext else { return }
    context.setLineWidth(8)
    context.setLineDash(phase: 0, lengths: [55, 25])
    context.setStrokeColor(CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
    context.stroke(NSRectToCGRect(rect))
    
    let text = isHighlight ? "Release and it will be opened by Xcode" : "Drag nib files here"
    let style = NSMutableParagraphStyle.default().mutableCopy() as? NSMutableParagraphStyle
    style?.alignment = .center
    
    (text as NSString).draw(
      in: NSRect(x: 0, y: rect.origin.y / 2 + 30, width: rect.width, height: rect.height / 2),
      withAttributes: [
        NSFontAttributeName: NSFont(name: "Helvetica", size: 30)!,
        NSParagraphStyleAttributeName: style!,
        NSForegroundColorAttributeName: NSColor.gray
      ])
  }
  
  override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
    super.draggingEntered(sender)
    
    isHighlight = true
    needsDisplay = true
    
    return .generic
  }
  
  override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
    super.draggingUpdated(sender)
    
    return .generic
  }
  
  override func draggingExited(_ sender: NSDraggingInfo?) {
    super.draggingExited(sender)
    
    isHighlight = false
    needsDisplay = true
  }
  
  override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
    isHighlight = false
    needsDisplay = true
    
    return true
  }
  
  override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
    let pasteBoard = sender.draggingPasteboard()
    
    if let types = pasteBoard.types, types.contains(NSFilenamesPboardType) {
      guard let files = pasteBoard.propertyList(forType: NSFilenamesPboardType) as? [String] else { return false }
      for file in files {
        FileManager.openNibFile(file)
      }
    }
    return true
  }
}
