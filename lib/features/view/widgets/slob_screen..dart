import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/slob_viewmodel.dart';

class SlobScreen extends StatefulWidget {
  @override
  _SlobScreenState createState() => _SlobScreenState();
}

class _SlobScreenState extends State<SlobScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SlobViewModel>(context, listen: false).fetchSlobs();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SlobViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              'assets/backarrow.png',
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Delivery Charges'),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: viewModel.slobs.isEmpty
            ? Center(
          child: Text(
            'Free Delivery',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DataTable(
              columnSpacing: 20.0,
              border: TableBorder.all(color: Colors.black),
              columns: const [
                DataColumn(
                    label: Text(
                      'SNO',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                DataColumn(
                    label: Text(
                      'From Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                DataColumn(
                    label: Text(
                      'To Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                DataColumn(
                    label: Text(
                      'Charges',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
              rows: viewModel.slobs.map((slob) {
                return DataRow(cells: [
                  DataCell(Text(slob.id.toString())),
                  DataCell(Text(slob.fromTotal.toString())),
                  DataCell(Text(slob.toTotal.toString())),
                  DataCell(Text(slob.deliveryCharges.toString())),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
