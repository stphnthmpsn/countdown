using Toybox.WatchUi;
using Toybox.Attention;

class CountdownView extends WatchUi.View {

	var _timer = null;
	var _time = "";
	var _label = Rez.Strings.Stopped;
	
    function initialize() {
        View.initialize();
    }

	function timerCallback() {
		var app = Application.getApp();

   		var state = app.getProperty(CountdownProperties.STATE);
		
		var remaining;
		
		if (CountdownState.RUNNING != state && null != _timer) {
			_timer.stop();
			_timer = null;
		}

		if (CountdownState.RUNNING == state) {
  			var now = new Time.Moment(Time.now().value());
  			var endValue = app.getProperty(CountdownProperties.END);
  			var end = new Time.Moment(endValue);
  			
  			if (now.greaterThan(end)) {
				_timer.stop();
				_timer = null;
				app.setProperty(CountdownProperties.STATE, CountdownState.STOPPED);
				_time = Rez.Strings.Finished;
  				_label = Rez.Strings.Stopped;
				
				if (Attention has :playTone) {
				   Attention.playTone(Attention.TONE_TIME_ALERT);
				}
				
  			} else {  		
  				
  				remaining = end.subtract(now).value();
  				
  				if (remaining < 3 && Attention has :playTone) {
  					Attention.playTone(Attention.TONE_KEY);
  				}
  				
  				_time = formatTime(remaining);
  				_label = Rez.Strings.Running;
  			}
  			
  		} else if (CountdownState.PAUSED == state) {
  			remaining = app.getProperty(CountdownProperties.REMAINING);
  			_time = formatTime(remaining);
  			_label = Rez.Strings.Paused;
  			
 		} else {
 			_time = "";
 			_label = "";
 		}
 		
		WatchUi.requestUpdate();
	}
	
    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));  	
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
         if (_timer == null && CountdownState.RUNNING == Application.getApp().getProperty(CountdownProperties.STATE)) {
 		    _timer = new Timer.Timer();
    		_timer.start(method(:timerCallback), 1000, true);
    	}
 
   		draw();
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc); 	
     }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

	function draw() {
        var stateUi = findDrawableById("state");
        var startUi = findDrawableById("time");
   		stateUi.setText(_label);
   		startUi.setText(_time);
   	}
   	
   	function formatTime(seconds) {
   		var hours = seconds / 3600;
		var remainder = seconds % 3600; 
		var minutes = remainder / 60; 
		seconds = remainder % 60;
		
		return Lang.format(
    		"$1$:$2$:$3$",
    		[hours.format("%02d"), minutes.format("%02d"), seconds.format("%02d")]
		);
   	}
}
