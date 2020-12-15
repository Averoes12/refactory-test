part of 'partner_bloc.dart';

@immutable
abstract class PartnerState {}

class PartnerInitial extends PartnerState {}

class PartnerSuccess extends PartnerState {
  final List<PartnerModel> listPartner;

  PartnerSuccess({
    this.listPartner,
  });

}

class PartnerError extends PartnerState {
  final String errorMessage;
  PartnerError({
    this.errorMessage
  });
}

class PartnerLoading extends PartnerState {}

