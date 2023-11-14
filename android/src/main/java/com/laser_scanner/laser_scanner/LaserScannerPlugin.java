package com.laser_scanner.laser_scanner;

import android.content.Context;
import android.device.scanner.configuration.Symbology;
import android.device.scanner.configuration.Triggering;
import android.util.Log;

import androidx.annotation.NonNull;

import com.laser_scanner.laser_scanner.events.ResultEventChannel;
import com.laser_scanner.laser_scanner.scanner.ScannerManagerHelper;

import java.util.HashMap;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** LaserScannerPlugin */
public class LaserScannerPlugin implements FlutterPlugin, MethodCallHandler {
  Context context;
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private EventChannel scannerResultEvent;
  private static final String STREAM = "com.laser_scanner.laser_scanner.flutter_event_channel/scanner_result";
  public static EventChannel.EventSink attachEvent;
  private BinaryMessenger binaryMessenger;
  public EventChannel.EventSink getAttachEvent(){
    return attachEvent;
  }
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    binaryMessenger = flutterPluginBinding.getBinaryMessenger();
    channel = new MethodChannel(binaryMessenger, "laser_scanner");
    scannerResultEvent = new EventChannel(flutterPluginBinding.getBinaryMessenger(),STREAM);


    channel.setMethodCallHandler(this);
  }





  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    ScannerManagerHelper scanner = new ScannerManagerHelper(context);
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }else if(call.method.equals("isSupport")){
      boolean isSupport =  scanner.isSupport();
      result.success(isSupport);
    } else if(call.method.equals("openScanner")){
      // Call function open scanner.
      boolean captureImageShow = (boolean)call.arguments;
      scanner.initScan(captureImageShow);
      scanner.registerReceiver(true);
      result.success(null);
    }else if(call.method.equals("closeScanner")){
      boolean status =  scanner.closeScanner();
      result.success(status);
    }else if(call.method.equals("onListenerResultScanner")){
      eventChannelRegister();
      result.success(null);
    } else if(call.method.equals("isTurnOn")){
      boolean status = scanner.getStatusOfScan();
      result.success(status);
    }else if(call.method.equals("getScanOutputMode")){
      int status = scanner.getScanOutputMode();
      result.success(status);
    }else if(call.method.equals("setScanOutputMode")){
      int mode = ( int)call.arguments;
      scanner.setScanOutputMode(mode);
      result.success(null);
    }else if(call.method.equals("setTrigger")){
      int triggeringIndex = ( int)call.arguments;
      Triggering triggering = fromInt(triggeringIndex);
      scanner.setTrigger(triggering);
      result.success(null);
    }else if(call.method.equals("getTriggerMode")){
      Triggering triggering = scanner.getTriggerMode();
      result.success(triggering.toInt());
    } else if(call.method.equals("getlockTriggerState")){
      boolean status = scanner.getlockTriggerState();
      result.success(status);
    }else if(call.method.equals("setlockTriggerState")){
      boolean state = (boolean)call.arguments;
      scanner.updateLockTriggerState(state);
      result.success(null);
    }else if(call.method.equals("enableSymbology")){
      HashMap<String,Object> arg = (HashMap<String,Object>)call.arguments;
      boolean enable = (boolean)arg.get("enable");
      int symbology = (int)arg.get("symbology");
      Symbology symbologyScan = Symbology.fromInt(symbology);
      boolean enableSymbology = scanner.enableSymbology(symbologyScan,enable);
      result.success(enableSymbology);
    }else if(call.method.equals("setUnVibrate")){
      result.success(null);
    }else if(call.method.equals("setVibrate")){
      result.success(null);
    } else if(call.method.equals("startDecode")){
      scanner.startDecode();
      result.success(null);
    } else if(call.method.equals("stopDecode")){
      scanner.stopDecode();
      result.success(null);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }


  private void eventChannelRegister(){
    scannerResultEvent.setStreamHandler(
            new EventChannel.StreamHandler() {
              @Override
              public void onListen(Object args, final EventChannel.EventSink events) {
                attachEvent = events;
              }

              @Override
              public void onCancel(Object args) {
                attachEvent = null;
                System.out.println("StreamHandler - onCanceled: ");
              }
            }
    );
  }

  public Triggering fromInt(int n) {
    for(int i = 0; i < Triggering.values().length; ++i) {
      if (Triggering.values()[i].toInt() == n) {
        return Triggering.values()[i];
      }
    }
    return Triggering.HOST;
  }

}
