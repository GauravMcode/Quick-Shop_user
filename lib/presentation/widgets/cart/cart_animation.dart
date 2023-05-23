part of 'package:user_shop/presentation/pages/product/product.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key, required this.size, required this.image, required this.cartState});
  final Size size;
  final String image;
  final User cartState;

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> with SingleTickerProviderStateMixin {
  double positionLeft = -400;
  double positionTop = 0;
  double opacityImage = 1.0;
  double initHeight = 220;
  double initWidth = 220;
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 2));
    animateP();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(),
          foregroundDecoration: BoxDecoration(color: Colors.transparent.withOpacity(0.8)),
        ),
        AnimatedPositioned(
          top: positionTop,
          left: widget.size.width * 0.2,
          duration: const Duration(seconds: 1),
          child: AnimatedOpacity(
            opacity: opacityImage,
            duration: const Duration(milliseconds: 800),
            child: CachedNetworkImage(
              imageUrl: widget.image,
              height: initHeight,
              width: initWidth,
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          left: positionLeft,
          curve: positionLeft < 0 ? Curves.bounceIn : Curves.bounceOut,
          duration: const Duration(seconds: 1),
          child: CustomPaint(
            painter: CartPainter(),
            child: SizedBox(
              height: widget.size.height,
              width: widget.size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 200),
                    Padding(
                      padding: const EdgeInsets.only(left: 45.0),
                      child: Card(
                        elevation: 30,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Total Price: \n₹ ${widget.cartState.cart!['total']}', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Align(
                      alignment: Alignment.center,
                      child: ConfettiWidget(
                        blastDirection: pi * 1.5,
                        maxBlastForce: 100,
                        confettiController: _controllerCenter,
                        blastDirectionality: BlastDirectionality.directional, // don't specify a direction, blast randomly
                        shouldLoop: true, // start again as soon as the animation is finished
                        colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple], // manually specify the colors to be used
                        createParticlePath: drawStar, // define a custom shape/path.
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text('Quantity: ${widget.cartState.cart!['number']}', style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  animateP() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() {
        positionLeft = widget.size.width * 0.01;
        positionTop = widget.size.height * 0.5;
        opacityImage = 0.0;
      });
    }
    await Future.delayed(const Duration(milliseconds: 700));
    _controllerCenter.play();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {
        positionLeft = widget.size.width * 1.5;
      });
    }

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _showCart.value = false;
      });
    }
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep), halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}

class CartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 10);
    Paint boundryPaint = Paint()
      ..color = const Color(0xffffa502)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    Path path = Path()
      ..moveTo(width * 0.2, height * 0.5)
      ..lineTo(width * 0.99, height * 0.5)
      ..lineTo(width * 0.75, height * 0.75)
      ..lineTo(width * 0.35, height * 0.75)
      ..lineTo(width * 0.2, height * 0.5)
      ..arcToPoint(Offset(width * 0.01, height * 0.5), radius: const Radius.elliptical(5, 2), clockwise: false)
      ..moveTo(width * 0.45, height * 0.75)
      ..arcToPoint(Offset(width * 0.45, height * 0.82), radius: const Radius.circular(10))
      ..arcToPoint(Offset(width * 0.45, height * 0.75), radius: const Radius.circular(10))
      ..moveTo(width * 0.65, height * 0.75)
      ..arcToPoint(Offset(width * 0.65, height * 0.82), radius: const Radius.circular(10))
      ..arcToPoint(Offset(width * 0.65, height * 0.75), radius: const Radius.circular(10));

    canvas.drawPath(path, paint);
    canvas.drawPath(path, boundryPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

//orange : orange : ffa502
//Prestige (dark grey) : 2f3542
//twinkle (not much white) : ced6e0