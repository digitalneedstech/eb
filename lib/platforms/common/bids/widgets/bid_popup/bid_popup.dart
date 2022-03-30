import 'package:cool_alert/cool_alert.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_popup/widgets/switch.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/rate.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_state.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_message.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/constants/routes.dart';

class BidPopup extends StatefulWidget {
  //TODO- Add new variable here for bid id which will be null if coming for new bid from search listing screen or anywhere
  final UserDTOModel model; // UserModel of Freelancer
  String freelancerId, bidderId;
  String companyId; //FreelancerID is the bidding Id and BidderId whosoe
  String bidId;
  String status; // ver is giving counter bid
  final Function callback;

  BidPopup({required this.model,
    required this.companyId,
    this.bidId = "",
    required this.callback,
    this.bidderId = "",
    this.freelancerId = "",
    this.status = "pending"});
  BidPopupState createState()=>BidPopupState(
    callback: callback,model: model,companyId: companyId,freelancerId: freelancerId,status: status,
    bidderId: bidderId,bidId: bidId
  );
}
class BidPopupState extends State<BidPopup>{
  final UserDTOModel model; // UserModel of Freelancer
  String freelancerId, bidderId;
  String companyId; //FreelancerID is the bidding Id and BidderId whosoe
  String bidId;
  String status; // ver is giving counter bid
  final Function callback;

  BidPopupState({required this.model,
    required this.companyId,
    this.bidId = "",
    required this.callback,
    this.bidderId = "",
    this.freelancerId = "",
    this.status = "pending"});
  Widget build(BuildContext context) {
    TextEditingController bidAmountController =
        BlocProvider.of<BidBloc>(context).bidController;
    TextEditingController messageController =
        BlocProvider.of<BidBloc>(context).messageController;

    if (bidId != "") {
      BlocProvider.of<BidBloc>(context)
          .add(FetchBidInfoInPopUpEvent(bidId: bidId, userId: bidderId));
    }
    return BlocListener<BidBloc, BidState>(
      listener: (context, bidState) {
        if (bidState is CreatedOrUpdatedBidState) {
          if (callback != null) {
            Navigator.pop(context, true);
            callback();
          } else {
            Navigator.popAndPushNamed(context, Routes.LISTING_PAGE);
          }
        }
      },
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(0.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Make Your Bid"),
            IconButton(
                padding: const EdgeInsets.all(0.0),
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context, false))
          ],
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlineButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Center(
                        child: Text("Cancel"),
                      )),
                  SizedBox(
                    width: 10.0,
                  ),bidId!=""?BlocBuilder<BidBloc, BidState>(
                          builder: (context, state) {
                          if (state is BidInfoInPopupState) {
                            if (state.bidModel.id == "") {
                              BlocProvider.of<BidBloc>(context)
                                      .isButtonEnabled =

                                      (bidAmountController.text != "" &&
                                          bidAmountController.text != "0" &&
                                          int.parse(bidAmountController.text) >=
                                              model.rateDetails.minBid);
                            } else if (state.bidModel.id != "") {
                              BlocProvider.of<BidBloc>(context)
                                  .isButtonEnabled =
                                  bidAmountController.text.trim() !=
                                      "0";
                            }
                            return RaisedButton(
                              onPressed: BlocProvider.of<BidBloc>(context)
                                      .isButtonEnabled
                                  ? () {
                                      BidModel bidModel = state.bidModel;
                                      _createBidMainModel(bidModel, context);
                                      bidModel.status = status;
                                      createBidMessage(bidModel, context);
                                      bidModel.description =
                                          messageController.text;
                                      bidModel.companyId=companyId;
                                      BlocProvider.of<BidBloc>(context).add(
                                          CreateOrUpdateBidEvent(
                                              updatedBy: getUserDTOModelObject(context)
                                                  .userId==bidModel.userId ?"user":"freelancer",
                                              companyId: companyId,
                                              bidModel: bidModel,
                                              userId: bidderId,
                                              freelancerId: freelancerId,
                                              isNewBid: bidModel.id == ""
                                                  ? true
                                                  : false));

                                      BlocProvider.of<BidBloc>(context)
                                          .isButtonEnabled = false;
                                    }
                                  : null,
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  "Send",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                          return RaisedButton(
                            onPressed: null,
                            color: Colors.blue,
                            child: Center(
                              child: Text(
                                "Loading",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }):
    RaisedButton(
    onPressed: () {
    BidModel bidModel = new BidModel();
    _createBidMainModel(bidModel, context);
    bidModel.status = status;
    createBidMessage(bidModel, context);
    bidModel.description = messageController.text;
    bidModel.companyId=companyId;
    BlocProvider.of<BidBloc>(context).add(
    CreateOrUpdateBidEvent(
    updatedBy: "user",
    companyId: companyId,
    bidModel: bidModel,
    userId: bidderId,
    freelancerId: freelancerId,
    isNewBid:
    bidModel.id == "" ? true : false));

    BlocProvider.of<BidBloc>(context).isButtonEnabled =
    false;
    },
    color: Colors.blue,
    child: Center(
    child: Text(
    "Send",
    style: TextStyle(color: Colors.white),
    ),
    ),
    )

                ],
              )),
        ],
        content: BlocBuilder<BidBloc,BidState>(builder:(context,state){


          return  SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(0.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Divider(
                    color: Colors.grey,
                    height: 2.0,
                  ),
                  SwitchBidType(bidId: bidId,
                      bidType: BlocProvider.of<BidBloc>(context).isLongTerm,callback: (val){
                      BlocProvider.of<BidBloc>(context).isLongTerm=val;
                      setState(() {

                      });
                    },),
                  _minimumBidWidget(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _bidAmountWidget(context),
                  SizedBox(
                    height: 10.0,
                  ),
                  _isLongTermContainer(context),
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
                          controller:
                              BlocProvider.of<BidBloc>(context).messageController,
                          maxLines: 2,
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
                  model.rateDetails.hourlyRate == 0 || BlocProvider.of<BidBloc>(context).bidController.text=="" ||
                          int.parse(BlocProvider.of<BidBloc>(context).bidController.text) >
                              model.rateDetails.hourlyRate
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Wrap(
                            children: [
                              Text(
                                "Hourly Amount should be more than zero or Bid Amount should be less than bid amount",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.redAccent,
                                    fontSize: 12.0),
                              )
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          );
          }
        ),
      ),
    );
  }

