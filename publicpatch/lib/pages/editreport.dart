import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:publicpatch/components/CustomFormInput.dart';
import 'package:publicpatch/components/CustomFormInputWithSuggestions.dart';

import 'package:publicpatch/components/CustomTextArea.dart';
import 'package:publicpatch/models/Category.dart';

import 'package:publicpatch/models/LocationData.dart';
import 'package:publicpatch/models/Report.dart';
import 'package:publicpatch/pages/home.dart';
import 'package:publicpatch/pages/reports.dart';
import 'package:publicpatch/service/category_Service.dart';
import 'package:publicpatch/service/report_Service.dart';
import 'package:publicpatch/service/user_secure.dart';
import 'package:publicpatch/utils/create_route.dart';

class EditReportPage extends StatefulWidget {
  final int reportId;
  final String title;
  final String description;
  final LocationData location;
  final List<String> imageUrls;
  const EditReportPage(
      {super.key,
      required this.reportId,
      required this.title,
      required this.description,
      required this.location,
      required this.imageUrls});

  @override
  State<EditReportPage> createState() => _EditReportFormState();
}

class _EditReportFormState extends State<EditReportPage> {
  final ImagePicker _picker = ImagePicker();
  // final FilePicker _filePicker = await FilePicker.platform.pickFiles();
  final List<File> _images = [];
  LocationData? _selectedLocation;
  ReportService reportService = ReportService();
  CategoryService categoryService = CategoryService();

  bool _isDisposed = false;
  bool _isSending = false;
  List<Category> _categories = [];
  Category? _selectedCategory;
  int _initialImageCount = 0;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
    _selectedLocation = widget.location;
    _locationController.text = widget.location.address;
    _initialImageCount = widget.imageUrls.length;

    // Load categories and set up existing data
    _loadCategories();
  }

  bool _validateForm() {
    // First check the form's built-in validators
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: 'Please check all required fields',
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    // Validate title
    if (_titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Title cannot be empty',
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    if (_titleController.text.trim().length < 3) {
      Fluttertoast.showToast(
        msg: 'Title must be at least 3 characters long',
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    if (_titleController.text.trim().length > 100) {
      Fluttertoast.showToast(
        msg: 'Title cannot exceed 100 characters',
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    // Validate location
    if (_selectedLocation == null) {
      Fluttertoast.showToast(
        msg: 'Please select a location',
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    // Validate description
    if (_descriptionController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Description cannot be empty',
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    if (_descriptionController.text.trim().length > 1000) {
      Fluttertoast.showToast(
        msg: 'Description cannot exceed 1000 characters',
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    // Validate category
    if (_selectedCategory == null) {
      Fluttertoast.showToast(
        msg: 'Please select a category',
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    // Validate images (if you want to enforce minimum/maximum images)
    if (_images.length > 6) {
      Fluttertoast.showToast(
        msg: 'Maximum 6 images allowed',
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    // Check for any changes in the form
    bool hasChanges = false;

    if (_titleController.text != widget.title ||
        _descriptionController.text != widget.description ||
        _selectedLocation != widget.location ||
        _images.isNotEmpty ||
        _images.length != _initialImageCount) {
      hasChanges = true;
    }

    if (!hasChanges) {
      Fluttertoast.showToast(
        msg: 'No changes detected',
        backgroundColor: Colors.orange,
        gravity: ToastGravity.TOP,
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryService().getCategories();
      if (!_isDisposed && mounted) {
        setState(() {
          _categories = categories;
          _selectedCategory = categories.isNotEmpty ? categories.first : null;
        });
      }
    } catch (e) {
      debugPrint("Error loading categories: $e");
    }
  }

  void _updateSelectedCategory(Category category) {
    if (!_isDisposed && mounted) {
      setState(() => _selectedCategory = category);
    }
  }

  Future<void> _handleSubmit() async {
    if (_validateForm()) {
      try {
        _isSending = true;
        final updatedReport = UpdateReportModel(
            title: _titleController.text,
            location: _selectedLocation!,
            description: _descriptionController.text,
            reportImages: _images,
            userId: await UserSecureStorage.getUserId(),
            id: widget.reportId);

        // Call update instead of create
        var responseData = await reportService.updateReport(updatedReport);
        if (responseData == null) {
          throw Exception('Failed to update report');
        }

        if (mounted) {
          _isSending = false;
          Fluttertoast.showToast(
              msg: 'Report updated successfully', gravity: ToastGravity.TOP);
          Navigator.pushReplacement(
              context, CreateRoute.createRoute(HomePage()));
        }
      } catch (e) {
        if (mounted) {
          _isSending = false;
          Fluttertoast.showToast(
              backgroundColor: Colors.red,
              msg: e.toString(),
              gravity: ToastGravity.TOP);
        }
      }
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
              'Report Images',
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
            if (widget.imageUrls.isNotEmpty || _images.isNotEmpty) ...[
              SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.imageUrls.length + _images.length,
                  itemBuilder: (context, index) {
                    // Determine if the image is from the original report or newly added
                    bool isOriginal = index < widget.imageUrls.length;
                    String? imageUrl =
                        isOriginal ? widget.imageUrls[index] : null;
                    File? imageFile = !isOriginal
                        ? _images[index - widget.imageUrls.length]
                        : null;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: isOriginal
                                ? Image.network(
                                    imageUrl!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    imageFile!,
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
                                  if (isOriginal) {
                                    widget.imageUrls.removeAt(index);
                                  } else {
                                    _images.removeAt(
                                        index - widget.imageUrls.length);
                                  }
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
                  preFixIcon: Icons.title,
                  content: widget.title),
              Padding(padding: EdgeInsets.only(top: 20)),
              CustomFormInputSuggestions(
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
                    if (!_isSending) {
                      await _handleSubmit();
                    }
                    if (mounted) {
                      Navigator.pushReplacement(
                          context, CreateRoute.createRoute(ReportsPage()));
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
