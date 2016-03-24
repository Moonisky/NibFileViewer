//
//  FileManager.swift
//  NibFileViewer
//
//  Created by Semper_Idem on 16/3/24.
//  Copyright © 2016年 星夜暮晨. All rights reserved.
//

import AppKit

class FileManager {
    
    static var openerNibPath = ""
    
    class func openNibFile(nib: String) {
        do {
            let fileManager = NSFileManager.defaultManager()
            
            // Step 1：拷贝 Compiled Nib Opener 到临时目录
            guard let nibURL = NSURL(string: nib), component = nibURL.lastPathComponent else { return }
            let destination = NSTemporaryDirectory() + component
            print("目标路径：" + destination)
            if fileManager.fileExistsAtPath(destination) {
                try fileManager.removeItemAtPath(destination)
            }
            try fileManager.copyItemAtPath(openerNibPath, toPath: destination)
            
            // Step 2：覆盖 keyedobjects.nib 文件
            let keyed = destination + "/" + "keyedobjects.nib"
            if fileManager.fileExistsAtPath(destination) {
                try fileManager.removeItemAtPath(keyed)
            }
            try fileManager.copyItemAtPath(nib, toPath: keyed)

            // Step 3：用 Xcode 打开
            if !NSWorkspace.sharedWorkspace().openFile(destination, withApplication: "Xcode") {
                throw NSError(domain: NSPOSIXErrorDomain, code: Int(ENOEXEC), userInfo: nil)
            }
        } catch let error as NSError {
            NSAlert(error: error).runModal()
        }
    }
}