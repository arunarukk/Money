import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/screens/home/screen_home.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ScreenTransaction extends StatefulWidget {
  ScreenTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenTransaction> createState() => _ScreenTransactionState();
}

class _ScreenTransactionState extends State<ScreenTransaction> {
  Map<String, double> _dataMap = {};
  //Map<String, double> dataMap = {"Travel": 100};
  ScrollController scrollController = ScrollController();

  bool closeTopContainer = false;
  
  bool flag = false;
  late TooltipBehavior _tooltipBehavior;

  

 
  @override
  void initState() {
    // TODO: implement initState
    TransactionDB.instance.refresh();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
    
    scrollController.addListener(() {
      setState(() {
        // dataMap = pieData() as Map<String, double>;
        closeTopContainer = scrollController.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    final Size size = MediaQuery.of(context).size;
    final double chartHeight = size.height * 0.27;
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Material(
                elevation: 20,
                shadowColor: const Color(0xFF3366FF),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3.2,
                  height: MediaQuery.of(context).size.height / 9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: app_color.widget,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        //Color(0xff00c9af),
                        Color(0xFF3366FF),
                        //Color(0xff2ad054),
                        Color(0xFF00CCFF)
                      ], // red to yellow
                      tileMode: TileMode
                          .repeated, // repeats the gradient over the canvas
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          child: ValueListenableBuilder(
                            valueListenable: TransactionDB
                                .instance.incomeTransactionListNotifier,
                            builder:
                                (BuildContext ctx, totalIncome, Widget? _) {
                              if (totalIncome == null)
                                return Container(
                                  child: const Text(
                                    '₹ 0',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                );
                              return SingleChildScrollView(
                                child: totalIncome == null
                                    ? const Text('₹ 0')
                                    : Text(
                                        '₹ ${(totalIncome).toString()}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFffffff),
                                          letterSpacing: 1,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Total Income',
                          style: TextStyle(
                            //color: app_color.textWhite,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Material(
                elevation: 20,
                shadowColor: Colors.orange,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3.2,
                  height: MediaQuery.of(context).size.height / 9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: app_color.widget,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        
                        Colors.red, Colors.orange
                      ], // red to yellow
                      tileMode: TileMode
                          .repeated, // repeats the gradient over the canvas
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        ValueListenableBuilder(
                          valueListenable: TransactionDB
                              .instance.expenseTransactionListNotifier,
                          builder: (BuildContext ctx, expense, Widget? _) {
                            
                            return expense == null
                                ? const Text('₹ 0')
                                : Text(
                                    '₹ ${(expense).toString()}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                      letterSpacing: 1,
                                    ),
                                  );
                          },
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Total Expense',
                          style: TextStyle(
                            //color: app_color.textWhite,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          width: size.width,
          alignment: Alignment.topCenter,
          height: closeTopContainer ? 0 : chartHeight,
          child: FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
            child: Card(
                color: Color(0xf01f2420),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 0,
                shadowColor: Colors.black,
                child: SizedBox(
                  width: 350,
                  height: 200,
                  child: ValueListenableBuilder(
                    valueListenable: TransactionDB.instance.mylistNotifier,
                    builder:
                        (BuildContext ctx, List<Customer> newMap, Widget? _) {
                      if (newMap == null || newMap.isEmpty) {
                        return Center(
                            child: Column(
                          children: [
                            Image.asset(
                              'assets/image/piechart.png',
                              height: 160,
                            ),
                            Text(
                              'No transactions yet',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 15),
                            ),
                          ],
                        ));
                      }
                      return SfCircularChart(
                        legend: Legend(
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap,
                            textStyle: TextStyle(color: Colors.white)),
                        tooltipBehavior: _tooltipBehavior,
                        series: <CircularSeries>[
                          PieSeries<Customer, String>(
                            dataSource: newMap,
                            xValueMapper: (Customer data, _) => data.typeName,
                            yValueMapper: (Customer data, _) => data.amount,
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                labelIntersectAction:
                                    LabelIntersectAction.shift,
                                labelPosition: ChartDataLabelPosition.outside,
                                connectorLineSettings: ConnectorLineSettings(
                                    type: ConnectorType.curve, length: '15%')),
                            enableTooltip: true,
                          )
                        ],
                      );
                    },
                  ),
                )),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: ValueListenableBuilder(
                valueListenable:
                    TransactionDB.instance.filteredTransactionListNotifier,
                builder: (BuildContext ctx, List<TransactionModel> newList,
                    Widget? _) {
                  return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      itemBuilder: (ctx, index) {
                        final _value = newList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Slidable(
                            //closeOnScroll: true,
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  spacing: 10,
                                  onPressed: (ctx) {
                                    // print('slidable delete');
                                    // print(_value.id);
                                    setState(() {
                                      TransactionDB.instance
                                          .deleteTransaction(_value.id!);
                                      TransactionDB.instance.refresh();
                                    });
                                  },
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  backgroundColor: const Color(0xFFFE4A49),
                                  //foregroundColor: Colors.white,
                                ),
                              ],
                            ),
                            child: SizedBox(
                              height: 80,
                              child: Center(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      parseDate(_value.date),
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.cyan),
                                    ),
                                  ),
                                  title: Text(
                                    '₹ ${_value.amount}',
                                    style: TextStyle(
                                      color: _value.type == CategoryType.expense
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                  subtitle: Text(_value.category.name),
                                  trailing: _value.type == CategoryType.expense
                                      ? const Icon(
                                          Icons.trending_down_sharp,
                                          color: Colors.red,
                                        )
                                      : const Icon(
                                          Icons.trending_up_sharp,
                                          color: Colors.green,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return const SizedBox(
                          height: 5,
                        );
                      },
                      itemCount: newList.length);
                })),
      ],
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split(' ');
    return '${_splitedDate.last}\n ${_splitedDate.first}';
    //return '${date.day}\n${date.month}';
  }

 
}
