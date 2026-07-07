package pause.rup1n13

import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Process
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity : FlutterActivity() {
    private val CHANNEL = "pause/usage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasUsageAccess" -> result.success(hasUsageAccess())
                "openUsageAccessSettings" -> {
                    startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
                    result.success(null)
                }
                "queryHourlyScreenBuckets" -> {
                    val startMs = call.argument<Long>("startMs")
                    val endMs = call.argument<Long>("endMs")
                    if (startMs == null || endMs == null) {
                        result.error("INVALID_ARGS", "startMs and endMs are required", null)
                        return@setMethodCallHandler
                    }
                    
                    try {
                        val buckets = queryHourlyScreenBuckets(startMs, endMs)
                        result.success(buckets)
                    } catch (e: Exception) {
                        result.error("QUERY_FAILED", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun hasUsageAccess(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            Process.myUid(),
            packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun queryHourlyScreenBuckets(startMs: Long, endMs: Long): List<Map<String, Any>> {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val events = usm.queryEvents(startMs, endMs)
        
        val event = UsageEvents.Event()
        var lastScreenOn = 0L
        
        // Maps hourStartMs to bucket data
        val buckets = mutableMapOf<Long, HourlyBucket>()
        
        fun getBucket(timestamp: Long): HourlyBucket {
            val cal = Calendar.getInstance().apply { timeInMillis = timestamp }
            cal.set(Calendar.MINUTE, 0)
            cal.set(Calendar.SECOND, 0)
            cal.set(Calendar.MILLISECOND, 0)
            val hourMs = cal.timeInMillis
            return buckets.getOrPut(hourMs) { HourlyBucket(hourMs) }
        }

        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            
            when (event.eventType) {
                UsageEvents.Event.SCREEN_INTERACTIVE -> {
                    lastScreenOn = event.timeStamp
                }
                UsageEvents.Event.KEYGUARD_HIDDEN -> {
                    getBucket(event.timeStamp).unlocks++
                }
                UsageEvents.Event.SCREEN_NON_INTERACTIVE -> {
                    if (lastScreenOn > 0) {
                        val durationMs = event.timeStamp - lastScreenOn
                        if (durationMs > 0) {
                            getBucket(event.timeStamp).screenMs += durationMs
                        }
                        lastScreenOn = 0L
                    }
                }
            }
        }
        
        // If screen is still on at the end
        if (lastScreenOn > 0 && lastScreenOn < endMs) {
             val durationMs = endMs - lastScreenOn
             if (durationMs > 0) {
                 getBucket(endMs).screenMs += durationMs
             }
        }

        return buckets.values.map { 
            mapOf(
                "timestamp" to it.hourStartMs,
                "screenMinutes" to (it.screenMs / 60000).toInt(),
                "unlocks" to it.unlocks
            )
        }
    }
    
    private class HourlyBucket(val hourStartMs: Long) {
        var screenMs = 0L
        var unlocks = 0
    }
}
