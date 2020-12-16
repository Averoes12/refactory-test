import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refactory_test/main/feature/home/bloc/home_bloc.dart';
import 'package:refactory_test/main/feature/home/bloc/partner/partner_bloc.dart';
import 'package:refactory_test/main/feature/home/bloc/see_on/see_on_bloc.dart';
import 'package:refactory_test/repo/api-repository.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiRepository apiRepository = ApiRepository();
  PartnerBloc partnerBloc;
  HomeBloc homeBloc;
  SeeOnBloc seeOnBloc;

  @override
  void initState() {
    super.initState();
    partnerBloc = BlocProvider.of<PartnerBloc>(context);
    homeBloc = BlocProvider.of<HomeBloc>(context);
    seeOnBloc = BlocProvider.of<SeeOnBloc>(context);
    partnerBloc.add(GetPartnerData());
    homeBloc.add(GetHomeData());
    seeOnBloc.add(GetSeeOnData());

  }

  @override
  void dispose() {
    homeBloc.close();
    partnerBloc.close();
    seeOnBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://outcomes.business/wp-content/uploads/2011/05/Team-Work.png"),
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
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoading) {
                          print("Loading Home");
                          return showLoading(context);
                        }
                        if (state is HomeError) {
                          print("Error Home");
                          return showError();
                        }
                        if(state is HomeInitial){
                          return Container(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            showHomeData(state),
                            Container(
                              color: Colors.white,
                              padding : EdgeInsets.only(top : 16, left: 16, right: 16),
                              child: showCorpService(state),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.white,
                  child: BlocBuilder<SeeOnBloc, SeeOnState>(
                    builder: (context, state) {
                      if (state is SeeOnLoading) {
                        return showLoading(context);
                      }
                      if (state is SeeOnError) {
                        return showError();
                      }
                      if (state is InitialSeeOnState) {
                        return showLoading(context);
                      }
                      return Column(
                        children: [
                          Container(
                            child: Text("As Seen On",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                            ),
                            ),
                          ),
                          showSeeOn(state),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        child: Container(
          height: 40,
          width: 40,
          child: SvgPicture.network("https://www.flaticon.com/svg/static/icons/svg/220/220236.svg",
            semanticsLabel: "Contact",
            placeholderBuilder: (context) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Container showLoading(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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

  Widget showHomeData(HomeSuccess state){
    if(state.homeModel == null){
      return Container(
        height: 30,
        width: 30,
        child: CircularProgressIndicator()
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.only(top: 16, left: 8, right: 8),
          child: Text("${state.homeModel.slogan}",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white
            ),
          ),
        ),
        Container(
          padding:EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Text("${state.homeModel.corpDesc}",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            width: 150,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Text("Find Your Solution",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12
              ),
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(8),
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Text("Upgrade Your Skill",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
          child: Text("Our Exclusive Partner",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white
            ),
          ),
        ),
        Container(
          height: 100,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<PartnerBloc, PartnerState>(
            // cubit: postBloc,
            builder: (context, state) {
              if (state is PartnerLoading) {
                print("Loading");
                return Container();
              }
              if (state is PartnerError) {
                print("Error");
                return Container(child: Text(state.errorMessage),);
              }
              if(state is PartnerInitial){
                return Container(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                );
              }
              return showListPartner(state);
            },
          ),
        ),
      ],
    );
  }

  Widget showListPartner(PartnerSuccess state) {
    if(state.listPartner.isEmpty){
      return Container(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: state.listPartner.map((item) {
        return Container(
          height: 48,
          width: 48,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("${item.photoUrl}")
              )
          ),
        );
      }).toList(),
    );
  }
  Widget showCorpService(HomeSuccess state){
    if (state.homeModel == null) {
      return Container(
          height: 30,
          width: 30,
          child: CircularProgressIndicator()
      );
    }
    return Column(
      children: [
        Container(
          child: Text("What's Refactory Can Help ?",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18
            ),
          ),
        ),
        Column(
          children: state.homeModel.corpService.map((item) =>
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      margin: EdgeInsets.only(bottom: 16, top: 16),
                      child: Image.network("${item.logo}")),
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Text("${item.title}",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 16) ,
                      child: Text("${item.desc}"),
                    )
                  ],
                ),
              )
          ).toList(),
        ),
      ],
    );
  }

  Widget showSeeOn(SeeOnSuccess state) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      primary: true,
      children: state.seeOnModel.map((item) =>
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Image.network("${item.photoUrl}"),
          )
      ).toList(),
    );
  }
}

