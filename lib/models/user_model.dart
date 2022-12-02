import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String? name;
  final bool? isBlocked;
  String? address;
  final Map? coordinates;
  final List? sexualOrientation;
  final String? gender;
  final String? showGender;
  final int? age;
  final String? phoneNumber;
  int? maxDistance;
  Timestamp? lastmsg;
  final Map? ageRange;
  final Map? editInfo;
  List? imageUrl = [];
  var distanceBW;
  User({
    this.id,
    this.age,
    this.address,
    this.isBlocked,
    this.coordinates,
    this.name,
    this.imageUrl,
    this.phoneNumber,
    this.lastmsg,
    this.gender,
    this.showGender,
    this.ageRange,
    this.maxDistance,
    this.editInfo,
    this.distanceBW,
    this.sexualOrientation,
  });

  @override
  String toString() {
    return 'User: {id: $id,name:$name, isBlocked: $isBlocked, address: $address, coordinates: $coordinates, sexualOrientation: $sexualOrientation, gender: $gender, showGender: $showGender, age: $age, phoneNumber: $phoneNumber, maxDistance: $maxDistance, lastmsg: $lastmsg, ageRange: $ageRange, editInfo: $editInfo, distanceBW : $distanceBW }';
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);
    return User(
        id: doc.get('userId') ?? "",
        isBlocked:
            doc.get('isBlocked') ?? false,
        phoneNumber: doc.get('phoneNumber') ?? "",
        name: doc.get('UserName') ?? "",
        editInfo: doc.get('editInfo'),
        ageRange: doc.get('age_range'),
        showGender: doc.get('showGender') ?? "",
        maxDistance: doc.get('maximum_distance'),
        sexualOrientation:
            doc.get('sexualOrientation')['orientation'] ?? "",
        age: ((DateTime.now()
                    .difference(DateTime.parse(doc.get("user_DOB")))
                    .inDays) /
                365.2425)
            .truncate(),
        address: doc.get('location')['address'],
        coordinates: doc.get('location'),
        // university: doc['editInfo']['university'],
        imageUrl: doc.get('Pictures') != null
            ? List.generate(doc.get('Pictures').length, (index) {
                return doc.get('Pictures')[index];
              })
            : []);
  }
}
