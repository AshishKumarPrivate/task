import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_task/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final UserListModel user;
   DetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: Text(user.fullName)),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: isTablet
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: buildImageCart()),
               SizedBox(width: 16),
              Expanded(child: buildUserDetailCard()),
            ],
          )
              : Column(
            children: [
              buildImageCart(),
               SizedBox(height: 16),
              buildUserDetailCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageCart() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset:  Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: user.largePicture,
          height: 250,
          placeholder: (context, url) => Image.asset(
            'assets/images/img_placeholder.jpeg',
            fit: BoxFit.cover,
            height: 250,
          ),
          errorWidget: (context, url, error) => Container(
            height: 250,
            color: Colors.grey[200],
            child:  Icon(Icons.error, size: 50, color: Colors.red),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildUserDetailCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.email_outlined, 'Email', user.email),
            Divider(height: 24),
            _buildDetailRow(Icons.phone_outlined, 'Phone', user.phone),
            Divider(height: 24),
            _buildDetailRow(
              Icons.location_on_outlined,
              'Location',
              '${user.city}, ${user.state}, ${user.country}',
            ),
            Divider(height: 24),
            _buildDetailRow(
              Icons.cake_outlined,
              'Date of Birth',
              DateFormat('dd MMM yyyy').format(user.dob),
            ),
            Divider(height: 24),
            _buildDetailRow(
              Icons.person_outline,
              'Age',
              '${user.age} years',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.blue[700]),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
