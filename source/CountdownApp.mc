using Toybox.Application;

class CountdownApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
        var state = getProperty(CountdownProperties.STATE);
        if (state == null) {
        	setProperty(CountdownProperties.STATE, CountdownState.STOPPED);
        }
        
        var interval = getProperty(CountdownProperties.INTERVAL);
        if (interval == null) {
        	setProperty(CountdownProperties.INTERVAL, 5 * 60);
        }
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new CountdownView(), new CountdownDelegate() ];
    }

}