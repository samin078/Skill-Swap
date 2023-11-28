class Users {

  late String? image;
  late final String phoneNo;
  late final String occupation;
  late final String gender;
  late final String dateOfBirth;
  late final String email;
  late final String name;
  late final String id;
  late String? location;
  late String? nidNo;
  late String? about;
  late String? createdAt;
  late String? institution;
  late SocialLink? socialLink;
  late bool? isOnline;
  late String? lastActive;
  late String? pushToken;

  Users({
    this.image,
    required this.phoneNo,
    required this.occupation,
    required this.gender,
    required this.dateOfBirth,
    required this.name,
    required this.id,
    required this.email,
    this.about,
    this.createdAt,
    this.institution,
    this.socialLink,
    this.location,
    this.isOnline,
    this.lastActive,
    this.nidNo,
    this.pushToken,

  });



  Users.fromJson(Map<String, dynamic> json){
    image = json['image'] ?? '';
    phoneNo = json['phone_no'] ?? '';
    occupation = json['occupation'] ?? '';
    gender = json['gender'] ?? '';
    dateOfBirth = json['date_of_birth'] ?? '';
    about = json['about'] ?? '';
    createdAt = json['created_at'] ?? '';
    institution = json['institution'] ?? '';
    socialLink = SocialLink.fromJson(json['social_link']);
    name = json['name'] ?? '';
    location = json['location'] ?? '';
    id = json['id'] ?? '';
    isOnline = json['is_online'] ?? '';
    lastActive = json['last_active'] ?? '';
    nidNo = json['nid_no'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['phone_no'] = phoneNo;
    data['occupation'] = occupation;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['institution'] = institution;
    data['social_link'] = socialLink?.toJson();
    data['name'] = name;
    data['location'] = location;
    data['id'] = id;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['nid_no'] = nidNo;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}

class SocialLink {
  SocialLink({
    this.github,
    this.linkedIn,
  });

  late String? github;
  late String? linkedIn;

  SocialLink.fromJson(Map<String, dynamic> json){
    github = json['github'];
    linkedIn = json['linked_in '];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['github'] = github;
    data['linked_in '] = linkedIn;
    return data;
  }
}