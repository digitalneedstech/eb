import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page_detail.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';

class ExpertPersonWidget extends StatelessWidget {
  UserDTOModel userDTOModel;
  ExpertPersonWidget({required this.userDTOModel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ListingPageDetail(
          userDTOModel: userDTOModel,
        )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.15,
        margin: const EdgeInsets.only(right: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade500)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EbCircleAvatarWidget(profileImageUrl: userDTOModel.personalDetails.profilePic,),
            Text(userDTOModel.personalDetails.displayName),
            Text(
              userDTOModel.profileOverview.profileTitle,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
