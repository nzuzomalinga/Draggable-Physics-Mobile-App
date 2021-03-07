import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NzuzoPhysics(),
    ),
  );
}

class NzuzoPhysics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draggable Physics Demo',style: TextStyle(fontFamily: 'RobotoMono')),
        
      ),
      body: DraggableCard(
        
        child:Container(
          height: 200,
          width: 200,
          padding: const EdgeInsets.all(14.0),
          alignment: Alignment.center,
          color: Colors.amber,
          child: Stack(
  children: <Widget>[
    // Stroked text as border.
    Text(
      'Nzuzos Draggable Physics Cube',
      style: TextStyle(
        fontSize: 18,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.5
          ..color = Colors.grey[700],
      ),
    ),
    // Solid text as fill.
    Text(
      'Nzuzos Draggable Physics Cube',
      style: TextStyle(
        fontSize: 20,
        color: Colors.green[400],
      ),
    ),
  ],
),
        ),
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  final Widget child;
  DraggableCard({this.child});

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Alignment _dragAlignment = Alignment.center;
  Animation<Alignment> _animation;

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 100,
      stiffness: 1,
      damping: 10,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }
}
