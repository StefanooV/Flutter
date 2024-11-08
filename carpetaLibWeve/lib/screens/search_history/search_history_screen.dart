import 'package:flutter/material.dart';

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Historial de busqueda",
          style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500,
              fontSize: 22),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Busquedas recientes",
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          fontSize: 22)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.history_outlined,
                          ),
                          iconColor: Colors.black,
                          title: Text("Bv. Geronimo Benavides 1665"),
                          subtitle: Text("14/03/2022 • 22:15"),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.history_outlined,
                          ),
                          iconColor: Colors.black,
                          title: Text("Av. Martín Perez Disalvo"),
                          subtitle: Text("21/09/2021 • 14:03"),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.history_outlined,
                          ),
                          iconColor: Colors.black,
                          title: Text("Bv. Geronimo Benavides 1665"),
                          subtitle: Text("14/03/2022 • 22:15"),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.history_outlined,
                          ),
                          iconColor: Colors.black,
                          title: Text("Av. Martín Perez Disalvo"),
                          subtitle: Text("21/09/2021 • 14:03"),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.history_outlined,
                          ),
                          iconColor: Colors.black,
                          title: Text("Bv. Geronimo Benavides 1665"),
                          subtitle: Text("14/03/2022 • 22:15"),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.history_outlined,
                          ),
                          iconColor: Colors.black,
                          title: Text("Av. Martín Perez Disalvo"),
                          subtitle: Text("21/09/2021 • 14:03"),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.history_outlined,
                          ),
                          iconColor: Colors.black,
                          title: Text("Bv. Geronimo Benavides 1665"),
                          subtitle: Text("14/03/2022 • 22:15"),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.history_outlined,
                          ),
                          iconColor: Colors.black,
                          title: Text("Av. Martín Perez Disalvo"),
                          subtitle: Text("21/09/2021 • 14:03"),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.history_outlined,
                          ),
                          iconColor: Colors.black,
                          title: Text("Bv. Geronimo Benavides 1665"),
                          subtitle: Text("14/03/2022 • 22:15"),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.history_outlined,
                          ),
                          iconColor: Colors.black,
                          title: Text("Av. Martín Perez Disalvo"),
                          subtitle: Text("21/09/2021 • 14:03"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
