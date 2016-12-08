using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;

using Fuse.Platform;

[ForeignInclude(Language.Java,"com.flurry.android.FlurryAgent")]
public class FuseFlurry : Behavior {
    public FuseFlurry () {
        debug_log "Constructor";
        Uno.Platform2.Application.EnteringForeground += OnEnteringForeground;
        if (Uno.Platform2.Application.State == Uno.Platform2.ApplicationState.Foreground) {
            _foreground = true;
        }
    }

    void OnEnteringForeground(Uno.Platform2.ApplicationState newState)
    {
        _foreground = true;
        Init();
    }

    static bool _foreground = false;
    static bool _inited = false;
    void Init() {
        debug_log "Init";
        if (_inited)
            return;
        if (Token == null) {
            if defined(iOS) {
                if (iOSToken == null)
                    return;
            }
            else if defined(Android) {
                if (AndroidToken == null)
                    return;                
            }
            else {
                return;
            }

        }
        if (!_foreground)
            return;
        _inited = true;
        if defined(iOS)
            if (iOSToken != null)
                InitImpl(iOSToken);
            else
                InitImpl(Token);
        if defined(Android)
            if (AndroidToken != null)
                InitImpl(AndroidToken);
            else
                InitImpl(Token);
    }

    [Require("Cocoapods.Podfile.Target", "pod 'Flurry-iOS-SDK/FlurrySDK'")]
    [Require("Cocoapods.Podfile.Target", "pod 'Flurry-iOS-SDK/FlurryAds'")]
    [Require("Source.Declaration", "#import \"Flurry.h\"")]
    [Foreign(Language.ObjC)]
    extern(iOS) void InitImpl(string token) 
    @{
        [Flurry setDebugLogEnabled:YES];
        [Flurry startSession:token];
    @}

    [Require("Gradle.Dependency.Compile", "com.flurry.android:analytics:6.2.0")]
    [Foreign(Language.Java)]
    extern(Android) void InitImpl(string token)
    @{
        FlurryAgent.init(com.fuse.Activity.getRootActivity(), token);
        FlurryAgent.onStartSession(com.fuse.Activity.getRootActivity(), token);
        //new FlurryAgent.Builder()
        //    .withLogEnabled(false)
        //    .build(com.fuse.Activity.getRootActivity(), token);

    @}


    // One or two tokens? http://stackoverflow.com/questions/15095116/flurry-integration-into-same-app-on-android-and-ios
    static string _token;
    public string Token {
        get { return _token; } 
        set { 
            _token = value;
            Init();
        }
    }

    public string iOSToken {
        get; set;
    }

    public string AndroidToken {
        get; set;
    }


}