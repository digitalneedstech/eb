import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/shared/utils/schedule_call_functions.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';

import 'widgets/connect_type/connect_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_bloc.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_event.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_state.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat.dart';
import 'package:flutter_eb/platforms/common/chat/widgets/single_chat.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/schedule_call/schedule_call.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickConnectPopup extends StatefulWidget {
  final UserDTOModel freelancerDTOModel;

  QuickConnectPopup({required this.freelancerDTOModel});

  QuickConnectPopupState createState() => QuickConnectPopupState();
}

class QuickConnectPopupState extends State<QuickConnectPopup> {
  int _selectedQuickConnectMethod = 0;
  List<String> disabledConnects = ["Signal"];
  String? errorMessageForPhoneNumberNotExists;
  Map<int, String> quickConnectMap = {
    0: "Voice/Video",
    1: "Chat-pro",
    2: "Phone-enterprise",
    3: "Whatsapp-enterprise",
    4: "Telegram-enterprise"
  };
  @override
  Widget build(BuildContext context) {
    UserDTOModel userDTOModel =
        BlocProvider.of<LoginBloc>(context).userDTOModel;
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is CreateChatState) {
          if (state.chatModel.id == "") {
            if (kIsWeb) {
              Navigator.pushNamed(
                  context,
                  "chat/" +
                      widget.freelancerDTOModel.userId +
                      "/" +
                      widget.freelancerDTOModel.personalDetails.displayName);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleChat(
                          otherUserName: widget
                              .freelancerDTOModel.personalDetails.displayName,
                          chatUserId: widget.freelancerDTOModel.userId,
                        )),
              );
            }
          }
        }
      },
      child: AlertDialog(
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Quick Connect Popups",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
        ),
        contentPadding: const EdgeInsets.all(0.0),
        content: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(0.0),
              width: MediaQuery.of(context).size.width,
              child: ListView(shrinkWrap: true, children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    return ConnectType(
                      callback: (val) {
                        setState(() {
                          _selectedQuickConnectMethod = val;
                        });
                      },
                      index: index,
                      name: quickConnectMap[index]!,
                      groupSelectedVal: _selectedQuickConnectMethod,
                    );
                    //return _getListTile(index, quickConnectMap[index]);
                  },
                  itemCount: quickConnectMap.length,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Divider(
                  color: Colors.grey,
                  height: 2.0,
                ),
                userDTOModel.planType != "pro" || userDTOModel.planType != "Pro"
                    ? Container(
                        margin: EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          "Upgrade to Enterprise! to access all points",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              fontSize: 14.0),
                        ),
                      )
                    : Container(),
                errorMessageForPhoneNumberNotExists == null
                    ? Container()
                    : Container(
                        alignment: Alignment.center,
                        child: Text(
                          errorMessageForPhoneNumberNotExists!,
                          style: TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                              fontSize: 12.0),
                        ),
                      )
              ])),
        ),
        actions: [
          OutlineButton(
              onPressed: () => Navigator.pop(context),
              child: Center(
                child: Text(
                  " Cancel",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              color: Colors.blue,
              textColor: Colors.blue,
              borderSide: BorderSide(
                color: Colors.blue, //Color of the border
                style: BorderStyle.solid, //Style of the border
                width: 1, //width of the border
              )),
          RaisedButton(
            onPressed:
                checkIfSubmitButtonIsEnabled() /*&&
                        !_checkIfMobileNumberIsEmpty(
                            _selectedQuickConnectMethod)*/
                    ? () {
                        if (_selectedQuickConnectMethod == 2) {
                          if (widget.freelancerDTOModel.personalDetails
                              .mobileData.mobile=="" || widget.freelancerDTOModel.personalDetails
                                  .mobileData.rawPhone =="") {
                            setState(() {
                              errorMessageForPhoneNumberNotExists =
                                  "Phone Number Not provided By freelancer";
                            });
                          } else {
                            launch(
                                "tel: ${widget.freelancerDTOModel.personalDetails.mobileData.mobile==""?
                                widget.freelancerDTOModel.personalDetails.mobileData.rawPhone:widget.freelancerDTOModel.personalDetails
                                    .mobileData.mobile}");
                          }
                        } else if (_selectedQuickConnectMethod == 3) {
                          if (widget.freelancerDTOModel.personalDetails
                                  .whatsAppData.rawPhone ==
                              "") {
                            setState(() {
                              errorMessageForPhoneNumberNotExists =
                                  "Phone Number Not provided By freelancer";
                            });
                          } else {
                            launch(
                                " https://wa.me/${widget.freelancerDTOModel.personalDetails.mobileData.mobile==""?
                                widget.freelancerDTOModel.personalDetails.mobileData.rawPhone:widget.freelancerDTOModel.personalDetails
                                    .mobileData.mobile}");
                          }
                        } else if (_selectedQuickConnectMethod == 4) {
                          if (widget.freelancerDTOModel.personalDetails
                                  .whatsAppData.rawPhone ==
                              "") {
                            setState(() {
                              errorMessageForPhoneNumberNotExists =
                                  "Phone Number Not provided By freelancer";
                            });
                          } else {
                            launch(
                                " https://t.me/${widget.freelancerDTOModel.personalDetails.mobileData.mobile==""?
                                widget.freelancerDTOModel.personalDetails.mobileData.rawPhone:widget.freelancerDTOModel.personalDetails
                                    .mobileData.mobile}");
                          }
                        } else if (_selectedQuickConnectMethod == 1) {
                          UserDTOModel userModel =
                              BlocProvider.of<LoginBloc>(context).userDTOModel;
                          ChatModel userChatModel = new ChatModel(
                              createdAt: DateTime.now().toIso8601String(),
                              lastMessage: "",
                              photoURL: widget.freelancerDTOModel
                                  .personalDetails.profilePic,
                              userName: widget.freelancerDTOModel
                                  .personalDetails.displayName);
                          ChatModel freelancerModel = new ChatModel(
                              createdAt: DateTime.now().toIso8601String(),
                              lastMessage: "",
                              photoURL: userModel.personalDetails.profilePic,
                              userName: userModel.personalDetails.displayName);
                          BlocProvider.of<ChatBloc>(context).add(
                              CreateChatEvent(
                                  chatUser: userChatModel,
                                  chatReceiver: freelancerModel,
                                  creatorId: userModel.userId,
                                  receiverId:
                                      widget.freelancerDTOModel.userId));
                        } else if (_selectedQuickConnectMethod == 0) {
                          if (widget.freelancerDTOModel.isOnline) {
                            checkIfExistingBidBeforeStartingCall(
                                    widget.freelancerDTOModel, context)
                                .then((BidModel bidModel) {
                              if (bidModel.acceptedRate == 0) {
                                setState(() {
                                  errorMessageForPhoneNumberNotExists =
                                      "Freelancer Asked Rate is Zero";
                                });
                              } else {
                                CallModel callModel = CallModel(
                                    acceptedPrice:
                                        bidModel.acceptedRate.toDouble(),
                                    userId: userDTOModel.userId,
                                    receiverId: [
                                      widget.freelancerDTOModel.userId
                                    ],
                                    scheduleId: "",
                                    receiverName: widget.freelancerDTOModel
                                        .personalDetails.displayName,
                                    userName: userDTOModel
                                        .personalDetails.displayName);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScheduleCall(
                                            callModel: callModel,
                                            buttonTitle: "Call Now",
                                          )),
                                );
                              }
                            });
                          } else {
                            setState(() {
                              errorMessageForPhoneNumberNotExists =
                                  "Freelancer Is Not Online to Take call.";
                            });
                          }
                        }
                      }
                    : null,
            color: Colors.blue,
            child: Center(
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool checkIfSubmitButtonIsEnabled() {
    String planType = getUserDTOModelObject(context).planType;
    switch (planType) {
      case "pro":
      case "Pro":
        if (_selectedQuickConnectMethod >= 0 &&
            _selectedQuickConnectMethod <= 1) return true;
        return false;
      case "enterprise":
      case "Enterprise":
        return true;
      default:
        if (_selectedQuickConnectMethod == 0) return true;
        return false;
    }
  }
}
