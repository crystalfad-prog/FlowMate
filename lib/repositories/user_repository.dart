import '../models/user_model.dart';

class UserRepository {

  UserModel getUser() {
    return UserModel(
      name: "Fad",
      cycleDay: 20,
      daysUntilPeriod: 8,
    );
  }
}