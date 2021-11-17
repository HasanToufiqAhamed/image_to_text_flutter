import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_to_text/a_main_pages/final_tab/final_tab_image.dart';
import 'package:image_to_text/a_main_pages/final_tab/final_tab_text.dart';
import 'package:image_to_text/widget/text_detector_painter.dart';

class FinalOutput extends StatefulWidget {
  String filePath;

  FinalOutput({required this.filePath});

  @override
  _FinalOutputState createState() => _FinalOutputState();
}

class _FinalOutputState extends State<FinalOutput>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    print(widget.filePath);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 20,),
              TabBar(
                indicatorColor: Colors.red,
                labelColor: Colors.red,
                labelStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),

                unselectedLabelStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                unselectedLabelColor: Colors.black26,
                indicatorWeight: 10,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(text: "Text", icon: Icon(Icons.text_snippet_outlined),),
                  Tab(text: "Image",  icon: Icon(Icons.image_outlined),),
                ],
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4,
                    color: Colors.red,
                  ),
                  insets: EdgeInsets.only(left: 20, right: 20, bottom: 4),
                ),
                isScrollable: true,
                labelPadding: EdgeInsets.only(left: 15, right: 15),
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              children: [
                FinalTabText(
                  imagePath: widget.filePath,
                ),
                FinalTabImage(
                  imagePath: widget.filePath,
                ),
              ],
              controller: _tabController,
            ),
          ),
        ],
      ),
    );
  }
}
