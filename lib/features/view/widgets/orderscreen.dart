import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../routs/Approuts.dart';
import '../../../viewmodel/order_view_model.dart';
import '../order_listView.dart'; // Assuming you have OrderListView

class OrderTabsView extends StatefulWidget {
  @override
  _OrderTabsViewState createState() => _OrderTabsViewState();
}

class _OrderTabsViewState extends State<OrderTabsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged); // Listen for tab changes
    Future.delayed(Duration.zero, () {
      Provider.of<OrderViewModel>(context, listen: false).fetchOrdersForTab();
    });
  }

  // Function to handle tab changes
  void _onTabChanged() {
    final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);
    String selectedTab = _tabController.index == 0
        ? 'Active'
        : _tabController.index == 1
        ? 'Delivered' // Ensure the correct tab name is passed for Completed
        : 'Cancelled';
    orderViewModel
        .setTab(selectedTab); // This triggers the tab change and API call
  }

  @override
  void dispose() {
    _tabController.removeListener(
        _onTabChanged); // Clean up the listener when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context);

    return WillPopScope(
      onWillPop: () async {
        // Navigate back to home when back button is pressed
        Navigator.pushReplacementNamed(context, AppRoutes.HOME);
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 1,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, AppRoutes.HOME); // Navigate back
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/backarrow.png',
                height: 24,
                width: 24,
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: const Text(
            'My Orders',
            style: TextStyle(color: Colors.black),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: Colors.white, // TabBar background color
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  // Manually call _onTabChanged when a tab is tapped
                  _onTabChanged();
                },
                labelColor: AppColors.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor:  AppColors.primaryColor,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Completed'), // Tab name
                  Tab(text: 'Cancelled'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            OrderListView(orderViewModel: orderViewModel, orderStatus: 'Active'),
            OrderListView(
                orderViewModel: orderViewModel, orderStatus: 'Delivered'),
            OrderListView(
                orderViewModel: orderViewModel, orderStatus: 'Cancelled'),
          ],
        ),
      ),
    );
  }
}
