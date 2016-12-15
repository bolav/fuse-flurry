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

			<Router ux:Name="router"/>
			<Flurry.AnalyticsLogPageViews Navigation="router" />

	*/
	public class AnalyticsLogPageViews : Behavior
	{
        public void OnHistoryChanged(object r) {
        	Flurry.Analytics.LogPageView();
        }

        public void OnActivePageChanged(object r, Fuse.Visual v) {
        	Flurry.Analytics.LogPageView();
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
