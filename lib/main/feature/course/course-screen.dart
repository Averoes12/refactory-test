import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:refactory_test/main/feature/course/bloc/course/course_bloc.dart';
import 'package:refactory_test/main/feature/course/bloc/list_course/list_course_bloc.dart';
import 'package:refactory_test/main/feature/course/bloc/review/review_bloc.dart';
import 'package:refactory_test/main/feature/course/detail_course-screen.dart';

class CourseScreen extends StatefulWidget {
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  CourseBloc courseBloc;
  ReviewBloc reviewBloc;
  ListCourseBloc listCourseBloc;

  @override
  void initState() {
    courseBloc = BlocProvider.of<CourseBloc>(context);
    reviewBloc = BlocProvider.of<ReviewBloc>(context);
    listCourseBloc = BlocProvider.of<ListCourseBloc>(context);
    courseBloc.add(GetCourseData());
    reviewBloc.add(GetReviewData());
    listCourseBloc.add(GetListCourseData());
    super.initState();
  }

  @override
  void dispose() {
    courseBloc.close();
    reviewBloc.close();
    listCourseBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://outcomes.business/wp-content/uploads/2011/05/Team-Work.png"),
                        fit: BoxFit.cover,
                      )
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.indigo.withOpacity(0.7),
                              Colors.blue.withOpacity(0.7)
                            ]
                        )
                    ),
                    child: BlocBuilder<CourseBloc, CourseState>(
                      builder: (context, state) {
                        if (state is CourseLoading) {
                          return showLoading(context);
                        }
                        if (state is CourseError) {
                          return showError();
                        }
                        if (state is InitialCourseState) {
                          return showLoading(context);
                        }
                        return showCourseData(state);
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Text("Alumni Review",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  width: MediaQuery.of(context).size.width,
                  child: BlocBuilder<ReviewBloc, ReviewState>(
                    builder: (context, state){
                      if (state is ReviewLoading) {
                        return showLoading(context);
                      }
                      if (state is ReviewError) {
                        return showError();
                      }
                      if (state is InitialReviewState) {
                        return showLoading(context);
                      }
                      return showReviewData(state);
                    },
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  margin: EdgeInsets.all(24),
                  child: Text("List Course",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  margin: EdgeInsets.only(bottom: 16),
                  width: MediaQuery.of(context).size.width,
                  child: BlocBuilder<ListCourseBloc, ListCourseState>(
                    builder: (context, state){
                      if (state is ListCourseLoading) {
                        return showLoading(context);
                      }
                      if (state is ListCourseError) {
                        return showError();
                      }
                      if (state is InitialListCourseState) {
                        return showLoading(context);
                      }
                      return showListCourseData(state);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container showLoading(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
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

  Widget showCourseData(CourseSuccess state) {
    if (state.courseModel == null) {
      return Container(
          height: 30,
          width: 30,
          child: CircularProgressIndicator()
      );
    }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Text("${state.courseModel.slogan}",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white
            ),
          ),
        ),
        SizedBox(height: 24,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text("${state.courseModel.desc}",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white
            ),
          ),
        ),
        Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal : 16, vertical: 16),
                    child: Text("How Refactory Course help you to upgrading your skill.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),
                    ),
                  ),
                  Image.network("https://gitlab.com/Daffaal/data-json/-/raw/master/Frame.png"),
                ],
              ),
            ),
            Container(
              color: Colors.grey.withOpacity(0.8),
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: 250,
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage("https://i1.wp.com/refactory.id/wp-content/uploads/2020/01/IMG_1152-1.jpg?fit=690%2C800&ssl=1"),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
            Container(
              color: Colors.grey.withOpacity(0.8),
              padding: EdgeInsets.only(top: 16, left: 8, right: 8),
              child: Text("${state.courseModel.titleDesc}",
                softWrap: true,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),
              ),
            ),
            Container(
              color: Colors.grey.withOpacity(0.8),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Text("${state.courseModel.descCourse}",
                softWrap: true,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget showReviewData(ReviewSuccess state){
    if (state.reviewModel.isEmpty) {
        return showLoading(context);
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: state.reviewModel.length,
      itemBuilder: (context, index) =>
        Container(
          width: MediaQuery.of(context).size.width * 0.70,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width * 0.70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  image: DecorationImage(
                    image: NetworkImage("${state.reviewModel[index].user.photoUrl}",),
                    fit: BoxFit.cover,
                  )
                ),
              ),
              SizedBox(height: 8,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 2,top: 8),
                      child: Text("${state.reviewModel[index].user.name}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 2,top: 8),
                      child: Text("${state.reviewModel[index].user.from}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    SizedBox(height: 24,),
                    RatingBar.builder(
                      itemCount: 5,
                      initialRating: (state.reviewModel[index].star).toDouble(),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amberAccent,
                      ),
                      itemSize: 20,
                      onRatingUpdate: (rating){},
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 2,top: 16),
                      child: Text("${state.reviewModel[index].title}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 2,top: 8, right: 2),
                      child: Text("${state.reviewModel[index].description}",
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }

  Widget showListCourseData(ListCourseSuccess state){
    if (state.listCourseModel.isEmpty) {
        return showLoading(context);
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: state.listCourseModel.length -1,
      itemBuilder: (context, index) =>
        GestureDetector(
          onTap: (){
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => DetailCourseScreen())
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.70,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    image: DecorationImage(
                      image: NetworkImage("${state.listCourseModel[index].photoUrl}",),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  margin: EdgeInsets.only(left: 16,top: 8),
                  child: Text("${state.listCourseModel[index].title}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16,top: 8),
                  child: Text("${state.listCourseModel[index].shortDescription}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 8,top: 8),
                        child: Text("${state.listCourseModel[index].user.name}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage("${state.listCourseModel[index].user.photoUrl}"),
                            fit: BoxFit.cover
                          )
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}
