class Users {

  late String? image;
  late String? phoneNo;
  late String? occupation;
  late String? gender;
  late String? dateOfBirth;
  late String? email;
  late String? name;
  late String? id;
  late String? location;
  late String? nidNo;
  late String? about;
  late String? createdAt;
  late String? institution;
  late SocialLink? socialLink;
  late bool? isOnline;
  late String? lastActive;
  late String? pushToken;

  late bool? isVerified;
  late String? degree;
  late String? fieldOfStudy;
  late String? graduationYear;

  Users({
    this.image,
    this.phoneNo,
    this.occupation,
    this.gender,
    this.dateOfBirth,
    this.name,
    this.id,
    this.email,
    this.about,
    this.createdAt,
    this.institution,
    this.socialLink,
    this.location,
    this.isOnline,
    this.lastActive,
    this.nidNo,
    this.pushToken,

    this.isVerified,
    this.degree,
    this.fieldOfStudy,
    this.graduationYear,

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

    isVerified = json['is_verified'] ?? '';
    degree = json['degree'] ?? '';
    fieldOfStudy = json['field_of_study'] ?? '';
    graduationYear = json['graduation_year'] ?? '';
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
    data['is_verified'] = isVerified;
    data['degree'] = degree;
    data['field_of_study'] = fieldOfStudy;
    data['graduation_year'] = graduationYear;
    return data;
  }
}

class SocialLink {
  SocialLink({
    this.github,
    this.linkedIn, this.facebook,
  });

  late String? github;
  late String? linkedIn;
  late String? facebook;

  SocialLink.fromJson(Map<String, dynamic> json){
    github = json['github'];
    linkedIn = json['linked_in'];
    facebook = json['facebook'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['github'] = github;
    data['linked_in'] = linkedIn;
    data['facebook'] = linkedIn;
    return data;
  }
}