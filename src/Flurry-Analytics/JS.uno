using Uno;
using Uno.UX;
using Uno.Threading;
using Uno.Text;
using Uno.Platform;
using Uno.Compiler.ExportTargetInterop;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Flurry.Analytics;

namespace Flurry.JS
{
	/**
	*/
	[UXGlobalModule]
	public sealed class AnalyticsModule : NativeModule
	{
		static readonly AnalyticsModule _instance;

		public AnalyticsModule()
		{
			if(_instance != null) return;

			Resource.SetGlobalKey(_instance = this, "Flurry/Analytics");

            // functions
            AddMember(new NativeFunction("logEvent", LogEvent));
            AddMember(new NativeFunction("endTimedEvent", EndTimedEvent));
		}

        // functions
        static object LogEvent(Context context, object[] args)
        {
            debug_log "LogEvent";
            var n = (string)args[0];

            string[] objs;
            string[] keys;
            if (args.Length > 1) {
                var p = (Fuse.Scripting.Object)args[1];

                keys = p.Keys;
                objs = new string[keys.Length];
                for (int i=0; i < keys.Length; i++) {
                    objs[i] = p[keys[i]].ToString();
                }               
            }
            else {
                objs = new string[0];
                keys = new string[0];
            }

            var timed = false;
            if (args.Length > 2) {
                timed = Marshal.ToBool(args[2]);
            }

            Analytics.LogEvent(n, keys, objs, keys.Length, timed);
            return null;
        }

        // functions
        static object EndTimedEvent(Context context, object[] args)
        {
            var n = (string)args[0];

            string[] objs;
            string[] keys;

            if (args.Length > 1) {
                var p = (Fuse.Scripting.Object)args[1];

                keys = p.Keys;
                objs = new string[keys.Length];
                for (int i=0; i < keys.Length; i++) {
                    objs[i] = p[keys[i]].ToString();
                }               
            }
            else {
                objs = new string[0];
                keys = new string[0];
            }

            Analytics.EndTimedEvent(n, keys, objs, keys.Length);
            return null;
        }

	}
}
