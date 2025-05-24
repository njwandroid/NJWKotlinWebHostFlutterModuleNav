# Flutter Add-to-App Billing Integration for Web Platform

## Issue Description

Extend the existing Flutter add-to-app billing integration to support web deployment. This
implementation builds upon the completed Android native list + Flutter detail pattern and adapts it
for web browsers while maintaining the same user experience and functionality.

**Prerequisites**: This issue assumes the Android add-to-app billing integration is complete and
working, with native Kotlin list view and Flutter detail screens successfully implemented.

## 🎯 Test-Driven Development Approach

**CRITICAL: Write failing web-specific Maestro tests BEFORE implementing any code.**

### Phase 1: Create Failing Web Tests First

1. **Web Navigation Test** - Test bill list and detail navigation in browser
2. **Responsive Design Test** - Test different viewport sizes
3. **Deep Link Test** - Test web URLs like `/bills` and `/bill/{billId}`
4. **Cross-Browser Test** - Test functionality across different browsers

```yaml
# maestro/flows/billing_web_test.yaml
platform: web
baseURL: http://localhost:8080
---
# Test 1: Web bill list loads
- launchApp:
    url: "http://localhost:8080/bills"
- assertVisible: "My Bills"
- assertVisible: "Internet Service"
- assertVisible: "$79.99"

# Test 2: Navigate to detail
- tapOn: "Internet Service"
- assertVisible: "Bill Details"
- assertVisible: "Pay Bill"

# Test 3: Deep link test
- launchApp:
    url: "http://localhost:8080/bill/bill_001"
- assertVisible: "Bill Details"
- assertVisible: "Internet Service"

# Test 4: Back navigation
- tapOn: id:"back_button"
- assertVisible: "My Bills"
```

```yaml
# maestro/flows/billing_responsive_test.yaml
platform: web
baseURL: http://localhost:8080
---
# Test responsive design
- setViewportSize: 1920x1080
- launchApp:
    url: "http://localhost:8080/bills"
- assertVisible: "Billing Dashboard"  # Desktop sidebar

- setViewportSize: 768x1024
- assertVisible: "My Bills"  # Tablet grid view

- setViewportSize: 375x667
- assertVisible: "My Bills"  # Mobile list view
```

All tests must fail initially, then implementation proceeds to make them pass.

## Requirements

### Core Web Adaptation Features

- **Web Router Navigation**: Implement Flutter web routing to replicate the native list → detail
  flow
- **URL-based Deep Links**: Support browser URLs like `/bills` and `/bill/{billId}` for direct
  navigation
- **Responsive Design**: Ensure billing screens work across desktop, tablet, and mobile web browsers
- **State Management**: Maintain Riverpod state management consistency between mobile and web
- **Mock API Integration**: Adapt existing fake services for web deployment

### Technical Stack

- **Flutter Web**: Single-page application with proper routing
- **Go Router**: Modern declarative routing for deep links and navigation
- **Dio HTTP Client**: Consistent API communication across platforms
- **Riverpod**: State management matching mobile implementation
- **Responsive UI**: Material Design 3 with adaptive layouts

## Implementation Guidelines

### 1. Project Structure for Web

```
MyFlutterNavBarApplication/
├── flutter_billing_module/
│   ├── lib/
│   │   ├── src/
│   │   │   ├── billing/
│   │   │   │   ├── models/              # Shared models
│   │   │   │   ├── services/            # API services (Dio-based)
│   │   │   │   ├── providers/           # Riverpod providers
│   │   │   │   └── fake_billing.dart    # Mock implementation
│   │   │   ├── web/
│   │   │   │   ├── bill_list_screen.dart    # Web version of native list
│   │   │   │   ├── bill_detail_screen.dart  # Enhanced detail screen
│   │   │   │   ├── responsive_layout.dart   # Adaptive layouts
│   │   │   │   └── web_navigation.dart      # Web-specific navigation
│   │   │   └── mobile/
│   │   │       └── bill_detail_screen.dart  # Existing mobile detail
│   │   ├── router/
│   │   │   ├── app_router.dart          # Go Router configuration
│   │   │   └── route_constants.dart     # Route definitions
│   │   └── main_web.dart                # Web entry point
│   ├── web/
│   │   ├── index.html                   # Web HTML template
│   │   └── manifest.json                # PWA manifest
│   ├── maestro/flows/                   # Web-specific test flows
│   │   ├── billing_web_test.yaml        # Main web integration test
│   │   ├── billing_responsive_test.yaml # Responsive design test
│   │   └── billing_cross_browser_test.yaml # Cross-browser test
│   └── pubspec.yaml
└── README_WEB.md                        # Web deployment guide
```

