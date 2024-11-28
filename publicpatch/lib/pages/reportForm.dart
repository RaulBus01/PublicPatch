import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:publicpatch/components/CustomDropDown.dart';
import 'package:publicpatch/components/CustomFormInput.dart';

import 'package:publicpatch/components/CustomTextArea.dart';
import 'package:publicpatch/models/Category.dart';
import 'package:publicpatch/models/CreateReport.dart';
import 'package:publicpatch/models/LocationData.dart';
import 'package:publicpatch/models/Report.dart';
import 'package:publicpatch/pages/home.dart';
import 'package:publicpatch/pages/report.dart';
import 'package:publicpatch/pages/reports.dart';
import 'package:publicpatch/service/category_Service.dart';
import 'package:publicpatch/service/report_Service.dart';
import 'package:publicpatch/service/user_Service.dart';
import 'package:publicpatch/service/user_secure.dart';
import 'package:publicpatch/utils/create_route.dart';
import 'package:publicpatch/utils/getIcon.dart';

class ReportFormPage extends StatefulWidget {
  const ReportFormPage({super.key});

  @override
  State<ReportFormPage> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportFormPage> {
  final ImagePicker _picker = ImagePicker();
  // final FilePicker _filePicker = await FilePicker.platform.pickFiles();
  final List<File> _images = [];
  LocationData? _selectedLocation;
  ReportService reportService = ReportService();
  CategoryService categoryService = CategoryService();

  List<Category> _categories = [];
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await categoryService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (_images.length < 6) {
            _images.add(File(image.path));
            Fluttertoast.showToast(
                msg: 'Image added', gravity: ToastGravity.TOP);
          } else {
            Fluttertoast.showToast(
                backgroundColor: Colors.red,
                msg: 'You can only add 6 images',
                gravity: ToastGravity.TOP);
          }
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: 'Error adding image',
          gravity: ToastGravity.TOP);
    }
  }

  Widget _buildImageCard() {
    return Card(
      color: Color.fromARGB(255, 54, 60, 73),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Images',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildImageButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                _buildImageButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
            if (_images.isNotEmpty) ...[
              SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _images[index],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _images.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;

    if (_titleController.text.isEmpty) {
      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: 'Title cannot be empty',
          gravity: ToastGravity.TOP);
      return false;
    }
    if (_selectedLocation == null) {
      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: 'Please select a location',
          gravity: ToastGravity.TOP);
      return false;
    }
    //TODO: Add validation for category
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text('Report Form'),
        backgroundColor: const Color(0XFF0D0E15),
        titleTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      backgroundColor: const Color(0XFF0D0E15),
      body: Form(
        key: _formKey,
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(134, 54, 60, 73),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                'Report Form',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
              CustomFormInput(
                  controller: _titleController,
                  title: 'Title',
                  preFixIcon: Icons.title),
              Padding(padding: EdgeInsets.only(top: 20)),
              CustomFormInput(
                controller: _locationController,
                title: 'Location',
                preFixIcon: Icons.location_on,
                suffixIcon: Icons.my_location_outlined,
                onLocationSelected: (dynamic location) {
                  if (location is LocationData) {
                    setState(() {
                      _selectedLocation = location;
                    });
                  }
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              CustomDropDown<Category>(
                initialValue: _selectedCategory ??
                    Category(id: 0, name: 'Select Category', description: ''),
                items: _categories,
                onChanged: (category) => setState(
                  () => _selectedCategory = category,
                ),
                itemBuilder: (category) => Row(
                  children: [
                    Icon(
                      getIconFromString(category.icon ?? ''),
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      category.name,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildImageCard(),
              Padding(padding: EdgeInsets.only(top: 15)),
              CustomTextArea(
                  controller: _descriptionController,
                  title: 'Description',
                  preFixIcon: Icons.description),
              Padding(padding: EdgeInsets.only(top: 40)),
              ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    try {
                      final report = CreateReport(
                          title: _titleController.text,
                          location: _selectedLocation!,
                          description: _descriptionController.text,
                          categoryId: _selectedCategory!.id,
                          imageUrls: _images.map((e) => e.path).toList(),
                          userId: await UserSecureStorage.getUserId());
                      print('Report data: ${report.toMap()}');
                      var responseData =
                          await ReportService().createReport(report);
                      if (responseData == null) {
                        throw Exception('Failed to create report');
                      }

                      Fluttertoast.showToast(
                          msg: 'Report created successfully',
                          gravity: ToastGravity.TOP);

                      Navigator.pushReplacement(
                          context, CreateRoute.createRoute(HomePage()));
                    } catch (e) {
                      Fluttertoast.showToast(
                          backgroundColor: Colors.red,
                          msg: e.toString(),
                          gravity: ToastGravity.TOP);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.blue,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
