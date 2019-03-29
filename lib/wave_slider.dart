import 'package:flutter/material.dart';
import 'package:flutter_custom_slider/wave_painter.dart';

class WaveSlider extends StatefulWidget {
  final double width;
  final double height;
  final Color color;

  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangedStart;

  const WaveSlider({
    this.width = 350.0,
    this.height = 50.0,
    this.color = Colors.black,
    @required this.onChanged,
    @required this.onChangedStart,
  }): assert(height >= 50 && height <= 600);

  @override
  _WaveSliderState createState() => _WaveSliderState();
}

class _WaveSliderState extends State<WaveSlider> with SingleTickerProviderStateMixin{
  double _dragPosition = 0.0;
  double _dragPercentage = 0.0;

  WaveSliderController _sliderController;

  @override
  void initState() {
    _sliderController = WaveSliderController(vsync: this)
      ..addListener(() => setState((){}));
    super.initState();
  }

  @override
  void dispose() {
    _sliderController.dispose();
    super.dispose();
  }

  void _updateDragPosition(Offset val) {
    double newDragPosition = 0;

    if(val.dx <= 0)
      newDragPosition = 0;
    else if(val.dx >= widget.width)
      newDragPosition = widget.width;
    else
      newDragPosition = val.dx;

    setState(() {
      _dragPosition = newDragPosition;
      _dragPercentage = _dragPosition / widget.width;
    });
  }


  _handleChangeStart(double val) {
    assert(widget.onChangedStart != null);
    widget.onChangedStart(val);
  }

  _handleChangeUpdate(double val) {
    assert(widget.onChanged != null);
    widget.onChanged(val);
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox box =  context.findRenderObject();
    Offset offset = box.globalToLocal(update.globalPosition);
    _sliderController.setStateSliding();
    _updateDragPosition(offset);
    _handleChangeUpdate(_dragPercentage);
  }

  void _onDragStart(BuildContext context, DragStartDetails start) {
    RenderBox box =  context.findRenderObject();
    Offset localOffset = box.globalToLocal(start.globalPosition);
    _sliderController.setStateStart();
    _updateDragPosition(localOffset);
    _handleChangeStart(_dragPercentage);
  }

  void _onDragEnd(BuildContext context, DragEndDetails update) {
    _sliderController.setStateStopping();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Container(
          width: widget.width,
          height: widget.height,
          child: CustomPaint(
            painter: WavePainter(
              animationProgress: _sliderController.progress,
              sliderState: _sliderController.state,
              color: widget.color,
              sliderPosition: _dragPosition,
              dragPercentage: _dragPercentage,
            ),
          ),
        ),
        onHorizontalDragUpdate: (DragUpdateDetails update) => _onDragUpdate(context, update),
        onHorizontalDragStart: (DragStartDetails start) => _onDragStart(context, start),
        onHorizontalDragEnd: (DragEndDetails end) => _onDragEnd(context, end),
      ),
    );
  }
}

class WaveSliderController extends ChangeNotifier {
  final AnimationController controller;
  SliderState _state = SliderState.resting;

  WaveSliderController({@required TickerProvider vsync}): controller = AnimationController(vsync: vsync) {
    controller
        ..addListener(_onProgressUpdate)
        ..addStatusListener(_onStatusUpdate);
  }

  double get progress => controller.value;

  SliderState get state => _state;

  void _onProgressUpdate() {
    notifyListeners();
  }

  void _onStatusUpdate(AnimationStatus status) {
    if(status == AnimationStatus.completed)
      _onTransitionCompleted();
  }

  void _onTransitionCompleted() {
    if(_state == SliderState.stopping)
      setStateToResting();
  }

  void _startAnimation() {
    controller.duration = Duration(milliseconds:  500);
    controller.forward(from: 0.0);
    notifyListeners();
  }

  void setStateToResting() {
    _state = SliderState.resting;
  }

  void setStateStart() {
    _startAnimation();
    _state = SliderState.starting;
  }

  void setStateStopping() {
    _startAnimation();
    _state = SliderState.stopping;
  }

  void setStateSliding() {
    _state = SliderState.sliding;
  }
}

enum SliderState {
  starting,
  resting,
  sliding,
  stopping
}
