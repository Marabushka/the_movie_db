import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/library/widgets/inherited/provider.dart';
import 'package:the_movie_db/widgets/movie_list/movie_list_model.dart';
import 'package:the_movie_db/widgets/movie_list/movie_list_widget.dart';
import 'package:the_movie_db/widgets/auth/button_styles/app_colors.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTab = 0;
  final movieListModel = MovieListModel();

  void _onSelectedTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movieListModel.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TMDB'),
        actions: [
          TextButton(
            onPressed: () => SessionDataProvider().setSessionId(null),
            child: Text('Loqout'),
          )
        ],
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          Text('News'),
          NotifierProvider(
            child: MovieListWidget(),
            create: () => movieListModel,
            isManageModel: false,
          ),
          Text('Serials'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.DarkBlue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedTab,
        onTap: _onSelectedTab,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Фильмы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Сериалы',
          )
        ],
      ),
    );
  }
}
