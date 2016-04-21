package com.mapbox.mapboxsdk.testapp.activity.annotation;

import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;
import android.os.Bundle;
import android.support.annotation.DrawableRes;
import android.support.annotation.NonNull;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import com.mapbox.mapboxsdk.annotations.Marker;
import com.mapbox.mapboxsdk.annotations.MarkerOptions;
import com.mapbox.mapboxsdk.annotations.MarkerView;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.maps.MapView;
import com.mapbox.mapboxsdk.maps.MapboxMap;
import com.mapbox.mapboxsdk.maps.OnMapReadyCallback;
import com.mapbox.mapboxsdk.testapp.R;
import com.mapbox.mapboxsdk.testapp.view.CustomMarkerView;

public class ViewMarkerActivity extends AppCompatActivity {

    private MapView mMapView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_marker_view);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setDisplayHomeAsUpEnabled(true);
            actionBar.setDisplayShowHomeEnabled(true);
        }

        mMapView = (MapView) findViewById(R.id.mapView);
        mMapView.onCreate(savedInstanceState);
        mMapView.getMapAsync(new OnMapReadyCallback() {
            @Override
            public void onMapReady(@NonNull final MapboxMap mapboxMap) {
                Marker china = mapboxMap.addMarker(new MarkerOptions().position(new LatLng(31.230416, 121.473701)));
                final MarkerView chinaView = createMarkerView("cn", R.drawable.ic_china);
                china.setMarkerView(chinaView);

                Marker brazil = mapboxMap.addMarker(new MarkerOptions().position(new LatLng(-15.798200, -47.922363)));
                final MarkerView brazilView = createMarkerView("br", R.drawable.ic_brazil);
                brazil.setMarkerView(brazilView);

                final Marker us = mapboxMap.addMarker(new MarkerOptions().position(new LatLng(38.907192, -77.036871)));
                final MarkerView usView = createMarkerView("us", R.drawable.ic_us);
                us.setMarkerView(usView);

                Marker germany = mapboxMap.addMarker(new MarkerOptions().position(new LatLng(52.520007, 13.404954)));
                final MarkerView germanyView = createMarkerView("de", R.drawable.ic_germany);
                germany.setMarkerView(germanyView);

                findViewById(R.id.fab).setOnClickListener(new View.OnClickListener() {

                    private static final int ANIM_REPEAT_COUNT = 21;
                    private static final int ANIM_DURATION = 750;

                    @Override
                    public void onClick(View v) {
                        ObjectAnimator rotateAnimator = ObjectAnimator.ofFloat(germanyView, "rotation", 0f, 360f);
                        rotateAnimator.setDuration(ANIM_DURATION);
                        rotateAnimator.setRepeatMode(ValueAnimator.RESTART);
                        rotateAnimator.setRepeatCount(ANIM_REPEAT_COUNT);
                        rotateAnimator.start();

                        ObjectAnimator alphaAnimator = ObjectAnimator.ofFloat(brazilView, "alpha", 0f, 1f);
                        alphaAnimator.setDuration(ANIM_DURATION);
                        alphaAnimator.setRepeatMode(ValueAnimator.REVERSE);
                        alphaAnimator.setRepeatCount(ANIM_REPEAT_COUNT);
                        alphaAnimator.start();

                        ObjectAnimator xTranslateAnimator = ObjectAnimator.ofFloat(chinaView, "translationX", 12f);
                        xTranslateAnimator.setRepeatMode(ValueAnimator.REVERSE);
                        xTranslateAnimator.setRepeatCount(ANIM_REPEAT_COUNT);
                        ObjectAnimator yTranslateAnimator = ObjectAnimator.ofFloat(chinaView, "translationY", 4f);
                        yTranslateAnimator.setRepeatMode(ValueAnimator.REVERSE);
                        yTranslateAnimator.setRepeatCount(ANIM_REPEAT_COUNT);
                        AnimatorSet translateAnimatorSet = new AnimatorSet();
                        translateAnimatorSet.playTogether(xTranslateAnimator, yTranslateAnimator);
                        translateAnimatorSet.setDuration(ANIM_DURATION);
                        translateAnimatorSet.start();

                        ObjectAnimator xScaleAnimator = ObjectAnimator.ofFloat(usView, "scaleX", 4f);
                        xScaleAnimator.setRepeatMode(ValueAnimator.REVERSE);
                        xScaleAnimator.setRepeatCount(ANIM_REPEAT_COUNT);
                        ObjectAnimator yScaleAnimator = ObjectAnimator.ofFloat(usView, "scaleY", 2f);
                        yScaleAnimator.setRepeatMode(ValueAnimator.REVERSE);
                        yScaleAnimator.setRepeatCount(ANIM_REPEAT_COUNT-5);
                        AnimatorSet scaleAnimatorSet = new AnimatorSet();
                        scaleAnimatorSet.playTogether(xScaleAnimator, yScaleAnimator);
                        scaleAnimatorSet.setDuration(ANIM_DURATION);
                        scaleAnimatorSet.start();
                    }
                });
            }
        });
    }

    private MarkerView createMarkerView(String countryAbbrev, @DrawableRes int countryIconRes) {
        CustomMarkerView customMarkerView = new CustomMarkerView(this);
        customMarkerView.setText(countryAbbrev);
        customMarkerView.setImage(countryIconRes);
        return customMarkerView;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        mMapView.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        mMapView.onPause();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        mMapView.onSaveInstanceState(outState);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mMapView.onDestroy();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        mMapView.onLowMemory();
    }

}