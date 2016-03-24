//
//  ViewController.swift
//  NibFileViewer
//
//  Created by Semper_Idem on 16/3/23.
//  Copyright © 2016年 星夜暮晨. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet private var dargView: DragView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let openZip = NSBundle.mainBundle().pathForResource("Compiled Nib Opener.nib", ofType: "zip") else { return }
        let zipTask = NSTask.launchedTaskWithLaunchPath("/usr/bin/unzip", arguments: [
            "-u", openZip, "-d", NSTemporaryDirectory()
        ])
        zipTask.waitUntilExit()
        FileManager.openerNibPath = NSTemporaryDirectory() + "Compiled Nib Opener.nib"
        
        dargView.registerForDraggedTypes([NSFilenamesPboardType])
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

