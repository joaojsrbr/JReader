class FromJson {
  Data? data;

  FromJson({this.data});

  FromJson.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Chapters {
  String? id;
  List<String>? images;
  Project? project;

  Chapters({this.id, this.images, this.project});

  Chapters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    images = json['images'].cast<String>();
    project =
        json['project'] != null ? Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['images'] = images;
    if (project != null) {
      data['project'] = project!.toJson();
    }
    return data;
  }
}

class Data {
  GetProjects? getProjects;
  Project? project;
  Data({this.getProjects, this.project});

  Data.fromJson(Map<String, dynamic> json) {
    project =
        json['project'] != null ? Project.fromJson(json['project']) : null;
    getProjects = json['getProjects'] != null
        ? GetProjects.fromJson(json['getProjects'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getProjects != null) {
      data['getProjects'] = getProjects!.toJson();
    }
    if (project != null) {
      data['project'] = project!.toJson();
    }
    return data;
  }
}

class GetProjects {
  List<Projects>? projects;
  int? count;
  int? currentPage;
  int? limit;
  int? totalPages;

  GetProjects(
      {this.projects,
      this.count,
      this.currentPage,
      this.limit,
      this.totalPages});

  GetProjects.fromJson(Map<String, dynamic> json) {
    if (json['projects'] != null) {
      projects = <Projects>[];
      json['projects'].forEach((v) {
        projects!.add(Projects.fromJson(v));
      });
    }
    count = json['count'];
    currentPage = json['currentPage'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (projects != null) {
      data['projects'] = projects!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['currentPage'] = currentPage;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    return data;
  }
}

class Projects {
  int? id;
  String? updateAt;
  String? name;
  String? cover;
  String? description;
  String? type;
  List<GetChapters>? getChapters;

  Projects(
      {this.id,
      this.updateAt,
      this.name,
      this.cover,
      this.description,
      this.type,
      this.getChapters});

  Projects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    updateAt = json['updateAt'];
    name = json['name'];
    cover = json['cover'];
    description = json['description'];
    type = json['type'];
    if (json['getChapters'] != null) {
      getChapters = <GetChapters>[];
      json['getChapters'].forEach((v) {
        getChapters!.add(GetChapters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['updateAt'] = updateAt;
    data['name'] = name;
    data['cover'] = cover;
    data['description'] = description;
    data['type'] = type;
    if (getChapters != null) {
      data['getChapters'] = getChapters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetChapters {
  String? id;
  List<String>? images;
  String? title;
  int? number;

  GetChapters({this.id, this.images, this.title, this.number});

  GetChapters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    images = json['images'].cast<String>();
    title = json['title'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['images'] = images;
    data['title'] = title;
    data['number'] = number;
    return data;
  }
}

class Project {
  int? id;
  String? name;
  String? type;
  String? description;
  List<String>? authors;
  String? cover;
  List<GetChapters2>? getChapters;
  List<GetTags>? getTags;

  Project(
      {this.id,
      this.name,
      this.type,
      this.description,
      this.authors,
      this.cover,
      this.getChapters,
      this.getTags});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    description = json['description'];
    authors = json['authors'].cast<String>();
    cover = json['cover'];
    if (json['getChapters'] != null) {
      getChapters = <GetChapters2>[];
      json['getChapters'].forEach((v) {
        getChapters!.add(GetChapters2.fromJson(v));
      });
    }
    if (json['getTags'] != null) {
      getTags = <GetTags>[];
      json['getTags'].forEach((v) {
        getTags!.add(GetTags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['description'] = description;
    data['authors'] = authors;
    data['cover'] = cover;
    if (getChapters != null) {
      data['getChapters'] = getChapters!.map((v) => v.toJson()).toList();
    }
    if (getTags != null) {
      data['getTags'] = getTags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetChapters2 {
  String? id;
  int? number;
  String? title;
  String? createAt;

  GetChapters2({this.id, this.number, this.title, this.createAt});

  GetChapters2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    title = json['title'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['number'] = number;
    data['title'] = title;
    data['createAt'] = createAt;
    return data;
  }
}

class GetTags {
  int? id;
  String? name;

  GetTags({this.id, this.name});

  GetTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
