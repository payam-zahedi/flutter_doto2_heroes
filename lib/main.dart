import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      home: FavoritePage(),
    );
  }
}

// favorite page
class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

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
                      style: Theme.of(context).textTheme.headline4.copyWith(
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
                  children: List<Widget>.generate(
                    DotaHero.favoriteHeroes.length,
                    (index) {
                      final count = DotaHero.favoriteHeroes.length + 3;
                      final beginInterval = (1 / count) * index;
                      final endInterval = math.min<double>(1, (1 / count) * (index + 5));
                      final Animation<double> animation = Tween<double>(
                        begin: 0,
                        end: 1,
                      ).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval(
                            beginInterval,
                            endInterval,
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      );

                      animationController.forward();
                      return HeroWidget(
                        hero: DotaHero.favoriteHeroes[index],
                        onTap: () {
                          Navigator.push(
                              context, _createDetailRoute(DotaHero.favoriteHeroes[index]));
                        },
                        transition: animation,
                        transitionController: animationController,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Route _createDetailRoute(DotaHero hero) {
    return PageRouteBuilder(
      transitionDuration: Duration(seconds: 1),
      pageBuilder: (context, animation, secondaryAnimation) => DetailPage(hero: hero),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(0.0, 1.0);
        final end = Offset.zero;

        final curve = Curves.fastOutSlowIn;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class HeroWidget extends StatefulWidget {
  const HeroWidget({
    Key key,
    @required this.hero,
    @required this.onTap,
    @required this.transitionController,
    @required this.transition,
  }) : super(key: key);

  final DotaHero hero;
  final VoidCallback onTap;
  final AnimationController transitionController;
  final Animation<dynamic> transition;

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
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _imageAnimation = Tween<double>(
      begin: 16,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _clickController,
      curve: Curves.fastOutSlowIn,
    ));

    _paddingAnimation = EdgeInsetsTween(
      begin: _beginPadding,
      end: _endPadding,
    ).animate(CurvedAnimation(
      parent: _clickController,
      curve: Curves.fastOutSlowIn,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _clickController,
      curve: Curves.fastOutSlowIn,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.transitionController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.transition,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              50 * (1.0 - widget.transition.value),
              0.0,
            ),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget?.onTap != null) widget.onTap();
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
                    child: Hero(
                      tag: widget.hero.name,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        fit: BoxFit.contain,
                        image: widget.hero.imagePath,
                      ),
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
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 16,
                          ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${widget.hero.views} Views',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _clickController.dispose();
    super.dispose();
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
class DetailPage extends StatefulWidget {
  final DotaHero hero;

  const DetailPage({
    Key key,
    @required this.hero,
  })  : assert(hero != null),
        super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  List<Animation> _slideAnimations;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(
          seconds: 3,
        ));
    _slideAnimations = List<Animation>.generate(8, (index) {
      final count = 13;
      final beginInterval = (1 / count) * index;
      final endInterval = 1.0;
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            beginInterval,
            endInterval,
            curve: Curves.fastOutSlowIn,
          ),
        ),
      );
    });

    _animationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.hero.name,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.shortestSide / 1.5,
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.3,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          fit: BoxFit.contain,
                          image: detailBackgroundUrl.replaceAll(
                            '{{ability}}',
                            widget.hero.primaryAttr.toString().split('.').last,
                          ),
                        ),
                      ),
//                      Opacity(
//                        opacity: 0.5,
//                        child: ColorFiltered(
//                          colorFilter: ColorFilter.mode(hero.color[400], BlendMode.modulate),
//                          child: FadeInImage.memoryNetwork(
//                            placeholder: kTransparentImage,
//                            fit: BoxFit.cover,
//                            image:
//                                'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/game/intelligence_background.png',
//                          ),
//                        ),
//                      ),
                      Hero(
                        tag: widget.hero.name,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          fit: BoxFit.contain,
                          image: widget.hero.imagePath,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: FadeTransition(
                          opacity: _slideAnimations[0],
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      widget.hero.name,
                                      style: Theme.of(context).textTheme.headline5.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    SizedBox(width: 8),
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: ClipOval(
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          fit: BoxFit.cover,
                                          image: abilityImage.replaceAll(
                                            '{{ability}}',
                                            widget.hero.primaryAttr.toString().split('.').last,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: widget.hero.color[400],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  widget.hero.roles.join(', '),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _slideAnimations[1],
                      child: Transform(
                        transform: Matrix4.translationValues(
                          0.0,
                          50 * (1.0 - _slideAnimations[1].value),
                          0.0,
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    'Hero Skills',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: widget.hero.color[300],
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    widget.hero.levels.length,
                    (index) {
                      final level = widget.hero.levels[index];
                      final animation = _slideAnimations[index + 2];
                      return Expanded(
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: Transform(
                                transform: Matrix4.translationValues(
                                  0.0,
                                  50 * (1.0 - animation.value),
                                  0.0,
                                ),
                                child: child,
                              ),
                            );
                          },
                          child: GestureDetector(
                            onTap: () {
                              _showSheet(context, level);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: MediaQuery.of(context).size.shortestSide / 7,
                                  width: MediaQuery.of(context).size.shortestSide / 7,
                                  child: ClipOval(
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      fit: BoxFit.cover,
                                      image: level.imageUrl,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  level.name,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _slideAnimations[6],
                    child: Transform(
                      transform: Matrix4.translationValues(
                        0.0,
                        50 * (1.0 - _slideAnimations[6].value),
                        0.0,
                      ),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bio',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: widget.hero.color[300],
                        ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _slideAnimations[7],
                    child: Transform(
                      transform: Matrix4.translationValues(
                        0.0,
                        50 * (1.0 - _slideAnimations[7].value),
                        0.0,
                      ),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.hero.bio,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideAnimations = null;
    super.dispose();
  }

  Future<void> _showSheet(BuildContext context, HeroLevel level) async {
    final maxBorderRadius = 50.0;
    var borderRadius = maxBorderRadius;
    log('modalShowed');
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            borderRadius =
                notification.maxExtent <= (notification.extent + 0.08) ? 0 : maxBorderRadius;
            log('$notification');
            return false;
          },
          child: DraggableScrollableSheet(
            expand: true,
            builder: (_, controller) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                ),
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: ListView(
                  controller: controller,
                  shrinkWrap: false,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: <Widget>[
                        SizedBox(
                          width: 75,
                          height: 75,
                          child: ClipOval(
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              fit: BoxFit.cover,
                              image: level.imageUrl,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 4,
                          child: Text(
                            level.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.all(4),
                            alignment: Alignment.topRight,
                            child: Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(level.description),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                        ),
                        SizedBox(width: 8),
                        Text('Mana Cost :  '),
                        Text(
                          level.manaCost,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text('Cooldown :  '),
                        Text(level.coolDown),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
    log('modal closed');
  }
}

// constants
const String detailBackgroundUrl =
    "https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/game/{{ability}}_background.png";
const String abilityImage =
    "https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/game/{{ability}}.jpg";

final Uint8List kTransparentImage = new Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);

// models
class DotaHero {
  const DotaHero({
    @required this.name,
    @required this.imagePath,
    @required this.views,
    @required this.color,
    @required this.bio,
    @required this.roles,
    @required this.attackType,
    @required this.primaryAttr,
    @required this.levels,
  });

  final String name;
  final String imagePath;
  final String views;
  final String bio;
  final List<String> roles;
  final AttackType attackType;
  final PrimaryAttr primaryAttr;
  final MaterialColor color;
  final List<HeroLevel> levels;

  static List<DotaHero> get favoriteHeroes => [
        DotaHero(
          name: 'Rubick',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/rubick/rubick.png',
          views: '24k',
          color: Colors.green,
          bio:
              "Any mage can cast a spell or two, and a few may even study long enough to become a wizard, but only the most talented are allowed to be recognized as a Magus."
              " Yet as with any sorcerer's circle, a sense of community has never guaranteed competitive courtesy."
              "Already a renowned duelist and scholar of the grander world of sorcery, it had never occurred to Rubick that he might perhaps be Magus material until he was in the midst of his seventh assassination attempt."
              " As he casually tossed the twelfth of a string of would-be killers from a high balcony, it dawned on him how utterly unimaginative the attempts on his life had become."
              " Where once the interruption of a fingersnap or firehand might have put a cheerful spring in his step, it had all become so very predictable. He craved greater competition. Therefore, donning his combat mask, he did what any wizard seeking to ascend the ranks would do: he announced his intention to kill a Magus."
              "Rubick quickly discovered that to threaten one Magus is to threaten them all, and they fell upon him in force. Each antagonist's spell was an unstoppable torrent of energy, and every attack a calculated killing blow."
              " But very soon something occurred that Rubick's foes found unexpected: their arts appeared to turn against them. Inside the magic maelstrom, Rubick chuckled, subtly reading and replicating the powers of one in order to cast it against another, sowing chaos among those who had allied against him."
              " Accusations of betrayal began to fly, and soon the sorcerers turned one upon another without suspecting who was behind their undoing. When the battle finally drew to a close, all were singed and frozen, soaked and cut and pierced. More than one lay dead by an ally's craft. Rubick stood apart, sore but delighted in the week's festivities."
              " None had the strength to argue when he presented his petition of assumption to the Hidden Council, and the Insubstantial Eleven agreed as one to grant him the title of Grand Magus.",
          attackType: AttackType.range,
          primaryAttr: PrimaryAttr.intelligence,
          roles: ['Support', 'Disabler', 'Nuker'],
          levels: [
            HeroLevel(
              name: 'Telekinesis',
              description:
                  'Rubick uses his telekinetic powers to lift the enemy into the air briefly and then hurls them back at the ground. The unit lands on the ground with such force that it stuns nearby enemies.',
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/rubick/level1.png',
              manaCost: '125',
              coolDown: '34/30/26/22',
            ),
            HeroLevel(
              name: 'Fade Bolt',
              description:
                  'Rubick creates a powerful stream of arcane energy that travels between enemy units, dealing damage and reducing their attack damage. Each jump deals less damage.',
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/rubick/level2.png',
              manaCost: '135/140/145/150',
              coolDown: '16/14/12/10',
            ),
            HeroLevel(
              name: 'Arcane Supremacy',
              description:
                  "Rubick's mastery of the arcane allows him to deal more spell damage and create spells that last longer on enemies.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/rubick/level3.png',
              manaCost: '0',
              coolDown: '0',
            ),
            HeroLevel(
              name: 'Spell Steal',
              description:
                  "Rubick studies the trace magical essence of one enemy hero, learning the secrets of the last spell the hero cast. Rubick can use this spell as his own for several minutes or until he dies.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/rubick/level4.png',
              manaCost: '25/25/25',
              coolDown: ' 20/18/16',
            ),
          ],
        ),
        DotaHero(
          name: 'Earth Shaker',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/earth_shaker/earth_shaker.png',
          views: '33k',
          color: Colors.orange,
          bio:
              "Like a golem or gargoyle, Earthshaker was one with the earth but now walks freely upon it."
              " Unlike those other entities, he created himself through an act of will, and serves no other master."
              " In restless slumbers, encased in a deep seam of stone, he became aware of the life drifting freely above him. He grew curious."
              " During a season of tremors, the peaks of Nishai shook themselves loose of avalanches,"
              " shifting the course of rivers and turning shallow valleys into bottomless chasms. When the land finally ceased quaking,"
              " Earthshaker stepped from the settling dust, tossing aside massive boulders as if throwing off a light blanket. He had shaped himself in the image of a mortal beast,"
              " and named himself Raigor Stonehoof. He bleeds now, and breathes, and therefore he can die."
              " But his spirit is still that of the earth; he carries its power in the magical totem that never leaves him."
              " And on the day he returns to dust, the earth will greet him as a prodigal son.",
          attackType: AttackType.melee,
          primaryAttr: PrimaryAttr.strength,
          roles: [
            'Support',
            'Initiator',
            'Disabler',
            'Nuker',
          ],
          levels: [
            HeroLevel(
              name: 'Fissure',
              description:
                  "Slams the ground with a mighty totem, creating an impassable ridge of stone while stunning and damaging enemy units along its line.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/earth_shaker/level1.png',
              manaCost: '110/130/150/170',
              coolDown: '21/19/17/15',
            ),
            HeroLevel(
              name: 'Enchant Totem',
              description:
                  "Empowers Earthshaker's totem, causing it to deal extra damage and have 75 bonus attack range on the next attack.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/earth_shaker/level2.png',
              manaCost: '35/40/45/50',
              coolDown: '5',
            ),
            HeroLevel(
              name: 'Aftershock',
              description:
                  "Causes the earth to shake underfoot, adding additional damage and stuns to nearby enemy units when Earthshaker casts his abilities.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/earth_shaker/level3.png',
              manaCost: '0',
              coolDown: '0',
            ),
            HeroLevel(
              name: "Echo Slam",
              description:
                  "Shockwaves travel through the ground, damaging enemy units. Each enemy hit causes an echo to damage nearby units. Real heroes cause two echoes.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/earth_shaker/level4.png',
              manaCost: '145/205/265',
              coolDown: '150/130/110',
            ),
          ],
        ),
        DotaHero(
          name: 'Void',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/void/void.png',
          views: '13k',
          color: Colors.deepPurple,
          bio: "Darkterror the Faceless Void is a visitor from Claszureme, a realm outside of time."
              " It remains a mystery why this being from another dimension believes the struggle for the Nemesis Stones is worth entering our physical plane, but apparently an upset in the balance of power in this world has repercussions in adjacent dimensions."
              " Time means nothing to Darkterror, except as a way to thwart his foes and aid his allies. His long-view of the cosmos has given him a remote, disconnected quality, although in battle he is quite capable of making it personal.",
          attackType: AttackType.melee,
          primaryAttr: PrimaryAttr.agility,
          roles: [
            'Carry ',
            'Initiator ',
            'Disabler',
            'Escape ',
            'Durable ',
          ],
          levels: [
            HeroLevel(
              name: 'Time Walk',
              description:
                  "Rushes to a target location while backtracking any damage taken the last 2 seconds.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/void/level1.png',
              manaCost: '40',
              coolDown: '24/18/12/6',
            ),
            HeroLevel(
              name: 'Time Dilation',
              description:
                  "Faceless Void traps all nearby enemies in a time dilation field for 8 seconds, extending their cooldowns and slowing their movement and attack speed by 10% for each cooldown extended.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/void/level2.png',
              manaCost: '75',
              coolDown: '40/34/28/22',
            ),
            HeroLevel(
              name: 'Time Lock',
              description:
                  "Adds the chance for an attack to lock an enemy unit in time while attacking it a second time.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/void/level3.png',
              manaCost: '0',
              coolDown: '0',
            ),
            HeroLevel(
              name: 'Chronosphere',
              description:
                  "Creates a blister in spacetime, trapping all units caught in its sphere of influence and causes you to move very quickly inside it."
                  " Only Faceless Void and any units he controls are unaffected. Invisible enemies in the sphere will be revealed.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/void/level4.png',
              manaCost: '150/225/300',
              coolDown: '160',
            ),
          ],
        ),
        DotaHero(
          name: 'Ogry',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/ogry/ogry.png',
          views: '24k',
          color: Colors.indigo,
          bio:
              "The ordinary ogre is the creature for whom the phrase 'As dumb as a bag of rock hammers' was coined"
              " In his natural state, an ogre is supremely incapable of doing or deciding anything. Clothed in dirt, he sometimes finds himself accidentally draped in animal skins after eating lanekill"
              " Not an especially social creature, he is most often found affectionately consorting with the boulders or tree-stumps he has mistaken for kin (a factor that may explain the ogre's low rate of reproduction)."
              " However, once every generation or so, the ogre race is blessed with the birth of a two-headed Ogre Magi, who is immediately given the traditional name of Aggron Stonebreak, the name of the first and perhaps only wise ogre in their line's history"
              " With two heads, Ogre Magi finds it possible to function at a level most other creatures manage with one"
              " And while the Ogre Magi will win no debates (even with itself), it is graced with a divine quality known as Dumb Luck--a propensity for serendipitous strokes of fortune which have allowed the ogre race to flourish in spite of enemies, harsh weather, and an inability to feed itself."
              " It's as if the Goddess of Luck, filled with pity for the sadly inept species, has taken Ogre Magi under her wing. And who could blame her? Poor things.",
          attackType: AttackType.melee,
          primaryAttr: PrimaryAttr.intelligence,
          roles: [
            'Support',
            'Nuker',
            'Disabler',
            'Durable',
            'Initiator',
          ],
          levels: [
            HeroLevel(
              name: 'Fireblast',
              description:
                  "Blasts an enemy unit with a wave of fire, dealing damage and stunning the target.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/ogry/level1.png',
              manaCost: '75/85/95/105',
              coolDown: '11/10/9/8',
            ),
            HeroLevel(
              name: 'Ignite',
              description:
                  "Drenches the target and another random unit in volatile chemicals, causing it to burst into flames. The target is in immense pain, taking damage and moving more slowly.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/ogry/level2.png',
              manaCost: '90',
              coolDown: '15',
            ),
            HeroLevel(
              name: 'Bloodlust',
              description:
                  "Incites a frenzy in a friendly unit, increasing its movement speed and attack speed. Gives bonus attacks speed if cast on Ogre himself. Can be cast on towers.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/ogry/level3.png',
              manaCost: '65',
              coolDown: '20/18/16/14',
            ),
            HeroLevel(
              name: 'Multicast',
              description:
                  "Enables Ogre Magi to cast his abilities and items multiple times with each use.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/ogry/level4.png',
              manaCost: '0',
              coolDown: ' 0',
            ),
          ],
        ),
        DotaHero(
          name: 'Shadow Fiend',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sf/sf.png',
          views: '33k',
          color: Colors.red,
          bio:
              "It is said that Nevermore the Shadow Fiend has the soul of a poet, and in fact he has thousands of them."
              " Over the ages he has claimed the souls of poets, priests, emperors, beggars, slaves, philosophers, criminals and (naturally) heroes; no sort of soul escapes him."
              " What he does with them is unknown. No one has ever peered into the Abysm whence Nevermore reaches out like an eel from among astral rocks. Does he devour them one after another?"
              " Does he mount them along the halls of an eldritch temple, or pickle the souls in necromantic brine? Is he merely a puppet, pushed through the dimensional rift by a demonic puppeteer?"
              " Such is his evil, so intense his aura of darkness, that no rational mind may penetrate it. Of course, if you really want to know where the stolen souls go, there's one sure way to find out: Add your soul to his collection. Or just wait for Nevermore.",
          attackType: AttackType.range,
          primaryAttr: PrimaryAttr.agility,
          roles: [
            'Carry ',
            'Nuker',
          ],
          levels: [
            HeroLevel(
              name: 'Shadowraze',
              description:
                  "Shadow Fiend razes the ground directly in front of him, dealing damage to enemy units in the area."
                  " Adds a stacking damage amplifier on the target that causes the enemy to take bonus Shadow Raze damage per stack.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sf/level1.png',
              manaCost: '90',
              coolDown: '10',
            ),
            HeroLevel(
              name: 'Necromastery',
              description:
                  "Shadow Fiend steals the soul from units he kills, gaining bonus damage. If the killed unit is a hero, he gains an additional 1 bonus souls. On death, he releases half of them from bondage.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sf/level2.png',
              manaCost: '0',
              coolDown: '0',
            ),
            HeroLevel(
              name: 'Presence of the Dark Lord',
              description: "Shadow Fiend's presence reduces the armor of nearby enemies.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sf/level3.png',
              manaCost: '0',
              coolDown: '0',
            ),
            HeroLevel(
              name: 'Requiem of Souls',
              description:
                  "Shadow Fiend gathers his captured souls to release them as lines of demonic energy. Units near Shadow Fiend when the souls are released can be damaged by several lines of energy."
                  " Any unit damaged by Requiem of Souls will be feared and have its movement speed reduced for 0.8 seconds for each line hit. Lines of energy are created for every 1 souls captured through Necromastery.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sf/level4.png',
              manaCost: '150/175/200',
              coolDown: '120/110/100',
            ),
          ],
        ),
        DotaHero(
          name: 'Zeus',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/zeus/zeus.png',
          views: '24k',
          color: Colors.blue,
          bio:
              "Lord of Heaven, father of gods, Zeus treats all the Heroes as if they are his rambunctious, rebellious children."
              " After being caught unnumbered times in the midst of trysts with countless mortal women,"
              " his divine wife finally gave him an ultimatum: 'If you love mortals so much, go and become one."
              " If you can prove yourself faithful, then return to me as my immortal husband. Otherwise, go and die among your creatures.' Zeus found her logic (and her magic) irrefutable,"
              " and agreed to her plan. He has been on his best behavior ever since, being somewhat fonder of immortality than he is of mortals."
              " But to prove himself worthy of his eternal spouse, he must continue to pursue victory on the field of battle.",
          attackType: AttackType.range,
          primaryAttr: PrimaryAttr.intelligence,
          roles: [
            'Nuker',
          ],
          levels: [
            HeroLevel(
              name: 'Arc Lightning',
              description: "Hurls a bolt of lightning that leaps through nearby enemy units.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/zeus/level1.png',
              manaCost: '80',
              coolDown: '1.60',
            ),
            HeroLevel(
              name: 'Lightning Bolt',
              description:
                  "Calls down a bolt of lightning to strike an enemy unit, causing damage and a mini-stun. When cast,"
                  " Lightning Bolt briefly provides unobstructed vision and True Sight around the target in a 750 radius. Can be cast on the ground, affecting the closest enemy hero in 325 range.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/zeus/level2.png',
              manaCost: '125/130/135/140',
              coolDown: '6',
            ),
            HeroLevel(
              name: 'Static Field',
              description:
                  "Zeus shocks any enemy hit by his abilities, causing damage proportional to their current health.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/zeus/level3.png',
              manaCost: '0',
              coolDown: '0',
            ),
            HeroLevel(
              name: "Thundergod's Wrath",
              description:
                  "Strikes all enemy heroes with a bolt of lightning, no matter where they may be."
                  " Thundergod's Wrath also provides True Sight around each hero struck. If an enemy hero is invisible, it takes no damage, but the True Sight is still created at that hero's location.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/zeus/level4.png',
              manaCost: '250/350/450',
              coolDown: '120',
            ),
          ],
        ),
        DotaHero(
          name: 'Sven',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sven/sven.png',
          views: '54k',
          color: Colors.cyan,
          bio:
              "Sven is the bastard son of a Vigil Knight, born of a Pallid Meranth, raised in the Shadeshore Ruins."
              " With his father executed for violating the Vigil Codex, and his mother shunned by her wild race,"
              " Sven believes that honor is to be found in no social order, but only in himself."
              " After tending his mother through a lingering death, he offered himself as a novice to the Vigil Knights,"
              " never revealing his identity. For thirteen years he studied in his father's school,"
              " mastering the rigid code that declared his existence an abomination. Then, on the day that should have been his In-Swearing,"
              " he seized the Outcast Blade, shattered the Sacred Helm, and burned the Codex in the Vigil's Holy Flame. He strode from Vigil Keep,"
              " forever solitary, following his private code to the last strict rune. Still a knight, yes...but a Rogue Knight. He answers only to himself.",
          attackType: AttackType.melee,
          primaryAttr: PrimaryAttr.strength,
          roles: [
            'Carry',
            'Disabler',
            'Initiator',
            'Durable',
            'Nuker',
          ],
          levels: [
            HeroLevel(
              name: 'Storm Hammer',
              description:
                  "Sven unleashes his magical gauntlet that deals damage and stuns enemy units in a small area around the target.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sven/level1.png',
              manaCost: '110/120/130/140',
              coolDown: '18/16/14/12',
            ),
            HeroLevel(
              name: 'Great Cleave',
              description:
                  "Sven strikes with great force, cleaving all nearby enemy units with his attack.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sven/level2.png',
              manaCost: '0/0/0/0',
              coolDown: '0',
            ),
            HeroLevel(
              name: 'Warcry',
              description:
                  "Sven's Warcry heartens his allied heroes for battle, increasing their armor and damage."
                  " Additionally increases Sven's own movement speed. Lasts 8 seconds.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sven/level3.png',
              manaCost: '30/40/50/60',
              coolDown: '32/28/24/20',
            ),
            HeroLevel(
              name: "God's Strength",
              description:
                  "Sven channels his rogue strength, granting bonus strength and damage for %abilityduration% seconds.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sven/level4.png',
              manaCost: '100/150/200',
              coolDown: '110',
            ),
          ],
        ),
        DotaHero(
          name: 'Slark',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/slark/slark.png',
          views: '39k',
          color: Colors.deepPurple,
          bio:
              "Little known to the inhabitants of the dry world, Dark Reef is a sunken prison where the worst of the sea-bred are sent for crimes against their fellows."
              " It is a razor barbed warren full of murderous slithereen, treacherous Deep Ones, sociopathic meranths. In this dim labyrinth, patrolled by eels and guarded by enormous anemones, only the vicious survive."
              " Pitched into Dark Reef for crimes unknown, Slark spent half a lifetime without kin or kindness, trusting no one, surviving through a combination of stealth and ruthlessness, keeping his thoughts and his plans to himself."
              " When the infamous Dark Reef Dozen plotted their ill-fated breakout, they kept their plans a perfect secret, murdering anyone who could have put the pieces together--but somehow Slark discovered their scheme and made a place for himself in it. Ten of the Dozen died in the escape attempt, and two were captured, hauled back to Dark Reef, then executed for the entertainment of their fellow inmates."
              " But Slark, the unsung thirteenth, used the commotion as cover and slipped away, never to be caught. Now a furtive resident of the carnivorous mangrove scrub that grips the southern reach of Shadeshore, Slark remains the only successful escapee from Dark Reef.",
          attackType: AttackType.melee,
          primaryAttr: PrimaryAttr.agility,
          roles: [
            'Carry ',
            'Escape ',
            'Disabler',
            'Nuker',
          ],
          levels: [
            HeroLevel(
              name: 'Dark Pact',
              description:
                  "After a short delay, Slark sacrifices some of his life blood, purging most negative debuffs and dealing damage to enemy units around him and to himself. Slark only takes 50% of the damage. DISPEL TYPE: Strong Dispel",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/slark/level1.png',
              manaCost: '60',
              coolDown: '9/8/7/6',
            ),
            HeroLevel(
              name: 'Pounce',
              description:
                  "Slark leaps forward, grabbing the first hero he connects with. That unit is leashed, and can only move a limited distance away from Slark's landing position.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/slark/level2.png',
              manaCost: '75/75/75/75',
              coolDown: '20/16/12/8',
            ),
            HeroLevel(
              name: 'Essence Shift',
              description:
                  "Slark steals the life essence of enemy heroes with his attacks, draining each of their attributes and converting them to bonus Agility. If Slark kills an affected enemy hero, he permanently steals 1 Agility.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/slark/level3.png',
              manaCost: '0',
              coolDown: '0',
            ),
            HeroLevel(
              name: 'Shadow Dance',
              description:
                  "When used, Slark hides himself in a cloud of shadows, becoming immune to detection. Attacking, casting spells, and using items will not reveal Slark. "
                  "Passively, when not visible to the enemy team, Slark gains bonus movement speed and health regeneration.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/slark/level4.png',
              manaCost: '120/120/120',
              coolDown: '80/70/60',
            ),
          ],
        ),
        DotaHero(
          name: 'Invoker',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/invoker/invoker.png',
          views: '33k',
          color: Colors.lime,
          bio:
              "In its earliest, and some would say most potent form, magic was primarily the art of memory."
              " It required no technology, no wands or appurtenances other than the mind of the magician."
              " All the trappings of ritual were merely mnemonic devices, meant to allow the practitioner to recall in rich detail the specific mental formulae that unlocked a spell's power."
              " The greatest mages in those days were the ones blessed with the greatest memories,"
              " and yet so complex were the invocations that all wizards were forced to specialize."
              " The most devoted might hope in a lifetime to have adequate recollection of three spells--four at most. Ordinary wizards were content to know two,"
              " and it was not uncommon for a village mage to know only one--with even that requiring him to consult grimoires as an aid against forgetfulness on the rare occasions when he might be called to use it."
              " But among these early practitioners there was one exception, a genius of vast intellect and prodigious memory who came to be known as the Invoker."
              " In his youth, the precocious wizard mastered not four, not five, not even seven incantations:"
              " He could command no fewer than ten spells, and cast them instantly."
              " Many more he learned but found useless, and would practice once then purge from his mind forever, to make room for more practical invocations."
              " One such spell was the Sempiternal Cantrap--a longevity spell of such power that those who cast it in the world's first days are among us still (unless they have been crushed to atoms)."
              " Most of these quasi-immortals live quietly, afraid to admit their secret: But Invoker is not one to keep his gifts hidden."
              " He is ancient, learned beyond all others, and his mind somehow still has space to contain an immense sense of his own worth...as well as the Invocations with which he amuses himself through the long slow twilight of the world's dying days.",
          attackType: AttackType.range,
          primaryAttr: PrimaryAttr.intelligence,
          roles: [
            'Carry',
            'Nuker',
            'Disabler',
            'Escape',
            'Pusher',
          ],
          levels: [
            HeroLevel(
              name: 'Quas',
              description:
                  "Allows manipulation of ice elements. Each Quas instance provides increased health regeneration. /n"
                  "DAMAGE: 0 / 0 / 0 / 0 , HP REGEN PER INSTANCE: 1 / 3 / 5 / 7 / 9 / 11 / 13",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/invoker/level1.png',
              manaCost: '0',
              coolDown: '0',
            ),
            HeroLevel(
              name: 'Wex',
              description:
                  "Allows manipulation of storm elements. Each Wex instance provides increased attack speed and movement speed. \n"
                  "DAMAGE: 0 / 0 / 0 / 0,"
                  "ATTACK SPEED PER INSTANCE: 2 / 4 / 6 / 8 / 10 / 12 / 14,"
                  "MOVE SPEED PER INSTANCE: 1% / 2% / 3% / 4% / 5% / 6% / 7%",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/invoker/level2.png',
              manaCost: '0',
              coolDown: '0',
            ),
            HeroLevel(
              name: 'Exort',
              description:
                  "Allows manipulation of fire elements. Each Exort instance provides increased attack damage."
                  "DAMAGE: 0 / 0 / 0 / 0,"
                  "DAMAGE PER INSTANCE: 2 / 6 / 10 / 14 / 18 / 22 / 26",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/invoker/level3.png',
              manaCost: '0',
              coolDown: '0',
            ),
          ],
        ),
        DotaHero(
          name: 'Disruptor',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/disruptor/disruptor.png',
          views: '33k',
          color: Colors.blue,
          bio:
              "High on the wind-ravaged steppes of Druud, a gifted young stormcrafter called Disruptor was the first to unlock the secrets of the summer squalls."
              " Constantly under assault from both seasonal storms and encroachment from civilized kingdoms to the South, the upland Oglodi have for centuries struggled to subsist atop the endless tablelands."
              " They are the fractured remnant of a once-great civilization, a fallen tribe, their stormcraft strange and inscrutable,"
              " cobbled together from scraps of lost knowledge which even they no longer fully understand. For those on the high plain,"
              " weather has become a kind of religion, worshiped as both the giver and taker of life."
              " But the electrical storms that bring life-sustaining rains arrive at a cost, and many are the charred and smoking corpses left in their wake."
              "Although small for his kind, Disruptor is fearless, and driven by an insatiable curiosity."
              " As a youth, while still unblooded and without a stryder, he explored the ruins of the ancestral cities,"
              " searching through collapsed and long-moldering libraries, rummaging through rusting manufactories."
              " He took what he needed and returned to his tribe. Adapting a coil of ancient design,"
              " he harnessed the power of electrical differential and now calls down the thunder whenever he wishes."
              " Part magic, part craftsmanship, his coils hold in their glowing plates the power of life and death--a power wielded with precision against the landed castes to the South, and any interlopers who cross into ancient Oglodi lands.",
          attackType: AttackType.range,
          primaryAttr: PrimaryAttr.intelligence,
          roles: [
            'Support',
            'Disabler',
            'Nuker',
            'Initiator',
          ],
          levels: [
            HeroLevel(
              name: 'Thunder Strike',
              description:
                  "Repeatedly strikes the targeted unit with lightning. Each strike damages nearby enemy units in a small radius and slows enemy movement and attack speed by 100% for 0.1 seconds. Provides vision of its target.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/disruptor/level1.png',
              manaCost: '130/140/150/160',
              coolDown: '18/15/12/9',
            ),
            HeroLevel(
              name: 'Glimpse',
              description:
                  "Teleports the target hero back to where it was 4 seconds ago. Instantly kills illusions.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/disruptor/level2.png',
              manaCost: '100',
              coolDown: '60/46/32/18',
            ),
            HeroLevel(
              name: 'Kinetic Field',
              description:
                  "After a short formation time, creates a circular barrier of kinetic energy that enemies can't pass.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/disruptor/level3.png',
              manaCost: '70/70/70/70',
              coolDown: '19/16/13/10',
            ),
            HeroLevel(
              name: "Static Storm",
              description:
                  "Creates a damaging static storm that also silences all enemy units in the area for the duration."
                  " The damage starts off weak, but increases in power over the duration.",
              imageUrl:
                  'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/disruptor/level4.png',
              manaCost: '125/175/225',
              coolDown: '90/80/70',
            ),
          ],
        ),
      ];
}

class HeroLevel {
  HeroLevel({
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    @required this.manaCost,
    @required this.coolDown,
  });

  final String name;
  final String description;
  final String imageUrl;
  final String manaCost;
  final String coolDown;

  @override
  String toString() {
    return 'HeroLevel{name: $name, description: $description, imageUrl: $imageUrl, manaCost: $manaCost, coolDown: $coolDown}';
  }
}

enum AttackType {
  melee,
  range,
}
enum PrimaryAttr {
  strength,
  agility,
  intelligence,
}
