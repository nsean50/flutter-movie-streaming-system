import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/firebase_service.dart';

class EditMovieScreen extends StatefulWidget {
  final Movie movie;

  const EditMovieScreen({super.key, required this.movie});

  @override
  State<EditMovieScreen> createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _videoUrlController;
  late TextEditingController _imageUrlController;
  
  late String _selectedCategory;
  late String _selectedLanguage;
  bool _isLoading = false;

  final List<String> _categories = ['أكشن', 'دراما', 'رعب', 'كوميدي'];
  final List<String> _languages = ['عربي', 'أجنبي'];

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie.title);
    _descriptionController = TextEditingController(text: widget.movie.description);
    _videoUrlController = TextEditingController(text: widget.movie.videoUrl);
    _imageUrlController = TextEditingController(text: widget.movie.imageUrl);
    _selectedCategory = widget.movie.category;
    _selectedLanguage = widget.movie.language;
  }

  void _updateMovie() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final updatedMovie = Movie(
        id: widget.movie.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        language: _selectedLanguage,
        videoUrl: _videoUrlController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        createdAt: widget.movie.createdAt,
      );

      final success = await _firebaseService.updateMovie(updatedMovie);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث الفيلم بنجاح')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في تحديث الفيلم')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الفيلم'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _updateMovie,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('حفظ', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان الفيلم/المسلسل',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال العنوان';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال الوصف';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'القسم',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'اللغة',
                border: OutlineInputBorder(),
              ),
              items: _languages.map((language) {
                return DropdownMenuItem(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _videoUrlController,
              decoration: const InputDecoration(
                labelText: 'رابط الفيديو',
                hintText: 'Google Drive أو M3U8 URL',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال رابط الفيديو';
                }
                if (!Uri.tryParse(value.trim())!.isAbsolute) {
                  return 'يرجى إدخال رابط صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'رابط الصورة',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال رابط الصورة';
                }
                if (!Uri.tryParse(value.trim())!.isAbsolute) {
                  return 'يرجى إدخال رابط صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateMovie,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'حفظ التغييرات',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoUrlController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
