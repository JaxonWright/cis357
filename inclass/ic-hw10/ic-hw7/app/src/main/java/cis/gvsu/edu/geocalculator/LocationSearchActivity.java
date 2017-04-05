package cis.gvsu.edu.geocalculator;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.DatePicker;
import android.widget.EditText;

import com.borax12.materialdaterangepicker.date.DatePickerDialog;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import com.google.android.gms.location.places.Place;
import com.google.android.gms.location.places.ui.PlaceAutocomplete;

import org.joda.time.DateTime;

import java.util.Calendar;
import java.util.Locale;

import butterknife.BindView;
import butterknife.OnClick;

public class LocationSearchActivity extends AppCompatActivity implements DatePickerDialog.OnDateSetListener{

    int PLACE_AUTOCOMPLETE_REQUEST_CODE = 1;

    @BindView(R.id.locationStart) EditText locationStart;
    @BindView(R.id.locationEnd) EditText locationEnd;
    @BindView(R.id.tripDate) EditText tripDateText;

    private DateTime tripDate;
    private DatePickerDialog dpDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_location_search);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        DateTime today = DateTime.now();
//        dpDialog = DatePickerDialog.newInstance((DatePickerDialog.OnDateSetListener) this, today.getYear(), today.getMonthOfYear() - 1, today.getDayOfMonth());

//        tripDateText.setText(formatted(today));


        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });
    }

    @OnClick(R.id.locationStart)
    public void locationStartPressed(){
        try {
            Intent intent =
                    new PlaceAutocomplete.IntentBuilder(PlaceAutocomplete.MODE_FULLSCREEN)
                            .build(this);
            startActivityForResult(intent, PLACE_AUTOCOMPLETE_REQUEST_CODE);
        } catch (GooglePlayServicesRepairableException e) {
            e.printStackTrace();
        } catch (GooglePlayServicesNotAvailableException e) {
            e.printStackTrace();
        }
    }

    @OnClick(R.id.locationEnd)
    public void locationEndPressed(){
        try {
            Log.d(TAG, "locationEndPressed: ");
            Intent intent =
                    new PlaceAutocomplete.IntentBuilder(PlaceAutocomplete.MODE_FULLSCREEN)
                            .build(this);
            startActivityForResult(intent, PLACE_AUTOCOMPLETE_REQUEST_CODE);
        } catch (GooglePlayServicesRepairableException e) {
            e.printStackTrace();
        } catch (GooglePlayServicesNotAvailableException e) {
            e.printStackTrace();
        }
    }

    @OnClick(R.id.tripDate)
    public void datePressed() {
        DialogFragment newFragment = new DatePickerFragment();
        newFragment.show(getSupportFragmentManager(), "date picker");
    }

    private String formatted(DateTime d) {
        return d.monthOfYear().getAsShortText(Locale.getDefault()) + " " +
                d.getDayOfMonth() + ", " + d.getYear();
    }

    @Override
    public void onDateSet(DatePickerDialog view, int year, int monthOfYear, int dayOfMonth, int yearEnd, int monthOfYearEnd, int dayOfMonthEnd) {
        tripDate = new DateTime(year, monthOfYear+1, dayOfMonth, 0, 0);
        tripDateText.setText(formatted(tripDate));
    }

    public static class DatePickerFragment extends DialogFragment implements android.app.DatePickerDialog.OnDateSetListener{

        @Override
        public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {

        }

        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState){
            final Calendar c = Calendar.getInstance();
            int year = c.get(Calendar.YEAR);
            int month = c.get(Calendar.MONTH);
            int day = c.get(Calendar.DAY_OF_MONTH);
            return new android.app.DatePickerDialog(getActivity(), this, year, month, day);
        }
    }
}
