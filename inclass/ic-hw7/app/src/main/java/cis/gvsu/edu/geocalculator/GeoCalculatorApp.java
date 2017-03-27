package cis.gvsu.edu.geocalculator;

import android.app.Application;

import net.danlew.android.joda.JodaTimeAndroid;

public class GeoCalculatorApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        JodaTimeAndroid.init(this);
    }
}
