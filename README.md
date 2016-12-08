# Fuse-Flurry
[![license](https://img.shields.io/github/license/bolav/fuse-flurry.svg?maxAge=2592000)](https://github.com/bolav/fuse-flurry/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/bolav/fuse-flurry.svg?branch=master)](https://travis-ci.org/bolav/fuse-flurry)

[Flurry](http://www.flurry.com) API bindings for [Fusetools](http://www.fusetools.com).

## Compiling

This project requires `-DCOCOAPODS` on iOS, and `-DGRADLE` on Android.

## Running the Example project

You can find the example in the `FlurryExample` folder. It contains:

FlurryExample.unoproj - Our project file
MainView.ux - The Super basic markup for our app (NO UI)

### Editing the Flurry parts

Log in to [https://y.flurry.com/admin/applications], and get your API keys. According to [StackOverflow](http://stackoverflow.com/questions/15095116/flurry-integration-into-same-app-on-android-and-ios) it might be possible to run both Android and iOS on the same token. You can then use `Token` in your markup, else use `iOSToken` and `AndroidToken`. Fill in the tokens in your UX and you are ready.

### Run

You should now be able to run, and get the result in your realtime analyitcs.


## JavaScript API

### require

    var flurry = require('Flurry/Analytics');

### logEvent

    flurry.logEvent("FuseEvent");
    flurry.logEvent("FuseEvent", {Author: "John Q", User_Status: "Registered"});

### Timed Event

    flurry.logEvent("FuseEvent", {}, true);
    flurry.endTimedEvent("FuseEvent");

    flurry.logEvent("FuseEvent", {Author: "John Q", User_Status: "Registered", Some_Other: "Created"}, true);
    flurry.endTimedEvent("FuseEvent", { Some_Other: "Updated" });

