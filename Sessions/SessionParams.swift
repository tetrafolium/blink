//////////////////////////////////////////////////////////////////////////////////
//
// B L I N K
//
// Copyright (C) 2016-2019 Blink Mobile Shell Project
//
// This file is part of Blink.
//
// Blink is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Blink is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Blink. If not, see <http://www.gnu.org/licenses/>.
//
// In addition, Blink is also subject to certain additional terms under
// GNU GPL version 3 section 7.
//
// You should have received a copy of these additional terms immediately
// following the terms and conditions of the GNU General Public License
// which accompanied the Blink Source Code. If not, see
// <http://www.github.com/blinksh/blink>.
//
////////////////////////////////////////////////////////////////////////////////

import Foundation
import UIKit

@objc class SessionParams: NSObject, NSSecureCoding {

  @objc var encodedState: Data?
  
  @objc func cleanEncodedState() {
    encodedState = nil
  }
  
  override init() {
    super.init()
  }
  
  private enum Key: CodingKey {
    case encodedState
  }
  
  func encode(with coder: NSCoder) {
    coder.encode(encodedState, for: Key.encodedState)
  }
  
  required init?(coder: NSCoder) {
    super.init()
    encodedState = coder.decode(for: Key.encodedState)
  }
  
  static var secureCoding1 = true
  class var supportsSecureCoding: Bool { return secureCoding1 }
}

@objc class MoshParams: SessionParams {
  @objc var ip: String?
  @objc var port: String?
  @objc var key: String?
  @objc var predictionMode: String?
  @objc var startupCmd: String?
  @objc var serverPath: String?
  @objc var experimentalRemoteIp: String?
  
  override init() {
    super.init()
  }
  
  private enum Key: CodingKey {
    case ip
    case port
    case key
    case predictionMode
    case startupCmd
    case serverPath
    case experimentalRemoteIp
  }
  
  override func encode(with coder: NSCoder) {
    super.encode(with: coder)
    
    coder.encode(ip, for: Key.ip)
    coder.encode(port, for: Key.port)
    coder.encode(key, for: Key.key)
    coder.encode(predictionMode, for: Key.predictionMode)
    coder.encode(startupCmd, for: Key.startupCmd)
    coder.encode(serverPath, for: Key.serverPath)
    coder.encode(experimentalRemoteIp, for: Key.experimentalRemoteIp)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.ip = coder.decode(for: Key.ip)
    self.port = coder.decode(for: Key.port)
    self.key = coder.decode(for: Key.key)
    self.predictionMode = coder.decode(for: Key.predictionMode)
    self.startupCmd = coder.decode(for: Key.startupCmd)
    self.serverPath = coder.decode(for: Key.serverPath)
    self.experimentalRemoteIp = coder.decode(for: Key.experimentalRemoteIp)
  }
  
  static var secureCoding2 = true
  override class var supportsSecureCoding: Bool { secureCoding2 }
}

@objc class MCPParams: SessionParams {
  @objc var childSessionType: String?
  @objc var childSessionParams: SessionParams?
  
  // TODO: Move to UIState?
  @objc var viewSize: CGSize = .zero
  @objc var rows: Int = 0
  @objc var cols: Int = 0
  @objc var themeName: String?
  @objc var fontName: String?
  @objc var fontSize: Int = 16
  @objc var layoutMode: Int = 0
  @objc var boldAsBright: Bool = false
  @objc var enableBold: UInt = 0
  @objc var layoutLocked: Bool = false
  @objc var layoutLockedFrame: CGRect = .zero
  
  @objc func hasEncodedState() -> Bool {
    childSessionParams?.encodedState != nil
  }
  
  override func cleanEncodedState() {
    childSessionParams?.cleanEncodedState()
    super.cleanEncodedState()
  }
  
  override init() {
    super.init()
  }
  
  private enum Key: CodingKey {
    case childSessionType
    case childSessionParams
    case viewSize
    case rows
    case cols
    case themeName
    case fontName
    case fontSize
    case layoutMode
    case boldAsBright
    case enableBold
    case layoutLocked
    case u
  }
  
  override func encode(with coder: NSCoder) {
    super.encode(with: coder)
    
    coder.encode(childSessionType, for: Key.childSessionType)
    coder.encode(childSessionParams, for: Key.childSessionParams)
    coder.encode(viewSize, for: Key.viewSize)
    coder.encode(rows, for: Key.rows)
    coder.encode(cols, for: Key.cols)
    coder.encode(themeName, for: Key.themeName)
    coder.encode(fontName, for: Key.fontName)
    coder.encode(fontSize, for: Key.fontSize)
    coder.encode(layoutMode, for: Key.layoutMode)
    coder.encode(boldAsBright, for: Key.boldAsBright)
    coder.encode(enableBold, for: Key.enableBold)
    coder.encode(layoutLocked, for: Key.layoutLocked)
    coder.encode(layoutLockedFrame, for: Key.u)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.childSessionType = coder.decode(for: Key.childSessionType)
    self.childSessionParams = coder.decode(of: [MoshParams.self, SessionParams.self], for: Key.childSessionParams)
    self.viewSize = coder.decode(for: Key.viewSize)
    self.rows = coder.decode(for: Key.rows)
    self.cols = coder.decode(for: Key.cols)
    self.themeName = coder.decode(for: Key.themeName)
    self.fontName = coder.decode(for: Key.fontName)
    self.fontSize = coder.decode(for: Key.fontSize)
    self.layoutMode = coder.decode(for: Key.layoutMode)
    self.boldAsBright = coder.decode(for: Key.boldAsBright)
    self.enableBold = coder.decode(for: Key.enableBold)
    self.layoutLocked = coder.decode(for: Key.layoutLocked)
    self.layoutLockedFrame = coder.decode(for: Key.u)
    
  }
  
  static var secureCoding2 = true
  override class var supportsSecureCoding: Bool { secureCoding2 }
}
