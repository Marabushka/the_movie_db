import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/entity/movie_details_credits.dart';
import 'package:the_movie_db/library/widgets/inherited/provider.dart';
import 'package:the_movie_db/navigation/main_navigation.dart';
import 'package:the_movie_db/widgets/movie_details/movie_details_model.dart';
import 'package:the_movie_db/widgets/movie_details/paint_widget.dart';
import 'package:the_movie_db/widgets/movie_details/screen_cast_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  void didChangeDependencies() {
    NotifierProvider.read<MovieDetailsModel>(context)?.setupLocale(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _TitleWidget(),
        centerTitle: true,
      ),
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final movieDetails = model?.movieDetails;
    if (movieDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: [
        MovieImageWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: MovieName(),
        ),
        UserAndPlayButtons(),
        SummaryWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Обзор',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            movieDetails.overview ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: PeopleDirectorWidget(),
        ),
        SizedBox(
          height: 20,
        ),
        MovieScreenCastWidget(),
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    return Text(model?.movieDetails?.title ?? 'Loading...');
  }
}

class MovieName extends StatelessWidget {
  const MovieName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final year = model?.movieDetails?.releaseDate?.year.toString() ?? ' ';
    return RichText(
      textAlign: TextAlign.center,
      maxLines: 3,
      text: TextSpan(children: [
        TextSpan(
            text: model?.movieDetails?.title ?? ' ',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w600,
            )),
        TextSpan(
            text: ' ($year)',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            )),
      ]),
    );
  }
}

class MovieImageWidget extends StatelessWidget {
  const MovieImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;
    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          backdropPath != null
              ? Image.network(ApiClient.imageUrl(backdropPath))
              : SizedBox.shrink(),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: posterPath != null
                  ? Image.network(ApiClient.imageUrl(posterPath))
                  : SizedBox.shrink(),
            ),
          ),
          Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                color: Colors.red,
                icon: Icon(model?.isFavorite == true
                    ? Icons.favorite
                    : Icons.favorite_border_sharp),
                onPressed: () => model?.toggleFavorite(),
              ))
        ],
      ),
    );
  }
}

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return SizedBox.shrink();
    final movieDetails = model.movieDetails;
    var texts = <String>[];
    final releaseDate = movieDetails?.releaseDate;
    final runtime = movieDetails?.runtime ?? 0;
    if (releaseDate != null) {
      texts.add(model.stringFromDate(releaseDate));
    }
    final productCountry = movieDetails?.productionCountries;
    if (productCountry != null && productCountry.isNotEmpty) {
      texts.add('(${productCountry.first.iso})');
    }
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}ч ${minutes}м');
    final genres = movieDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genr in genres) {
        genresNames.add(genr.name);
      }
      texts.add(genresNames.join(', '));
    }

    return ColoredBox(
      color: Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          texts.join(' '),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class UserAndPlayButtons extends StatelessWidget {
  const UserAndPlayButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var percent = model?.movieDetails?.voteAverage ?? 0;

    var raiting = (percent * 10).toStringAsFixed(0);
    final videos = model?.movieDetails?.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;

    return Row(
      children: [
        TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () {},
            child: Row(
              children: [
                SizedBox(
                  height: 45,
                  width: 45,
                  child: RadialPercentWidget(
                    child: Text('$raiting'),
                    arcLeftColor: Color.fromARGB(255, 10, 23, 25),
                    arcColor: Color.fromARGB(255, 37, 203, 103),
                    lineWidth: 3,
                    freeColor: Color.fromARGB(255, 25, 54, 31),
                    percent: percent / 10,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Пользовательский',
                    ),
                    Text(
                      'cчет',
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            )),
        Container(
          width: 1,
          height: 15,
          color: Colors.grey,
        ),
        trailerKey != null
            ? TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () => Navigator.of(context).pushNamed(
                    MainNavigationRouteNames.movieTrailerWidget,
                    arguments: trailerKey),
                child: Row(
                  children: [
                    Icon(Icons.play_arrow),
                    Text(
                      'Воспроизвести трейлер',
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

class PeopleDirectorWidget extends StatelessWidget {
  const PeopleDirectorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var crew = model?.movieDetails?.credits.crew;
    if (crew == null || crew.isEmpty) return SizedBox.shrink();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<Employee>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks
          .add(crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2));
    }
    return Column(
        children: crewChunks
            .map((chunk) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _PeopleWidgetsRow(employes: chunk),
                ))
            .toList());
  }
}

class _PeopleWidgetsRow extends StatelessWidget {
  final List<Employee> employes;
  const _PeopleWidgetsRow({
    Key? key,
    required this.employes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        children: employes
            .map((employee) => _PeopleWidgetsRowItem(
                  employee: employee,
                ))
            .toList());
  }
}

class _PeopleWidgetsRowItem extends StatelessWidget {
  final Employee employee;
  const _PeopleWidgetsRowItem({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          Text(
            employee.job,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
