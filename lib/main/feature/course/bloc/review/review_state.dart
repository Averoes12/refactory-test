part of 'review_bloc.dart';

@immutable
abstract class ReviewState {}

class InitialReviewState extends ReviewState {}

class ReviewSuccess extends ReviewState{
  final List<ReviewModel> reviewModel;
  ReviewSuccess({@required this.reviewModel});
}

class ReviewError extends ReviewState {
  final String errMessage;
  ReviewError({this.errMessage});
}

class ReviewLoading extends ReviewState{}