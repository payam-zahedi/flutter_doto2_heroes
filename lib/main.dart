import 'dart:developer';
import 'dart:typed_data';

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
      home: DetailPage(
        hero: DotaHero.favoriteHeroes.first,
      ),
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
                      final count = DotaHero.favoriteHeroes.length;
                      final beginInterval = (1 / count) * index;
                      final endInterval = 1.0;
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
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(
                                hero: DotaHero.favoriteHeroes.first,
                              ),
                            ),
                          );
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
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      fit: BoxFit.contain,
                      image: widget.hero.imagePath,
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
          style: Theme.of(context).textTheme.bodyText2,
        ),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: () {}),
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
                          image:
                          'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/game/intelligence_background.png',
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
                      FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        fit: BoxFit.contain,
                        image: hero.imagePath,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                hero.name,
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: hero.color[400],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                hero.roles.join(', '),
                              ),
                            ),
                          ],
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
                child: Text(
                  'Hero Skills',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: hero.color[300],
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: hero.levels
                      .map(
                        (level) => Expanded(
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
                      )
                      .toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bio',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: hero.color[300],
                      ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  hero.bio,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    this.bio,
    this.roles,
    this.attackType,
    this.primaryAttr,
    this.levels,
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
          name: 'Ogry',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/ogry/ogry.png',
          views: '24k',
          color: Colors.indigo,
        ),
        DotaHero(
          name: 'Slark',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/slark/slark.png',
          views: '39k',
          color: Colors.brown,
        ),
        DotaHero(
          name: 'Void',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/void/void.png',
          views: '13k',
          color: Colors.deepPurple,
        ),
        DotaHero(
          name: 'Shadow Fiend',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sf/sf.png',
          views: '33k',
          color: Colors.red,
        ),
        DotaHero(
          name: 'Zeus',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/zeus/zeus.png',
          views: '24k',
          color: Colors.blue,
        ),
        DotaHero(
          name: 'Earth Shaker',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/earth_shaker/earth_shaker.png',
          views: '33k',
          color: Colors.orange,
        ),
        DotaHero(
          name: 'Disruptor',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/disruptor/disruptor.png',
          views: '33k',
          color: Colors.teal,
        ),
        DotaHero(
          name: 'Invoker',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/invoker/invoker.png',
          views: '33k',
          color: Colors.lime,
        ),
        DotaHero(
          name: 'Sven',
          imagePath:
              'https://raw.githubusercontent.com/payam-zahedi/flutter_doto2_heroes/master/assets/image/heroes/sven/sven.png',
          views: '54k',
          color: Colors.blueGrey,
        ),
      ];
}

class HeroLevel {
  HeroLevel({
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    this.manaCost,
    this.coolDown,
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
