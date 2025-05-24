# Flutter Add-to-App Billing Integration in Existing NavBar Application

## Issue Description

Integrate Flutter billing detail screens into the existing Kotlin bottom navigation app. The billing
functionality should be implemented within the existing "Billing" tab where:

- **Kotlin Native**: Displays list of bills in the billing tab
- **Flutter Module**: Shows detailed bill view when tapping on a bill item
- **Deep Links**: Bill detail pages accessible via Android deep links
- **Backstack**: Proper navigation flow between native list and Flutter details

This implementation builds on the existing bottom navigation structure and demonstrates seamless
native-to-Flutter navigation patterns.

## 🎯 Test-Driven Development Approach

**CRITICAL: Write failing Maestro tests BEFORE implementing any code.**

### Phase 1: Create Failing Tests First

1. **Billing List Test** - Test native Kotlin billing tab with mock data
2. **Navigation Test** - Test tap on bill item navigating to Flutter detail
3. **Detail Screen Test** - Test Flutter bill detail screen functionality
4. **Deep Link Test** - Test `myapp://bill/{billId}` deep link navigation
5. **Back Navigation Test** - Test proper backstack from Flutter to native

```yaml
# maestro/flows/billing_integration_test.yaml
appId: com.example.myflutternavbarapplication
---
# Test 1: Billing tab loads with mock bills
- launchApp
- tapOn: "Billing"
- assertVisible: "Internet Service"
- assertVisible: "$79.99"
- assertVisible: "Electric Bill"

# Test 2: Navigate to Flutter detail
- tapOn: "Internet Service"
- assertVisible: "Bill Details"
- assertVisible: "Pay Bill"
- assertVisible: "Monthly internet bill"

# Test 3: Deep link test
- launchApp:
    url: "myapp://bill/bill_001"
- assertVisible: "Bill Details"
- assertVisible: "Internet Service"

# Test 4: Back navigation
- tapOn: id:"back_button"
- assertVisible: "Billing"
- assertVisible: "Internet Service"
```

All tests must fail initially, then implementation proceeds to make them pass.

## Requirements

### Core Integration Features

- **Native Billing List**: Kotlin RecyclerView showing bill summaries in the billing tab
- **Flutter Detail View**: Rich bill detail screen with payment options and history
- **Method Channel Communication**: Pass bill data between Kotlin and Flutter
- **Deep Link Support**: Direct navigation to specific bill details via `myapp://bill/{billId}`
- **Backstack Management**: Proper back navigation from Flutter detail to native list

### Technical Stack

- **Android**: Existing Kotlin app with bottom navigation + billing tab integration
- **Flutter**: Add-to-app module for bill detail screens
- **Mock Testing**: MockWebServer for Android, fake_dio for Flutter
- **Navigation**: Android Intent-based navigation + Flutter named routes

## Implementation Guidelines

### 1. Project Structure Integration
```
MyFlutterNavBarApplication/
├── app/src/main/kotlin/
│   ├── billing/
│   │   ├── BillingFragment.kt         # Existing billing tab
│   │   ├── BillListAdapter.kt         # RecyclerView adapter
│   │   ├── BillingService.kt          # API service with MockWebServer
│   │   └── models/                    # Bill data models
│   ├── flutter/
│   │   ├── FlutterBillDetailActivity.kt # Host for Flutter detail
│   │   └── BillingMethodChannel.kt     # Method channel setup
│   └── MainActivity.kt                 # Existing main activity
├── flutter_billing_module/             # New Flutter module
│   ├── lib/
│   │   ├── bill_detail_screen.dart    # Main detail screen
│   │   ├── billing_service.dart       # Flutter billing service
│   │   ├── fake_billing.dart          # Mock implementation
│   │   └── method_channel_handler.dart # Communication bridge
│   └── pubspec.yaml
└── android/app/src/main/AndroidManifest.xml # Deep link configuration
```

### 2. Android Native Implementation

#### Update Existing Billing Fragment

```kotlin
// BillingFragment.kt (modify existing)
class BillingFragment : Fragment() {
    private lateinit var billsAdapter: BillListAdapter
    private lateinit var billingService: BillingService
    
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val view = inflater.inflate(R.layout.fragment_billing, container, false)
        
        setupRecyclerView(view)
        setupBillingService()
        loadBills()
        
        return view
    }
    
    private fun setupRecyclerView(view: View) {
        billsAdapter = BillListAdapter { bill ->
            // Navigate to Flutter detail screen
            val intent = Intent(requireContext(), FlutterBillDetailActivity::class.java).apply {
                putExtra("billId", bill.id)
                putExtra("billData", bill.toJson())
            }
            startActivity(intent)
        }
        
        view.findViewById<RecyclerView>(R.id.bills_recycler_view).apply {
            layoutManager = LinearLayoutManager(requireContext())
            adapter = billsAdapter
        }
    }
    
    private fun setupBillingService() {
        // Initialize with MockWebServer for testing
        val mockServer = MockBillingServer()
        val baseUrl = mockServer.start()
        billingService = BillingService(baseUrl)
    }
    
    private fun loadBills() {
        lifecycleScope.launch {
            try {
                val bills = billingService.getBills()
                billsAdapter.submitList(bills)
            } catch (e: Exception) {
                // Handle error
            }
        }
    }
}
```

