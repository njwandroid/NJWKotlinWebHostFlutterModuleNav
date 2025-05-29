package com.neiljaywarner.myflutternavbarapplication

import android.app.Application
import android.content.Intent

class MyApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        try {
            // Initialize Flutter engine using reflection to avoid import issues
            val flutterEngineClass = Class.forName("io.flutter.embedding.engine.FlutterEngine")
            val flutterEngine =
                flutterEngineClass.getConstructor(android.content.Context::class.java)
                    .newInstance(this)

            // Set up navigation channel using reflection
            val dartExecutorMethod = flutterEngineClass.getMethod("getDartExecutor")
            val dartExecutor = dartExecutorMethod.invoke(flutterEngine)

            val dartExecutorClass = Class.forName("io.flutter.embedding.engine.dart.DartExecutor")
            val dartEntrypointClass =
                Class.forName("io.flutter.embedding.engine.dart.DartExecutor\$DartEntrypoint")
            val createDefaultMethod = dartEntrypointClass.getMethod("createDefault")
            val defaultEntrypoint = createDefaultMethod.invoke(null)

            val executeDartEntrypointMethod =
                dartExecutorClass.getMethod("executeDartEntrypoint", dartEntrypointClass)
            executeDartEntrypointMethod.invoke(dartExecutor, defaultEntrypoint)

            // Set up method channel for navigation using reflection
            val getBinaryMessengerMethod = dartExecutorClass.getMethod("getBinaryMessenger")
            val binaryMessenger = getBinaryMessengerMethod.invoke(dartExecutor)

            val methodChannelClass = Class.forName("io.flutter.plugin.common.MethodChannel")
            val channelName = "com.neiljaywarner.myflutternavbarapplication/navigation"
            val methodChannel = methodChannelClass.getConstructor(
                Class.forName("io.flutter.plugin.common.BinaryMessenger"),
                String::class.java
            ).newInstance(binaryMessenger, channelName)

            // Set method call handler using reflection
            val methodCallHandlerInterface =
                Class.forName("io.flutter.plugin.common.MethodChannel\$MethodCallHandler")
            val setMethodCallHandlerMethod =
                methodChannelClass.getMethod("setMethodCallHandler", methodCallHandlerInterface)

            // Create a method call handler using a proxy
            val handler = java.lang.reflect.Proxy.newProxyInstance(
                methodCallHandlerInterface.classLoader,
                arrayOf(methodCallHandlerInterface)
            ) { proxy, method, args ->
                if (method.name == "onMethodCall") {
                    handleMethodCall(args[0], args[1])
                }
                null
            }

            setMethodCallHandlerMethod.invoke(methodChannel, handler)

            // Cache the engine using reflection
            val flutterEngineCacheClass =
                Class.forName("io.flutter.embedding.engine.FlutterEngineCache")
            val getInstanceMethod = flutterEngineCacheClass.getMethod("getInstance")
            val cache = getInstanceMethod.invoke(null)
            val putMethod =
                flutterEngineCacheClass.getMethod("put", String::class.java, flutterEngineClass)
            putMethod.invoke(cache, "my_flutter_engine", flutterEngine)

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun handleMethodCall(call: Any, result: Any) {
        try {
            val callClass = call.javaClass
            val getMethodMethod = callClass.getMethod("method")
            val method = getMethodMethod.invoke(call) as String

            if (method == "navigateToBillDetail") {
                // Get arguments using reflection
                val getArgumentMethod = callClass.getMethod("argument", String::class.java)
                val billId = getArgumentMethod.invoke(call, "billId") as? String ?: ""
                val title = getArgumentMethod.invoke(call, "title") as? String ?: ""
                val amount = getArgumentMethod.invoke(call, "amount") as? String ?: ""
                val dueDate = getArgumentMethod.invoke(call, "dueDate") as? String ?: ""

                // Create intent to launch BillDetailActivity
                val intent = Intent(this, BillDetailActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    putExtra("billId", billId)
                    putExtra("title", title)
                    putExtra("amount", amount)
                    putExtra("dueDate", dueDate)
                }
                startActivity(intent)

                // Call result.success() using reflection
                val resultClass = result.javaClass
                val successMethod = resultClass.getMethod("success", Any::class.java)
                successMethod.invoke(result, null)
            } else {
                // Call result.notImplemented() using reflection
                val resultClass = result.javaClass
                val notImplementedMethod = resultClass.getMethod("notImplemented")
                notImplementedMethod.invoke(result)
            }
        } catch (e: Exception) {
            e.printStackTrace()
            try {
                // Call result.error() using reflection if there's an error
                val resultClass = result.javaClass
                val errorMethod = resultClass.getMethod(
                    "error",
                    String::class.java,
                    String::class.java,
                    Any::class.java
                )
                errorMethod.invoke(result, "ERROR", e.message, null)
            } catch (errorException: Exception) {
                errorException.printStackTrace()
            }
        }
    }
}
