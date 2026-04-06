import 'package:flutter/material.dart';
import '../models/mehndi_design.dart';
import '../utils/constants.dart';
import '../widgets/design_detail_widget.dart';

class DesignDetailScreen extends StatefulWidget {
  final MehndiDesign design;

  const DesignDetailScreen({
    Key? key,
    required this.design,
  }) : super(key: key);

  @override
  State<DesignDetailScreen> createState() => _DesignDetailScreenState();
}

class _DesignDetailScreenState extends State<DesignDetailScreen> {
  late MehndiDesign _design;

  @override
  void initState() {
    super.initState();
    _design = widget.design;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_design.title),
        elevation: 0,
      ),
      body: DesignDetailWidget(design: _design),
    );
  }
}
