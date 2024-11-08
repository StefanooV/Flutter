import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weveapp/theme/app_theme.dart';

class UserIdentity extends StatefulWidget {
  const UserIdentity({super.key});

  @override
  State<UserIdentity> createState() => _UserIdentityState();
}

class _UserIdentityState extends State<UserIdentity> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser?.photoURL != null &&
        currentUser?.displayName != null &&
        currentUser?.displayName != "") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push("/driverMyAccount"),
            child: SizedBox(
              height: 50,
              width: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      currentUser!.photoURL!,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            currentUser!.displayName!,
            style: const TextStyle(
              color: Colors.white,
            ),
          )
        ],
      );
    } else if (currentUser?.photoURL == null &&
        currentUser?.displayName != null &&
        currentUser?.displayName != "") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push("/driverMyAccount"),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.wevePrimaryBlue,
                ),
                child: Center(
                  child: Text(
                    currentUser!.displayName![0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            currentUser!.displayName!,
            style: const TextStyle(
              color: Colors.white,
            ),
          )
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push("/driverMyAccount"),
            child: SizedBox(
              height: 50,
              width: 50,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.wevePrimaryBlue,
                ),
                child: const Center(
                  child: Text(
                    "?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Desconocido!",
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      );
    }
  }
}
