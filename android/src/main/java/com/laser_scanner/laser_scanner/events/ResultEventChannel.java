package com.laser_scanner.laser_scanner.events;



import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
public class ResultEventChannel implements StreamHandler {
    private final EventChannel eventChannel;
    private EventSink eventSink;

    public EventSink getEventSink(){
        return eventSink;
    }

    public ResultEventChannel(BinaryMessenger binaryMessenger) {
        eventChannel = new EventChannel(binaryMessenger, "com.laser_scanner.laser_scanner.flutter_event_channel/scanner_result");
        eventChannel.setStreamHandler(this);
    }

    // Implement onListen and onCancel methods
    @Override
    public void onListen(Object arguments, EventSink events) {
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
    }

    // Other methods of your plugin
}
