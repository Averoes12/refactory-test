import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refactory_test/main/feature/home/bloc/home_bloc.dart';
import 'package:refactory_test/main/feature/home/bloc/partner/partner_bloc.dart';
import 'package:refactory_test/repo/api-repository.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiRepository apiRepository = ApiRepository();
  PartnerBloc partnerBloc;
  HomeBloc homeBloc;
  @override
  void initState() {
    super.initState();
    partnerBloc = BlocProvider.of<PartnerBloc>(context);
    homeBloc = BlocProvider.of<HomeBloc>(context);
    partnerBloc.add(GetPartnerData());
    homeBloc.add(GetHomeData());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.80,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 200,

                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      print("Loading Home");
                      return CircularProgressIndicator();
                    }
                    if (state is HomeError) {
                      print("Error Home");
                      return Container();
                    }
                    if(state is HomeInitial){
                      return CircularProgressIndicator();
                    }
                    return showHomeData(state);
                  },
                ),
              ),
              Container(
                height: 200,
                child: BlocBuilder<PartnerBloc, PartnerState>(
                  // cubit: postBloc,
                  builder: (context, state) {
                    if (state is PartnerLoading) {
                      print("Loading");
                      return CircularProgressIndicator();
                    }
                    if (state is PartnerError) {
                      print("Error");
                      return Container(child: Text(state.errorMessage),);
                    }
                    if(state is PartnerInitial){
                      return Container(
                        child: Center(
                          child: Text("Press the button below"),
                        ),
                      );
                    }
                    return showListPartner(state);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showHomeData(HomeSuccess state){
    if(state.homeModel == null){
      return Center(child: CircularProgressIndicator(),);
    }
    return Container(
      height: 100,
      child: Text("${state.homeModel.slogan}"),
    );
  }
  Widget showListPartner(PartnerSuccess state) {
    if(state.listPartner.isEmpty){
      return CircularProgressIndicator();
    }
    return ListView.builder(
        itemCount: state.listPartner != null ? state.listPartner.length : 0,
        itemBuilder: (context, index) =>
            ListTile(
              title: Text(state.listPartner[index].name),
            )
    );
  }
}

