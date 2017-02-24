package com.dunrite.geocalculator;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;
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

        Intent i = getIntent();
        if (i.hasExtra("distance") && i.getStringExtra("distance").equals("Miles"))
            distanceGroup.check(R.id.radioMI);
        else
            distanceGroup.check(R.id.radioKM);

        if(i.hasExtra("bearing") && i.getStringExtra("bearing").equals("Mils"))
            bearingGroup.check(R.id.radioMil);
        else
            bearingGroup.check(R.id.radioDeg);

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
            //startActivityForResult(intent, Const.SETTINGS_REQ_CODE);
            setResult(Const.MAIN_REQ_CODE, intent);
            finish();
        });
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                finish();
                return(true);
        }

        return(super.onOptionsItemSelected(item));
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        finish();
    }

}
