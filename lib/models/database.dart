import 'package:mz_flutter_07/controllers/dbcontroller.dart';
import 'package:mz_flutter_07/controllers/maincontroller.dart';

class DB {
  static List versioninfotable = [];
  static List userinfotable = [];

  static List allofficeinfotable = [];
  static List allremindinfotable = [];
  static List allusersinfotable = [];
  static List logstable = [];
  static String? error;

  List queries = [
    '''
create table if not exists version
(
v_id int(11) unique primary key auto_increment,
version varchar(255),
android varchar(255),
windows varchar(255),
web varchar(255),
skip tinyint(1) default 0
);
''',
    '''
insert into version (v_id,version,android,windows,web,skip)values(1,'v_1.0.1',null,null,'http://192.168.30.8',0);
''',
    '''
create table if not exists users
(
user_id int(11) unique primary key auto_increment,
username varchar(255) unique,
fullname varchar(255) unique,
password varchar(255),
email varchar(255),
mobile varchar(255),
personalimg MediumBLOB
);
''',
    '''
create table if not exists offices
(
office_id int(11) unique primary key auto_increment,
officename varchar(255) unique,
chatid varchar(255),
apitoken varchar(255),
notifi tinyint(1) default 0
);
''',
    '''
create table if not exists users_privileges
(
up_id int(11) unique primary key auto_increment,
up_user_id int(11),
foreign key (up_user_id) references users(user_id),
admin tinyint(1) default 0,
enable tinyint(1) default 1,
mustchgpass tinyint(1) default 1,
pbx tinyint(1) default 0
);
''',
    '''
create table if not exists users_priv_office
(
upo_id int(11) unique primary key auto_increment,
upo_user_id int(11),
foreign key (upo_user_id) references users(user_id),
upo_office_id int(11),
foreign key (upo_office_id) references offices(office_id),
position varchar(225),
addtask tinyint(1) default 0,
showalltasks tinyint(1) default 0,
addping tinyint(1) default 0,
showallpings tinyint(1) default 0,
addcost tinyint(1) default 0,
showallcosts tinyint(1) default 0,
acceptcosts tinyint(1) default 0,
addtodo tinyint(1) default 0,
showalltodos tinyint(1) default 0,
addremind tinyint(1) default 0,
showallreminds tinyint(1) default 0,
addemailtest tinyint(1) default 0,
showallemailtests tinyint(1) default 0,
addhyperlink tinyint(1) default 0,
showallhyperlinks tinyint(1) default 0
);
''',
    '''
create table if not exists tasks
(
task_id int(11) unique primary key auto_increment,
taskname varchar(255) unique,
taskdetails varchar(255),
duration int(11),
extratime int(11) default 0,
status tinyint(1),
donedate TIMESTAMP NULL DEFAULT NULL,
notifi tinyint(1) default 1,
createby_id int(11),
foreign key (createby_id) references users(user_id),
createdate TIMESTAMP NULL DEFAULT NULL,
editby_id int(11),
foreign key (editby_id) references users(user_id),
editdate TIMESTAMP NULL DEFAULT NULL,
task_office_id int(11),
foreign key (task_office_id) references offices(office_id)
);
''',
    '''
create table if not exists users_tasks
(
ut_id int(11) unique primary key auto_increment,
ut_user_id int(11),
foreign key (ut_user_id) references users(user_id),
ut_task_id int(11),
foreign key (ut_task_id) references tasks(task_id)
);
''',
    '''
create table if not exists todo
(
todo_id int(11) unique primary key auto_increment,
todoname varchar(255) unique,
tododetails varchar(255),
createby_id int(11),
foreign key (createby_id) references users(user_id),
createdate TIMESTAMP NULL DEFAULT NULL,
editby_id int(11),
foreign key (editby_id) references users(user_id),
editdate TIMESTAMP NULL DEFAULT NULL,
todo_office_id int(11),
foreign key (todo_office_id) references offices(office_id)
);
''',
    '''
create table if not exists remind
(
remind_id int(11) unique primary key auto_increment,
remindname varchar(255) unique,
reminddetails varchar(255),
sendalertbefor int(11),
repeate int(11),
notifi tinyint(1) default 1,
certsrc varchar(255),
remind_office_id int(11),
type varchar(20),
foreign key (remind_office_id) references offices(office_id),
reminddate TIMESTAMP NULL DEFAULT NULL,
createby_id int(11),
foreign key (createby_id) references users(user_id),
createdate TIMESTAMP NULL DEFAULT NULL,
editby_id int(11),
foreign key (editby_id) references users(user_id),
editdate TIMESTAMP NULL DEFAULT NULL,
lastsend TIMESTAMP NULL DEFAULT NULL
);
''',
    '''
create table if not exists reminddates
(
reminddates_id int(11) unique primary key auto_increment,
rdate TIMESTAMP NULL DEFAULT NULL,
remind_d_id int(11),
foreign key (remind_d_id) references remind(remind_id)
);
    ''',
    '''
    create table if not exists dailysend
(
  dailysend remind tinyint(1) default 0
)''',
    '''
create table if not exists notification
(
notifi_id int(11) unique primary key auto_increment,
notifi varchar(255),
notifireaded tinyint(1)
);
    ''',
    '''
create table if not exists comments
(
uc_id int(11) unique primary key auto_increment,
uc_user_id int(11),
foreign key (uc_user_id) references users(user_id),
comments varchar(255),
commentdate TIMESTAMP  NULL DEFAULT NULL,
t_name varchar(255),
t_type varchar(255),
idtype int(11)
);
''',
    '''
create table if not exists logs
(
log_id int(11) unique primary key auto_increment,
log varchar(255),
logdate TIMESTAMP  NULL DEFAULT NULL
);
''',
    '''
create table if not exists chat
(
chat_id int(11) unique primary key auto_increment,
sender_id int(11),
foreign key (sender_id) references users(user_id),
reciever_id int(11),
foreign key (reciever_id) references users(user_id),
msg varchar(255),
readstatus tinyint(1)
);
''',
    '''
create table if not exists costs
(
cost_id int(11) unique primary key auto_increment,
costname varchar(255) unique,
costdetails varchar(255),
cost varchar(255),
attach_n varchar(255),
attch_file MediumBLOB,
costdate TIMESTAMP NULL DEFAULT NULL,
begin_acceptcost tinyint(1),
final_acceptcost tinyint(1),
cost_status tinyint(1),
cost_user_id int(11),
foreign key (cost_user_id) references users(user_id),
cost_office_id int(11),
foreign key (cost_office_id) references offices(office_id)
);
''',
    '''
insert into users(user_id,username,fullname,password)values(1,'admin','Admin','${MainController().codepassword(word: 'admin')}');
''',
    '''
insert into users_privileges(up_id,up_user_id,admin)values(1,1,1);
'''
  ];
  createtables() async {
    // ignore: prefer_typing_uninitialized_variables
    var t;
    error = null;
    for (var i in queries) {
      t = await DBController()
          .requestpost(type: 'curd', data: {'customquery': '$i'});
      if (t['status'] != 'done') {
        error = t['status'];
      }
    }
  }
}
