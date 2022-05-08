import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/library/widgets/inherited/provider.dart';
import 'package:the_movie_db/resources/resources.dart';
import 'package:the_movie_db/widgets/movie_details/movie_details_model.dart';

class MovieScreenCastWidget extends StatelessWidget {
  const MovieScreenCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'В главных ролях',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 250,
            child: Scrollbar(
              child: _ActorList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: Text('Полный актёрский и съёмочный состав')),
          ),
          Container(
            color: Colors.grey,
            height: 2,
            width: double.infinity,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Социальные сети',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('Обсуждения 21'),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Рецензии 0'),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  )
                ],
              ),
            ],
          ),
          Column(
            children: [
              CommensWidget(
                Avatar: AssetImage(AppImages.riotImage),
                CommenttText: 'Fight scenes are garbage',
                CommentNumber: '11',
                UserCommentName: 'от Skilovik54',
                CommentDate: '02 июл 2021 в 00:41',
              ),
              CommensWidget(
                Avatar: AssetImage(AppImages.bale),
                CommenttText: 'Ну я чисто пажилой рыцарь',
                CommentNumber: '17',
                UserCommentName: 'от Skilovik54',
                CommentDate: '02 июл 2021 в 00:41',
              ),
              CommensWidget(
                Avatar: AssetImage(AppImages.bale2),
                CommenttText: 'Ohhh Its Daril bra',
                CommentNumber: '22',
                UserCommentName: 'от Skilovik54',
                CommentDate: '02 июл 2021 в 00:41',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActorList extends StatelessWidget {
  const _ActorList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var cast = model?.movieDetails?.credits.cast;
    if (cast == null || cast.isEmpty) return SizedBox.shrink();
    return ListView.builder(
      itemCount: cast.length,
      itemExtent: 120,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return _ListRowItemWidget(actorsIndex: index);
      },
    );
  }
}

class _ListRowItemWidget extends StatelessWidget {
  final int actorsIndex;
  const _ListRowItemWidget({
    required this.actorsIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<MovieDetailsModel>(context);
    final actor = model!.movieDetails!.credits.cast[actorsIndex];
    final profilePath = actor.profilePath;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                child: profilePath != null
                    ? Image.network(
                        ApiClient.imageUrl(profilePath),
                        width: 120,
                        height: 120,
                        fit: BoxFit.fitWidth,
                      )
                    : SizedBox.shrink()),
            TextButton(
              onPressed: () {},
              child: Text(
                actor.name,
                maxLines: 2,
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                actor.character,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommensWidget extends StatelessWidget {
  const CommensWidget({
    Key? key,
    required this.Avatar,
    required this.CommenttText,
    required this.CommentNumber,
    required this.UserCommentName,
    required this.CommentDate,
  }) : super(key: key);
  final AssetImage Avatar;
  final String CommenttText;
  final String CommentNumber;
  final String UserCommentName;
  final String CommentDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    child: CircleAvatar(
                      backgroundImage: Avatar,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      CommenttText,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Открыто',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(CommentNumber),
                Column(
                  children: [
                    Text(
                      CommentDate,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      UserCommentName,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
