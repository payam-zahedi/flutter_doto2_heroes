import 'dart:developer';

import 'package:flutter/material.dart';

// model
class DotaHero {
  const DotaHero({
    @required this.name,
    @required this.imagePath,
    @required this.views,
    @required this.color,
  });

  final String name;
  final String imagePath;
  final String views;
  final MaterialColor color;

  static List<DotaHero> get favoriteHeroes => [
        DotaHero(
          name: 'Rubick',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/rubick.png',
          views: '24k',
          color: Colors.green,
        ),
        DotaHero(
          name: 'Ogry',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/ogry.png',
          views: '24k',
          color: Colors.indigo,
        ),
        DotaHero(
          name: 'Slark',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/slark.png',
          views: '39k',
          color: Colors.brown,
        ),
        DotaHero(
          name: 'Void',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/void.png',
          views: '13k',
          color: Colors.deepPurple,
        ),
        DotaHero(
          name: 'Shadow Fiend',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sf.png',
          views: '33k',
          color: Colors.red,
        ),
        DotaHero(
          name: 'Zeus',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/zeus.png',
          views: '24k',
          color: Colors.blue,
        ),
        DotaHero(
          name: 'Earth Shaker',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/earth_shaker.png',
          views: '33k',
          color: Colors.orange,
        ),
        DotaHero(
          name: 'Disruptor',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/disruptor.png',
          views: '33k',
          color: Colors.teal,
        ),
        DotaHero(
          name: 'Invoker',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/invoker.png',
          views: '33k',
          color: Colors.lime,
        ),
        DotaHero(
          name: 'Sven',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sven.png',
          views: '54k',
          color: Colors.blueGrey,
        ),
      ];
}

//main runner
void main() {
  runApp(IntroductionApp());
}

class IntroductionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFAD4637),
          primaryVariant: Color(0xFFC95053),
          secondary: Color(0xFF18B767),
          secondaryVariant: Color(0xFF18B767),
          background: Color(0xFF000001),
          surface: Color(0xFF14141C),
          error: Color(0xFFe51c23),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Color(0xFFDBDBEF),
          onSurface: Color(0xFFC1C1D3),
          onError: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xFF000001),
          elevation: 0,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: DetailPage(hero: DotaHero.favoriteHeroes.first),
    );
  }
}

// favorite page
class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Learn your \nFavorite Hero',
                      style: Theme.of(context).textTheme.display1.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipOval(
                        child: Image.network(
                          'https://www.thersa.org/globalassets/profile-images/staff/ben-dellot.jpg',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.extent(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  maxCrossAxisExtent: 210,
                  childAspectRatio: 9 / 11,
                  children: DotaHero.favoriteHeroes
                      .map(
                        (item) => HeroWidget(
                          hero: item,
                          onTap: () {},
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HeroWidget extends StatefulWidget {
  const HeroWidget({
    Key key,
    @required this.hero,
    @required this.onTap,
  }) : super(key: key);

  final DotaHero hero;
  final VoidCallback onTap;

  @override
  _HeroWidgetState createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> with SingleTickerProviderStateMixin {
  AnimationController _clickController;
  Animation _imageAnimation;
  Animation _paddingAnimation;
  Animation _fadeAnimation;

  final _beginPadding = EdgeInsets.only(top: 36, left: 16, right: 8);
  final _endPadding = EdgeInsets.only(top: 42, left: 24, right: 8, bottom: 8);

  @override
  void initState() {
    _clickController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );

    _imageAnimation = Tween<double>(
      begin: 16,
      end: 0,
    ).animate(CurvedAnimation(parent: _clickController, curve: Curves.easeInSine));

    _paddingAnimation = EdgeInsetsTween(
      begin: _beginPadding,
      end: _endPadding,
    ).animate(CurvedAnimation(parent: _clickController, curve: Curves.easeInSine));

    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _clickController, curve: Curves.easeInSine));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        log('onTap');
      },
      onTapDown: (value) {
        log('onTapDown');
        _clickController.forward();
      },
      onTapCancel: () {
        log('onTapCancel');
        _clickController.reverse();
      },
      onTapUp: (value) {
        log('onTapUp');
        _clickController.reverse();
      },
      child: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _paddingAnimation,
            builder: (BuildContext context, Widget child) {
              return Padding(
                padding: _paddingAnimation.value,
                child: child,
              );
            },
            child: ClipPath(
              clipper: RoundedDiagonalPathClipper(borderRadius: 24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.hero.color[200],
                      widget.hero.color[800],
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: LayoutBuilder(
              builder: (context, constraints) {
                print(constraints);
                return AnimatedBuilder(
                  child: Image.network(
                    widget.hero.imagePath,
                    fit: BoxFit.contain,
                  ),
                  animation: _imageAnimation,
                  builder: (BuildContext context, Widget child) {
                    return SizedBox(
                      width: constraints.maxWidth - _imageAnimation.value,
                      height: constraints.maxHeight - _imageAnimation.value,
                      child: child,
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            left: 32,
            bottom: 32,
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.hero.name,
                    style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: 16,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${widget.hero.views} Views',
                    style: Theme.of(context).textTheme.body1.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedDiagonalPathClipper extends CustomClipper<Path> {
  const RoundedDiagonalPathClipper({this.borderRadius});

  final double borderRadius;

  @override
  Path getClip(Size size) {
    double radius = borderRadius ?? 60;
    final initWidth = radius;
    final initHeight = size.height * 1 / 10;

    Path path = Path()
      ..moveTo(initWidth, initHeight)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(
        Offset(size.width, radius),
        radius: Radius.circular(radius),
      )
      ..lineTo(size.width, size.height - radius)
      ..arcToPoint(
        Offset(size.width - radius, size.height),
        radius: Radius.circular(radius),
      )
      ..lineTo(radius, size.height)
      ..arcToPoint(
        Offset(0, size.height - radius),
        radius: Radius.circular(radius),
        clockwise: true,
      )
      ..lineTo(0, initHeight + radius)
      ..arcToPoint(
        Offset(radius, initHeight),
        radius: Radius.elliptical(radius, radius),
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

// detail page
class DetailPage extends StatelessWidget {
  final DotaHero hero;

  const DetailPage({
    Key key,
    @required this.hero,
  })  : assert(hero != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          hero.name,
          style: Theme.of(context).textTheme.body1,
        ),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: () {}),
      ),
    );
  }
}
