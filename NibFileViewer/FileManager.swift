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
  
  class func openNibFile(_ nib: String) {
    do {
      let fileManager = Foundation.FileManager.default
      
      // Step 1：拷贝 Compiled Nib Opener 到临时目录
      guard let nibURL = URL(string: nib) else { return }
      let component = nibURL.lastPathComponent
      let destination = NSTemporaryDirectory() + component
      print("目标路径：" + destination)
      if fileManager.fileExists(atPath: destination) {
        try fileManager.removeItem(atPath: destination)
      }
      try fileManager.copyItem(atPath: openerNibPath, toPath: destination)
      
      // Step 2：覆盖 keyedobjects.nib 文件
      let keyed = destination + "/" + "keyedobjects.nib"
      if fileManager.fileExists(atPath: destination) {
        try fileManager.removeItem(atPath: keyed)
      }
      try fileManager.copyItem(atPath: nib, toPath: keyed)
      
      // Step 3：用 Xcode 打开
      if !NSWorkspace.shared().openFile(destination, withApplication: "Xcode") {
        throw NSError(domain: NSPOSIXErrorDomain, code: Int(ENOEXEC), userInfo: nil)
      }
    } catch let error as NSError {
      NSAlert(error: error).runModal()
    }
  }
}
