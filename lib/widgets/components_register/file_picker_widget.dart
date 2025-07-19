import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../custom_button.dart';
import '../../core/constants/app_colors.dart';

class FilePickerWidget extends StatelessWidget {
  final String label;
  final PlatformFile? file;
  final VoidCallback onPressed;
  final IconData icon;

  const FilePickerWidget({
    super.key,
    required this.label,
    required this.file,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    bool isFileSelected = file != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFileSelected
              ? AppColors.primary
              : AppColors.textSecondary.withOpacity(0.3),
          width: isFileSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isFileSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isFileSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (isFileSelected)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            file!.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                CustomButton(
                  label: isFileSelected ? "Modifier" : "Choisir",
                  onPressed: onPressed,
                  backgroundColor:
                      isFileSelected ? Colors.white : AppColors.secondary,
                  textColor:
                      isFileSelected ? AppColors.secondary : Colors.white,
                  borderColor: isFileSelected ? AppColors.secondary : null,
                  height: 40,
                  width: 100,
                  borderRadius: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}