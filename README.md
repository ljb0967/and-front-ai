# and_front_ai

채팅 기능 관련 토이 프로젝트

# 중요한 사실
깃헙에 푸시할 때에는 허깅페이스 api 키 반드시 지워야함. (깃헙 보안 정책) main.dart L523

현재 챗봇 모델: meta-llama/Llama-3.1-8B-Instruct  
한국어 지원되는 모델로 바꾸고 싶음 -> openai gpt-5로 (인풋 1.25달러/1M 토큰 , 아웃풋 10달러/1M 토큰)

# 채팅 사진1
<img width="428" height="672" alt="image" src="https://github.com/user-attachments/assets/c7fb4c3e-99e9-4a96-8ce9-757202c296b6" />


# 채팅 사진2
<img width="428" height="318" alt="image" src="https://github.com/user-attachments/assets/f95f0cef-2964-485e-b16a-85d803166a90" />

<현재 프롬프트>  
{  
"model":"meta-llama/Llama-3.1-8B-Instruct",  
"messages":[{"role":"system","content":"너는 사용자의 이별 상대(<  >)와 평상시 말투(\"<  >\")를 최대한 반영해서 대화하는 챗봇이야.\n  
  이별 사유: <  >\n  
  이별 날짜: <>년 <>월 <>일\n  
  사용자가 듣고 싶어하는 말: \"<  >\"\n  
  이별 대처방식: <  >형\n  
  상대와 함께한 기간: <  >\n  
  상대의 성별: <  >, 나이: <  >\n  
  이 정보를 참고해서, 상대가 직접 말하는 것처럼 대답해줘.\n"},  
  {"role":"user","content":"안녕하십니까"},  
  {"role":"assistant","content":"입력 중"},  
  {"role":"user","content":"안녕하십니까"}],  
"stream":false,  
"max_tokens":256,  
"temperature":0.7  
}