### 2. Web Router Configuration

#### Go Router Setup

```dart
// app_router.dart
final appRouter = GoRouter(
  initialLocation: '/bills',
  routes: [
    GoRoute(
      path: '/bills',
      name: 'billList',
      pageBuilder: (context, state) => MaterialPage(
        key: ValueKey('bills'),
        child: BillListScreen(),
      ),
    ),
    GoRoute(
      path: '/bill/:billId',
      name: 'billDetail',
      pageBuilder: (context, state) {
        final billId = state.pathParameters['billId']!;
        return MaterialPage(
          key: ValueKey('bill-$billId'),
          child: BillDetailScreen(billId: billId),
        );
      },
    ),
    // Redirect root to bills list
    GoRoute(
      path: '/',
      redirect: (context, state) => '/bills',
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    key: ValueKey('error'),
    child: ErrorScreen(error: state.error.toString()),
  ),
);
```

#### Web Main Entry Point

```dart
// main_web.dart
void main() {
  runApp(MyBillingWebApp());
}

class MyBillingWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        title: 'Billing Management',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
```

### 3. Web Bill List Screen Implementation

#### Responsive Bill List

```dart
// bill_list_screen.dart
class BillListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billsListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bills'),
        centerTitle: true,
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(billsAsync),
        tablet: _buildTabletLayout(billsAsync),
        desktop: _buildDesktopLayout(billsAsync),
      ),
    );
  }
  
  Widget _buildMobileLayout(AsyncValue<List<Bill>> billsAsync) {
    return billsAsync.when(
      data: (bills) => ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: bills.length,
        itemBuilder: (context, index) => BillCard(
          bill: bills[index],
          onTap: () => _navigateToBillDetail(bills[index].id),
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorWidget(error),
    );
  }
  
  Widget _buildTabletLayout(AsyncValue<List<Bill>> billsAsync) {
    return billsAsync.when(
      data: (bills) => GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: bills.length,
        itemBuilder: (context, index) => BillCard(
          bill: bills[index],
          onTap: () => _navigateToBillDetail(bills[index].id),
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorWidget(error),
    );
  }
  
  Widget _buildDesktopLayout(AsyncValue<List<Bill>> billsAsync) {
    return Row(
      children: [
        // Sidebar navigation
        Container(
          width: 250,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Billing Dashboard',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              ListTile(
                leading: Icon(Icons.receipt_long),
                title: Text('All Bills'),
                selected: true,
              ),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Payment History'),
              ),
            ],
          ),
        ),
        // Main content
        Expanded(
          child: _buildTabletLayout(billsAsync),
        ),
      ],
    );
  }
  
  void _navigateToBillDetail(String billId) {
    context.go('/bill/$billId');
  }
}
```

#### Responsive Layout Widget

```dart
// responsive_layout.dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  
  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobile;
        } else if (constraints.maxWidth < 1200) {
          return tablet;
        } else {
          return desktop;
        }
      },
    );
  }
}
```

### 4. Enhanced Web Bill Detail Screen

#### Web-Optimized Detail Screen

