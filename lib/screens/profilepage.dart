import 'package:flutter/material.dart';

class ProfilePage1 extends StatelessWidget {
  const ProfilePage1({super.key});
  static const String path = '/profile';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            "Full name : ",
                            style: TextStyle(
                              fontFamily: 'CustomIcons',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Richie Lorie",
                            style: TextStyle(
                              fontFamily: 'CustomIcons',
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            "Email : ",
                            style: TextStyle(
                              fontFamily: 'CustomIcons',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "richie.lorie@example.com",
                            style: TextStyle(
                              fontFamily: 'CustomIcons',
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            "Role : ",
                            style: TextStyle(
                              fontFamily: 'CustomIcons',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Administrator",
                            style: TextStyle(
                              fontFamily: 'CustomIcons',
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            "City : ",
                            style: TextStyle(
                              fontFamily: 'CustomIcons',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Agadir",
                            style: TextStyle(
                              fontFamily: 'CustomIcons',
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'data:image/png;base64,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',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://hrmasia.com/wp-content/uploads/2022/04/81617901_m.jpg',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
