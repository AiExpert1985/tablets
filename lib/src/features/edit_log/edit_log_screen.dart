import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/widgets/show_transaction_dialog.dart';
import 'package:tablets/src/features/edit_log/edit_log_service.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

final editLogEntriesProvider =
    StateProvider<List<EditLogEntry>>((ref) => []);

final filteredEditLogEntriesProvider =
    StateProvider<List<EditLogEntry>>((ref) => []);

class EditLogScreen extends ConsumerStatefulWidget {
  const EditLogScreen({super.key});

  @override
  ConsumerState<EditLogScreen> createState() => _EditLogScreenState();
}

class _EditLogScreenState extends ConsumerState<EditLogScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedType;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEntries();
    });
  }

  void _loadEntries() {
    final service = ref.read(editLogServiceProvider);
    final entries = service.loadAllEntries();
    entries.sort((a, b) => b.editTime.compareTo(a.editTime));
    ref.read(editLogEntriesProvider.notifier).state = entries;
    ref.read(filteredEditLogEntriesProvider.notifier).state = entries;
  }

  void _applyFilters() {
    final allEntries = ref.read(editLogEntriesProvider);
    var filtered = allEntries.toList();

    final numberText = _numberController.text.trim();
    if (numberText.isNotEmpty) {
      final number = int.tryParse(numberText);
      if (number != null) {
        filtered = filtered.where((e) =>
            e.oldTransaction['number'] == number ||
            e.newTransaction['number'] == number).toList();
      }
    }

    final nameText = _nameController.text.trim();
    if (nameText.isNotEmpty) {
      filtered = filtered.where((e) =>
          (e.oldTransaction['name'] ?? '').toString().contains(nameText) ||
          (e.newTransaction['name'] ?? '').toString().contains(nameText)).toList();
    }

    if (_selectedType != null && _selectedType!.isNotEmpty) {
      filtered = filtered.where((e) =>
          e.oldTransaction['transactionType'] == _selectedType ||
          e.newTransaction['transactionType'] == _selectedType).toList();
    }

    if (_selectedDate != null) {
      filtered = filtered.where((e) {
        return e.editTime.year == _selectedDate!.year &&
            e.editTime.month == _selectedDate!.month &&
            e.editTime.day == _selectedDate!.day;
      }).toList();
    }

    ref.read(filteredEditLogEntriesProvider.notifier).state = filtered;
  }

  void _clearFilters() {
    _numberController.clear();
    _nameController.clear();
    setState(() {
      _selectedType = null;
      _selectedDate = null;
    });
    ref.read(filteredEditLogEntriesProvider.notifier).state =
        ref.read(editLogEntriesProvider);
  }

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = ref.watch(filteredEditLogEntriesProvider);
    final allEntries = ref.watch(editLogEntriesProvider);
    final hasFilters = _numberController.text.isNotEmpty ||
        _nameController.text.isNotEmpty ||
        _selectedType != null ||
        _selectedDate != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل التعديلات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoute.home.name),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderWithFilters(context, hasFilters),
            const Divider(thickness: 2),
            Expanded(
              child: allEntries.isEmpty
                  ? const Center(
                      child: Text('لا توجد سجلات تعديل',
                          style: TextStyle(fontSize: 18)))
                  : filteredEntries.isEmpty
                      ? const Center(
                          child: Text('لا توجد نتائج مطابقة',
                              style: TextStyle(fontSize: 16)))
                      : ListView.builder(
                          itemCount: filteredEntries.length,
                          itemBuilder: (context, index) {
                            final entry = filteredEntries[index];
                            return Column(
                              children: [
                                _buildTableRow(context, entry, index + 1),
                                const Divider(thickness: 0.5),
                              ],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWithFilters(BuildContext context, bool hasFilters) {
    const headerStyle = TextStyle(fontWeight: FontWeight.bold);
    const filterPadding = EdgeInsets.symmetric(horizontal: 4);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                  width: 40,
                  child: hasFilters
                      ? IconButton(
                          onPressed: _clearFilters,
                          icon: const Icon(Icons.cancel_outlined,
                              color: Colors.red, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )
                      : const Text('#',
                          style: headerStyle, textAlign: TextAlign.center)),
              const Expanded(
                  flex: 2,
                  child: Text('الوقت',
                      style: headerStyle, textAlign: TextAlign.center)),
              const Expanded(
                  flex: 3,
                  child: Text('النسخة القديمة',
                      style: headerStyle, textAlign: TextAlign.center)),
              const Expanded(
                  flex: 3,
                  child: Text('النسخة الجديدة',
                      style: headerStyle, textAlign: TextAlign.center)),
              const Expanded(
                  flex: 3,
                  child: Text('التغييرات',
                      style: headerStyle, textAlign: TextAlign.center)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 40),
              // Edit date filter
              Expanded(
                flex: 2,
                child: Padding(
                  padding: filterPadding,
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                        _applyFilters();
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
                            : '...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ),
              ),
              // Old version filters: type + number + name
              Expanded(
                flex: 3,
                child: Padding(
                  padding: filterPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedType,
                          hint: const Text('نوع', style: TextStyle(fontSize: 11)),
                          isExpanded: true,
                          isDense: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          ),
                          items: [
                            'customerInvoice',
                            'customerReceipt',
                            'customerReturn',
                            'vendorInvoice',
                            'vendorReceipt',
                            'vendorReturn',
                            'expenditures',
                            'gifts',
                            'damagedItems',
                          ]
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(
                                        translateDbTextToScreenText(
                                            context, type),
                                        style: const TextStyle(fontSize: 11)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() => _selectedType = value);
                            _applyFilters();
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _numberController,
                          decoration: const InputDecoration(
                            hintText: 'رقم',
                            hintStyle: TextStyle(fontSize: 11),
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 11),
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'اسم',
                            hintStyle: TextStyle(fontSize: 11),
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 11),
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // New version column - no separate filter needed (filters search both)
              const Expanded(flex: 3, child: SizedBox()),
              // Changes column - no filter
              const Expanded(flex: 3, child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
      BuildContext context, EditLogEntry entry, int rowNumber) {
    final dateTimeFormat = DateFormat('dd-MM-yyyy HH:mm');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(rowNumber.toString(), textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dateTimeFormat.format(entry.editTime),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () => _showTransaction(context, entry.oldTransaction),
              child: _buildSummary(context, entry.oldTransaction),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () => _showTransaction(context, entry.newTransaction),
              child: _buildSummary(context, entry.newTransaction),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              entry.changedFields.join('، '),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, Map<String, dynamic> tx) {
    final type = translateDbTextToScreenText(
        context, tx['transactionType'] ?? '');
    final number = tx['number']?.toString() ?? '';
    final name = tx['name'] ?? '';
    final amount = tx['totalAmount']?.toString() ?? '';

    String dateStr = '';
    final dateValue = tx['date'];
    if (dateValue is String) {
      final parsed = DateTime.tryParse(dateValue);
      if (parsed != null) {
        dateStr = DateFormat('dd-MM-yyyy').format(parsed);
      }
    } else if (dateValue is DateTime) {
      dateStr = DateFormat('dd-MM-yyyy').format(dateValue);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$type | $number | $name | $amount | $dateStr',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11, color: Colors.blue),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _showTransaction(BuildContext context, Map<String, dynamic> txData) {
    try {
      final transactionData = Map<String, dynamic>.from(txData);
      transactionData['imageUrls'] ??= <String>[];
      if (transactionData['date'] is String) {
        final parsed = DateTime.tryParse(transactionData['date']);
        if (parsed != null) {
          transactionData['date'] = parsed;
        }
      }
      final transaction = Transaction.fromMap(transactionData);
      showReadOnlyTransaction(context, transaction);
    } catch (e) {
      // silently ignore if transaction data is corrupted
    }
  }
}
