import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPlantsEquipmentsPage extends StatefulWidget {
  @override
  _UploadPlantsEquipmentsPageState createState() =>
      _UploadPlantsEquipmentsPageState();
}

class _UploadPlantsEquipmentsPageState
    extends State<UploadPlantsEquipmentsPage> {
  String selectedType = '';
  String selectedCategory = '';
  File? imageFile;

  final List<String> plantCategories = [
    'Indoor Plants',
    'Outdoor Plants',
    'Flowering Plants',
    'Medicinal Plants',
    'Rare and Exotic Plants',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Plants and Equipments'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Image',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildImageUploader(),
            SizedBox(height: 30),
            Text(
              'Select Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildTypeSelection(),
            SizedBox(height: 30),
            if (selectedType == 'plants') ...[
              Text(
                'Select Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildCategorySelection(),
              SizedBox(height: 30),
            ],
            Text(
              'Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildTextField('Enter Name', _nameController),
            SizedBox(height: 30),
            Text(
              'Price',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildTextField('Enter Price', _priceController),
            SizedBox(height: 30),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildTextFieldDescrption(
                'Enter Description', _descriptionController),
            SizedBox(height: 30),
            Text(
              'Quantity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildTextField('Enter Quantity', _quantityController),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _handleUpload,
              child: Text(
                'Upload',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploader() {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: _selectImage,
            child: imageFile != null
                ? Image.file(imageFile!, fit: BoxFit.cover)
                : Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.grey[600],
                  ),
          ),
        ),
        SizedBox(height: 10),
        TextButton.icon(
          onPressed: _selectImage,
          icon: Icon(Icons.cloud_upload),
          label: Text(
            'Upload Image',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 24.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      ],
    );
  }

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Widget _buildTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTypeButton('plants', 'Plants'),
        _buildTypeButton('equipments', 'Equipments'),
      ],
    );
  }

  Widget _buildTypeButton(String type, String label) {
    final isSelected = selectedType == type;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedType = type;
          selectedCategory = '';
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey,
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 24.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (String category in plantCategories) _buildCategoryButton(category),
      ],
    );
  }

  Widget _buildCategoryButton(String category) {
    final isSelected = selectedCategory == category;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey,
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 24.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      controller: controller,
    );
  }

  Widget _buildTextFieldDescrption(
      String label, TextEditingController controller) {
    return TextField(
      onChanged: (value) {
        // Handle the text changes here
      },
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      controller: controller,
    );
  }

  Future<void> _handleUpload() async {
    final String name = _nameController.text.trim();
    final String price = _priceController.text.trim();
    final String description = _descriptionController.text.trim();
    final String quantity = _quantityController.text.trim();

    if (selectedType.isNotEmpty &&
        name.isNotEmpty &&
        price.isNotEmpty &&
        description.isNotEmpty &&
        quantity.isNotEmpty &&
        imageFile != null) {
      try {
        // Upload the image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('Uploaded Images')
            .child(DateTime.now().toString());
        final UploadTask uploadTask = storageRef.putFile(imageFile!);
        final TaskSnapshot uploadSnapshot =
            await uploadTask.whenComplete(() {});

        // Get the image URL from Firebase Storage
        final String imageUrl = await storageRef.getDownloadURL();

        // Store the details in Firestore
        final String collection =
            selectedType == 'plants' ? 'Plants' : 'Equipments';

        if (selectedType == 'plants' && selectedCategory.isNotEmpty) {
          final String category = selectedCategory.replaceAll(' ', '');

          await _firestore
              .collection(collection)
              .doc(category)
              .collection('Items')
              .add({
            'name': name,
            'price': price,
            'description': description,
            'quantity': quantity,
            'image_url': imageUrl,
            'Category': category,
            'date': DateTime.now()
          });
        } else if (selectedType == 'plants' && selectedCategory.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a category for plants')),
          );
          return;
        } else {
          await _firestore
              .collection(collection)
              .doc('equipments')
              .collection('Items')
              .add({
            'name': name,
            'price': price,
            'description': description,
            'quantity': quantity,
            'image_url': imageUrl,
            'date': DateTime.now(),
          });
        }

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful')),
        );

        // Clear the form fields and selected image
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _quantityController.clear();
        setState(() {
          imageFile = null;
        });
      } catch (error) {
        print('Error uploading to Firestore: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please fill in all fields and select an image')),
      );
    }
  }
}
