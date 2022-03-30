
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';

class InfoWidget extends StatefulWidget {
  final PostModel postModel;
  const InfoWidget({required this.postModel,
  });
  InfoWidgetState createState()=>InfoWidgetState();
}
class InfoWidgetState extends State<InfoWidget>{

  bool isExtended=false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
      child: isExtended ?
      Container(
        //height: MediaQuery.of(context).size.height*0.1,
        child: Text(widget.postModel.info,style: TextStyle(color: Colors.grey,fontSize: 14.0),overflow: TextOverflow.ellipsis,),
      ):Wrap(
        children: [
          Text(widget.postModel.info,softWrap: false,style: TextStyle(color: Colors.grey,fontSize: 14.0),overflow: TextOverflow.ellipsis,),
        ],
      ),
    );
  }
}
