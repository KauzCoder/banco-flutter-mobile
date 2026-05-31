import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/controllers/transactions_controller.dart';
import 'package:flutter_aplication_bank/core/routes/app_routes.dart';
import 'package:flutter_aplication_bank/models/transaction_model.dart';
import 'package:flutter_aplication_bank/widgets/bottom_navigation/app_bottom_nav_bar.dart';
import 'package:flutter_aplication_bank/widgets/headers/app_screen_header.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'Todas';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<TransactionsController>().fetchTransactions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TransactionModel> _filteredTransactions(
    List<TransactionModel> transactions,
  ) {
    final query = _searchController.text.trim().toLowerCase();

    return transactions.where((transaction) {
      final matchesFilter = switch (_selectedFilter) {
        'Entradas' => !transaction.isExpense,
        'Saídas' => transaction.isExpense,
        _ => true,
      };

      return transaction.matchesQuery(query) && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionsController>();
    final filteredTransactions = _filteredTransactions(controller.transactions);

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: const AppBottomNavBar(
        currentItem: AppBottomNavItem.transactions,
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppScreenHeader(
              title: 'Historico de Transacoes',
              onBackPressed: () => Navigator.maybePop(context),
              horizontalPadding: 17,
              verticalPadding: 20,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(17, 24, 17, 24),
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 16),
                  _buildFilters(),
                  const SizedBox(height: 24),
                  if (controller.isLoading)
                    const _LoadingTransactions()
                  else if (controller.error != null)
                    _TransactionsError(
                      message: controller.error!,
                      onRetry: () => controller.fetchTransactions(),
                    )
                  else if (filteredTransactions.isEmpty)
                    const _EmptyTransactions()
                  else
                    ...filteredTransactions.map(
                      (transaction) => _TransactionRow(
                        transaction: transaction,
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.receipt),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      cursorColor: const Color(0xFF8A35FF),
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: 'Pesquisar',
        hintStyle: const TextStyle(color: Color(0xFFA4A4AE), fontSize: 16),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xFFA4A4AE),
          size: 24,
        ),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFFA4A4AE),
                  size: 24,
                ),
              ),
        filled: true,
        fillColor: const Color(0xFF252736),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF8A35FF)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        _FilterChip(
          label: 'Todas',
          isSelected: _selectedFilter == 'Todas',
          onTap: () => setState(() => _selectedFilter = 'Todas'),
        ),
        const SizedBox(width: 10),
        _FilterChip(
          label: 'Entradas',
          isSelected: _selectedFilter == 'Entradas',
          onTap: () => setState(() => _selectedFilter = 'Entradas'),
        ),
        const SizedBox(width: 10),
        _FilterChip(
          label: 'Saídas',
          isSelected: _selectedFilter == 'Saídas',
          onTap: () => setState(() => _selectedFilter = 'Saídas'),
        ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction, required this.onTap});

  final TransactionModel transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1F30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                transaction.icon,
                color: transaction.iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.category,
                    style: const TextStyle(
                      color: Color(0xFFA4A4AE),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              transaction.formattedAmount,
              style: TextStyle(
                color: transaction.isExpense
                    ? Colors.white
                    : const Color(0xFFDBFF2F),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDBFF2F) : const Color(0xFF1E1F30),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : const Color(0xFFA4A4AE),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, color: Color(0xFFA4A4AE), size: 40),
          SizedBox(height: 16),
          Text(
            'Nenhuma transação encontrada',
            style: TextStyle(
              color: Color(0xFFA4A4AE),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingTransactions extends StatelessWidget {
  const _LoadingTransactions();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Center(child: CircularProgressIndicator(color: Color(0xFF8A35FF))),
    );
  }
}

class _TransactionsError extends StatelessWidget {
  const _TransactionsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFFF6B72), size: 40),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFA4A4AE),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: const Text('Tentar novamente')),
        ],
      ),
    );
  }
}
