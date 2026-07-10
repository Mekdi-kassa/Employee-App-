package com.example.employee_app

import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import android.app.Activity

class BrowserActivity : Activity() {
    companion object {
        const val EXTRA_URL = "extra_url"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val webView = WebView(this)

        val url = intent.getStringExtra(EXTRA_URL).orEmpty()
        if (url.isBlank()) {
            finish()
            return
        }

        webView.settings.javaScriptEnabled = true
        webView.settings.domStorageEnabled = true
        webView.webViewClient = WebViewClient()
        webView.loadUrl(url)

        setContentView(webView)
    }
}