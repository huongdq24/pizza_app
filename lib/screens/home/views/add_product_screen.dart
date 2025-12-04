import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'package:uuid/uuid.dart';

import '../../../components/cloudinary_images.dart';
import '../blocs/create_pizza/create_pizza_bloc.dart';

class AddProductScreen extends StatefulWidget {
  final Pizza? pizzaToEdit;

  const AddProductScreen({this.pizzaToEdit, super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();

  bool _isVeg = true;
  int _spicyLevel = 1; // 1: Bland, 2: Balance, 3: Spicy
  // ProductCategory _selectedCategory = ProductCategory.pizza;
  String? _selectedImageUrl;
  bool get isEditMode => widget.pizzaToEdit != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final pizza = widget.pizzaToEdit!;
      _nameController.text = pizza.name;
      _descriptionController.text = pizza.description;
      _priceController.text = pizza.price.toString();
      _discountController.text = pizza.discount.toString();
      _caloriesController.text = pizza.macros.calories.toString();
      _proteinsController.text = pizza.macros.proteins.toString();
      _fatController.text = pizza.macros.fat.toString();
      _carbsController.text = pizza.macros.carbs.toString();
      _isVeg = pizza.isVeg;
      _spicyLevel = pizza.spicy;
      // _selectedCategory = pizza.category;
      _selectedImageUrl = pizza.picture;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _caloriesController.dispose();
    _proteinsController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn ảnh sản phẩm'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final pizza = Pizza(
        pizzaId: isEditMode ? widget.pizzaToEdit!.pizzaId : const Uuid().v4(),
        picture: _selectedImageUrl!,
        isVeg: _isVeg,
        spicy: _spicyLevel,
        name: _nameController.text,
        description: _descriptionController.text,
        price: int.parse(_priceController.text),
        discount: int.parse(_discountController.text),
        // category: _selectedCategory,
        macros: Macros(
          calories: int.parse(_caloriesController.text),
          proteins: int.parse(_proteinsController.text),
          fat: int.parse(_fatController.text),
          carbs: int.parse(_carbsController.text),
        ),
      );

      if (isEditMode) {
        context.read<CreatePizzaBloc>().add(UpdatePizza(pizza));
      } else {
        context.read<CreatePizzaBloc>().add(CreatePizza(pizza));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          isEditMode ? 'Sửa Sản Phẩm' : 'Thêm Sản Phẩm',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<CreatePizzaBloc, CreatePizzaState>(
        listener: (context, state) {
          if (state is CreatePizzaSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isEditMode
                    ? 'Cập nhật thành công!'
                    : 'Thêm sản phẩm thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate back - the home screen will auto-refresh when it becomes active
            Navigator.pop(context, true); // Return true to indicate success
          } else if (state is CreatePizzaFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CreatePizzaBloc, CreatePizzaState>(
          builder: (context, state) {
            if (state is CreatePizzaLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Selection Section
                    const Text(
                      'Chọn ảnh sản phẩm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: CloudinaryImages.allImageUrls.length,
                        itemBuilder: (context, index) {
                          final imageUrl = CloudinaryImages.allImageUrls[index];
                          final isSelected = _selectedImageUrl == imageUrl;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImageUrl = imageUrl;
                              });
                            },
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade300,
                                  width: isSelected ? 3 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.error),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Basic Information
                    const Text(
                      'Thông tin cơ bản',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên sản phẩm';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mô tả';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Category Selection
                    const Text(
                      'Phân loại',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<bool>(
                                value: _isVeg,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(
                                    value: true,
                                    child: Text('Chay (VEG)'),
                                  ),
                                  DropdownMenuItem(
                                    value: false,
                                    child: Text('Mặn (NON-VEG)'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _isVeg = value ?? true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _spicyLevel,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('🌶️ Nhẹ'),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('🌶️ Vừa'),
                                  ),
                                  DropdownMenuItem(
                                    value: 3,
                                    child: Text('🌶️ Cay'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _spicyLevel = value ?? 1;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Pricing
                    const Text(
                      'Giá bán',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Giá gốc (\$)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nhập giá';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Số không hợp lệ';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _discountController,
                            decoration: const InputDecoration(
                              labelText: 'Giảm giá (%)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nhập %';
                              }
                              final discount = int.tryParse(value);
                              if (discount == null) {
                                return 'Số không hợp lệ';
                              }
                              if (discount < 0 || discount > 100) {
                                return '0-100';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Nutrition Information
                    const Text(
                      'Thông tin dinh dưỡng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _caloriesController,
                            decoration: const InputDecoration(
                              labelText: 'Calories',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nhập calories';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Số không hợp lệ';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _proteinsController,
                            decoration: const InputDecoration(
                              labelText: 'Protein (g)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nhập protein';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Số không hợp lệ';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _fatController,
                            decoration: const InputDecoration(
                              labelText: 'Chất béo (g)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nhập chất béo';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Số không hợp lệ';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _carbsController,
                            decoration: const InputDecoration(
                              labelText: 'Carbs (g)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nhập carbs';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Số không hợp lệ';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Thêm Sản Phẩm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
