using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;
using Toybox.WatchUi;

const MINUTE_FORMAT = "%02d";

class CountdownPicker extends WatchUi.Picker {

    function initialize() {
    
        var title = new WatchUi.Text({
	        :text=>Rez.Strings.IntervalTitle, 
	        :locX=>WatchUi.LAYOUT_HALIGN_CENTER, 
	        :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, 
	        :color=>Graphics.COLOR_WHITE
	    });
        
        var factories;
        var hourFactory;
        var numberFactories;

        factories = new [5];
        factories[0] = new NumberFactory(0, 23, 1, {});
        factories[1] = new WatchUi.Text({:text=>Rez.Strings.TimeSeparator, :font=>Graphics.FONT_MEDIUM, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER, :color=>Graphics.COLOR_WHITE});
        factories[2] = new NumberFactory(0, 59, 1, {:format=>MINUTE_FORMAT});
        factories[3] = new WatchUi.Text({:text=>Rez.Strings.TimeSeparator, :font=>Graphics.FONT_MEDIUM, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER, :color=>Graphics.COLOR_WHITE});
        factories[4] = new NumberFactory(0, 59, 1, {:format=>MINUTE_FORMAT});

		var seconds = Application.getApp().getProperty(CountdownProperties.INTERVAL);
		if (seconds == null) {
			seconds = 30 * 60;
		}
		
   		var hours = seconds / 3600;
		var remainder = seconds % 3600; 
		var minutes = remainder / 60; 
		seconds = remainder % 60;
		
        var defaults = new [5];
		defaults[0] = hours;
		defaults[2] = minutes;
		defaults[4] = seconds;

        Picker.initialize({:title=>title, :pattern=>factories, :defaults=>defaults});

    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class CountdownPickerDelegate extends WatchUi.PickerDelegate {

    function initialize() {
    	PickerDelegate.initialize();
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        var time = values[0] * 3600 + values[2] * 60 + values[4];
        Application.getApp().setProperty(CountdownProperties.INTERVAL, time);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}
