import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DriverMyAccountCard extends StatelessWidget {
  const DriverMyAccountCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListTile(
                onTap: () => context.push("/driverPersonalInformation"),
                leading: const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                ),
                title: const Text(
                  "Información personal",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Divider(color: Colors.grey, thickness: 0.5),
            ),
            SizedBox(
              height: 40,
              child: ListTile(
                onTap: () => context.push("/driverMyVehicles"),
                leading: const Icon(
                  Icons.directions_car,
                  color: Colors.grey,
                ),
                title: const Text(
                  "Vehículos",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            // const Padding(
            //   padding: EdgeInsets.only(left: 10, right: 10),
            //   child: Divider(color: Colors.grey, thickness: 0.5),
            // ),
            // SizedBox(
            //   height: 50,
            //   child: ListTile(
            //     onTap: () => {print('log de notificaciones')},
            //     leading: Stack(children: [
            //       Icon(
            //         Icons.notifications_outlined,
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 16, top: 16),
            //         child: Container(
            //           alignment: AlignmentDirectional.bottomEnd,
            //           height: 10,
            //           width: 10,
            //           padding: const EdgeInsets.all(0), //spacing using padding
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             border: Border.all(width: 6, color: Colors.red),
            //           ),
            //         ),
            //       )
            //     ]),
            //     title: const Text("Notificaciones",
            //         style: TextStyle(fontSize: 13)),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
