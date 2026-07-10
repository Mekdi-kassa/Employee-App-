package com.example.employee_app

import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
	private val channelName = "employee_app/browser"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
			when (call.method) {
				"openUrl" -> {
					val url = call.argument<String>("url")
					if (url.isNullOrBlank()) {
						result.error("INVALID_URL", "URL was empty.", null)
						return@setMethodCallHandler
					}

					try {
						val intent = Intent(this, BrowserActivity::class.java)
						intent.putExtra(BrowserActivity.EXTRA_URL, url)
						startActivity(intent)
						result.success(true)
					} catch (exception: Exception) {
						result.error("OPEN_FAILED", exception.message, null)
					}
				}
				else -> result.notImplemented()
			}
		}
	}
}
