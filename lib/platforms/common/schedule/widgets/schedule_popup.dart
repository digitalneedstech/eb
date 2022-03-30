import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/home_nav/home_nav.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_event.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/date_time_row.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/rate_duration_row.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/scheduled_freelancer_image/scheduled_freelancer_image.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';

class SchedulePopUp extends StatefulWidget {
  final ScheduleRequest scheduleRequest;
  SchedulePopUp({required this.scheduleRequest});
  SchedulePopUpState createState() => SchedulePopUpState();
}

class SchedulePopUpState extends State<SchedulePopUp> {
  TextEditingController _descriptionController = new TextEditingController();
  Widget build(BuildContext context) {
    return BlocListener<ScheduledBloc, ScheduledState>(
      listener: (context, state) {
        if (state is CreatedScheduledState) {
          if(state.isUpdated) {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeNav(index: 4)),
            );
          }
        }
      },
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(0.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Scheduling your Call with:",
              style: TextStyle(fontSize: 16.0),
            ),
            IconButton(
                padding: const EdgeInsets.all(0.0),
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context))
          ],
        ),
        actions: [
          OutlineButton(
              onPressed: () => Navigator.pop(context),
              child: Center(
                child: Text("Cancel"),
              )),
          BlocBuilder<ScheduledBloc, ScheduledState>(
            builder: (context, state) {
              if (state is CreatedScheduledState) {
                return Center(
                  child: Text(
                    state.isUpdated
                        ? "Schedule is Created"
                        : "Schedule Could not be updated. Please try after some time",
                    style: TextStyle(
                        color: state.isUpdated
                            ? Colors.green
                            : Colors.red),
                  ),
                );
              }
              if (state is LoadingScheduleState) {
                return EbRaisedButtonWidget(
                  callback: (){},
                  textColor: Colors.white,
                );
              } else {
                return RaisedButton(
                  onPressed: () {

                    widget.scheduleRequest.description =
                        _descriptionController.text;
                    BlocProvider.of<ScheduledBloc>(context).add(
                        CreateScheduleEvent(
                            scheduleRequest:
                            widget.scheduleRequest));
                  },
                  child: Center(
                    child: Text("Schedule"),
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                );
              }
            },
          )
        ],
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(0.0),
            height: MediaQuery.of(context).size.height * 0.70,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ScheduledFreelancerImageWidget(userId: widget.scheduleRequest.freelancerId,)
                      ],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.scheduleRequest.freelancerName,
                            style: TextStyle(
                              color: Color(0xFF1787E0),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("Title")
                        ])
                  ]),
                ),
                SizedBox(
                  height: 10.0,
                ),
                DateTimeRow(scheduleRequest: widget.scheduleRequest),
                RateDurationRow(
                  scheduleRequest: widget.scheduleRequest,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    alignment: Alignment.topLeft,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      "Additional Message",
                      style: TextStyle(color: Colors.grey.shade500),
                    )),
                Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    color: Colors.white,
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (String val) {
                          setState(() {
                            _descriptionController.text = val;
                          });
                        },
                        maxLines: 5,
                        decoration: InputDecoration.collapsed(
                            hintText: "Tell About Yourself"),
                      ),
                    )),
                SizedBox(
                  height: 10.0,
                ),
                Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BidTextField extends StatefulWidget {
  Function callback;
  BidTextField({required this.callback});
  BidTextFieldState createState() => BidTextFieldState();
}

class BidTextFieldState extends State<BidTextField> {
  String bidValue = "";
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.40,
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: bidValue,
        onChanged: (String val) {
          setState(() {
            bidValue = val;
            widget.callback(bidValue);
          });
        },
        decoration: InputDecoration(
          hintText: "Enter Value",
          enabledBorder: OutlineInputBorder(
            gapPadding: 0.0,
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
