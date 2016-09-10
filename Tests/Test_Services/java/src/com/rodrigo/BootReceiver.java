package com.embarcadero;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.Context;

public class BootReceiver extends BroadcastReceiver
{

        @Override
        public void onReceive(Context context, Intent intent) 
        {
           Intent launchintent = new Intent();
           launchintent.setClassName(context, "com.embarcadero.services.BeaconService");           
           context.startService(launchintent);  
        }

}