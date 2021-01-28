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

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KBWebViewBase : WKWebView

@property(readonly) UIKeyModifierFlags trackingModifierFlags;

- (UIView *_Nullable)selectionView;
- (void)reportFocus:(BOOL)value;
- (void)reportStateReset:(BOOL)hasSelection;
- (void)reportLang:(NSString *)lang isHardwareKB:(BOOL)isHardwareKB;
- (void)reportHex:(NSString *)hex;
- (void)reportPress:(UIKeyModifierFlags)mods keyId:(NSString *)keyId;
- (void)reportToolbarPress:(UIKeyModifierFlags)mods keyId:(NSString *)keyId;
- (void)reportToolbarModifierFlags:(UIKeyModifierFlags)flags;
- (void)onSelection:(NSDictionary *)args;
- (void)onCommand:(NSString *)command;
- (void)setHasSelection:(BOOL)value;
- (void)removeAssistantsFromView;
- (void)report:(NSString *)cmd arg:(NSObject *)arg;
- (void)ready;
- (void)onMods;
- (void)onOut:(NSString *)data;
- (void)onIME:(NSString *)event data:(NSString *)data;
- (void)setTrackingModifierFlags:(UIKeyModifierFlags)trackingModifierFlags;

- (void)_keyboardDidChangeFrame:(NSNotification *)notification;
- (void)_keyboardWillChangeFrame:(NSNotification *)notification;
- (void)_keyboardWillShow:(NSNotification *)notification;
- (void)_keyboardWillHide:(NSNotification *)notification;
- (void)_keyboardDidHide:(NSNotification *)notification;
- (void)_keyboardDidShow:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
