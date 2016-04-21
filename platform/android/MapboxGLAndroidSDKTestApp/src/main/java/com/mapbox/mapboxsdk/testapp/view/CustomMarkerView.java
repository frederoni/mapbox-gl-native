package com.mapbox.mapboxsdk.testapp.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;

import com.mapbox.mapboxsdk.annotations.MarkerView;
import com.mapbox.mapboxsdk.testapp.R;

public class CustomMarkerView extends MarkerView{

    public CustomMarkerView(Context context) {
        super(context);
        init(context);
    }

    public CustomMarkerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public CustomMarkerView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        LayoutInflater.from(context).inflate(R.layout.view_custom_marker,this);
    }
}
