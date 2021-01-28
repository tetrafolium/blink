'use strict';

hterm.Terminal.prototype.onFocusChange_ = function(focused) {};

hterm.Terminal.prototype.onFocusChange__ = function(focused) {
  var currentState = this.cursorNode_.getAttribute('focus');
  if (currentState === focused + '') {
    return;
  }

  this.cursorNode_.setAttribute('focus', focused);
  this.restyleCursor_();

  if (this.reportFocus) {
    this.io.sendString(focused === true ? '\x1b[I' : '\x1b[O');
  }

  if (focused === true)
    this.closeBellNotifications_();
};

// Do not show resize notifications. We show ours
hterm.Terminal.prototype.overlaySize = function() {};

hterm.Terminal.prototype.onMouse_ = function() {};

// TODO: Remove our patch. htermjs supports cursorBlinkPause_ option now
// see
// https://github.com/chromium/hterm/commit/f57d62de8f91f1fc8923fb000aeace041d063f9f
hterm.Terminal.prototype.setCursorVisible = function(state) {
  this.options_.cursorVisible = state;

  if (!state) {
    if (this.timeouts_.cursorBlink) {
      clearTimeout(this.timeouts_.cursorBlink);
      delete this.timeouts_.cursorBlink;
    }
    this.cursorNode_.style.opacity = '0';
    return;
  }

  this.syncCursorPosition_();

  this.cursorNode_.style.opacity = '1';

  if (this.options_.cursorBlink) {
    if (this.timeouts_.cursorBlink)
      return;

    // Blink: Switch the cursor off, so that the manual (first) blink trigger
    // sets it on again
    this.cursorNode_.style.opacity = '0';
    this.onCursorBlink_();
  } else {
    if (this.timeouts_.cursorBlink) {
      clearTimeout(this.timeouts_.cursorBlink);
      delete this.timeouts_.cursorBlink;
    }
  }
};
