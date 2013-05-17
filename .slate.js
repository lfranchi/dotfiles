// order screens left to right so they are easier to reference
slate.config("orderScreensLeftToRight", true);

var externalScreen = function() {
    // Either a 1920x1200 on the left (home)
    // or a x on the right (work)
    var home_24inch = slate.screenForRef("1920x1200");
    if (home_24inch.rect()) {
        return home_24inch;
    }
    var work_27inch = slate.screenForRef("2560x1440");
    if (work_27inch.rect()) {
        return work_27inch;
    }

    // If no external screen, return the only one
    return slate.screenForRef("0");
};

var laptopScreen = function () {
    var s = slate.screenForRef("1680x1050");
    if (s.rect()) {
        return s;
    }
    s = slate.screenForRef("1920x1200");
    if (s.rect()) {
        return s;
    }
    s = slate.screenForRef("1440x900");
    return s;
};

var fullscreen = slate.operation("move", {
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" : "screenSizeX",
  "height" : "screenSizeY"
});
var pushRight = slate.operation("push", {
  "direction" : "right",
  "style" : "bar-resize:screenSizeX/2"
});
var pushLeft = slate.operation("push", {
  "direction" : "left",
  "style" : "bar-resize:screenSizeX/2"
});
var pushTop = slate.operation("push", {
  "direction" : "top",
  "style" : "bar-resize:screenSizeX/3"
});
var throwNext = slate.operation("throw", {
  "screen": "next"
});
var putOnExternal = slate.operation("throw", {
    "screen": externalScreen()
});
var moveBottomRight = slate.operation("move", {
    "x": "screenOriginX+screenSizeX-windowSizeX",
    "y": "screenOriginY+screenSizeY-windowSizeY",
    "width": "windowSizeX",
    "height": "windowSizeY"
});

var showhide = function (show_hide) {
    return function (appname) {
        return function (win) {
            win.doOperation(slate.operation(show_hide, { "app": appname } ));
        }
    }
};



var show = showhide("show");
var hide = showhide("hide");


var centerWindow = slate.operation("move", {
    "x": "screenOriginX+(screenSizeX)/2-(windowSizeX/2)",
    "y": "screenOriginY+(screenSizeY)/2-(windowSizeY/2)",
    "width": "windowSizeX",
    "height": "windowSizeY",
});

var centerExternally  = function (win) {
    win.doOperation(slate.operation("show", {"app": win.app().name()}));
    win.doOperation(putOnExternal);
    win.doOperation(centerWindow);
};

var fullscreenExternally = function (win) {
    win.doOperation(slate.operation("show", {"app": win.app().name()}));
    win.doOperation(show(win.app().name()));
    win.doOperation(putOnExternal);
    win.doOperation(fullscreen);
};

var halfLeftExternal = function (win) {
    win.doOperation(slate.operation("show", {"app": win.app().name()}));
    win.doOperation(putOnExternal);
    win.doOperation(pushLeft);
};

var halfRightExternal = function (win) {
    win.doOperation(slate.operation("show", {"app": win.app().name()}));
    win.doOperation(putOnExternal);
    win.doOperation(pushRight);
};

var bottomRightExternal = function (win) {
    win.doOperation(slate.operation("show", {"app": win.app().name()}));
    win.doOperation(putOnExternal);
    win.doOperation(moveBottomRight);
};

var focusBelow = function (win) {
    win.doOperation(slate.operation("focus", { "direction": "below" }));
};

// Layouts
var home_layout = slate.layout("Home-External",
                               { "Mail": { "title-order": ["Activity"],
                                           "operations": [bottomRightExternal, fullscreen] },
                                 "SourceTree": { "operations": [centerExternally]},
                                 "Calendar": { "operations": [centerExternally]},
                                 "Google Chrome": { "title-order-regex": ["Developer Tools.*"],
                                                    "operations": [halfRightExternal, fullscreen, halfLeftExternal]},
                                 "iTerm": {"operations": [pushTop]},
                                 "Tomahawk": { "operations": [centerExternally] },
                                 "Safari": { "operations": [fullscreen] },
                                 "WebKit": { "title-order-regex": ["Web Inspector.*"],
                                             "operations": [halfRightExternal, halfLeftExternal] },
                                 "Sublime Text 2": { "title-order-regex": [".*humbug-split", ".*humbug"],
                                                     "operations": [fullscreenExternally, fullscreen] },
                                 "Quassel IRC Client": { "operations": [fullscreen] },
                                 "Twitter": { "operations": [halfRightExternal] }
                               });

var laptop_only = slate.layout("Laptop-Only",
                               { "Mail": { "operations": [] },
                                 "SourceTree": { "operations": [hide("SourceTree")]},
                                 "Calendar": { "operations": [hide("Calendar")]},
                                 "Google Chrome": { "title-order-regex": ["Developer Tools.*"],
                                                    "operations": [focusBelow, fullscreen, fullscreen]},
                                 "iTerm": {"operations": [pushTop]},
                                 "Tomahawk": { "operations": [centerWindow] },
                                 "Safari": { "operations": [fullscreen] },
                                 "WebKit": { "title-order-regex": ["Web Inspector.*"],
                                             "operations": [halfRightExternal, halfLeftExternal] },
                                 "Sublime Text 2": { "title-order-regex": [".*humbug-split", ".*humbug"],
                                                     "operations": [fullscreenExternally, fullscreen] },
                                 "Quassel IRC Client": { "operations": [fullscreen] },
                                 "Twitter": { "operations": [pushRight] }
                               });


// Apply home layout on pressing control-h
slate.bind("h:ctrl", slate.operation("layout", { "name" : home_layout }));
//slate.bind("g:ctrl", slate.operation("layout", {"name" : laptop_only }));

slate.default(["1920x1080","1680x1050"], home_layout);
slate.default(["1680x1050"], laptop_only);

slate.bind("1:alt", function (win) {
    win.doOperation(fullscreen);
});
slate.bind("2:alt", function (win) {
    win.doOperation(pushLeft);
});
slate.bind("3:alt", function (win) {
    win.doOperation(pushRight);
});
slate.bind("4:alt", function (win) {
    win.doOperation(pushTop);
});
slate.bind("tab:alt", function (win) {
    win.doOperation(throwNext);
    win.doOperation(centerWindow);
});

S.bnda({
    "`:alt": S.op('hint')
});

slate.log("[SLATE] -------------- Finished Loading Config --------------");
