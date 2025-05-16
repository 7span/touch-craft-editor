import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/services/connectivity_service.dart';

class ConnectivityWrapper extends StatefulWidget {
  const ConnectivityWrapper({
    required this.child,
    required this.connectivityService,
    super.key,
  });

  final Widget child;
  final ConnectivityService connectivityService;

  @override
  ConnectivityWrapperState createState() => ConnectivityWrapperState();
}

class ConnectivityWrapperState extends State<ConnectivityWrapper> {
  @override
  void initState() {
    super.initState();
    widget.connectivityService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: widget.child);
  }

  @override
  void dispose() {
    widget.connectivityService.dispose();
    super.dispose();
  }
}
