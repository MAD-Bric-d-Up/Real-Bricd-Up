import 'package:bricd_up/constants/app_colors.dart';
import 'package:bricd_up/models/search_model.dart';
import 'package:bricd_up/models/user_profile.dart';
import 'package:bricd_up/pages/other_profile.dart';
import 'package:bricd_up/services/firestore_service.dart';
import 'package:bricd_up/repository/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final TextEditingController _searchController = TextEditingController();
  UserProfile? _foundUser;
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // handle searching for a user
  void _handleSearch(String value) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String searchContentString = _searchController.text;

    if (currentUser == null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _foundUser = null;
    });

    final String uid = currentUser.uid;

    try {
      final UserProfile? myFullUser = await UserRepo.instance.fetchUserProfile();

      if (myFullUser == null) return;

      final String username = myFullUser.username;

      final SearchModel searchModel = SearchModel(
        uid: "",
        userUid: uid,
        username: username,
        searchContent: searchContentString,
        createdAt: Timestamp.now().toDate(),
      );

      final Map<String, dynamic> postData = searchModel.toMap();


      final String generatedSearchUid = await FirestoreService.instance.createSearchDatabaseEntry(postData);
      final UserProfile? resultUser = await UserRepo.instance.fetchUserProfileByUsername(searchContentString);
      
      if (resultUser == null) return;

      setState(() {
        _foundUser = resultUser;
        _searchController.clear();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }


  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: null,
      backgroundColor: AppColors.primaryGreen,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[

              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                    ),
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.black
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: _handleSearch,
                ),
              ),

              const SizedBox(height: 8.0,),

              SizedBox(
                height: screenHeight * .20,
                width: double.infinity,
                child: Text(
                  'past searches',
                  style: const TextStyle(
                    backgroundColor: AppColors.primaryBeige
                  ),
                ),
              ),

              const SizedBox(height: 8.0,),

              SizedBox(
                height: 75,
                width: double.infinity,
                child: _buildSearchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return SizedBox(
        width: 50.0,
        height: 50.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator()
          ],
        ),
      );
    } else if (_foundUser != null) {
      final String _foundUsername = _foundUser!.username;
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtherProfile(
                userProfile: _foundUser!,
              )
            )
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: Colors.black87,
                width: 1.5,
              )
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // pfp
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 5.0,
                    )
                  ),
                ),

                const SizedBox(width: 8.0,),

                Text(
                  '@$_foundUsername',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                const Icon(Icons.arrow_right)
              ]
            ), 
          )
        )
      );
    } else {
      return SizedBox();
    }
  }
}