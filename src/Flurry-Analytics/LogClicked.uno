using Uno;
using Uno.Collections;
using Uno.UX;
using Fuse;
using Fuse.Gestures;
using Fuse.Navigation;
using Flurry.Analytics;

namespace Flurry
{
	/**
		Enables logging on all clicks

	*/
	public class AnalyticsLogClicked : Fuse.Gestures.Clicked
	{
        [UXAttachedEventAdder("Gestures.LogClicked")]
        public static void AddHandler(Visual visual, ClickedHandler handler)
        {
            Fuse.Gestures.Clicked.AddHandler(visual, handler);
            debug_log("Added clicked handler");
            Flurry.AnalyticsLogClicks.getInstance().AddClickedHandlers(visual);
            debug_log("Added logclicked handler");
        }

	}
}
