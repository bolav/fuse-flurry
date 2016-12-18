using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Navigation;
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
		public string PathParameter {
			get; set;
		}
		public bool Timed {
			get; set;
		}

		bool active = false;
		public void OnActivePageChanged(object r, Fuse.Visual vis) {
		    if defined(mobile) {
		    	if (active && Timed) {
		    		Flurry.Analytics.EndTimedEvent(PageEvent, null, null, 0);
		    	}

		    	var k = new List<string>();
		    	var v = new List<string>();

		    	if (PageParameter != null) {
		    		k.Add(PageParameter);
		    		v.Add(vis.Name);
		    	}
		    	Flurry.Analytics.LogEvent(PageEvent, k.ToArray(), v.ToArray(), k.Count, Timed);
		    	active = true;
		    }
		}

        public void OnHistoryChanged(object r) {
        	if (active && Timed) {
        		Flurry.Analytics.EndTimedEvent(PageEvent, null, null, 0);
        	}

        	var k = new List<string>();
        	var v = new List<string>();

        	if (r is Router) {
        		var router = r as Router;
        		var route = router.GetCurrentRoute();
        		var len = route.Length;
        		var path = "";
        		var page = "";
        		for (int i = 0; i < len; i++)
        		{
        			path = path + "/" + route.Path;
        			page = route.Path;
        			// debug_log route.Path;
        			// debug_log route.Parameter;
        			// debug_log route.SubRoute;
        			route = route.SubRoute;
        		}
        		if (PageParameter != null) {
        			k.Add(PageParameter);
        			v.Add(page);
        		}
        		if (PathParameter != null) {
        			k.Add(PathParameter);
        			v.Add(path);
        		}
        	}

        	Flurry.Analytics.LogEvent(PageEvent, k.ToArray(), v.ToArray(), k.Count, Timed);
        	active = true;
        }

        Fuse.Navigation.IBaseNavigation _navigation = null;
        public Fuse.Navigation.IBaseNavigation Navigation {
            get { return _navigation; }
            set {
                // Remove old handler:
                if (_navigation != null) {
                    if (_navigation is Fuse.Navigation.INavigation) {
                        var _in = _navigation as Fuse.Navigation.INavigation;
                        _in.ActivePageChanged -= OnActivePageChanged;
                    }
                    else {
                        _navigation.HistoryChanged -= OnHistoryChanged;
                    }
                }

                // Set value
                _navigation = value;

                // Add new handler:
                if (_navigation != null) {
                    if (_navigation is Fuse.Navigation.INavigation) {
                        var _in = _navigation as Fuse.Navigation.INavigation;
                        _in.ActivePageChanged += OnActivePageChanged;
                    }
                    else {
                        _navigation.HistoryChanged += OnHistoryChanged;
                    }
                }
            }
        }


	}
}
