import 'package:drift/drift.dart';
import 'package:kale/core/database/app_database.dart';
import 'package:kale/features/transactions/data/tables/categories_table.dart';

part 'categories_dao.g.dart';

/// DAO for categories table operations.
@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  /// Watches all categories ordered by sortOrder.
  Stream<List<Category>> watchAll() {
    return (select(categories)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  /// Gets all categories.
  Future<List<Category>> getAll() {
    return (select(categories)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Gets categories by type.
  Future<List<Category>> getByType(String type) {
    return (select(categories)
          ..where(
            (t) => t.type.equals(type) | t.type.equals('both'),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Gets a single category by ID.
  Future<Category?> getById(String id) {
    return (select(categories)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Inserts or replaces a category.
  Future<void> upsert(CategoriesCompanion entry) {
    return into(categories).insertOnConflictUpdate(entry);
  }

  /// Inserts multiple categories at once.
  Future<void> insertAll(List<CategoriesCompanion> entries) {
    return batch((b) => b.insertAll(categories, entries));
  }

  /// Deletes a category by ID.
  Future<void> deleteById(String id) {
    return (delete(categories)..where((t) => t.id.equals(id))).go();
  }

  /// Gets the count of categories.
  Future<int> getCount() async {
    final count = categories.id.count();
    final query = selectOnly(categories)..addColumns([count]);
    final row = await query.getSingle();
    return row.read(count)!;
  }
}
