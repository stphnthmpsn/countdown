using Toybox.WatchUi;

class CountdownDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        WatchUi.pushView(new CountdownPicker(), new CountdownPickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

	function onBack() {
		return false;
	}
	    
    function onKey(keyEvent) {
    	var key = keyEvent.getKey();	
        var app = Application.getApp();
        var state = app.getProperty(CountdownProperties.STATE);
        var now = Time.now();
        var interval = app.getProperty(CountdownProperties.INTERVAL);
        var remaining;
        var finish;
        
        if (WatchUi.KEY_LAP == key || WatchUi.KEY_START == key && (CountdownState.STOPPED == state || null == state)) {
        	finish = now.add(new Time.Duration(interval));
        	app.setProperty(CountdownProperties.STATE, CountdownState.RUNNING);
        	app.setProperty(CountdownProperties.END, finish.value());
            WatchUi.requestUpdate();
            return true;        
        }
        
        if (WatchUi.KEY_START == key) {
            if (CountdownState.PAUSED == state) {
            	remaining = app.getProperty(CountdownProperties.REMAINING);
            	finish = now.add(new Time.Duration(remaining));
               	app.setProperty(CountdownProperties.STATE, CountdownState.RUNNING);
          		app.setProperty(CountdownProperties.END, finish.value());
            
            } else {
   				var endValue = app.getProperty(CountdownProperties.END);
  				finish = new Time.Moment(endValue);
  			
  				if (now.greaterThan(finish)) {
            		app.setProperty(CountdownProperties.STATE, CountdownState.STOPPED);
            	} else {
            		app.setProperty(CountdownProperties.STATE, CountdownState.PAUSED);
             		remaining = finish.subtract(now).value();
            		app.setProperty(CountdownProperties.REMAINING, remaining);
            	}
            }
            WatchUi.requestUpdate();
            return true;
        }

        return false;
    }
    
    function start() {
    
    }
    
}