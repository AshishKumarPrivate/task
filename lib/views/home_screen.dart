import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_task/controller/user_controller.dart';
import 'package:demo_task/views/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserControllerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:  Text('User Filter List'),
        actions: [
          PopupMenuButton<AlphabetSortOrderEnum>(
            icon:  Icon(Icons.sort),
            onSelected: userController.setUserSortingOrder,
            itemBuilder: (context) => [
              PopupMenuItem(value: AlphabetSortOrderEnum.az, child: Text('A-Z')),
              PopupMenuItem(value: AlphabetSortOrderEnum.za, child: Text('Z-A')),
              PopupMenuItem(value: AlphabetSortOrderEnum.none, child: Text('None')),
            ],
          ),
          PopupMenuButton<String?>(
            icon:  Icon(Icons.filter_list),
            onSelected: userController.setGenderFilter,
            itemBuilder: (context) => [
              PopupMenuItem(value: null, child: Text('All')),
              PopupMenuItem(value: 'male', child: Text('Male')),
              PopupMenuItem(value: 'female', child: Text('Female')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration:  InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: userController.setSearchQuery,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: userController.refreshUsers,
              child: buildUserList(userController, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserList(UserControllerProvider controller, BuildContext context) {
    if (controller.isLoading && controller.users.isEmpty) {
      return  Center(child: CircularProgressIndicator());
    }

    if (controller.error != null) {
      return Center(child: Text('Error: ${controller.error}'));
    }

    if (controller.users.isEmpty) {
      return  Center(child: Text('No users found'));
    }

    return ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.users.length + (controller.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.users.length) {
          return Center(child: CircularProgressIndicator());
        }

        final user = controller.users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.thumbnail),
          ),
          title: Text(user.fullName),
          subtitle: Text(user.email),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(user: user),
            ),
          ),
        );
      },
    );
  }
}