```dart
// web/bill_detail_screen.dart
class BillDetailScreen extends ConsumerWidget {
  final String billId;
  
  const BillDetailScreen({Key? key, required this.billId}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billAsync = ref.watch(billDetailProvider(billId));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/bills'),
        ),
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(billAsync),
        tablet: _buildTabletLayout(billAsync),
        desktop: _buildDesktopLayout(billAsync),
      ),
    );
  }
  
  Widget _buildMobileLayout(AsyncValue<Bill> billAsync) {
    return billAsync.when(
      data: (bill) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBillCard(bill),
            SizedBox(height: 20),
            _buildPaymentSection(bill),
          ],
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorScreen(error: error.toString()),
    );
  }
  
  Widget _buildDesktopLayout(AsyncValue<Bill> billAsync) {
    return billAsync.when(
      data: (bill) => Padding(
        padding: EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill details panel
            Expanded(
              flex: 2,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: _buildBillDetails(bill),
                ),
              ),
            ),
            SizedBox(width: 24),
            // Payment panel
            Expanded(
              flex: 1,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: _buildPaymentPanel(bill),
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorScreen(error: error.toString()),
    );
  }
  
  Widget _buildPaymentSection(Bill bill) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _payBill(bill.id),
                icon: Icon(Icons.payment),
                label: Text('Pay ${bill.amount}'),
              ),
            ),
            SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _schedulePay(bill.id),
              icon: Icon(Icons.schedule),
              label: Text('Schedule Payment'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _payBill(String billId) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final billingService = ref.read(billingServiceProvider);
      await billingService.payBill(billId);
      
      messenger.showSnackBar(
        SnackBar(
          content: Text('Payment processed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

### 5. Web-Adapted Services

#### Enhanced Fake Billing Service for Web

```dart
// fake_billing.dart (enhanced for web)
class FakeBillingService implements BillingService {
  // Simulate network delay for realistic web experience
  static const Duration _networkDelay = Duration(milliseconds: 800);
  
  @override
  Future<List<Bill>> getBills() async {
    await Future.delayed(_networkDelay);
    
    return [
      Bill(
        id: 'bill_001',
        title: 'Internet Service',
        amount: '\$79.99',
        dueDate: '2024-02-15',
        status: 'pending',
        description: 'Monthly high-speed internet service',
        category: 'Utilities',
      ),
      Bill(
        id: 'bill_002',
        title: 'Electric Bill',
        amount: '\$120.50',
        dueDate: '2024-02-20',
        status: 'overdue',
        description: 'Monthly electricity usage',
        category: 'Utilities',
      ),
      Bill(
        id: 'bill_003',
        title: 'Phone Service',
        amount: '\$45.00',
        dueDate: '2024-02-25',
        status: 'paid',
        description: 'Monthly mobile phone service',
        category: 'Communication',
      ),
    ];
  }
  
  @override
  Future<Bill> getBillDetail(String billId) async {
    await Future.delayed(_networkDelay);
    
    final bills = await getBills();
    final bill = bills.firstWhere(
      (b) => b.id == billId,
      orElse: () => throw Exception('Bill not found'),
    );
    
    // Add additional details for web view
    return bill.copyWith(
      detailedDescription: '''
        ${bill.description}
        
        Account Number: ${billId.toUpperCase()}
        Service Period: Jan 1 - Jan 31, 2024
        Previous Balance: \$0.00
        New Charges: ${bill.amount}
        
        Payment Due: ${bill.dueDate}
        Late Fee: \$5.00 (after due date)
      ''',
      paymentHistory: [
        PaymentRecord(date: '2024-01-15', amount: bill.amount, status: 'completed'),
        PaymentRecord(date: '2023-12-15', amount: bill.amount, status: 'completed'),
      ],
    );
  }
  
  @override
  Future<PaymentResult> payBill(String billId) async {
    await Future.delayed(Duration(milliseconds: 1500)); // Simulate payment processing
    
    // Simulate occasional payment failures for testing
    if (Random().nextInt(10) == 0) {
      throw Exception('Payment processing failed. Please try again.');
    }
    
    return PaymentResult(
      success: true,
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      message: 'Payment processed successfully',
      timestamp: DateTime.now(),
    );
  }
}
```

### 6. Progressive Web App (PWA) Support

#### Web Manifest

```json
// web/manifest.json
{
  "name": "Billing Management",
  "short_name": "Billing",
  "start_url": "/bills",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#2196f3",
  "description": "Manage your bills and payments",
  "orientation": "portrait-primary",
  "prefer_related_applications": false,
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512", 
      "type": "image/png"
    }
  ]
}
```

#### Enhanced HTML Template

```html
<!-- web/index.html -->
<!DOCTYPE html>
<html>
<head>
  <base href="$FLUTTER_BASE_HREF">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="Billing Management Web App">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="Billing">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">
  <link rel="icon" type="image/png" href="favicon.png"/>
  <link rel="manifest" href="manifest.json">
  <title>Billing Management</title>
</head>
<body>
  <script>
    window.addEventListener('load', function(ev) {
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: serviceWorkerVersion,
        },
        onEntrypointLoaded: function(engineInitializer) {
          engineInitializer.initializeEngine().then(function(appRunner) {
            appRunner.runApp();
          });
        }
      });
    });
  </script>
