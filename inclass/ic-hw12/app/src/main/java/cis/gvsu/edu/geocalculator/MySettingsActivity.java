package cis.gvsu.edu.geocalculator;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;

public class MySettingsActivity extends AppCompatActivity {
    private String bearingUnits = "degrees";
    private String distanceUnits = "kilometers";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my_settings);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                //        .setAction("Action", null).show();
                Intent intent = new Intent();
                intent.putExtra("bearingUnits", bearingUnits);
                intent.putExtra("distanceUnits", distanceUnits);
                setResult(MainActivity.SETTINGS_RESULT,intent);
                finish();
            }
        });

        Spinner spinnerDistance = (Spinner) findViewById(R.id.distance_units);
        ArrayAdapter<CharSequence> adapterDistance = ArrayAdapter.createFromResource(this,
                R.array.distance, android.R.layout.simple_spinner_item);
        adapterDistance.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinnerDistance.setAdapter(adapterDistance);

        spinnerDistance.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                distanceUnits = (String) adapterView.getItemAtPosition(i);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        Spinner spinnerBearing  = (Spinner) findViewById(R.id.bearing_units);
        ArrayAdapter<CharSequence> adapterBearing = ArrayAdapter.createFromResource(this,
                R.array.bearing, android.R.layout.simple_spinner_item);
        adapterBearing.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinnerBearing.setAdapter(adapterBearing);
        spinnerBearing.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                bearingUnits = (String) adapterView.getItemAtPosition(i);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }

}
