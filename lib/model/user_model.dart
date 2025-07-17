class UserModel {
  UserModel({
      this.user, 
      this.token,});

  UserModel.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }
  User? user;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['token'] = token;
    return map;
  }

}

class User {
  User({
      this.id, 
      this.fName, 
      this.lName, 
      this.name, 
      this.nickName, 
      this.email, 
      this.profilePhotoPath, 
      this.emailVerifiedAt, 
      this.phone, 
      this.parentPhone, 
      this.parentEmail, 
      this.image, 
      this.cityId, 
      this.position, 
      this.userAdminId, 
      this.grade, 
      this.courseId, 
      this.categoryId, 
      this.state, 
      this.avatar, 
      this.extraEmail, 
      this.createdAt, 
      this.updatedAt, 
      this.lastLoginAt, 
      this.lastLoginIp, 
      this.deletedAt, 
      this.token, 
      this.imageLink, 
      this.userAdmin,});

  User.fromJson(dynamic json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    name = json['name'];
    nickName = json['nick_name'];
    email = json['email'];
    profilePhotoPath = json['profile_photo_path'];
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    parentPhone = json['parent_phone'];
    parentEmail = json['parent_email'];
    image = json['image'];
    cityId = json['city_id'];
    position = json['position'];
    userAdminId = json['user_admin_id'];
    grade = json['grade'];
    courseId = json['course_id'];
    categoryId = json['category_id'];
    state = json['state'];
    avatar = json['avatar'];
    extraEmail = json['extra_email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastLoginAt = json['last_login_at'];
    lastLoginIp = json['last_login_ip'];
    deletedAt = json['deleted_at'];
    token = json['token'];
    imageLink = json['image_link'];
    userAdmin = json['user_admin'];
  }
  num? id;
  String? fName;
  String? lName;
  String? name;
  String? nickName;
  String? email;
  dynamic profilePhotoPath;
  dynamic emailVerifiedAt;
  String? phone;
  String? parentPhone;
  dynamic parentEmail;
  String? image;
  dynamic cityId;
  String? position;
  dynamic userAdminId;
  dynamic grade;
  dynamic courseId;
  dynamic categoryId;
  String? state;
  dynamic avatar;
  dynamic extraEmail;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic lastLoginAt;
  dynamic lastLoginIp;
  dynamic deletedAt;
  String? token;
  String? imageLink;
  dynamic userAdmin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['f_name'] = fName;
    map['l_name'] = lName;
    map['name'] = name;
    map['nick_name'] = nickName;
    map['email'] = email;
    map['profile_photo_path'] = profilePhotoPath;
    map['email_verified_at'] = emailVerifiedAt;
    map['phone'] = phone;
    map['parent_phone'] = parentPhone;
    map['parent_email'] = parentEmail;
    map['image'] = image;
    map['city_id'] = cityId;
    map['position'] = position;
    map['user_admin_id'] = userAdminId;
    map['grade'] = grade;
    map['course_id'] = courseId;
    map['category_id'] = categoryId;
    map['state'] = state;
    map['avatar'] = avatar;
    map['extra_email'] = extraEmail;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['last_login_at'] = lastLoginAt;
    map['last_login_ip'] = lastLoginIp;
    map['deleted_at'] = deletedAt;
    map['token'] = token;
    map['image_link'] = imageLink;
    map['user_admin'] = userAdmin;
    return map;
  }

}