</body>
</html>
```

### 7. Testing Strategy for Web

#### Web Integration Tests

```dart
// test/web_integration_test.dart
void main() {
  group('Web Billing Integration Tests', () {
    testWidgets('navigates from bill list to detail', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            billingServiceProvider.overrideWithValue(FakeBillingService()),
          ],
          child: MyBillingWebApp(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Should start on bills list
      expect(find.text('My Bills'), findsOneWidget);
      
      // Tap first bill
      await tester.tap(find.byType(BillCard).first);
      await tester.pumpAndSettle();
      
      // Should navigate to detail screen
      expect(find.text('Bill Details'), findsOneWidget);
      expect(find.text('Pay'), findsOneWidget);
    });
    
    testWidgets('supports deep link navigation', (tester) async {
      // Test URL-based navigation
      final router = GoRouter(
        initialLocation: '/bill/bill_001',
        routes: appRouter.configuration.routes,
      );
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            billingServiceProvider.overrideWithValue(FakeBillingService()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Should directly show bill detail
      expect(find.text('Bill Details'), findsOneWidget);
    });
  });
}
```

### 8. Deployment Configuration

#### Build and Deploy Scripts

```bash
#!/bin/bash
# scripts/build_web.sh

echo "Building Flutter web app..."
flutter build web --release --base-href="/billing/"

echo "Optimizing build..."
# Additional optimization steps
gzip -r build/web/

echo "Web build complete!"
echo "Deploy the build/web/ directory to your web server"
```

## Acceptance Criteria

- [ ] **All web Maestro tests pass** - Complete web test suite runs successfully
- [ ] **Failing tests written first** - TDD approach demonstrated for web
- [ ] Web application loads with responsive bill list screen
- [ ] URL routing works for `/bills` and `/bill/{billId}` paths
- [ ] Clicking bill items navigates to detail screens with proper URLs
- [ ] Back navigation works using browser back button
- [ ] Deep links work when shared or bookmarked
- [ ] Responsive design adapts to mobile, tablet, and desktop screen sizes
- [ ] Payment functionality works with proper feedback
- [ ] PWA features work (installable, offline-capable)
- [ ] Web application maintains visual consistency with mobile version
- [ ] Performance is acceptable on various network conditions

## Testing Requirements

- [ ] **Maestro web tests pass** - All web-specific integration tests
- [ ] Integration tests for web navigation flows
- [ ] Responsive design tests across different screen sizes
- [ ] Deep link functionality testing
- [ ] Payment flow testing with mock responses
- [ ] PWA functionality testing
- [ ] Cross-browser compatibility testing (Chrome, Firefox, Safari, Edge)

## 📊 Success Metrics

### Likelihood of Success: 7/10

**Reasoning:**

- ✅ Building on completed mobile implementation
- ✅ Flutter web is mature and well-supported
- ✅ Go Router provides robust web navigation
- ✅ Responsive design patterns are well-established
- ⚠️ Maestro web testing support may be limited
- ⚠️ Cross-browser compatibility can be challenging
- ⚠️ PWA features may require additional configuration

### Time Estimate: 14-18 hours

**Breakdown for Claude Sonnet 4.0 + Firebender:**

- **Test Creation**: 3-4 hours (Web Maestro flows, responsive tests)
- **Router & Navigation**: 3-4 hours (Go Router setup, URL handling)
- **Responsive UI**: 4-5 hours (Mobile/tablet/desktop layouts)
- **Web Services**: 2-3 hours (Adapting fake services for web)
- **PWA & Polish**: 2-3 hours (Manifest, service worker, optimization)

### Risk Factors:

- **Medium Risk**: Maestro web testing configuration and reliability
- **Medium Risk**: Cross-browser compatibility issues
- **Low Risk**: Flutter web routing and state management

## Resources

- [Flutter Web Documentation](https://docs.flutter.dev/platform-integration/web)
- [Go Router Package](https://pub.dev/packages/go_router)
- [Responsive Design in Flutter](https://docs.flutter.dev/development/ui/layout/adaptive-responsive)
- [PWA Documentation](https://web.dev/progressive-web-apps/)

## Priority

**Medium** - Extends existing mobile functionality to web platform, providing broader accessibility.

## Labels

`flutter-web`, `routing`, `responsive-design`, `pwa`, `billing`, `add-to-app`, `tdd`,
`maestro-testing`
