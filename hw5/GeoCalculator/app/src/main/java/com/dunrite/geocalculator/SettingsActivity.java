package com.dunrite.geocalculator;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import butterknife.BindView;
import butterknife.ButterKnife;

public class SettingsActivity extends AppCompatActivity {
    @BindView(R.id.bearingGroup) RadioGroup bearingGroup;
    @BindView(R.id.radioDeg) RadioButton radioDeg;
    @BindView(R.id.radioMil) RadioButton radioMil;

    @BindView(R.id.distanceGroup) RadioGroup distanceGroup;
    @BindView(R.id.radioKM) RadioButton radioKM;
    @BindView(R.id.radioMI) RadioButton radioMI;

    @BindView(R.id.fab) FloatingActionButton fab;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);
        ButterKnife.bind(this);

        fab.setOnClickListener(v -> {
            Intent intent = new Intent(SettingsActivity.this, MainActivity.class);

            if (distanceGroup.getCheckedRadioButtonId() == R.id.radioKM)
                intent.putExtra("distance", "Kilometers");
            else
                intent.putExtra("distance", "Miles");

            if (bearingGroup.getCheckedRadioButtonId() == R.id.radioDeg)
                intent.putExtra("bearing", "Degrees");
            else
                intent.putExtra("bearing", "Mils");
            startActivityForResult(intent, Const.SETTINGS_REQ_CODE);
            finish();
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.d("fromMain", "" + requestCode);
        if (requestCode == Const.MAIN_REQ_CODE) {
            if (data.getStringExtra("distance").equals("Kilometers"))
                distanceGroup.check(R.id.radioKM);
            else
                distanceGroup.check(R.id.radioMI);

            if(data.getStringExtra("bearing").equals("Degrees"))
                bearingGroup.check(R.id.radioDeg);
            else
                bearingGroup.check(R.id.radioMil);
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }
}
