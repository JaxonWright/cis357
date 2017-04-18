package cis.gvsu.edu.geocalculator;

import android.app.Activity;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.Intent;

import android.os.Bundle;
import android.os.Parcelable;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.FragmentActivity;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.DatePicker;
import android.widget.TextView;
import android.app.DatePickerDialog;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.places.Place;
import com.google.android.gms.location.places.ui.PlaceAutocomplete;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;
import org.parceler.Parcels;

import java.util.Calendar;
import java.util.Locale;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

import static cis.gvsu.edu.geocalculator.R.id.p1;

public class LocationSearchActivity extends AppCompatActivity {
//public class LocationSearchActivity extends FragmentActivity {

    int START_AUTOCOMPLETE_REQUEST_CODE = 1;
    int END_AUTOCOMPLETE_REQUEST_CODE = 2;
    private static final String TAG = "LocationSearchActivity";
    LocationLookup location;

    @BindView(R.id.start_location) TextView startLocation;
    @BindView(R.id.end_location) TextView endLocation;
    @BindView(R.id.date) TextView dateView;


    private DateTime startDate, endDate;
    private DatePickerDialog dpDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_location_search);
        ButterKnife.bind(this);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

       // DateTime today = DateTime.now();

//        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
//        fab.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
//                        .setAction("Action", null).show();
//            }
//        });
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        location = new LocationLookup();
    }

    @OnClick(R.id.start_location)
    public void startLocationPressed() {
        this.locationPressed(START_AUTOCOMPLETE_REQUEST_CODE);
    }

    @OnClick(R.id.end_location)
    public void endLocationPressed() {
        this.locationPressed(END_AUTOCOMPLETE_REQUEST_CODE);
    }

    private void locationPressed(int whichOne) {
        try {
            Intent intent =
                    new PlaceAutocomplete.IntentBuilder(PlaceAutocomplete.MODE_FULLSCREEN)
                            .build(this);
            startActivityForResult(intent, whichOne);
        } catch (GooglePlayServicesRepairableException e) {
            e.printStackTrace();
        } catch (GooglePlayServicesNotAvailableException e) {
            e.printStackTrace();
        }
    }

    @OnClick(R.id.date)
    public void datePressed()
    {
        DialogFragment newFragment = new DatePickerFragment();
        newFragment.show(getFragmentManager(), "datePicker");
    }

    @OnClick(R.id.fab)
    public void fabPressed()
    {
        Intent result = new Intent();
        Parcelable parcel = Parcels.wrap(location);
        result.putExtra("SEARCH_RESULTS", parcel);
        setResult(RESULT_OK, result);
        finish();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (requestCode == START_AUTOCOMPLETE_REQUEST_CODE || requestCode == END_AUTOCOMPLETE_REQUEST_CODE)  {
            TextView target = requestCode == START_AUTOCOMPLETE_REQUEST_CODE ? startLocation : endLocation;
            if (resultCode == RESULT_OK) {
                Place pl = PlaceAutocomplete.getPlace(this, data);
                target.setText(pl.getName());
                if(target == startLocation) {
                    location.setOrigLat(pl.getLatLng().latitude);
                    location.setOrigLng(pl.getLatLng().longitude);
                } else {
                    location.setEndLat(pl.getLatLng().latitude);
                    location.setEndLng(pl.getLatLng().longitude);
                }
                Log.i(TAG, "onActivityResult: " + pl.getName() + "/" + pl.getAddress());
            } else if (resultCode == PlaceAutocomplete.RESULT_ERROR) {
                Status stat = PlaceAutocomplete.getStatus(this, data);
                Log.d(TAG, "onActivityResult: ");
            }
            else if (requestCode == RESULT_CANCELED){
                System.out.println("Cancelled by the user");
            }
        }
        else
            super.onActivityResult(requestCode, resultCode, data);
    }

    public static class DatePickerFragment extends DialogFragment
            implements DatePickerDialog.OnDateSetListener {

        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            // Use the current date as the default date in the picker
            final Calendar c = Calendar.getInstance();
            DateTime now = DateTime.now();

            int year = c.get(Calendar.YEAR);
            int month = c.get(Calendar.MONTH);
            int day = now.dayOfMonth().get();;

            // Create a new instance of DatePickerDialog and return it
            return new DatePickerDialog(getActivity(), this, year, month, day);
        }

        public void onDateSet(DatePicker view, int year, int month, int day) {
            DateTime d = new DateTime(year, month + 1, day, 0, 0);
            LocationSearchActivity activity = (LocationSearchActivity) getActivity();
            activity.dateView.setText(formatted(d));
        }

        private String formatted(DateTime d) {
            return d.monthOfYear().getAsShortText(Locale.getDefault()) + " " +
                    d.getDayOfMonth() + ", " + d.getYear();
        }
    }


}
