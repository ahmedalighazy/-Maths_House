class StudentModel {
  StudentModel({
      this.students, 
      this.categories, 
      this.courses,});

  StudentModel.fromJson(dynamic json) {
    if (json['students'] != null) {
      students = [];
      json['students'].forEach((v) {
        students?.add(Students.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories?.add(Categories.fromJson(v));
      });
    }
    if (json['courses'] != null) {
      courses = [];
      json['courses'].forEach((v) {
        courses?.add(Courses.fromJson(v));
      });
    }
  }
  List<Students>? students;
  List<Categories>? categories;
  List<Courses>? courses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (students != null) {
      map['students'] = students?.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      map['categories'] = categories?.map((v) => v.toJson()).toList();
    }
    if (courses != null) {
      map['courses'] = courses?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Courses {
  Courses({
      this.id, 
      this.courseName,});

  Courses.fromJson(dynamic json) {
    id = json['id'];
    courseName = json['course_name'];
  }
  num? id;
  String? courseName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['course_name'] = courseName;
    return map;
  }

}

class Categories {
  Categories({
      this.id, 
      this.cateName, 
      this.cateDes, 
      this.cateUrl, 
      this.createdAt, 
      this.updatedAt, 
      this.teacherId,});

  Categories.fromJson(dynamic json) {
    id = json['id'];
    cateName = json['cate_name'];
    cateDes = json['cate_des'];
    cateUrl = json['cate_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    teacherId = json['teacher_id'];
  }
  num? id;
  String? cateName;
  String? cateDes;
  String? cateUrl;
  String? createdAt;
  String? updatedAt;
  num? teacherId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['cate_name'] = cateName;
    map['cate_des'] = cateDes;
    map['cate_url'] = cateUrl;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['teacher_id'] = teacherId;
    return map;
  }

}

class Students {
  Students({
      this.id, 
      this.fName, 
      this.lName, 
      this.nickName, 
      this.email, 
      this.phone, 
      this.parentPhone, 
      this.parentEmail, 
      this.grade, 
      this.payment, 
      this.image, 
      this.category, 
      this.categoryId,});

  Students.fromJson(dynamic json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    nickName = json['nick_name'];
    email = json['email'];
    phone = json['phone'];
    parentPhone = json['parent_phone'];
    parentEmail = json['parent_email'];
    grade = json['grade'];
    payment = json['payment'];
    image = json['image'];
    category = json['category'];
    categoryId = json['category_id'];
  }
  num? id;
  String? fName;
  String? lName;
  String? nickName;
  String? email;
  String? phone;
  String? parentPhone;
  String? parentEmail;
  String? grade;
  String? payment;
  dynamic image;
  String? category;
  num? categoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['f_name'] = fName;
    map['l_name'] = lName;
    map['nick_name'] = nickName;
    map['email'] = email;
    map['phone'] = phone;
    map['parent_phone'] = parentPhone;
    map['parent_email'] = parentEmail;
    map['grade'] = grade;
    map['payment'] = payment;
    map['image'] = image;
    map['category'] = category;
    map['category_id'] = categoryId;
    return map;
  }

}