  Widget _isLongTermContainer(BuildContext context) {
    return bidId == ""
        ? (BlocProvider.of<BidBloc>(context).isLongTerm
            ? getLongTermWidget(context)
            : Container())
        : BlocBuilder<BidBloc, BidState>(builder: (context, state) {
            if (state is BidInfoInPopupState) {
              if (state.bidModel.id != "") {
                if (state.bidModel.isLongTerm) {
                  return getLongTermWidget(context);
                }
                return Container();
              } else {
                getLongTermWidget(context);
              }
            }
            return Container();
          });
  }

  Container getLongTermWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hours Needed"),
                  SizedBox(
                    height: 10.0,
                  ),
                  bidderId ==
                          BlocProvider.of<LoginBloc>(context)
                              .userDTOModel
                              .userId
                      ? BlocBuilder<BidBloc, BidState>(
                          builder: (context, state) {
                          if (state is BidInfoInPopupState) {
                            if (state.bidModel.id == "") {
                              return BidTextField(
                                controller: BlocProvider.of<BidBloc>(context)
                                    .hoursController,
                                  );
                            } else {
                              BlocProvider.of<BidBloc>(context).hoursController.text=state.bidModel.bid
                              [state.bidModel.bid.length-1].amount.toString();
                              return BidTextField(
                                controller: BlocProvider.of<BidBloc>(context)
                                    .hoursController,
                              );
                            }
                          }
                          return BidTextField(
                            controller: BlocProvider.of<BidBloc>(context)
                                .hoursController,
                          );
                        })
                      : BlocBuilder<BidBloc, BidState>(
                          builder: (context, state) {
                          if (state is BidInfoInPopupState) {
                            return Text(state.bidModel
                                .bid[state.bidModel.bid.length - 1].hoursNeeded
                                .toString());
                          }
                          return Container();
                        }),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Valid Till"),
                    SizedBox(
                      height: 10.0,
                    ),
                    bidderId ==
                            BlocProvider.of<LoginBloc>(context)
                                .userDTOModel
                                .userId
                        ? Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Row(
                              children: [
                                Text(BlocProvider.of<BidBloc>(context)
                                            .selectedValidDate ==
                                        ""
                                    ? "Date"
                                    : BlocProvider.of<BidBloc>(context)
                                        .validDateController
                                        .text),
                                IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                              context: context,
                                              initialDate:
                                                  BlocProvider.of<BidBloc>(
                                                          context)
                                                      .selectedValidDate,
                                              initialDatePickerMode:
                                                  DatePickerMode.day,
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2101));
                                      if (picked != null) {
                                        BlocProvider.of<BidBloc>(context)
                                            .selectedValidDate = picked;
                                        BlocProvider.of<BidBloc>(context)
                                                .validDateController
                                                .text =
                                            DateFormat.yMd().format(
                                                BlocProvider.of<BidBloc>(
                                                        context)
                                                    .selectedValidDate);
                                      }
                                    })
                              ],
                            ))
                        : BlocBuilder<BidBloc, BidState>(
                            builder: (context, state) {
                            if (state is BidInfoInPopupState) {
                              DateTime dateTime = DateTime.parse(state
                                  .bidModel
                                  .bid[state.bidModel.bid.length - 1]
                                  .validTill);
                              String date = dateTime.day.toString() +
                                  Constants.months[dateTime.month]! +
                                  "-" +
                                  dateTime.year.toString();
                              return Text(date);
                            }
                            return Container();
                          })
                  ],
                ),
              )
            ]));
  }

  Container _bidAmountWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Current Rate"),
              SizedBox(
                height: 10.0,
              ),
              BlocBuilder<BidBloc, BidState>(builder: (context, state) {
                if (state is BidInfoInPopupState) {
                  if (state.bidModel.id != "") {
                    return BidRate(
                        hourlyRate: state.bidModel
                            .bid[state.bidModel.bid.length - 1].amount);
                  }
                }
                return BidRate(hourlyRate: model.rateDetails.hourlyRate);
              })
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Your Bid"),
        BidTextField(
    controller: BlocProvider.of<BidBloc>(context)
        .bidController,
    )

            ],
          )
        ],
      ),
    );
  }

  Container _minimumBidWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(10.0)),
      child: Text(
          "The Minimum bid starts From \$ ${model.rateDetails == null ? '0' : "${model.rateDetails.minBid}"}"),
    );
  }


  void createBidMessage(BidModel bidModel, BuildContext context) {
    BidMessageModel message = BidMessageModel();
    message.status = status;
    message.message = BlocProvider.of<BidBloc>(context).messageController.text;
    message.userId =
        bidderId == BlocProvider.of<LoginBloc>(context).userDTOModel.userId
            ? bidderId
            : freelancerId;
    message.createdAt = DateTime.now().toIso8601String();
    message.amount =
        BlocProvider.of<BidBloc>(context).bidController.text=="" ? 0:
        int.parse(BlocProvider.of<BidBloc>(context).bidController.text);
    if (bidModel.id == "") {
      if (BlocProvider.of<BidBloc>(context).isLongTerm) {
        message.hoursNeeded = bidModel.hoursNeeded;
        message.validTill = BlocProvider.of<BidBloc>(context)
            .selectedValidDate
            .toIso8601String();
      } else {
        message.validTill =
            DateTime.now().add(Duration(days: 2)).toIso8601String();
      }
    } else {
      if (bidModel.isLongTerm) {
        message.hoursNeeded = bidModel.hoursNeeded;
        message.validTill = BlocProvider.of<BidBloc>(context)
            .selectedValidDate
            .toIso8601String();

        message.validTill=BlocProvider.of<BidBloc>(context)
            .selectedValidDate.day==DateTime.now().add(Duration(days: 2)).day ?
        bidModel.bid[bidModel.bid.length-1].validTill:
        BlocProvider.of<BidBloc>(context)
            .selectedValidDate.toIso8601String();
      }
    }

    bidModel.bid.add(message);
  }

  void _createBidMainModel(BidModel bidModel, BuildContext context) {
    if (bidModel.id == "") {
      bidModel.clientName = model.personalDetails.displayName;
      bidModel.profileName = BlocProvider.of<LoginBloc>(context)
          .userDTOModel
          .personalDetails
          .displayName;
      bidModel.status = status;
      bidModel.bid = [];
      bidModel.userId = bidderId;
      bidModel.freelancerId = freelancerId;
      bidModel.createdAt = DateTime.now().toIso8601String();
      bidModel.askedRate = model.rateDetails.hourlyRate;
    }
    if (bidModel.id == "") {
      if (BlocProvider.of<BidBloc>(context).isLongTerm) {
        bidModel.isLongTerm = true;
        bidModel.hoursNeeded =
            int.parse(BlocProvider.of<BidBloc>(context).hoursController.text);
        bidModel.validTill = BlocProvider.of<BidBloc>(context)
            .selectedValidDate
            .toIso8601String();
      } else {
        bidModel.validTill = BlocProvider.of<BidBloc>(context)
            .selectedValidDate
            .toIso8601String();
      }
    } else {
      if (bidModel.isLongTerm) {
        if (bidModel.userId ==
            BlocProvider.of<LoginBloc>(context).userDTOModel.userId) {
          bidModel.hoursNeeded =
              int.parse(BlocProvider.of<BidBloc>(context).hoursController.text);
          bidModel.validTill = BlocProvider.of<BidBloc>(context)
              .selectedValidDate==DateTime.now().add(Duration(days: 2)) ? bidModel.bid[bidModel.bid.length-1].validTill:
          BlocProvider.of<BidBloc>(context)
              .selectedValidDate.toIso8601String();
        } else
          bidModel.hoursNeeded =
              bidModel.bid[bidModel.bid.length - 1].hoursNeeded;
      }
    }
  }
}

class BidTextField extends StatelessWidget {
 TextEditingController controller;
  BidTextField({required this.controller});
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.40,
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
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
