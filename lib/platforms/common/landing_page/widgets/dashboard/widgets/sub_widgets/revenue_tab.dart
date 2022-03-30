import 'package:flutter/material.dart';
import 'package:flutter_eb/shared/widgets/bar_chart/bar_chart.dart';
import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter_eb/shared/utils/util_functions.dart';
class RevenueTab extends StatelessWidget{
  final String headerTitle,subTitle;
  final int index;
  RevenueTab({required this.index,required this.subTitle,required this.headerTitle});
  @override
  Widget build(BuildContext context) {
    List<chart.Series<OrdinalSales, String>> data =_createSampleData();
    //_getDataForContainer(context);
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width*0.8,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(headerTitle,style: TextStyle(color: Colors.black,fontSize: 14.0),),
          SizedBox(height: 20.0),
          Text("\$ ${getUserDTOModelObject(context).walletAmount}",style: TextStyle(color: Colors.black,fontSize: 14.0),),
          SizedBox(height: 10.0),
          Text("Earnings",style: TextStyle(color: Colors.grey,fontSize: 12.0),),
          SizedBox(height: 10.0,),
          data.length==0?Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No Earnings Found For TimeFrame")
            ],
          ):
          Container(width:MediaQuery.of(context).size.width*0.9,
              height:MediaQuery.of(context).size.height*0.1,
              child: SimpleBarChart(_createSampleData(),animateProperty: true,)),
        ],
      ),
    );
  }

  static List<chart.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('14', 5),
      new OrdinalSales('15', 25),
      new OrdinalSales('16', 100),
      new OrdinalSales('17', 75),
    ];

    return [
      new chart.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => chart.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.date,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}