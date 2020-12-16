import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:refactory_test/model/review-model.dart';
import 'package:refactory_test/repo/api-repository.dart';

part 'review_event.dart';

part 'review_state.dart';

class ReviewBloc extends HydratedBloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(InitialReviewState()){
    hydrate();
  }

  @override
  Stream<ReviewState> mapEventToState(
      ReviewEvent event
      ) async* {
      if (event is GetReviewData) {
        yield* getReviewData();
      }
  }

  Stream<ReviewState> getReviewData() async* {
    ApiRepository apiRepository = ApiRepository();
    yield ReviewLoading();
    try{
      var reviewData = await apiRepository.getReviewData();
      yield ReviewSuccess(reviewModel: reviewData);
    }catch(e){
      yield ReviewError(errMessage: e);
    }
  }

  @override
  ReviewState fromJson(Map<String, dynamic> json) {
    var parsed = json['review'];
    var reviewData = List<ReviewModel>.from(parsed.map<ReviewModel>((list) => ReviewModel.fromJson(list)));
    return ReviewSuccess(reviewModel: reviewData);
  }

  @override
  Map<String, dynamic> toJson(ReviewState state) {
    if (state is ReviewSuccess) {
      return {
        "review" : state.reviewModel
      };
    }
    return null;
  }
}
