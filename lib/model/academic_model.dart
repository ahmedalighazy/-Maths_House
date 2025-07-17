class AcademicModel {
  AcademicModel({
      this.coursesList, 
      this.myCourses,});

  AcademicModel.fromJson(dynamic json) {
    if (json['courses_list'] != null) {
      coursesList = [];
      json['courses_list'].forEach((v) {
        coursesList?.add(CoursesList.fromJson(v));
      });
    }
    if (json['my_courses'] != null) {
      myCourses = [];
      json['my_courses'].forEach((v) {
        myCourses?.add(MyCourses.fromJson(v));
      });
    }
  }
  List<CoursesList>? coursesList;
  List<MyCourses>? myCourses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (coursesList != null) {
      map['courses_list'] = coursesList?.map((v) => v.toJson()).toList();
    }
    if (myCourses != null) {
      map['my_courses'] = myCourses?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class MyCourses {
  MyCourses({
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
      this.pivot,});

  MyCourses.fromJson(dynamic json) {
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
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }
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
  Pivot? pivot;

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
    if (pivot != null) {
      map['pivot'] = pivot?.toJson();
    }
    return map;
  }

}

class Pivot {
  Pivot({
      this.userId, 
      this.courseId,});

  Pivot.fromJson(dynamic json) {
    userId = json['user_id'];
    courseId = json['course_id'];
  }
  num? userId;
  num? courseId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['course_id'] = courseId;
    return map;
  }

}

class CoursesList {
  CoursesList({
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
      this.currancyId,});

  CoursesList.fromJson(dynamic json) {
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