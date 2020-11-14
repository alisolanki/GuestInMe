class RegistrationModel {
  final String date;
  final List<UserRegistrationModel> userRegistrationModel;
  RegistrationModel({
    this.date,
    this.userRegistrationModel,
  });
}

class UserRegistrationModel {
  final String phoneNumber;
  final List<EventRegistrationModel> eventRegistrationModel;
  UserRegistrationModel({
    this.phoneNumber,
    this.eventRegistrationModel,
  });
}

class EventRegistrationModel {
  final String eventName;
  final Map<String, String> typePrice;
  EventRegistrationModel({
    this.eventName,
    this.typePrice,
  });
}
