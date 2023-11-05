package com.laser_scanner.laser_scanner.scanner;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.device.ScanManager;
import android.device.scanner.configuration.Constants;
import android.device.scanner.configuration.PropertyID;
import android.device.scanner.configuration.Symbology;
import android.device.scanner.configuration.Triggering;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.preference.CheckBoxPreference;
import android.preference.EditTextPreference;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.PreferenceFragment;
import android.preference.PreferenceManager;
import android.preference.PreferenceScreen;
import android.preference.SwitchPreference;
import android.provider.SyncStateContract;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.laser_scanner.laser_scanner.LaserScannerPlugin;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;
/**
 * ScanManagerDemo
 *
 * @author shenpidong
 * @effect Introduce the use of android.device.ScanManager
 * @date 2020-03-06
 * @description , Steps to use ScanManager:
 * 1.Obtain an instance of BarCodeReader with ScanManager scan = new ScanManager().
 * 2.Call openScanner to power on the barcode reader.
 * 3.After that, the default output mode is TextBox Mode that send barcode data to the focused text box. User can check the output mode using getOutputMode and set the output mode using switchOutputMode.
 * 4.Then, the default trigger mode is manually trigger signal. User can check the trigger mode using getTriggerMode and set the trigger mode using setTriggerMode.
 * 5.If necessary, check the current settings using getParameterInts or set the scanner configuration properties PropertyID using setParameterInts.
 * 6.To begin a decode session, call startDecode. If the configured PropertyID.WEDGE_KEYBOARD_ENABLE is 0, your registered broadcast receiver will be called when a successful decode occurs.
 * 7.If the output mode is intent mode, the captured data is sent as an implicit Intent. An application interestes in the scan data should register an action as android.intent.ACTION_DECODE_DATA broadcast listerner.
 * 8.To get a still image through an Android intent. Register the "scanner_capture_image_result" broadcast reception image, trigger the scan to listen to the result output and send the "action.scanner_capture_image" broadcast request to the scan service to output the image.
 * 9.Call stopDecode to end the decode session.
 * 10.Call closeScanner to power off the barcode reader.
 * 11.Can set parameters before closing the scan service.
 */
public class ScannerManagerHelper {
    Context context;
    public ScannerManagerHelper(Context context){
        this.context = context;
        mScanManager = new ScanManager();
    };
    private static final String TAG = "ScanManagerDemo";
    private static final boolean DEBUG = true;

    private static final String ACTION_DECODE = ScanManager.ACTION_DECODE;   // default action
    private static final String ACTION_DECODE_IMAGE_REQUEST = "action.scanner_capture_image";
    private static final String ACTION_CAPTURE_IMAGE = "scanner_capture_image_result";
    private static final String BARCODE_STRING_TAG = ScanManager.BARCODE_STRING_TAG;
    private static final String BARCODE_TYPE_TAG = ScanManager.BARCODE_TYPE_TAG;
    private static final String BARCODE_LENGTH_TAG = ScanManager.BARCODE_LENGTH_TAG;
    private static final String DECODE_DATA_TAG = ScanManager.DECODE_DATA_TAG;

    private static final String DECODE_ENABLE = "decode_enable";
    private static final String DECODE_TRIGGER_MODE = "decode_trigger_mode";
    private static final String DECODE_TRIGGER_MODE_HOST = "HOST";
    private static final String DECODE_TRIGGER_MODE_CONTINUOUS = "CONTINUOUS";
    private static final String DECODE_TRIGGER_MODE_PAUSE = "PAUSE";

    private static final int DECODE_OUTPUT_MODE_INTENT = 0;
    private static final int DECODE_OUTPUT_MODE_FOCUS = 1;
    private static final String DECODE_OUTPUT_MODE = "decode_output_mode";
    private static final String DECODE_CAPTURE_IMAGE_KEY = "bitmapBytes";
    private static final String DECODE_CAPTURE_IMAGE_SHOW = "scan_capture_image";

    private ScanManager mScanManager = null;
    private static boolean mScanEnable = true;
    private static boolean mScanCaptureImageShow = false;

    private static final int MSG_SHOW_SCAN_RESULT = 1;
    private static final int MSG_SHOW_SCAN_IMAGE = 2;
    HashMap<String,Object> result = new HashMap<String,Object>();

    private BroadcastReceiver mReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            LogI("onReceive , action:" + action);

