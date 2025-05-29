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
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import com.neiljaywarner.myflutternavbarapplication.ui.theme.MyFlutterNavBarApplicationTheme

class MainActivity : ComponentActivity() {

    private fun launchFlutterBilling() {
        try {
            // Use reflection to launch Flutter with cached engine
            val flutterActivityClass = Class.forName("io.flutter.embedding.android.FlutterActivity")
            val withCachedEngineMethod =
                flutterActivityClass.getMethod("withCachedEngine", String::class.java)
            val builder = withCachedEngineMethod.invoke(null, "my_flutter_engine")
            val buildMethod =
                builder.javaClass.getMethod("build", android.content.Context::class.java)
            val intent = buildMethod.invoke(builder, this) as Intent
            startActivity(intent)
        } catch (e: Exception) {
            e.printStackTrace()
            // Fallback to bill detail if Flutter fails
            val intent = Intent(this, BillDetailActivity::class.java).apply {
                putExtra("billId", "electric")
                putExtra("title", "Electric Bill")
                putExtra("amount", "$120.50")
                putExtra("dueDate", "Jan 15, 2025")
            }
            startActivity(intent)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setContent {
            MyFlutterNavBarApplicationTheme {
                MainScreen { launchFlutterBilling() }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainScreen(onLaunchFlutter: () -> Unit = {}) {
    var selectedTabIndex by remember { mutableStateOf(0) }
    val context = LocalContext.current

    val tabs = listOf("My", "Billing", "Dashboard", "Items", "Settings")

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Flutter NavBar App") },
                actions = {
                    TextButton(
                        onClick = onLaunchFlutter
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
                        onClick = {
                            if (index == 1) {
                                // Billing tab: launch Flutter directly (Story 03 requirement)
                                onLaunchFlutter()
                            } else {
                                selectedTabIndex = index
                            }
                        },
                        icon = {
                            Text(title.first().toString())
                        },
                        label = { Text(title) }
                    )
                }
            }
        }
    ) { innerPadding ->
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
