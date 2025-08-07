import 'package:flutter/material.dart';
import 'models/pre_test_info.dart';
import 'dart:io';
import 'package:http/http.dart'
    as http; // http 패키지 필요: pubspec.yaml에 http: ^0.13.0 이상 추가
import 'dart:convert';
import 'dart:async'; // Timer 패키지 필요

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const PreTestFormPage(),
    );
  }
}

class PreTestFormPage extends StatefulWidget {
  const PreTestFormPage({super.key});

  @override
  State<PreTestFormPage> createState() => _PreTestFormPageState();
}

class _PreTestFormPageState extends State<PreTestFormPage> {
  int _step = 0;
  final _formKey = GlobalKey<FormState>();

  // 입력값 상태
  String? _name;
  int? _age;
  String? _gender;
  String? _separationTarget;
  String? _familyTarget;
  String? _togetherPeriod;
  DateTime? _separationDate;
  String? _copingStyle;
  String? _reason;
  String? _wantToHear;
  String? _speakingStyle;
  String? _speakingStyleFilePath;

  // 성별, 이별상대, 대처방안, 이별사유 등 선택지
  final List<String> _genders = ['남성', '여성', '기타'];
  final List<String> _separationTargets = ['연인', '반려동물', '친구', '가족'];
  final List<String> _familyTargets = [
    '엄마',
    '아빠',
    '아들',
    '딸',
    '여자형제',
    '남자형제',
    '조부모님',
  ];
  final List<String> _togetherPeriods = [
    '1~6개월',
    '6개월~1년',
    '1~2년',
    '2~5년',
    '5~10년',
    '10년~',
  ];
  final List<String> _copingStyles = ['억누르기형', '표출형', '회피형', '분석형'];
  final Map<String, List<String>> _reasons = {
    '연인': [
      '상대의 마음이 식었어요',
      '내가 마음이 떠났어요',
      '성격, 가치관 차이',
      '바람이나 배신',
      '상황/환경 문제',
      '정확히 모르겠어요 / 복합적이에요',
    ],
    '반려동물': [
      '자연사 (노화)',
      '질병/사고로 인한 갑작스러운 죽음',
      '안락사 결정',
      '실종',
      '정확히 모르겠어요 / 복합적이에요',
    ],
    '친구': [
      '큰 싸움으로 인한 연락 두절',
      '갑작스러운 차단 / 멀어짐',
      '자연스러운 멀어짐',
      '친구에게 상처를 받음',
      '복합적 / 설명하기 어려워요',
      '정확히 모르겠어요 / 복합적이에요',
    ],
    '가족': [
      '사망(자연사)',
      '사망(사고사/급작스러운 상실)',
      '관계 단절',
      '이혼/가족 구조 해체',
      '장기적 거리감 (연락두절, 이민, 실종 등)',
      '정확히 모르겠어요 / 복합적이에요',
    ],
  };

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _step++;
      });
    }
  }

  void _prevStep() {
    setState(() {
      if (_step > 0) _step--;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _separationDate ?? now,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _separationDate = picked;
      });
    }
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        // 1. 이름, 나이, 성별
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: '이름'),
                validator: (v) => v == null || v.isEmpty ? '이름을 입력하세요' : null,
                onSaved: (v) => _name = v,
                initialValue: _name,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '나이'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return '나이를 입력하세요';
                  final n = int.tryParse(v);
                  if (n == null || n < 0) return '유효한 나이를 입력하세요';
                  return null;
                },
                onSaved: (v) => _age = int.tryParse(v ?? ''),
                initialValue: _age?.toString(),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '성별'),
                value: _gender,
                items: _genders
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                validator: (v) => v == null ? '성별을 선택하세요' : null,
                onChanged: (v) => setState(() => _gender = v),
                onSaved: (v) => _gender = v,
              ),
            ],
          ),
        );
      case 1:
        // 2. 이별상대
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '이별 상대'),
                value: _separationTarget,
                items: _separationTargets
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                validator: (v) => v == null ? '이별 상대를 선택하세요' : null,
                onChanged: (v) => setState(() {
                  _separationTarget = v;
                  _familyTarget = null;
                  _togetherPeriod = null;
                  _reason = null;
                }),
                onSaved: (v) => _separationTarget = v,
              ),
            ],
          ),
        );
      case 2:
        // 3. 가족상세 or 함께한 기간
        if (_separationTarget == '가족') {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: '가족 상대'),
                  value: _familyTarget,
                  items: _familyTargets
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  validator: (v) => v == null ? '가족 상대를 선택하세요' : null,
                  onChanged: (v) => setState(() => _familyTarget = v),
                  onSaved: (v) => _familyTarget = v,
                ),
              ],
            ),
          );
        } else {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: '함께 한 기간'),
                  value: _togetherPeriod,
                  items: _togetherPeriods
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  validator: (v) => v == null ? '함께 한 기간을 선택하세요' : null,
                  onChanged: (v) => setState(() => _togetherPeriod = v),
                  onSaved: (v) => _togetherPeriod = v,
                ),
              ],
            ),
          );
        }
      case 3:
        // 4. 이별 날짜
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _separationDate == null
                  ? '이별 날짜를 선택하세요'
                  : '이별 날짜: ${_separationDate!.year}년 ${_separationDate!.month}월 ${_separationDate!.day}일',
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _pickDate, child: const Text('날짜 선택')),
          ],
        );
      case 4:
        // 5. 이별 대처방안
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '이별 대처방안'),
                value: _copingStyle,
                items: _copingStyles
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                validator: (v) => v == null ? '대처방안을 선택하세요' : null,
                onChanged: (v) => setState(() => _copingStyle = v),
                onSaved: (v) => _copingStyle = v,
              ),
            ],
          ),
        );
      case 5:
        // 6. 이별 사유
        final reasons = _separationTarget != null
            ? _reasons[_separationTarget!] ?? <String>[]
            : <String>[];
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '이별 사유'),
                value: _reason,
                items: reasons
                    .map(
                      (r) => DropdownMenuItem<String>(value: r, child: Text(r)),
                    )
                    .toList(),
                validator: (v) => v == null ? '이별 사유를 선택하세요' : null,
                onChanged: (v) => setState(() => _reason = v),
                onSaved: (v) => _reason = v,
              ),
            ],
          ),
        );
      case 6:
        // 7. 듣고 싶은 말
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: '상대에게 듣고 싶은 말'),
                validator: (v) => v == null || v.isEmpty ? '입력하세요' : null,
                onSaved: (v) => _wantToHear = v,
                initialValue: _wantToHear,
              ),
            ],
          ),
        );
      case 7:
        // 8. 말투 설명/첨부
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: '상대의 평상시 말투(설명)'),
                validator: (v) => v == null || v.isEmpty ? '입력하세요' : null,
                onSaved: (v) => _speakingStyle = v,
                initialValue: _speakingStyle,
              ),
              // 첨부파일은 실제 파일 업로드 대신 파일 경로 입력으로 대체(토이 프로젝트)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '카톡 내역 등 첨부파일 경로(선택)',
                ),
                onSaved: (v) => _speakingStyleFilePath = v,
                initialValue: _speakingStyleFilePath,
              ),
            ],
          ),
        );
      default:
        return const Center(child: Text('완료'));
    }
  }

  void _onNext() {
    if (_step == 3) {
      // 날짜는 별도 검증
      if (_separationDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('이별 날짜를 선택하세요')));
        return;
      }
      setState(() => _step++);
      return;
    }
    if (_step == 8) {
      // 모든 입력 완료, PreTestInfo 생성
      final info = PreTestInfo(
        name: _name!,
        age: _age!,
        gender: _gender!,
        separationTarget: _separationTarget!,
        familyTarget: _familyTarget,
        togetherPeriod: _togetherPeriod,
        separationDate: _separationDate!,
        copingStyle: _copingStyle!,
        reason: _reason!,
        wantToHear: _wantToHear!,
        speakingStyle: _speakingStyle!,
        speakingStyleFilePath: _speakingStyleFilePath,
      );
      // 입력 완료 시 홈 화면으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage(preTestInfo: info)),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _step++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사전테스트 입력')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildStep()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_step > 0 && _step < 8)
                  ElevatedButton(onPressed: _prevStep, child: const Text('이전')),
                ElevatedButton(
                  onPressed: _onNext,
                  child: Text(_step == 7 ? '완료' : '다음'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final PreTestInfo preTestInfo;
  const ChatPage({super.key, required this.preTestInfo});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _isTyping = false;
  int _typingDotCount = 0;
  Timer? _typingTimer;

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  void _startTypingAnimation() {
    _isTyping = true;
    _typingDotCount = 0;
    _messages.add({'role': 'assistant', 'content': '입력 중'});
    _typingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _typingDotCount = (_typingDotCount + 1) % 4;
        final dots = '.' * _typingDotCount;
        final idx = _messages.lastIndexWhere(
          (m) => m['role'] == 'assistant' && m['content']!.startsWith('입력 중'),
        );
        if (idx != -1) {
          _messages[idx]['content'] = '입력 중$dots';
        }
      });
    });
  }

  void _stopTypingAnimation() {
    _isTyping = false;
    _typingTimer?.cancel();
    _messages.removeWhere(
      (m) => m['role'] == 'assistant' && m['content']!.startsWith('입력 중'),
    );
  }

  String _buildSystemPrompt() {
    final info = widget.preTestInfo;
    final buffer = StringBuffer();
    buffer.writeln(
      '너는 사용자의 이별 상대(${info.separationTarget}${info.separationTarget == '가족' ? ' - ${info.familyTarget}' : ''})와 평상시 말투("${info.speakingStyle}")를 최대한 반영해서 대화하는 챗봇이야.',
    );
    buffer.writeln('이별 사유: ${info.reason}');
    buffer.writeln(
      '이별 날짜: ${info.separationDate.year}년 ${info.separationDate.month}월 ${info.separationDate.day}일',
    );
    buffer.writeln('사용자가 듣고 싶어하는 말: "${info.wantToHear}"');
    buffer.writeln('이별 대처방식: ${info.copingStyle}');
    buffer.writeln('상대와 함께한 기간: ${info.togetherPeriod ?? '-'}');
    buffer.writeln('상대의 성별: ${info.gender}, 나이: ${info.age}');
    buffer.writeln('이 정보를 참고해서, 상대가 직접 말하는 것처럼 대답해줘.');
    return buffer.toString();
  }

  Future<String> _fetchBotReply(String userMessage) async {
    final systemPrompt = _buildSystemPrompt();
    final url = Uri.parse('https://router.huggingface.co/v1/chat/completions');
    final body = jsonEncode({
      'model': 'meta-llama/Llama-3.1-8B-Instruct',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ..._messages.map((m) => {'role': m['role'], 'content': m['content']}),
        {'role': 'user', 'content': userMessage},
      ],
      'stream': false,
      'max_tokens': 256,
      'temperature': 0.7,
    });
    print('system 프롬프트: $systemPrompt');
    print('프롬프트(요청 body): $body');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer <api key>',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['choices'] != null && data['choices'].isNotEmpty) {
        return data['choices'][0]['message']['content']?.toString().trim() ??
            '챗봇 응답을 가져오지 못했습니다.';
      }
    }
    return '챗봇 응답을 가져오지 못했습니다.';
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _controller.clear();
      _isLoading = true;
    });
    _startTypingAnimation();
    String reply;
    try {
      reply = await _fetchBotReply(text);
    } catch (e) {
      reply = '챗봇 응답을 가져오지 못했습니다.';
    }
    setState(() {
      _stopTypingAnimation();
      _messages.add({'role': 'assistant', 'content': reply});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('챗봇과 대화하기')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final msg = _messages[idx];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(msg['content'] ?? ''),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(hintText: '메시지를 입력하세요'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final PreTestInfo preTestInfo;
  const HomePage({super.key, required this.preTestInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChatPage(preTestInfo: preTestInfo),
              ),
            );
          },
          child: const Text('채팅 시작'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
