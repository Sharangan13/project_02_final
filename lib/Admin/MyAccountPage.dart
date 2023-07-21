import 'package:flutter/material.dart';

class MyAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('My Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(child: _buildProfileCard(context)),
              SizedBox(height: 20),
              Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildChangePasswordCard(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile_image.jpg'),
            ),
            SizedBox(height: 16),
            Text(
              'Sharangan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'sharangan@gmail.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add your code to change the password
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildProfilePhotoField(),
              SizedBox(height: 20),
              _buildUsernameField(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your code to update the profile information
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoField() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile_image.jpg'),
          ),
          SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              // Add your code to change the profile photo
            },
            icon: Icon(Icons.camera_alt),
            label: Text('Change Photo'),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
      ),
    );
  }
}
