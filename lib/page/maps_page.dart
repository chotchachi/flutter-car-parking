import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/backdrop.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(body: Panels());
}

class Panels extends StatelessWidget {
  final frontPanelVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      frontLayer: FrontPanel(),
      backLayer: BackPanel(
        frontPanelOpen: frontPanelVisible,
      ),
      frontHeader: FrontPanelTitle(),
      panelVisible: frontPanelVisible,
      frontPanelOpenHeight: 40.0,
      frontHeaderHeight: 48.0,
      frontHeaderVisibleClosed: true,
    );
  }
}

class FrontPanelTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Text(
        'Show trip details',
        style: Theme.of(context).textTheme.subtitle1,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class FrontPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).cardColor, child: Text('Hello world'));
  }
}

class BackPanel extends StatefulWidget {
  BackPanel({@required this.frontPanelOpen});
  final ValueNotifier<bool> frontPanelOpen;

  @override
  createState() => _BackPanelState();
}

class _BackPanelState extends State<BackPanel> {
  bool panelOpen;

  @override
  initState() {
    super.initState();
    panelOpen = widget.frontPanelOpen.value;
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  void _subscribeToValueNotifier() =>
      setState(() => panelOpen = widget.frontPanelOpen.value);

  /// Required for resubscribing when hot reload occurs
  @override
  void didUpdateWidget(BackPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.frontPanelOpen.removeListener(_subscribeToValueNotifier);
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
        onMapCreated: (GoogleMapController controller) {},
        initialCameraPosition:
            CameraPosition(target: LatLng(16.047079, 108.206230), zoom: 15.0),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        // onLongPress: ()  {
        //   widget.frontPanelOpen.value = true;
        // },
      ),
    ]);
  }
}
