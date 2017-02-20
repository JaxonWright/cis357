package com.dunrite.geocalculator;

import android.content.Context;
import android.location.Location;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import java.util.Locale;

/**
 * GeoCalculator app by Jaxon Wright and Kent Sinclair
 */
public class MainActivity extends AppCompatActivity {
    
    private EditText latP1, lonP1, latP2, lonP2;
    private Button calcButton, clearButton;
    private TextView distanceText, bearingText;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        latP1 = (EditText) findViewById(R.id.latitudeP1);
        lonP1 = (EditText) findViewById(R.id.longitudeP1);
        latP2 = (EditText) findViewById(R.id.latitudeP2);
        lonP2 = (EditText) findViewById(R.id.longitudeP2);

        calcButton = (Button) findViewById(R.id.calcButton);
        clearButton = (Button) findViewById(R.id.clearButton);

        distanceText = (TextView) findViewById(R.id.distanceText);
        bearingText = (TextView) findViewById(R.id.bearingText);

        calcButton.setOnClickListener(v -> {
            hideKeyboard();
            calculate();
        });
        clearButton.setOnClickListener(v -> {
            hideKeyboard();
            clear();
        });
    }

    /**
     * Hide keyboard
     * pulled from http://stackoverflow.com/questions/1109022/close-hide-the-android-soft-keyboard
     */
    private void hideKeyboard() {
        View v  = this.getCurrentFocus();
        if (v != null) {
            InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(this.getCurrentFocus().getWindowToken(), 0);
        }
    }

    /**
     * Calculates distance and bearing and displays
     */
    private void calculate() {
        if (validateValues()) {
            Location p1 = new Location("");
            Location p2 = new Location("");

            p1.setLongitude(Double.parseDouble(lonP1.getText().toString()));
            p1.setLatitude(Double.parseDouble(latP1.getText().toString()));
            p2.setLongitude(Double.parseDouble(lonP2.getText().toString()));
            p2.setLatitude(Double.parseDouble(latP2.getText().toString()));

            String dist = " " + String.format(Locale.ENGLISH, "%.2f", (p1.distanceTo(p2)/1000)) + " kilometers";
            distanceText.setText(R.string.distance);
            distanceText.append(dist);

            String bearing = " " + String.format(Locale.ENGLISH, "%.2f", p1.bearingTo(p2)) + " degrees";
            bearingText.setText(R.string.bearing);
            bearingText.append(bearing);
        }
    }

    /**
     * clears all values
     */
    private void clear() {
        latP1.setText("");
        lonP1.setText("");
        latP2.setText("");
        lonP2.setText("");

        distanceText.setText(R.string.distance);
        bearingText.setText(R.string.bearing);
    }

    /**
     * make sure all fields have values in them
     * @return valid
     */
    private boolean validateValues() {
        if(lonP1.getText().toString().equals("") || latP1.getText().toString().equals("") ||
                lonP2.getText().toString().equals("") || latP2.getText().toString().equals("")) {
            Snackbar.make(findViewById(android.R.id.content),
                    "Please Enter All Values", Snackbar.LENGTH_SHORT).show();
            return false;
        }
        return true;
    }
}