#### Flutter Host Activity for Detail Screen
```kotlin
// FlutterBillDetailActivity.kt
class FlutterBillDetailActivity : FlutterActivity() {
    companion object {
        const val BILLING_CHANNEL = "com.example.billing/channel"
    }
    
    private lateinit var billingMethodChannel: MethodChannel
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        billingMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BILLING_CHANNEL
        )
        
        billingMethodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getBillData" -> {
                    val billData = intent.getStringExtra("billData")
                    result.success(billData)
                }
                "payBill" -> {
                    val billId = call.argument<String>("billId")
                    handlePayment(billId, result)
                }
                "navigateBack" -> {
                    finish()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
    
    override fun getInitialRoute(): String {
        val billId = intent.getStringExtra("billId") ?: ""
        return "/bill_detail?billId=$billId"
    }
    
    private fun handlePayment(billId: String?, result: MethodChannel.Result) {
        // Implement payment logic with MockWebServer
        lifecycleScope.launch {
            try {
                val paymentResult = billingService.payBill(billId ?: "")
                result.success(paymentResult.toJson())
            } catch (e: Exception) {
                result.error("PAYMENT_ERROR", e.message, null)
            }
        }
    }
}
```

#### Deep Link Configuration

```xml
<!-- AndroidManifest.xml -->
<activity
    android:name=".flutter.FlutterBillDetailActivity"
    android:exported="true"
    android:theme="@style/LaunchTheme">
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="myapp" android:host="bill" />
    </intent-filter>
</activity>
```

#### MockWebServer Setup for Billing
```kotlin
// MockBillingServer.kt
class MockBillingServer {
    private val mockWebServer = MockWebServer()
    
    fun start(): String {
        mockWebServer.start()
        setupMockResponses()
        return mockWebServer.url("/").toString()
    }
    
    private fun setupMockResponses() {
        // Bills list endpoint
        mockWebServer.enqueue(
            MockResponse()
                .setResponseCode(200)
                .setHeader("Content-Type", "application/json")
                .setBody("""
                    {
                        "bills": [
                            {
                                "id": "bill_001",
                                "title": "Internet Service",
                                "amount": "$79.99",
                                "dueDate": "2024-02-15",
                                "status": "pending",
                                "description": "Monthly internet bill"
                            },
                            {
                                "id": "bill_002", 
                                "title": "Electric Bill",
                                "amount": "$120.50",
                                "dueDate": "2024-02-20",
                                "status": "overdue",
                                "description": "Monthly electricity usage"
                            }
                        ]
                    }
                """.trimIndent())
        )
        
        // Payment endpoint
        mockWebServer.enqueue(
            MockResponse()
                .setResponseCode(200)
                .setHeader("Content-Type", "application/json")
                .setBody("""
                    {
                        "success": true,
                        "transactionId": "txn_${System.currentTimeMillis()}",
                        "status": "completed",
                        "message": "Payment processed successfully"
                    }
                """.trimIndent())
        )
    }
}
```

### 3. Flutter Module Implementation

#### Bill Detail Screen

```dart
// bill_detail_screen.dart
class BillDetailScreen extends ConsumerWidget {
  final String billId;
  
  const BillDetailScreen({Key? key, required this.billId}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billData = ref.watch(billDetailProvider(billId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _navigateBack(),
        ),
      ),
      body: billData.when(
        data: (bill) => _buildBillDetails(bill),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading bill: $error'),
        ),
      ),
    );
  }
  
  Widget _buildBillDetails(Bill bill) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bill.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Amount: ${bill.amount}', style: const TextStyle(fontSize: 18)),
                  Text('Due Date: ${bill.dueDate}', style: const TextStyle(fontSize: 16)),
                  Text('Status: ${bill.status}', style: TextStyle(
                    fontSize: 16,
                    color: bill.status == 'overdue' ? Colors.red : Colors.green,
                  )),
                  const SizedBox(height: 8),
                  Text(bill.description),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _payBill(bill.id),
              child: const Text('Pay Bill'),
            ),
          ),
        ],
      ),
    );
  }
  
  void _payBill(String billId) async {
    try {
      await MethodChannelHandler.payBill(billId);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment processed successfully!')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }
  
  void _navigateBack() {
    MethodChannelHandler.navigateBack();
  }
}
```

#### Method Channel Handler

```dart
// method_channel_handler.dart
class MethodChannelHandler {
  static const platform = MethodChannel('com.example.billing/channel');
  
  static Future<Bill?> getBillData() async {
    try {
      final String? billData = await platform.invokeMethod('getBillData');
      if (billData != null) {
        return Bill.fromJson(jsonDecode(billData));
      }
    } catch (e) {
      print('Error getting bill data: $e');
    }
    return null;
  }
  
  static Future<void> payBill(String billId) async {
    await platform.invokeMethod('payBill', {'billId': billId});
  }
  
  static Future<void> navigateBack() async {
    await platform.invokeMethod('navigateBack');
  }
}
```

