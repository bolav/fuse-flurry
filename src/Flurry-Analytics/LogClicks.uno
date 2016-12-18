using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Navigation;
using Flurry.Analytics;

namespace Flurry
{
	/**
		Enables logging on all clicks

	*/
	public class AnalyticsLogClicks : Behavior, IParentObserver
	{
		public string ClickEvent {
			get; set;
		}
        public string ElementParameter {
            get; set;
        }
        public string ElementPathParameter {
            get; set;
        }
		public string PageParameter {
			get; set;
		}
		public string PathParameter {
			get; set;
		}

        protected override void OnRooted() {
            base.OnRooted();
            LookFor(Parent);
        }

        int depth = 0;
        void LookFor(Visual vis) {
            depth++;
            if (depth > 50) {
                return;
            }
            var c = vis.Children;
            for (int i = 0; i < c.Count; i++)
            {
                var v = c[i] as Visual;
                if (v != null) {
                    LookFor(v);
                }
                var click = c[i] as Fuse.Gestures.Clicked;
                if (click != null) {
                    click.Handler += VisClicked;
                }
            }
            depth--;
        }

        void VisClicked (object o, Fuse.Gestures.ClickedArgs a) {
            var c = o as Fuse.Gestures.Clicked;
            if (c != null) {
                var vis = c.Parent;
                if (vis != null) {
                    var k = new List<string>();
                    var v = new List<string>();
                    if (ElementParameter != null) {
                        k.Add(ElementParameter);
                        v.Add(vis.Name);                        
                    }
                    if (ElementPathParameter != null) {
                        var m = vis;
                        var path = "";
                        while (m != null) {
                            path = "/" + m.GetType() + "[" + m.Name + "]" + path;
                            m = m.Parent;
                        }
                        k.Add(ElementPathParameter);
                        v.Add(path);
                    }
                    if (Navigation != null) {
                        var router = Navigation as Router;
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
                    Flurry.Analytics.LogEvent(ClickEvent, k.ToArray(), v.ToArray(), k.Count, false);
                }

            }
        }

        void IParentObserver.OnChildAddedWhileRooted(Node n) {
            var v = n as Visual;
            if (v != null) {
                LookFor(v);
            }
        }

        void IParentObserver.OnChildRemovedWhileRooted(Node n) {
        }

        public Fuse.Navigation.IBaseNavigation Navigation {
            get; set;
        }

	}
}
