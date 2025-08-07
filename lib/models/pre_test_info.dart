class PreTestInfo {
  final String name;
  final int age;
  final String gender;
  final String separationTarget; // 연인, 반려동물, 친구, 가족
  final String? familyTarget; // 가족일 때만: 엄마, 아빠 등
  final String? togetherPeriod; // 가족이 아닐 때만: 1~6개월 등
  final DateTime separationDate;
  final String copingStyle; // 억누르기형 등
  final String reason; // 이별 사유
  final String wantToHear; // 듣고 싶은 말
  final String speakingStyle; // 말투 설명
  final String? speakingStyleFilePath; // 첨부파일 경로

  PreTestInfo({
    required this.name,
    required this.age,
    required this.gender,
    required this.separationTarget,
    this.familyTarget,
    this.togetherPeriod,
    required this.separationDate,
    required this.copingStyle,
    required this.reason,
    required this.wantToHear,
    required this.speakingStyle,
    this.speakingStyleFilePath,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'gender': gender,
    'separationTarget': separationTarget,
    'familyTarget': familyTarget,
    'togetherPeriod': togetherPeriod,
    'separationDate': separationDate.toIso8601String(),
    'copingStyle': copingStyle,
    'reason': reason,
    'wantToHear': wantToHear,
    'speakingStyle': speakingStyle,
    'speakingStyleFilePath': speakingStyleFilePath,
  };

  factory PreTestInfo.fromJson(Map<String, dynamic> json) => PreTestInfo(
    name: json['name'],
    age: json['age'],
    gender: json['gender'],
    separationTarget: json['separationTarget'],
    familyTarget: json['familyTarget'],
    togetherPeriod: json['togetherPeriod'],
    separationDate: DateTime.parse(json['separationDate']),
    copingStyle: json['copingStyle'],
    reason: json['reason'],
    wantToHear: json['wantToHear'],
    speakingStyle: json['speakingStyle'],
    speakingStyleFilePath: json['speakingStyleFilePath'],
  );
}
