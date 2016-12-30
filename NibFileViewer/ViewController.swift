//
//  ViewController.swift
//  NibFileViewer
//
//  Created by Semper_Idem on 16/3/23.
//  Copyright © 2016年 星夜暮晨. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  
  @IBOutlet fileprivate var dargView: DragView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let openZip = Bundle.main.path(forResource: "Compiled Nib Opener.nib", ofType: "zip") else { return }
    let zipTask = Process.launchedProcess(launchPath: "/usr/bin/unzip", arguments: [
      "-u", openZip, "-d", NSTemporaryDirectory()
      ])
    zipTask.waitUntilExit()
    FileManager.openerNibPath = NSTemporaryDirectory() + "Compiled Nib Opener.nib"
    
    dargView.register(forDraggedTypes: [NSFilenamesPboardType])
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
}
