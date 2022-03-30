import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/widgets/schedule_group_call_button.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/schedule.dart';
import 'package:flutter_eb/shared/utils/schedule_call_functions.dart';

class GroupHeaderWidget extends StatefulWidget {
  final GroupModel groupModel;
  final Function callback;

  GroupHeaderWidget({required this.callback, required this.groupModel});
  GroupHeaderWidgetState createState() => GroupHeaderWidgetState();
}

class GroupHeaderWidgetState extends State<GroupHeaderWidget> {
  TextEditingController _durationController =
      new TextEditingController(text: "15");
  DateTime selectedDate=DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.groupModel.groupName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "${widget.groupModel.groupMembers.length} members",
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    "Total Amount",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Text(
                    "Duration",
                    style: TextStyle(color: Colors.grey),
                  ))
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    "\$ ${_getTotalAmount()}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: ScheduleDropDownField(callback: (int val) {
                    setState(() {
                      _durationController.text = val.toString();
                    });
                  }))
            ],
          ),
          Divider(
            color: Colors.grey,
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
              // border: Border.all(color: Colors.grey.shade500,width: 1.0),
            ),
            child: RaisedButton(
              onPressed: () async {
                DatePicker.showDateTimePicker(context, showTitleActions: true,
                    onChanged: (date) {
                  print('change $date in time zone ' +
                      date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                  print('confirm $date');
                }, currentTime: DateTime.now());
              },
              child: Center(
                child: Text(selectedDate.toLocal().toIso8601String().split("T")[0]),
              ),
              color: Color(0xFF067EED),
              textColor: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScheduleGroupCallButtonByOwner(
                userName: BlocProvider.of<LoginBloc>(context)
                    .userDTOModel
                    .personalDetails
                    .displayName,
                validator: (bool isValid) {
                  if (!isValid)
                    widget.callback(false, "Please Select All the fields");
                },
                callback: (bool isCreated) {
                  if (isCreated) {
                    widget.callback(isCreated, "Schedule is Created");
                    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Schedule is Created"),backgroundColor: Colors.green,));
                  } else {
                    widget.callback(isCreated, "Schedule cant Created");
                    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Schedule cannt be Created"),backgroundColor: Colors.red,));
                  }
                },
                groupModel: widget.groupModel,
                duration: int.parse(_durationController.text),
                selectedDate: selectedDate,
              )
            ],
          )
        ],
      ),
    );
  }

  double _getTotalAmount() {
    double totalAmount = 0;
    for (UserDTOModel model in widget.groupModel.groupMembers.keys.toList()) {
      totalAmount += calculateRate(int.parse(_durationController.text),
          model.rateDetails.hourlyRate.toDouble());
    }
    return totalAmount;
  }
}
