class PaymantHistoryModel {
  PaymantHistoryModel({
      this.chapters,});

  PaymantHistoryModel.fromJson(dynamic json) {
    if (json['chapters'] != null) {
      chapters = [];
      json['chapters'].forEach((v) {
        chapters?.add(Chapters.fromJson(v));
      });
    }
  }
  List<Chapters>? chapters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (chapters != null) {
      map['chapters'] = chapters?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Chapters {
  Chapters({
      this.id, 
      this.chapterName, 
      this.courseId, 
      this.currancyId, 
      this.chDes, 
      this.chUrl, 
      this.preRequisition, 
      this.gain, 
      this.teacherId, 
      this.createdAt, 
      this.updatedAt, 
      this.type, 
      this.chapter, 
      this.teacher, 
      this.course,});

  Chapters.fromJson(dynamic json) {
    id = json['id'];
    chapterName = json['chapter_name'];
    courseId = json['course_id'];
    currancyId = json['currancy_id'];
    chDes = json['ch_des'];
    chUrl = json['ch_url'];
    preRequisition = json['pre_requisition'];
    gain = json['gain'];
    teacherId = json['teacher_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    chapter = json['chapter'];
    teacher = json['teacher'];
    course = json['course'] != null ? Course.fromJson(json['course']) : null;
  }
  num? id;
  String? chapterName;
  num? courseId;
  num? currancyId;
  String? chDes;
  String? chUrl;
  String? preRequisition;
  String? gain;
  num? teacherId;
  String? createdAt;
  String? updatedAt;
  String? type;
  String? chapter;
  dynamic teacher;
  Course? course;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['chapter_name'] = chapterName;
    map['course_id'] = courseId;
    map['currancy_id'] = currancyId;
    map['ch_des'] = chDes;
    map['ch_url'] = chUrl;
    map['pre_requisition'] = preRequisition;
    map['gain'] = gain;
    map['teacher_id'] = teacherId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['type'] = type;
    map['chapter'] = chapter;
    map['teacher'] = teacher;
    if (course != null) {
      map['course'] = course?.toJson();
    }
    return map;
  }

}

class Course {
  Course({
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

  Course.fromJson(dynamic json) {
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