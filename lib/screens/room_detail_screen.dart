import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:step/constants.dart';
import 'package:step/models/announcement_model.dart';
import 'package:step/models/assessment_model.dart';
import 'package:step/models/assignment_model.dart';
import 'package:step/models/attendance_model.dart';
import 'package:step/models/material_model.dart';
import 'package:step/models/people_model.dart';
import 'package:step/models/response_model.dart';
import 'package:step/models/room_model.dart';
import 'package:step/palette.dart';
import 'package:step/screens/assignment_detail_screen.dart';
import 'package:step/screens/comment_screen.dart';
import 'package:step/screens/login_screen.dart';
import 'package:step/services/announcement_service.dart';
import 'package:step/services/assessment_service.dart';
import 'package:step/services/assignment_service.dart';
import 'package:step/services/attendance_service.dart';
import 'package:step/services/material_service.dart';
import 'package:step/services/people_servide.dart';
import 'package:step/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;

  RoomDetailScreen({required this.room});

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  List<dynamic> _announcementsList = [];
  List<dynamic> _assessmentsList = [];
  List<dynamic> _materialsList = [];
  List<dynamic> _assignmentsList = [];
  List<dynamic> _peopleList = [];
  List<dynamic> _attendancesList = [];
  bool _loading = true;
  int userId = 0;
  int _currentIndex = 0;

  // Get Announcements
  Future<void> _getAnnouncements() async {
    userId = await getUserId();
    ApiResponse response = await getAnnouncements(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _announcementsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then(
        (value) => {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
          ),
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Get Assessments
  Future<void> _getAssessments() async {
    userId = await getUserId();
    ApiResponse response = await getAssessments(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _assessmentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then(
        (value) => {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
          ),
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Get Materials
  Future<void> _getMaterials() async {
    userId = await getUserId();
    ApiResponse response = await getMaterials(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _materialsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then(
        (value) => {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
          ),
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Get Assignments
  Future<void> _getAssignments() async {
    userId = await getUserId();
    ApiResponse response = await getAssignments(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _assignmentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then(
        (value) => {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
          ),
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Get People
  Future<void> _getPeople() async {
    userId = await getUserId();
    ApiResponse response = await getPeople(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _peopleList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then(
        (value) => {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
          ),
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Get Attendances
  Future<void> _getAttendances() async {
    userId = await getUserId();
    ApiResponse response = await getAttendances(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _attendancesList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then(
        (value) => {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
          ),
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  googleMeet() async {
    final url = widget.room.vclink ?? 'https://meet.google.com/';
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    _getAnnouncements();
    _getAssessments();
    _getMaterials();
    _getAssignments();
    _getPeople();
    _getAttendances();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name!),
        foregroundColor: Palette.kToDark,
        actions: [
          IconButton(icon: Icon(Icons.videocam), onPressed: () => googleMeet()),
        ],
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: Column(children: [Expanded(child: _buildBody())]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Palette.kToDark,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        iconSize: 28,
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Assessments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Materials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'People'),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'Attendance',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildAnnouncements();
      case 1:
        return _buildAssessments();
      case 2:
        return _buildMaterials();
      case 3:
        return _buildAssignments();
      case 4:
        return _buildPeople();
      case 5:
        return _buildAttendances();
      default:
        return Container();
    }
  }

  Widget _buildAnnouncements() {
    return RefreshIndicator(
      onRefresh: () {
        return _getAnnouncements();
      },
      child: _announcementsList.isEmpty
          ? Center(child: Text('No Announcements'))
          : ListView.builder(
              itemCount: _announcementsList.length,
              itemBuilder: (BuildContext context, int index) {
                Announcement announcement = _announcementsList[index];
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    announcement.user!.avatar!,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${announcement.user!.name}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat.yMMMMd().format(
                                        DateTime.parse(announcement.created!),
                                      ),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (announcement.title != null)
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          margin: EdgeInsets.only(
                            left: 20,
                            top: 15,
                            bottom: 10,
                          ),
                          child: Text(
                            (announcement.title)!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Html(
                          data: announcement.body ?? 'N/A',
                          style: {'body': Style(fontSize: FontSize(10))},
                        ),
                      ),
                      if (announcement.file != null)
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: InkWell(
                            onTap: () async {
                              final assessmentLink = Uri.parse(
                                '${announcement.file}',
                              );
                              if (await canLaunchUrl(assessmentLink)) {
                                await launchUrl(assessmentLink);
                              } else {
                                print('Could not launch $assessmentLink');
                              }
                            },
                            child: Text(
                              'see attachment',
                              style: TextStyle(
                                fontSize: 10,
                                color: Palette.kToDark,
                              ),
                            ),
                          ),
                        ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                announcementID: announcement.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          height: 40,
                          width: MediaQuery.of(context).size.width - 30,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            '${announcement.commentCount ?? 'No Class Comment'} Class Comment',
                            style: TextStyle(
                              fontSize: 10,
                              color: Palette.kToDark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAssessments() {
    return RefreshIndicator(
      onRefresh: () {
        return _getAssessments();
      },
      child: _assessmentsList.isEmpty
          ? Center(child: Text('No Assessments'))
          : ListView.builder(
              itemCount: _assessmentsList.length,
              itemBuilder: (BuildContext context, int index) {
                Assessment assessment = _assessmentsList[index];
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    onTap: () async {
                      final assessmentLink = Uri.parse(
                        'https://udd.steps.com.ph/classwork/student/assessment/${assessment.id}',
                      ); // Replace with your assessment URL
                      if (await canLaunchUrl(assessmentLink)) {
                        await launchUrl(assessmentLink);
                      } else {
                        // Handle error if the URL cannot be launched
                        print('Could not launch $assessmentLink');
                      }
                    },
                    title: Text(
                      '${assessment.title}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${assessment.startDate} - ${assessment.endDate} ',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          '${assessment.status}',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMaterials() {
    return RefreshIndicator(
      onRefresh: () => _getMaterials(),
      child: _materialsList.isEmpty
          ? Center(child: Text('No Materials'))
          : ListView.builder(
              itemCount: _materialsList.length,
              itemBuilder: (context, index) {
                Materials material = _materialsList[index];
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    onTap: () => downloadFile(material.url!),
                    title: Text(
                      '${material.title}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${material.description}',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAssignments() {
    return RefreshIndicator(
      onRefresh: () => _getAssignments(),
      child: _assignmentsList.isEmpty
          ? Center(child: Text('No Assignments'))
          : ListView.builder(
              itemCount: _assignmentsList.length,
              itemBuilder: (context, index) {
                Assignment assignment = _assignmentsList[index];
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AssignmentDetailScreen(assignment: assignment),
                      ),
                    ),
                    title: Text(
                      '${assignment.title}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd().format(
                        DateTime.parse(assignment.due!),
                      ),
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPeople() {
    return RefreshIndicator(
      onRefresh: () {
        return _getPeople();
      },
      child: _peopleList.isEmpty
          ? Center(child: Text('No People'))
          : ListView.builder(
              itemCount: _peopleList.length,
              itemBuilder: (BuildContext context, int index) {
                People people = _peopleList[index];
                if (people.staff != null) {
                  return _buildStaffRow(people.staff!);
                } else if (people.student != null) {
                  return _buildStudentRow(people.student!);
                }
                return null; // return an empty widget instead of null
              },
            ),
    );
  }

  Widget _buildStaffRow(Staff staff) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          '${staff.name}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Faculty',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildStudentRow(Student student) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          '${student.name}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Student',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildAttendances() {
    return RefreshIndicator(
      onRefresh: () {
        return _getAttendances();
      },
      child: _attendancesList.isEmpty
          ? Center(child: Text('No Attendances'))
          : ListView.builder(
              itemCount: _attendancesList.length,
              itemBuilder: (BuildContext context, int index) {
                Attendance attendance = _attendancesList[index];
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      '${attendance.description}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd().format(
                        DateTime.parse(attendance.date ?? ''),
                      ),
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        attend(attendance.id ?? 0).then((response) {
                          if (response.error == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${response.data}')),
                            );
                          } else if (response.error == unauthorized) {
                            logout().then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                                (route) => false,
                              );
                            });
                          } else {
                            setState(() {
                              _loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${response.error}')),
                            );
                          }
                        });
                      },
                      child: Text('Attend'),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> downloadFile(String url) async {
    // Check if permission is granted
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      // Request permission
      await Permission.storage.request();
    }
    try {
      var request = await http.get(Uri.parse(url));
      var bytes = request.bodyBytes;
      String fileName = url.split('/').last;
      String dir = '/storage/emulated/0/Download';
      File file = File('$dir/$fileName');
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${fileName} Downloaded Successfully')),
      );
    } catch (e) {
      print(e);
    }
  }
}
