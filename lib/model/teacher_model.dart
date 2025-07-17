class TeacherModel {
  TeacherModel({
    this.teachers,
    this.categories,
    this.courses,
  });

  List<Teachers>? teachers;
  List<Categories>? categories;
  List<Courses>? courses;

  TeacherModel.fromJson(dynamic json) {
    if (json['teachers'] != null && json['teachers'] is List) {
      teachers = List<Teachers>.from(
        (json['teachers'] as List).map((e) => Teachers.fromJson(e)),
      );
    }

    if (json['categories'] != null && json['categories'] is List) {
      categories = List<Categories>.from(
        (json['categories'] as List).map((e) => Categories.fromJson(e)),
      );
    }

    if (json['courses'] != null && json['courses'] is List) {
      courses = List<Courses>.from(
        (json['courses'] as List).map((e) => Courses.fromJson(e)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (teachers != null) {
      map['teachers'] = teachers!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      map['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (courses != null) {
      map['courses'] = courses!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Teachers {
  Teachers({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.categories,
    this.courses,
  });

  num? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  List<Categories>? categories;
  List<Courses>? courses;

  Teachers.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];

    if (json['categories'] != null && json['categories'] is List) {
      categories = List<Categories>.from(
        (json['categories'] as List).map((e) => Categories.fromJson(e)),
      );
    }

    if (json['courses'] != null && json['courses'] is List) {
      courses = List<Courses>.from(
        (json['courses'] as List).map((e) => Courses.fromJson(e)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['image'] = image;
    if (categories != null) {
      map['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (courses != null) {
      map['courses'] = courses!.map((v) => v.toJson()).toList();
    }
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
    this.teacherId,
  });

  num? id;
  String? cateName;
  String? cateDes;
  String? cateUrl;
  String? createdAt;
  String? updatedAt;
  num? teacherId;

  Categories.fromJson(dynamic json) {
    id = json['id'];
    cateName = json['cate_name'];
    cateDes = json['cate_des'];
    cateUrl = json['cate_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    teacherId = json['teacher_id'];
  }

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

class Courses {
  Courses({
    this.id,
    this.courseName,
    this.categoryId,
    this.courseDes,
    this.courseUrl,
    this.preRequisition,
    this.gain,
    this.createdAt,
    this.updatedAt,
    this.teacherId,
    this.userId,
    this.type,
    this.currancyId,
  });

  num? id;
  String? courseName;
  num? categoryId;
  String? courseDes;
  String? courseUrl;
  dynamic preRequisition;
  dynamic gain;
  String? createdAt;
  String? updatedAt;
  num? teacherId;
  dynamic userId;
  String? type;
  num? currancyId;

  Courses.fromJson(dynamic json) {
    id = json['id'];
    courseName = json['course_name'];
    categoryId = json['category_id'];
    courseDes = json['course_des'];
    courseUrl = json['course_url'];
    preRequisition = json['pre_requisition'];
    gain = json['gain'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    teacherId = json['teacher_id'];
    userId = json['user_id'];
    type = json['type'];
    currancyId = json['currancy_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['course_name'] = courseName;
    map['category_id'] = categoryId;
    map['course_des'] = courseDes;
    map['course_url'] = courseUrl;
    map['pre_requisition'] = preRequisition;
    map['gain'] = gain;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['teacher_id'] = teacherId;
    map['user_id'] = userId;
    map['type'] = type;
    map['currancy_id'] = currancyId;
    return map;
  }
}

class Category {
  Category({
    this.id,
    this.cateName,
    this.cateDes,
    this.cateUrl,
    this.createdAt,
    this.updatedAt,
    this.teacherId,
  });

  num? id;
  String? cateName;
  String? cateDes;
  String? cateUrl;
  String? createdAt;
  String? updatedAt;
  num? teacherId;

  Category.fromJson(dynamic json) {
    id = json['id'];
    cateName = json['cate_name'];
    cateDes = json['cate_des'];
    cateUrl = json['cate_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    teacherId = json['teacher_id'];
  }

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

class Pivot {
  Pivot({
    this.userId,
    this.courseId,
  });

  num? userId;
  num? courseId;

  Pivot.fromJson(dynamic json) {
    userId = json['user_id'];
    courseId = json['course_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['course_id'] = courseId;
    return map;
  }
}
