using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;

namespace Flurry
{

    [ForeignInclude(Language.Java,
        "com.flurry.android.FlurryAgent",
        "java.util.HashMap")]
    public class Analytics : Behavior {
        public Analytics () {
            debug_log "Constructor";
            Fuse.Platform.Lifecycle.Started += OnStarted;
            if (Fuse.Platform.Lifecycle.State == Fuse.Platform.ApplicationState.Foreground) {
                _foreground = true;
            }
        }

        void OnStarted(Fuse.Platform.ApplicationState newState)
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
            [::Flurry setDebugLogEnabled:YES];
            [::Flurry startSession:token];
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

        [Foreign(Language.Java)]
        extern(android)
        public static void LogEvent(string name, string[] keys, string[] vals, int len, bool timed)
        @{
            HashMap<String,String> param = new HashMap<String,String>();

            for (int i = 0; i < len; i++) {
                param.put(keys.get(i), vals.get(i));
            }
            FlurryAgent.logEvent(name, param, timed);
        @}


        [Foreign(Language.ObjC)]
        extern(iOS)
        public static void LogEvent(string name, string[] keys, string[] vals, int len, bool timed)
        @{
            NSDictionary *param = [NSDictionary dictionaryWithObjects:[vals copyArray] forKeys:[keys copyArray]];
            [::Flurry logEvent:name withParameters:param timed:timed];
        @}

        extern(!mobile)
        public static void LogEvent(string name, string[] keys, string[] vals, int len, bool timed) {

        }

        [Foreign(Language.Java)]
        extern(android)
        public static void EndTimedEvent(string name, string[] keys, string[] vals, int len)
        @{
            HashMap<String,String> param = new HashMap<String,String>();

            for (int i = 0; i < len; i++) {
                param.put(keys.get(i), vals.get(i));
            }
            FlurryAgent.endTimedEvent(name, param);
        @}


        [Foreign(Language.ObjC)]
        extern(iOS)
        public static void EndTimedEvent(string name, string[] keys, string[] vals, int len)
        @{
            NSDictionary *param = [NSDictionary dictionaryWithObjects:[vals copyArray] forKeys:[keys copyArray]];
            [::Flurry endTimedEvent:name withParameters:param];
        @}

        extern(!mobile)
        public static void EndTimedEvent(string name, string[] keys, string[] vals, int len)
        { }

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

}
