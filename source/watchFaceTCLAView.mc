import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.UserProfile;
import Toybox.ActivityMonitor;
import Toybox.Time;
import Toybox.Time.Gregorian;


class watchFaceTCLAView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeDisplay") as Text;
        view.setText(timeString);
        setBatteryDisplay();
        setTotalWeekDistance();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    hidden function setBatteryDisplay() {
        var battery = System.getSystemStats().battery;
        var batteryDisplay = View.findDrawableById("BatteryDisplay") as Text;
        batteryDisplay.setText(battery.format("%d")+"%");
    }

    hidden function setTotalWeekDistance(){  
      var userActivityIterator = UserProfile.getUserActivityHistory();
      var sample = userActivityIterator.next();                        // get the user activity data
      //var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
      var today = new Time.Moment(Time.today().value());
      var sFormat = sample.startTime;
      //sFormat = Gregorian.info(sample.startTime, Time.FORMAT_MEDIUM); 

      //System.println("Sample Start Time: " + sFormat);

      var secondsDifference = today.subtract(sFormat);
      var daysDifference = (secondsDifference.value()/86400);
      var totalWeekDistance= 0;
      //System.println("Time Difference: " + daysDifference);

      if (sample != null && daysDifference <=7) {
        System.println("Sample Distance: " + sample.distance);        // print the current sample
        totalWeekDistance = totalWeekDistance + (sample.distance);
        //System.println("Start Time: " + sample.startTime);        // print the current sample
        sample = userActivityIterator.next();

      }else{
        var weekDistanceDisplay = View.findDrawableById("totalWeekDistance") as Text;
        weekDistanceDisplay.setText(totalWeekDistance.toString());
      }

    }

}