            // Get Scan Image . Make sure to make a request before getting a scanned image
            if (ACTION_CAPTURE_IMAGE.equals(action)) {
                byte[] imagedata = intent.getByteArrayExtra(DECODE_CAPTURE_IMAGE_KEY);
                if (imagedata != null && imagedata.length > 0) {
                    Bitmap bitmap = BitmapFactory.decodeByteArray(imagedata, 0, imagedata.length);
                    Message msg = mHandler.obtainMessage(MSG_SHOW_SCAN_IMAGE);
                    msg.obj = bitmap;
                    mHandler.sendMessage(msg);
                } else {
                    LogI("onReceive , ignore imagedata:" + imagedata);
                }
            } else {
                result = new HashMap<>();
                // Get scan results, including string and byte data etc.
                byte[] barcode = intent.getByteArrayExtra(DECODE_DATA_TAG);
                int barcodeLen = intent.getIntExtra(BARCODE_LENGTH_TAG, 0);
                byte temp = intent.getByteExtra(BARCODE_TYPE_TAG, (byte) 0);
                String barcodeStr = intent.getStringExtra(BARCODE_STRING_TAG);
                LogI("barcode type:" + temp);
                String scanResult = new String(barcode, 0, barcodeLen);
                result.put("length",barcodeLen);
                result.put("barcode",scanResult);
                result.put("bytesToHexString",bytesToHexString(barcode));
                result.put("barcodeStr",barcodeStr);
                if (mScanCaptureImageShow) {
                    // Request images of this scan
                    context.sendBroadcast(new Intent(ACTION_DECODE_IMAGE_REQUEST));
                }else{
                    //HashMap<String,Object> scanResultMap = new HashMap<String,Object>();
                    Message msg = mHandler.obtainMessage(MSG_SHOW_SCAN_RESULT);
                    msg.obj = result;
                    mHandler.sendMessage(msg);
                }
            }
        }
    };

    @SuppressLint("HandlerLeak")
    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what) {
                case MSG_SHOW_SCAN_RESULT:
                    HashMap<String,Object> scanResult = (HashMap<String,Object>) msg.obj;
                    if(LaserScannerPlugin.attachEvent != null){
                        LaserScannerPlugin.attachEvent.success(scanResult);
                    }
                    break;
                case MSG_SHOW_SCAN_IMAGE:
                    if (mScanCaptureImageShow) {
                        Bitmap bitmap = (Bitmap) msg.obj;
                        result.put("image",convertBipmapToByte(bitmap));
                        LaserScannerPlugin.attachEvent.success(result);
                    }
                    break;
            }
        }
    };


    private byte[] convertBipmapToByte(Bitmap bitmap){
        Bitmap.CompressFormat format = Bitmap.CompressFormat.PNG; // or CompressFormat.JPEG for JPEG format
        int quality = 100; // Set the quality (0-100), only applicable for JPEG format

        // Convert the Bitmap to a byte array
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(format, quality, stream);
        byte[] byteArray = stream.toByteArray();
        return byteArray;
    }


    public void setCaptureImageShow(boolean enable){
        mScanCaptureImageShow = enable;
    }


    /**
     * @param register , ture register , false unregister
     */
    public void registerReceiver(boolean register) {
        if (register && mScanManager != null) {
            IntentFilter filter = new IntentFilter();
            int[] idbuf = new int[]{PropertyID.WEDGE_INTENT_ACTION_NAME, PropertyID.WEDGE_INTENT_DATA_STRING_TAG};
            String[] value_buf = mScanManager.getParameterString(idbuf);
            if (value_buf != null && value_buf[0] != null && !value_buf[0].equals("")) {
                filter.addAction(value_buf[0]);
            } else {
                filter.addAction(ACTION_DECODE);
            }
            filter.addAction(ACTION_CAPTURE_IMAGE);

            context.registerReceiver(mReceiver, filter);
        } else if (mScanManager != null) {
            mScanManager.stopDecode();
            context.unregisterReceiver(mReceiver);
        }
    }

    /**
     * byte[] toHex String
     *
     * @param src
     * @return String
     */
    public static String bytesToHexString(byte[] src) {
        StringBuilder stringBuilder = new StringBuilder("");
        if (src == null || src.length <= 0) {
            return null;
        }
        for (int i = 0; i < src.length; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);
            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
        }
        return stringBuilder.toString();
    }



    private void updateCaptureImage() {
//        if (mScanImage == null) {
//            LogI("updateCaptureImage ignore.");
//            return;
//        }
//        if (mScanCaptureImageShow) {
//            mScanImage.setVisibility(View.VISIBLE);
//        } else {
//            mScanImage.setVisibility(View.INVISIBLE);
//        }
    }


    // Init scan
    public void initScan(boolean captureImageShow) {
        mScanCaptureImageShow = captureImageShow;
        openScanner();
        /*
        mScanManager = new ScanManager();
        mScanManager.openScanner();
        initBarcodeParameters();*/
    }

    public boolean getStatusOfScan(){
        boolean powerOn = mScanManager.getScannerState();
        return powerOn;
    }

    /**
     * ScanManager.getOutputMode
     *
     * @return
     */
    public int getScanOutputMode() {
        int mode = mScanManager.getOutputMode();
        return mode;
    }

    /**
     * ScanManager.switchOutputMode
     *
     * @param mode
     */
    public void setScanOutputMode(int mode) {
        int currentMode = getScanOutputMode();
        if (mode != currentMode && (mode == DECODE_OUTPUT_MODE_FOCUS ||
                mode == DECODE_OUTPUT_MODE_INTENT)) {
            mScanManager.switchOutputMode(mode);
        } else {
            LogI("setScanOutputMode , ignore update Output mode:" + mode);
        }
    }

    /**
     * ScanManager.getTriggerMode
     *
     * @return
     */
    public Triggering getTriggerMode() {
        if(mScanManager == null){
            mScanManager = new ScanManager();
        }
        Triggering mode = mScanManager.getTriggerMode();
        return mode;
    }


    /**
     * ScanManager.setTriggerMode
     *
     * @param mode value : Triggering.HOST, Triggering.CONTINUOUS, or Triggering.PULSE.
     */
    public void setTrigger(Triggering mode) {
        Triggering currentMode = getTriggerMode();
        LogD("setTrigger , mode;" + mode + ",currentMode:" + currentMode);
        if (mode != currentMode) {
            mScanManager.setTriggerMode(mode);
        } else {
            LogI("setTrigger , ignore update Trigger mode:" + mode);
        }
    }



    /**
     * ScanManager.getTriggerLockState
     *
     * @return
     */
    public boolean getlockTriggerState() {
        boolean state = mScanManager.getTriggerLockState();
        return state;
    }

    /**
     * ScanManager.lockTrigger and ScanManager.unlockTrigger
     *
     * @param state value ture or false
     */
    public void updateLockTriggerState(boolean state) {
        boolean currentState = getlockTriggerState();
        if (state != currentState) {
            if (state) {
                mScanManager.lockTrigger();
            } else {
                mScanManager.unlockTrigger();
            }
        } else {
            LogI("updateLockTriggerState , ignore update lockTrigger state:" + state);
        }
    }

    /**
     * ScanManager.startDecode
     */
    public void startDecode() {
        boolean lockState = getlockTriggerState();
        if (lockState) {
            LogI("startDecode ignore, Scan lockTrigger state:" + lockState);
            return;
        }
        if (mScanManager != null) {
            mScanManager.startDecode();
        }
    }

    /**
     * ScanManager.stopDecode
     */
    public void stopDecode() {
        if (mScanManager != null) {
            mScanManager.stopDecode();
        }
    }

    /**
     * ScanManager.closeScanner
     *
     * @return
     */
    public boolean closeScanner() {
        boolean state = false;
        if (mScanManager != null) {
            mScanManager.stopDecode();
            state = mScanManager.closeScanner();
        }
        return state;
    }

    /**
     * Obtain an instance of BarCodeReader with ScanManager
     * ScanManager.getScannerState
     * ScanManager.openScanner
     * ScanManager.enableAllSymbologies
     *
     * @return
     */
    private boolean openScanner() {
        if(mScanManager == null){
            mScanManager = new ScanManager();
        }
        boolean powerOn = mScanManager.getScannerState();
        if (!powerOn) {
            powerOn = mScanManager.openScanner();
            if (!powerOn) {
                return false;
            }
        }
        mScanManager.enableAllSymbologies(true);   // or execute enableSymbologyDemo() || enableSymbologyDemo2() is the same.
        setTrigger(getTriggerMode());
        setScanOutputMode(getScanOutputMode());
        return powerOn;
    }

    /**
     * ScanManager.enableSymbology
     *
     * @param symbology
     * @param enable
     * @return
     */
    public boolean enableSymbology(Symbology symbology, boolean enable) {
        boolean result = false;
        boolean isSupportBarcode = mScanManager.isSymbologySupported(symbology);
        if (isSupportBarcode) {
            boolean isEnableBarcode = mScanManager.isSymbologyEnabled(symbology);
            if (!isEnableBarcode) {
                mScanManager.enableSymbology(symbology, enable);
                result = true;
            } else {
                result = isEnableBarcode;
                LogI("enableSymbology , ignore " + symbology + " barcode is enable.");
            }
        } else {
            LogI("enableSymbology , ignore " + symbology + " barcode not Support.");
        }
        return result;
    }

    public void setUnVibrate(Triggering triggering){
        mScanManager.setUnVibrate();
    }
    public void setVibrate(Triggering triggering){
        mScanManager.setVibrate();
    }

    private void LogD(String msg) {
        if (DEBUG) {
            android.util.Log.d(TAG, msg);
        }
    }

    private void LogI(String msg) {
        android.util.Log.i(TAG, msg);
    }

}

