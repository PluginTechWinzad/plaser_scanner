package com.laser_scanner.laser_scanner.events;
import io.flutter.plugin.common.EventChannel;
public class ResultEventChannelSingleton {
	private static ResultEventChannelSingleton instance;
	private EventChannel.EventSink eventSink;

	private ResultEventChannelSingleton() {
		// Khởi tạo
	}

	public static ResultEventChannelSingleton getInstance() {
		if (instance == null) {
			instance = new ResultEventChannelSingleton();
		}
		return instance;
	}

	public EventChannel.EventSink getEventSink() {
		return eventSink;
	}

	public void setEventSink(EventChannel.EventSink eventSink) {
		this.eventSink = eventSink;
	}
}
