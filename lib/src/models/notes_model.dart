class NotesModel {
  String? _userUid;
  String? _title;
  String? _content;
  String? _date;

  NotesModel({String? userUid, String? title, String? content, String? date}) {
    if (userUid != null) {
      this._userUid = userUid;
    }
    if (title != null) {
      this._title = title;
    }
    if (content != null) {
      this._content = content;
    }
    if (date != null) {
      this._date = date;
    }
  }

  String? get userUid => _userUid;
  set userUid(String? userUid) => _userUid = userUid;
  String? get title => _title;
  set title(String? title) => _title = title;
  String? get content => _content;
  set content(String? content) => _content = content;
  String? get date => _date;
  set date(String? date) => _date = date;

  NotesModel.fromJson(Map<String, dynamic> json) {
    _userUid = json['user_uid'];
    _title = json['title'];
    _content = json['content'];
    _date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_uid'] = this._userUid;
    data['title'] = this._title;
    data['content'] = this._content;
    data['date'] = this._date;
    return data;
  }
}
