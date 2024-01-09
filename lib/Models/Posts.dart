import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  late final String id;
  final String title;
  final String type;
  final String description;
  final String budget;
  final String deadline;
  final String requirement;
  final String submission;
  final String userId;
  final String requestStatus;
  final String projectUrl;
  final Timestamp time;

  Post(
      {
        required this.id,
        required this.title,
      required this.budget,
      required this.deadline,
      required this.time,
      required this.description,
      required this.projectUrl,
      required this.requestStatus,
      required this.requirement,
      required this.submission,
      required this.type,
      required this.userId});

  Post.fromMap(Map<String, dynamic> res): title= res['Title'],
      //  id=res['id'],
        budget= res['Budget'],
        deadline= res['Deadline'],
        time= res['TimeStamp'],
        description= res['Description'],
        projectUrl= res['ProjectUrl'],
        requestStatus= res['RequestStatus'],
        requirement= res['Requirement'],
        submission= res['Submission'],
        type= res['Type'],
        userId= res['UserId'];

}
