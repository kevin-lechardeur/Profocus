import 'package:hive/hive.dart';
import 'transaction_category.dart';

class TransactionCategoryAdapter extends TypeAdapter<TransactionCategory> {
  @override
  final int typeId = 4;

  @override
  TransactionCategory read(BinaryReader reader) {
    return TransactionCategory.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, TransactionCategory obj) {
    writer.writeInt(obj.index);
  }
}
