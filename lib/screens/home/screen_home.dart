import 'package:animations/animations.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manager/screens/category/category_add_popup.dart';
import 'package:money_manager/screens/category/screen_category.dart';
import 'package:money_manager/screens/home/widgets/bottom_navigation.dart';
import 'package:money_manager/screens/transactions/screen_transaction.dart';

class ScreenHome extends StatefulWidget {
  ScreenHome({
    Key? key,
  }) : super(key: key);

  // DateTime defaultDate = 0 as DateTime;
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  //static ValueNotifier<DateTimeRange>? _selectedDate;
  DateTimeRange? dateRange;

  List<TransactionModel> _newList = [];

  String? _selectedStartDate;

  String? _selectedEndDate;

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;
    dateRange = newDateRange;
    setState(() {
      _selectedStartDate = DateFormat('MMM-dd').format(dateRange!.start);
      _selectedEndDate = DateFormat('MMM-dd').format(dateRange!.end);
    });

    //print(newDateRange.start);
    //print(dateRange);
    print(_selectedStartDate);
    if (dateRange != null) {}
  }

  final _pages = [
    ScreenTransaction(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xf0f2f2f2),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color(0xf0f6f3ec),
        title: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 28,
                    child: Image.asset(
                      'assets/icon/bux_vector.png',
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'buX',
                    style: TextStyle(
                      color: Color.fromARGB(255, 77, 76, 76),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                //color: Colors.amber,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0, left: 10, top: 23),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          await pickDateRange(context);
                          if (dateRange != null) {
                            TransactionDB.instance
                                .wafi(dateRange!.start, dateRange!.end);
                            TransactionDB.instance.sfPieChart();
                          }
                        },
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                          size: 12,
                        ),
                        label: Text(
                          dateRange == null
                              ? 'Set Range'
                              : '$_selectedStartDate - $_selectedEndDate',
                          style: TextStyle(color: Colors.black),
                          // _selectedDate.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //centerTitle: true,
        // bottom: PreferredSize(
        //   preferredSize: Size(0, 25),
        //   child: SizedBox(
        //     height: 35,
        //     child: Padding(
        //       padding: const EdgeInsets.only(
        //         right: 10,
        //         left: 10,
        //       ),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           TextButton.icon(
        //             onPressed: () async {
        //               await pickDateRange(context);
        //               if (dateRange != null) {
        //                 TransactionDB.instance
        //                     .wafi(dateRange!.start, dateRange!.end);
        //                 TransactionDB.instance.sfPieChart();
        //               }
        //             },
        //             icon: const Icon(
        //               Icons.calendar_today,
        //               color: Colors.black,
        //               size: 15,
        //             ),
        //             label: Text(
        //               dateRange == null
        //                   ? 'Set Range'
        //                   : '$_selectedStartDate - $_selectedEndDate',
        //               style: TextStyle(color: Colors.black),
        //               // _selectedDate.toString(),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
      bottomNavigationBar: MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: ScreenHome.selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () {
          if (ScreenHome.selectedIndexNotifier.value == 0) {
            print('add transaction');
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            //print('add category');
            // showcategoryAddPopup(context);
          }
        },
        child: OpenContainer(
          transitionDuration: const Duration(milliseconds: 400),
          closedBuilder: (_, openContainer) {
            return const Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 32.0,
              ),
            );
          },
          openColor: Colors.white,
          closedElevation: 0.0,
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          closedColor: Colors.cyan,
          openBuilder: (_, closeContainer) {
            if (ScreenHome.selectedIndexNotifier.value == 0) {
              print('add transaction');
              //Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
              return ScreenAddTransaction();
            } else {
              print('add category');

              return AddCategory();
            }
          },
        ),
        //Icon(Icons.add,),
      ),
    );
  }
}
