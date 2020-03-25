import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoPage/likebutton/model.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'dot_painter.dart';
import 'circle_painter.dart';

typedef LikeCallback = void Function(bool isLike);

class LikeButton extends StatefulWidget {
  final double width;
  final LikeIcon icon;
  final Duration duration;
  final DotColor dotColor;
  final Color circleStartColor;
  final Color circleEndColor;
  final LikeCallback onIconClicked;

  final int looker;
  final Video video;

  const LikeButton({
    Key key,
    @required this.width,
    this.icon = const LikeIcon(
      Icons.favorite,
      iconColor: Colors.pinkAccent,
    ),
    this.duration = const Duration(milliseconds: 5000),
    this.dotColor = const DotColor(
      dotPrimaryColor: const Color(0xFFFFC107),
      dotSecondaryColor: const Color(0xFFFF9800),
      dotThirdColor: const Color(0xFFFF5722),
      dotLastColor: const Color(0xFFF44336),
    ),
    this.circleStartColor = const Color(0xFFFF5722),
    this.circleEndColor = const Color(0xFFFFC107),
    this.onIconClicked,
    this.looker,
    this.video,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> outerCircle;
  Animation<double> innerCircle;
  Animation<double> scale;
  Animation<double> dots;

  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _controller =
        new AnimationController(duration: widget.duration, vsync: this)
          ..addListener(() {
            setState(() {});
          });
    _initAllAmimations();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CustomPaint(
          size: Size(widget.width, widget.width),
          painter: DotPainter(
            currentProgress: dots.value,
            color1: widget.dotColor.dotPrimaryColor,
            color2: widget.dotColor.dotSecondaryColor,
            color3: widget.dotColor.dotThirdColorReal,
            color4: widget.dotColor.dotLastColorReal,
          ),
        ),
        CustomPaint(
          size: Size(widget.width * 0.35, widget.width * 0.35),
          painter: CirclePainter(
              innerCircleRadiusProgress: innerCircle.value,
              outerCircleRadiusProgress: outerCircle.value,
              startColor: widget.circleStartColor,
              endColor: widget.circleEndColor),
        ),
        Container(
          width: widget.width,
          height: widget.width,
          alignment: Alignment.center,
          child: Transform.scale(
            scale: isLiked ? scale.value : 1.0,
            child: GestureDetector(
              child: Icon(
                widget.icon.icon,
                color: isLiked ? widget.icon.color : Colors.grey,
                size: widget.width * 0.4,
              ),
              onTap: _onTap,
            ),
          ),
        ),
      ],
    );
  }

  void _onTap() async {
    Video video = widget.video;
    int looker = widget.looker;
    if(looker == null) {
      TsUtils.showShort('请先登录');
      return;
    }

    if (_controller.isAnimating) return;
    isLiked = !isLiked;

    isLiked == true ? video.likes = video.likes + 1 : video.likes = video.likes - 1;

    Map<String, dynamic> data = {
      'video' : Video.model2map(video),
      'looker' : looker,
      'isLiked' : isLiked
    };

    try {
      Result result = await DioRequest.dioPut(URL.VIDEO_LIKE, data);
      if(result.code.toString() != "1") {
        throw "Error:后台错误{${result.code}, ${result.data}, ${result.msg}";
      }
    } on Exception {
      TsUtils.showShort('通讯错误，请重试');
      return;
    }
    if (isLiked) {
      _controller.reset();
      _controller.forward();
    } else {
      setState(() {});
    }

    if (widget.onIconClicked != null)
      widget.onIconClicked(isLiked);
  }
  
  void _initAllAmimations() {
    outerCircle = new Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );
    innerCircle = new Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );
    scale = new Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.35,
          0.7,
          curve: OvershootCurve(),
        ),
      ),
    );
    dots = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.1,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}
