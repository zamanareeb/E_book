import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_book/appTabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  ScrollController? _scrollController;
  List? popularBooks;
  readData() async{
    await rootBundle.loadString('json/popularBooks.json').then((value){
      setState(() {
        popularBooks = json.decode(value);
      });
    });
  }

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    readData();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFffffff),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              // SizedBox(height: 10,),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 10, top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.menu_outlined, size: 30,),
                    Row(
                      children: const [
                        Icon(Icons.search, size: 30,),
                        SizedBox(width: 10,),
                        Icon(Icons.notifications, size: 30),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                children:  [
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: const Text('Popular Books',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Roboto Mono'
                    ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.28,
                child: PageView.builder(
                    controller: PageController(viewportFraction: 0.9),
                    itemCount: popularBooks == null?0:popularBooks?.length,
                    itemBuilder: (_, i){
                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(popularBooks?[i]['img']),
                          )
                        ),
                      );
                    }
                ),
              ),
              Expanded(
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (BuildContext context, bool isScroll){
                      return[
                        SliverAppBar(
                          pinned: true,
                          backgroundColor: Colors.white,
                          bottom: PreferredSize(
                            preferredSize: const Size.fromHeight(50),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20, left: 20),
                              child: TabBar(
                                indicatorPadding: const EdgeInsets.all(0),
                                indicatorSize: TabBarIndicatorSize.label,
                                labelPadding: const EdgeInsets.only(right: 10),
                                controller: _tabController,
                                isScrollable: true,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 7,
                                      offset: const Offset(0,0)
                                    )
                                  ]
                                ),
                                tabs: const [
                                  AppTabs(color: Colors.yellow, label: 'New'),
                                  AppTabs(color: Colors.red, label: 'Trending'),
                                  AppTabs(color: Colors.lightBlueAccent, label: 'Popular'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: const [
                        Material(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                            ),
                            title: Text('Content in new tab'),
                          ),
                        ),
                        Material(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                            ),
                            title: Text('Content in trending tab'),
                          ),
                        ),
                        Material(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                            ),
                            title: Text('Content in popular tab'),
                          ),
                        )
                      ],
                    ),
                  )
              )
              ,
              Container(
                margin: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                height: MediaQuery.of(context).size.height*0.06,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: (){},
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.29,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.yellow,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 2,
                                offset: const Offset(0,0),
                              )
                            ]
                          ),
                          child: Center(child: Text('New', style: TextStyle(fontSize: 20, color: Colors.white),)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: (){},
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.29,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  blurRadius: 2,
                                  offset: const Offset(0,0),
                                )
                              ]
                          ),
                          child: Center(child: Text('Trending', style: TextStyle(fontSize: 20, color: Colors.white),)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: (){},
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.29,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.lightBlueAccent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  blurRadius: 2,
                                  offset: const Offset(0,0),
                                )
                              ]
                          ),
                          child: Center(child: Text('Popular', style: TextStyle(fontSize: 20, color: Colors.white),)),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                // height: 200,
                child: ListView.builder(
                  itemCount: popularBooks == null?0:popularBooks?.length,
                  itemBuilder: (_,i){
                  return Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            offset: const Offset(0,0),
                            color: Colors.grey.withOpacity(0.2)
                          )
                        ]
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Container(
                              width: 90,
                              height: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(popularBooks?[i]['img']),
                                  )
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 24, color: Colors.yellow,),
                                    const SizedBox(width: 5,),
                                    Text(
                                      popularBooks?[i]['rating'],
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*12,
                                          fontFamily: 'Avenir', fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  popularBooks?[i]['title'],
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).textScaleFactor*11,
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  popularBooks?[i]['writer'],
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).textScaleFactor*11,
                                    fontFamily: 'Avenir',
                                    color: Colors.grey
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.lightBlueAccent
                                  ),
                                  child: Text(
                                    popularBooks?[i]['genre'],
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor*11,
                                      fontFamily: 'Avenir',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
