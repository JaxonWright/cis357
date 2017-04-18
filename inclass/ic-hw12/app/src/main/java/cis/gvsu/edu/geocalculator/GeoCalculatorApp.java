package cis.gvsu.edu.geocalculator;

import android.app.Application;

import net.danlew.android.joda.JodaTimeAndroid;

/**
 * Created by engeljo on 3/23/17.
 */

public class GeoCalculatorApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        JodaTimeAndroid.init(this);
    }
}

