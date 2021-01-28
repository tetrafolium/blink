////////////////////////////////////////////////////////////////////////////////
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

import UIKit

enum KBDevice {
  
  case in4   // iPhone4   // SE
  case in4_7 // iPhone4_7 // 6, 7, 8
  case in5_5 //
  case in5_8 // X, Xs, 12 Mini
  case in6_1 // iPhone 12 Pro
  case in6_5 // Xr!, Xs Max?         phone_5
  case in6_7
  
  case in9_7 // iPad Mini is the same
  case in10_2
  case in10_5
  case in10_9 // iPad Air 4 (2020)
  case in11
  case in12_9

  func layoutFor(lang: String) -> KBLayout {
    switch self {
    case .in9_7:   return .iPad_9_7(lang: lang)
    case .in10_2:  return .iPad_9_7(lang: lang)
    case .in10_5:  return .iPad_10_5(lang: lang)
    case .in10_9:  return .iPad_11(lang: lang)
    case .in11:    return .iPad_11(lang: lang)
    case .in12_9:  return .iPad_12_9(lang: lang)
    default: return .iPhone(lang: lang)
    }
  }
  
  func sizesFor(portrait: Bool) -> KBSizes {
    switch self {
    case .in4:    return portrait ? .portrait_iPhone_4   : .landscape_iPhone_4
    case .in4_7:  return portrait ? .portrait_iPhone_4_7 : .landscape_iPhone_4_7
    case .in5_5:  return portrait ? .portrait_iPhone_5_5 : .landscape_iPhone_5_5
    case .in5_8:  return portrait ? .portrait_iPhone_5_8 : .landscape_iPhone_5_8
    case .in6_1:  return portrait ? .portrait_iPhone_6_1 : .landscape_iPhone_6_1
    case .in6_5:  return portrait ? .portrait_iPhone_6_5 : .landscape_iPhone_6_5
    case .in6_7:  return portrait ? .portrait_iPhone_6_7 : .landscape_iPhone_6_7
    case .in9_7:  return portrait ? .portrait_iPad_9_7   : .landscape_iPad_9_7
    case .in10_2: return portrait ? .portrait_iPad_9_7   : .landscape_iPad_9_7
    case .in10_5: return portrait ? .portrait_iPad_10_5  : .landscape_iPad_10_5
    case .in10_9: return portrait ? .portrait_iPad_10_9  : .landscape_iPad_10_9
    case .in11:   return portrait ? .portrait_iPad_11    : .landscape_iPad_11
    case .in12_9: return portrait ? .portrait_iPad_12_9  : .landscape_iPad_12_9
    }
  }
  
  static func detect() -> Self {
    let size = UIScreen.main.bounds.size
    let wideSideSize = Int(max(size.height, size.width))
  
    switch wideSideSize {
    case 568:  return .in4
    case 667:  return .in4_7
    case 736:  return .in5_5
    case 812:  return .in5_8 // iPhone 11 Pro
    case 844:  return .in6_1 // iPhone 12 Pro
    case 896:  return .in6_5 // iPhone 11 Pro Max
    case 926:  return .in6_7 // iPhone 12 Pro Max
    case 1024: return .in9_7
    case 1080: return .in10_2
    case 1112: return .in10_5
    case 1180: return .in10_9
    case 1194: return .in11
    case 1366: return .in12_9

    default:   return .in9_7
    }
  }
    
}
