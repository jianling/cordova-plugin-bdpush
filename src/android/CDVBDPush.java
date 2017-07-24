/**
 * Baidu Push plugin for Cordova / Phonegap
 */
package com.baidu;

import com.baidu.android.pushservice.PushConstants;
import com.baidu.android.pushservice.PushManager;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

public class CDVBDPush extends CordovaPlugin {

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    @Override
    public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext)
            throws JSONException {
        if (action.equals("registerNotifications")) {
            PushManager.startWork(cordova.getActivity().getApplicationContext(), PushConstants.LOGIN_TYPE_API_KEY, "L6ys6wMUmyvvCMV8BCuX7R4q");
        }
        else if (action.equals("unregisterNotifications")) {
            PushManager.stopWork(cordova.getActivity().getApplicationContext());
        }
        else {
            return false;
        }

        return true;
    }

}
