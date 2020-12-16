import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refactory_test/main/feature/course/bloc/detail_course/detail_course_bloc.dart';

import '../webview-screen.dart';

class DetailCourseScreen extends StatefulWidget {
  DetailCourseScreen({Key key}) : super(key: key);

  @override
  _DetailCourseScreenState createState() => _DetailCourseScreenState();
}

class _DetailCourseScreenState extends State<DetailCourseScreen> {
  DetailCourseBloc detailCourseBloc;

  @override
  void initState() {
    detailCourseBloc = BlocProvider.of<DetailCourseBloc>(context);
    detailCourseBloc.add(GetDetailCourse());
    super.initState();
  }

  @override
  void dispose() {
    detailCourseBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Html & CSS",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://outcomes.business/wp-content/uploads/2011/05/Team-Work.png"),
                fit: BoxFit.cover,
              )),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Colors.indigo.withOpacity(0.7),
                      Colors.blue.withOpacity(0.7)
                    ])),
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      padding: EdgeInsets.only(top: 24, left: 8, right: 8),
                      child: Text(
                        "HTML & CSS Introduction",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: 300,
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                      child: Text(
                        "HTML dan CSS adalah materi dasar untuk pengembangan web. Setiap web developer harus memiliki pengetahuan dasar setidaknya HTML dan CSS. ",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: BlocBuilder<DetailCourseBloc, DetailCourseState>(
                builder: (context, state) {
                  if (state is DetailCourseLoading) {
                    return showLoading();
                  }
                  if (state is DetailCourseError) {
                    return showError();
                  }
                  if (state is InitialDetailCourseState) {
                    return showLoading();
                  }
                  return showDetailCourse(state);
                },
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget showDetailCourse(DetailCourseSuccess state) {
    if(state.detailCourseModel == null){
      return showLoading();
    }
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "About Course",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "${state.detailCourseModel.shortDescription}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Course Lesson",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: state.detailCourseModel.materiCourse.map((item) =>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.grey.withOpacity(0.6),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                            child: Text(
                              "${item.section}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Column(
                            children: item.data.map((item) =>
                                Container(
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        child: Icon(Icons.video_collection_rounded),
                                      ),
                                      Container(
                                        child: Text(
                                          "${item.title}",
                                          style: TextStyle(
                                              fontSize: 20, fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          "(${item.timeIn})",
                                          style: TextStyle(
                                              fontSize: 20, fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                      RaisedButton(
                                        onPressed: (){
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) => WebViewScreen(
                                                    title: "${item.title}",
                                                    url: "${item.url}",
                                                  )
                                              )
                                          );
                                        },
                                        color: Colors.deepOrangeAccent,
                                        textColor: Colors.white,
                                        elevation: 0,
                                        hoverColor: Colors.white.withOpacity(0.5),
                                        child: Text("Start"),
                                      )
                                    ],
                                  ),
                                ),
                            ).toList(),
                          )
                        ],
                      ),
                  ).toList(),
                )
              )
            ],
          ),
        )
      ],
    );

  }

  Widget showLoading() {
    return Container(
      height: 30,
      width: 30,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Container showError() {
    return Container(
      child: Center(
        child: Text("Something Wrong!"),
      ),
    );
  }
}
