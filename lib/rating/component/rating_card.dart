import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  //NetworkImage, AssetImage, CircleAvatar
  final ImageProvider avatarImage;
  //리스트로 위젯 이미지를 보여줄때
  final List<Image> reviewImages;
  //별점
  final int rating;
  //이메일
  final String email;
  //리뷰내용
  final String content;

  const RatingCard(
      {required this.rating,
      required this.content,
      required this.avatarImage,
      required this.email,
      required this.reviewImages,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          email: email,
          rating: rating,
        ),
        const SizedBox(height: 8.0,),
        _Body(
          content: content,
        ),
        if(reviewImages.length >0)
        SizedBox(
          height: 100,
          child: _Images(
            reviewImages: reviewImages,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final int rating;
  final String email;

  const _Header(
      {required this.email,
      required this.avatarImage,
      required this.rating,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: PRIMARY_COlOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ]
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> reviewImages;

  const _Images({
    required this.reviewImages,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: reviewImages.mapIndexed(
              (index, e) => Padding(
                padding: EdgeInsets.only(
                 right: index == reviewImages.length -1 ? 0 : 16.0
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: e,
                ),
              ),
      ).toList(),
    );
  }
}
