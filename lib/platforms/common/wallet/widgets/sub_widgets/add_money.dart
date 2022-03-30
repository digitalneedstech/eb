import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_eb/platforms/common/wallet/bloc/wallet_event.dart';
import 'package:flutter_eb/platforms/common/wallet/bloc/wallet_state.dart';
import 'package:flutter_eb/platforms/common/wallet/model/transaction_response.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AddMoneyPopUp extends StatefulWidget {
  Function callback;
  AddMoneyPopUp({required this.callback});
  AddPopupState createState()=>AddPopupState();
}
class AddPopupState extends State<AddMoneyPopUp>{
  TextEditingController _moneyController=TextEditingController();
  TextEditingController _currencyNameController=TextEditingController(text: "USD");
  TextEditingController _currencyCodeController=TextEditingController(text:"\$");
  int indexAmountButtonSelected=1;
  late String transactionId;
  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    TransactionResponse transactionResponse=new TransactionResponse(paymentId: response.paymentId!,
    orderId: response.orderId!,signature: response.signature!,amount: int.parse(_moneyController.text),status: 1);
    widget.callback(transactionId,transactionResponse);
    widget.callback(transactionId,"success");
    Navigator.pop(context);
    print("Success");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    TransactionResponse transactionResponse=new TransactionResponse(paymentId: "",signature: "",message: response.message!,
        orderId: "",code: response.code!,status: 0);
    widget.callback(transactionId,transactionResponse);
    widget.callback(transactionId,"failed");
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    TransactionResponse transactionResponse=new TransactionResponse(paymentId: "",signature: "",message: "",orderId: "",code:0);
    widget.callback(transactionId,transactionResponse);
    Navigator.pop(context);
  }

  void openCheckout() async {
    var options = {
      'key': Constants.RAZOR_PAY_ID,
      'amount': int.parse(_moneyController.text.toString())*100,
      'name': 'Acme Corp.',
      'description': 'Add Money To Wallet',
      'prefill': {'contact': BlocProvider.of<LoginBloc>(context).userDTOModel.personalDetails.mobileData.mobile, 'email': BlocProvider.of<LoginBloc>(context).userDTOModel.personalDetails.email},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc,WalletState>(
      listener: (context,state){
        if(state is InitiateTransactionEventState){
          setState(() {
            transactionId=state.transactionId;
          });
          openCheckout();
        }
      },
      child: AlertDialog(
        title: Center(child: Text("Add Money To Wallet"),),
        content: Container(
          height: MediaQuery.of(context).size.height*0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                //crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _currencyCodeController,
                      style: TextStyle(fontSize: 30.0),
                      decoration: InputDecoration.collapsed(
                        hintText: "Please enter currency",
                        border: InputBorder.none,
                      ),
                      onTap:(){
                        showCurrencyPicker(
                          context: context,
                          showFlag: true,
                          showCurrencyName: true,
                          showCurrencyCode: true,
                          onSelect: (Currency currency) {
                            _currencyNameController.text=currency.code;
                            _currencyCodeController.text=currency.symbol;
                          }
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex:3,
                    child: CustomTextField(

                        icon: Icon(Icons.monetization_on_outlined),
                      controller: _moneyController,
                      labelText: "Enter Amount",
                      inputType: TextInputType.number
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Wrap(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlineButton(
                      onPressed: () {
                        _moneyController.text=(int.parse(_moneyController.text==""?"0":_moneyController.text)+int.parse("100")).toString();
                      },
                      child: Center(
                        child: Text(
                          " \$ 100",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      color: Colors.blue,
                      textColor: Colors.blue,
                      borderSide: BorderSide(
                        color: Colors.blue, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 2, //width of the border
                      ),padding: const EdgeInsets.all(0.0),),
                  SizedBox(width: 10.0,),
                  OutlineButton(
                      onPressed: () {
                        _moneyController.text=(int.parse(_moneyController.text==""?"0":_moneyController.text)+int.parse("500")).toString();
                      },
                      child: Center(
                        child: Text(
                          " \$ 500",
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
                  SizedBox(width: 10.0,),
                  OutlineButton(
                      onPressed: () {
                        _moneyController.text=(int.parse(_moneyController.text==""?"0":_moneyController.text)+int.parse("1000")).toString();
                      },
                      child: Center(
                        child: Text(
                          " \$ 1000",
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
                ],
              ),
              Divider(color: Colors.grey,height: 2.0,)
            ],
          ),
        ),
        actions: [
          OutlineButton(
              onPressed: ()=>Navigator.pop(context),
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
          BlocBuilder<WalletBloc,WalletState>(
            builder: (context,state) {
              return RaisedButton(
                onPressed:state is LoadingWalletState ? null : () {
                  if(_moneyController.text!="") {
                    BlocProvider.of<WalletBloc>(context).add(
                        InitiateTransactionEvent(userId: BlocProvider
                            .of<LoginBloc>(context)
                            .userDTOModel
                            .userId,
                            amount: int.parse(_moneyController.text) * 100,
                            currency: _currencyNameController.text));
                  }
                },
                disabledTextColor: Colors.white,
                color: Colors.blue,
                child: Center(
                  child: Text("Submit", style: TextStyle(color: Colors.white),),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}