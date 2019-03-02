import processing.serial.*;
import java.util.List;
import java.util.ArrayList;

Serial myPort;

final int    LEAST_SEND_INTERVAL_MIN = 60;                      // 前回のsendから最低限空ける分数
final int    HUMIDITY_SHOULD_SEND    = 60;                      // 通達すべき湿度の閾値
final String PORT                    = "/dev/tty.usbmodem1441";
final int    BAUDRATE                = 115200;

String       sh_path;
String       json_path;
int          humidity;
int          passed_sec = 0;
boolean      can_send   = true;  // sendできるタイミングかどうか
List<String> line_ids   = new ArrayList<String>();

StringList strout = new StringList(); //出力が入る変数
StringList strerr = new StringList(); //エラーが入る変数

void setup() {
  sh_path = sketchPath() + "/../../push.sh";
  json_path = sketchPath() + "/../../push.json";
  line_ids.add("U919dce0b60793448d540e122a9afc6b4"); // ひろLineId
  line_ids.add("U0df659fa47b607f89ffb0837b2ef6580"); // ゆかLineId
  myPort = new Serial(this, PORT, BAUDRATE);
  myPort.clear();
}

void draw(){
  if(can_send == false){
    passed_sec++;
    if(passed_sec >= LEAST_SEND_INTERVAL_MIN * 60){
      can_send = true;
    }
  }
  
  if(can_send == true && humidity >= HUMIDITY_SHOULD_SEND){
    System.out.println(humidity);
    makeJSON();
    shell(strout, strerr, sh_path);
    can_send = false;
    passed_sec = 0;
  }
  
  delay(1000);
}

void serialEvent(Serial myPort){
  humidity = myPort.read();
}

void makeJSON(){
  JSONObject output = new JSONObject();
  
  JSONArray to = new JSONArray();
  for(String line_id : line_ids){
    to.append(line_id); 
  }
  output.setJSONArray("to", to);

  JSONArray messages = new JSONArray();
  JSONObject message1 = new JSONObject();
  message1.setString("type", "text");
  message1.setString("text", "現在の湿度は" + humidity + "%です");
  messages.append(message1);
  output.setJSONArray("messages", messages);

  saveJSONObject(output, json_path);
}
