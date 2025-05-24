package com.neiljaywarner.myflutternavbarapplication

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import com.neiljaywarner.myflutternavbarapplication.ui.theme.MyFlutterNavBarApplicationTheme

class MainActivity : ComponentActivity() {
    companion object {
        private const val CHANNEL = "com.neiljaywarner.myflutternavbarapplication/navigation"
    }
    
    private lateinit var flutterEngine: FlutterEngine

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        
        // Initialize Flutter engine for platform channel
        flutterEngine = FlutterEngine(this)
        
        // Set up method channel to handle navigation from Flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "navigateToBillDetail") {
                val billId = call.argument<String>("billId")
                val title = call.argument<String>("title")
                val amount = call.argument<String>("amount")
                val dueDate = call.argument<String>("dueDate")
                
                val intent = Intent(this, BillDetailActivity::class.java)
                intent.putExtra("billId", billId)
                intent.putExtra("title", title)
                intent.putExtra("amount", amount)
                intent.putExtra("dueDate", dueDate)
                startActivity(intent)
                
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
        
        setContent {
            MyFlutterNavBarApplicationTheme {
                MainScreen()
            }
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        flutterEngine.destroy()
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainScreen() {
    var selectedTabIndex by remember { mutableStateOf(0) }
    val context = LocalContext.current

    val tabs = listOf("My", "Billing", "Dashboard", "Items", "Settings")

    // Launch Flutter activity when Billing tab is selected
    LaunchedEffect(selectedTabIndex) {
        if (selectedTabIndex == 1) { // Billing tab
            val intent = FlutterActivity.createDefaultIntent(context)
            context.startActivity(intent)
            selectedTabIndex = 0 // Reset to My tab
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Flutter NavBar App") },
                actions = {
                    TextButton(
                        onClick = {
                            // Launch Flutter activity
                            val intent = FlutterActivity.createDefaultIntent(context)
                            context.startActivity(intent)
                        }
                    ) {
                        Text("TF")
                    }
                }
            )
        },
        bottomBar = {
            NavigationBar {
                tabs.forEachIndexed { index, title ->
                    NavigationBarItem(
                        selected = selectedTabIndex == index,
                        onClick = { selectedTabIndex = index },
                        icon = {
                            // Use a simple text as icon for simplicity
                            Text(title.first().toString())
                        },
                        label = { Text(title) }
                    )
                }
            }
        }
    ) { innerPadding ->
        // Display different content based on selected tab
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = tabs[selectedTabIndex],
                style = MaterialTheme.typography.headlineMedium
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun MainScreenPreview() {
    MyFlutterNavBarApplicationTheme {
        MainScreen()
    }
}
