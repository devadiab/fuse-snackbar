using Uno;
using Uno.UX;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;
using Uno.Threading;

using Uno.Compiler.ExportTargetInterop;

[ForeignInclude(Language.Java, "android.os.*")]
[ForeignInclude(Language.Java, "java.io.*")]
[ForeignInclude(Language.Java, "android.graphics.Bitmap")]
[ForeignInclude(Language.Java, "android.util.Log")]
[ForeignInclude(Language.Java, "android.app.Activity")]
[ForeignInclude(Language.Java, "android.view.View")]
[ForeignInclude(Language.Java, "android.view.ViewGroup")]
//[ForeignInclude(Language.Java, "android.support.design.widget.CoordinatorLayout")]
[ForeignInclude(Language.Java, "androidx.appcompat.app.AppCompatActivity")]
[ForeignInclude(Language.Java, "androidx.coordinatorlayout.widget.CoordinatorLayout")]
[ForeignInclude(Language.Java, "android.content.res.Resources")]
[ForeignInclude(Language.Java, "android.widget.FrameLayout")]
[UXGlobalModule]

public class Snackbar  : NativeModule
{
	static readonly Snackbar _instance;
	public Snackbar ()
	{
        if (_instance != null) return;
    	_instance = this;
		Resource.SetGlobalKey(_instance, "Snackbar");
		AddMember(new NativePromise<string, string>("Show", ShowAsync, null));
	}

	static Future<string>  ShowAsync (object[] args) 
	{
		if defined(Android)
		{
			ClickAction = new Promise<string>();
			showSnackbar(args[0] as string,args[1] as string,Marshal.ToType<int>(args[2]));
			return ClickAction;
		}
		return null;
	}

	static Promise<string> ClickAction {
			get; set;
	}

	public static void Clicked () {
		ClickAction.Resolve("");
	}

	[Foreign(Language.Java)]
	static extern(Android) void showSnackbar(string message,string action,int duration)
	@{

        final Activity context = com.fuse.Activity.getRootActivity();
        context.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                View viewGroup = context.getWindow().getDecorView().getRootView();
                //android.support.design.widget.Snackbar mySnackbar = android.support.design.widget.Snackbar.make(
		com.google.android.material.snackbar.Snackbar mySnackbar = com.google.android.material.snackbar.Snackbar.make(
                        viewGroup,
                        message,
                        duration);
                View sbView = mySnackbar.getView();
                FrameLayout.LayoutParams lp= (FrameLayout.LayoutParams)sbView.getLayoutParams();
                Resources resources = context.getResources();
                int resourceId = resources.getIdentifier("navigation_bar_height", "dimen", "android");
                if (resourceId > 0) {
                    lp.bottomMargin = resources.getDimensionPixelSize(resourceId);
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    sbView.setZ(1000);
                }
                mySnackbar.setAction(action, new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        @{Clicked():Call()};
                    }
                });
                mySnackbar.show();
                sbView.bringToFront();

            }
        });
	@}
}
