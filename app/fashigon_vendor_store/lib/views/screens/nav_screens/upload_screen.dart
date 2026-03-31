import 'dart:io';
import 'package:fashigon_vendor_store/controllers/product_controller.dart';
import 'package:fashigon_vendor_store/models/subcategory.dart';
import 'package:fashigon_vendor_store/provider/vendor_provider.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fashigon_vendor_store/models/category.dart' as custom_category;
import 'package:fashigon_vendor_store/controllers/category_controller.dart';
import 'package:fashigon_vendor_store/controllers/subcategory_controller.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  late Future<List<custom_category.Category>> futureCategories;
  Future<List<Subcategory>>? futureSubcategories;

  custom_category.Category? selectedCategory;
  Subcategory? selectedSubcategory;
  late String productName;
  late int productPrice;
  late int quantity;
  late String description;

  bool isLoading = false;

  final ImagePicker picker = ImagePicker();
  List<File> images = [];

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  // Helper function to handle image display for both mobile and web
  Widget buildImage(File imageFile) {
    if (kIsWeb) {
      return Image.network(imageFile.path); // Use network for web
    } else {
      return Image.file(imageFile); // Use file for mobile
    }
  }

  // Function to choose an image
  Future<void> chooseImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          images.add(File(pickedFile.path));
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No image selected')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
    }
  }

  // Fetch subcategories based on the selected category
  void getSubcategoriesByCategory(custom_category.Category? category) {
    if (category != null) {
      futureSubcategories = SubcategoryController()
          .getSubcategoriesByCategoryName(category.name);
      setState(() {
        selectedSubcategory = null;
      });
    }
  }

  // Helper function to build a text field
  Widget buildTextField({
    required String label,
    required String hint,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    int maxLines = 1,
  }) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        maxLength: maxLength,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display selected images
            GridView.builder(
              shrinkWrap: true,
              itemCount: images.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: chooseImage,
                      ),
                    )
                    : SizedBox(
                      height: 40,
                      width: 50,
                      child: buildImage(images[index - 1]),
                    );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField(
                    label: 'Enter Product Name',
                    hint: 'Enter product name',
                    onChanged: (value) => productName = value,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter Product Name'
                                : null,
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    label: 'Enter Product Price',
                    hint: 'Enter product price',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => productPrice = int.parse(value),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter Product Price'
                                : null,
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    label: 'Enter Product Quantity',
                    hint: 'Enter product quantity',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => quantity = int.parse(value),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter Product Quantity'
                                : null,
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<custom_category.Category>>(
                    future: futureCategories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No categories available'),
                        );
                      } else {
                        return DropdownButton<custom_category.Category>(
                          value: selectedCategory,
                          hint: const Text('Select Category'),
                          items:
                              snapshot.data!.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                            getSubcategoriesByCategory(value);
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Subcategory>>(
                    future: futureSubcategories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No subcategories available'),
                        );
                      } else {
                        return DropdownButton<Subcategory>(
                          value: selectedSubcategory,
                          hint: const Text('Select Subcategory'),
                          items:
                              snapshot.data!.map((subcategory) {
                                return DropdownMenuItem(
                                  value: subcategory,
                                  child: Text(subcategory.subCategoryName),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSubcategory = value;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    label: 'Enter Product Description',
                    hint: 'Enter product description',
                    maxLength: 500,
                    maxLines: 3,
                    onChanged: (value) => description = value,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter Product Description'
                                : null,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    final vendor = ref.read(vendorProvider);
                    if (vendor != null) {
                      await _productController.uploadProduct(
                        productName: productName,
                        productPrice: productPrice,
                        quantity: quantity,
                        description: description,
                        category: selectedCategory!.name,
                        vendorId: vendor.id,
                        fullName: vendor.fullName,
                        subCategory: selectedSubcategory!.subCategoryName,
                        pickedImages: images,
                        context: context,
                      );
                      setState(() {
                        isLoading = false;
                        selectedCategory = null;
                        selectedSubcategory = null;
                        images.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product uploaded successfully!'),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Upload Product',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.7,
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
