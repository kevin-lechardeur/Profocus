import 'package:flutter/material.dart';

enum TransactionCategory {
  logement,
  alimentation,
  transport,
  divertissement,
  sante,
  education,
  autres,
}

extension TransactionCategoryExtension on TransactionCategory {
  Color get color {
    switch (this) {
      case TransactionCategory.logement:
        return Colors.blue;
      case TransactionCategory.alimentation:
        return Colors.green;
      case TransactionCategory.transport:
        return Colors.orange;
      case TransactionCategory.divertissement:
        return Colors.purple;
      case TransactionCategory.sante:
        return Colors.red;
      case TransactionCategory.education:
        return Colors.teal;
      case TransactionCategory.autres:
      default:
        return Colors.grey;
    }
  }
}