#### Fake Billing Service (Flutter)
```dart
// fake_billing.dart
class FakeBillingService implements BillingService {
  @override
  Future<Bill> getBillDetail(String billId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock bill data
    return Bill(
      id: billId,
      title: 'Internet Service',
      amount: '\$79.99',
      dueDate: '2024-02-15',
      status: 'pending',
      description: 'Monthly internet bill with detailed breakdown...',
    );
  }
  
  @override
  Future<PaymentResult> payBill(String billId) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    return PaymentResult(
      success: true,
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      message: 'Payment processed successfully',
    );
  }
}

// Riverpod providers
final billingServiceProvider = Provider<BillingService>((ref) {
  return FakeBillingService(); // Switch to real service for production
});

final billDetailProvider = FutureProvider.family<Bill, String>((ref, billId) async {
  final billingService = ref.read(billingServiceProvider);
  return billingService.getBillDetail(billId);
});
```

### 4. Testing Strategy

#### Android Testing with MockWebServer
```kotlin
@Test
fun `test billing list loads from mock server`() = runTest {
    val mockServer = MockBillingServer()
    val baseUrl = mockServer.start()
    
    val billingService = BillingService(baseUrl)
    val bills = billingService.getBills()
    
    assertEquals(2, bills.size)
    assertEquals("bill_001", bills[0].id)
    assertEquals("Internet Service", bills[0].title)
    
    mockServer.shutdown()
}

@Test
fun `test navigation to Flutter detail screen`() {
    val scenario = launchActivity<MainActivity>()
    
    // Navigate to billing tab
    onView(withId(R.id.billing_tab)).perform(click())
    
    // Click on first bill item
    onView(withId(R.id.bills_recycler_view))
        .perform(RecyclerViewActions.actionOnItemAtPosition<BillViewHolder>(0, click()))
    
    // Verify Flutter activity is launched
    intended(hasComponent(FlutterBillDetailActivity::class.java.name))
}
```

#### Flutter Testing
```dart
void main() {
  group('Bill Detail Screen Tests', () {
    testWidgets('displays bill information correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            billingServiceProvider.overrideWithValue(FakeBillingService()),
          ],
          child: MaterialApp(
            home: BillDetailScreen(billId: 'bill_001'),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      expect(find.text('Internet Service'), findsOneWidget);
      expect(find.text('\$79.99'), findsOneWidget);
      expect(find.text('Pay Bill'), findsOneWidget);
    });
  });
}
```

## Deep Link Testing

Test deep links using ADB:

```bash
adb shell am start \
  -W -a android.intent.action.VIEW \
  -d "myapp://bill/bill_001" \
  com.example.myflutternavbarapplication
```

## Acceptance Criteria

- [ ] **All Maestro tests pass** - Complete test suite runs successfully
- [ ] **Failing tests written first** - TDD approach demonstrated
- [ ] Billing tab displays list of bills using RecyclerView
- [ ] Tapping bill item opens Flutter detail screen with smooth transition
- [ ] Flutter detail screen receives bill data via method channel
- [ ] Payment functionality works with mock API responses
- [ ] Deep links (`myapp://bill/{billId}`) open specific bill details
- [ ] Back navigation works properly from Flutter to native list
- [ ] MockWebServer provides realistic API responses for testing
- [ ] Unit tests cover both Android and Flutter components
- [ ] Integration tests verify end-to-end navigation flow

## 📊 Success Metrics

### Likelihood of Success: 8/10

**Reasoning:**

- ✅ Building on existing working app structure
- ✅ Well-defined scope with clear test cases
- ✅ MockWebServer provides isolated testing
- ✅ Standard Flutter add-to-app patterns
- ⚠️ Method channel complexity may cause integration issues
- ⚠️ Deep link configuration can be tricky

### Time Estimate: 12-16 hours

**Breakdown for Claude Sonnet 4.0 + Firebender:**

- **Test Creation**: 2-3 hours (Maestro flows + unit tests)
- **Android Implementation**: 4-5 hours (Fragment, Activity, MockWebServer)
- **Flutter Module**: 3-4 hours (Detail screen, method channels, fake services)
- **Integration & Deep Links**: 2-3 hours (Method channels, manifest, debugging)
- **Testing & Refinement**: 1-2 hours (Making all tests pass, edge cases)

### Risk Factors:

- **Medium Risk**: Method channel parameter marshaling
- **Low Risk**: Deep link intent filter configuration
- **Low Risk**: MockWebServer response timing

## Resources

- [Flutter Add-to-App Documentation](https://docs.flutter.dev/development/add-to-app)
- [Android Deep Links Guide](https://developer.android.com/training/app-links/deep-linking)
- [Method Channels Documentation](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [MockWebServer Documentation](https://github.com/square/okhttp/tree/master/mockwebserver)

## Priority

**High** - Demonstrates real-world integration pattern of native list + Flutter details within
existing app structure.

## Labels

`add-to-app`, `billing`, `navigation`, `deep-links`, `method-channels`, `mockwebserver`, `tdd`,
`maestro-testing`
