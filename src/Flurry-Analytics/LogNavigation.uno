using Uno;
using Uno.Collections;
using Fuse;
using Flurry.Analytics;

namespace Flurry
{
	/**
		Enables logging on all page transitions

		# Examples

		This starts the logging.

			<Navigator DefaultTemplate="splash" ux:Name="navigator">
				<Flurry.AnalyticsLogNavigation Navigation="navigator" PageEvent="Page_Read" PageParameter="page" Timed="true" />
				<SplashPage ux:Template="splash" router="router"/>
				<HomePage ux:Template="home" router="router"/>
			</Navigator>

	*/
	public class AnalyticsLogNavigation : Behavior
	{
		public string PageEvent {
			get; set;
		}
		public string PageParameter {
			get; set;
		}
		public bool Timed {
			get; set;
		}

		bool active = false;
		public void OnActivePageChanged(object r, Fuse.Visual v) {
		    if defined(mobile) {
		    	if (active && Timed) {
		    		Flurry.Analytics.EndTimedEvent(PageEvent, null, null, 0);
		    	}
		    	var keys = new string[] { PageParameter };
		    	var vals = new string[] { v.Name };
		    	Flurry.Analytics.LogEvent(PageEvent, keys, vals, 1, Timed);
		    	active = true;
		    }
		}

        Fuse.Navigation.INavigation _navigation = null;
        public Fuse.Navigation.INavigation Navigation {
            get { return _navigation; }
            set {
                // Remove old handler:
                if (_navigation != null) {
	                _navigation.ActivePageChanged -= OnActivePageChanged;
                }

                // Set value
                _navigation = value;

                // Add new handler:
                if (_navigation != null) {
	                _navigation.ActivePageChanged += OnActivePageChanged;
                }
            }
        }

	}
}
