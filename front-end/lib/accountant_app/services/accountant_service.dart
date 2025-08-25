import '../models/financial_log.dart';
import '../models/invoice.dart';

class AccountantService {
  static final List<FinancialLog> _financialLogs = [
    FinancialLog(
      id: '101',
      description: 'Freelance Graphic Design',
      amount: 75000.00,
      type: 'income',
      category: 'Other',
      date: DateTime(2025, 7, 3),
      notes: 'Logo design for startup',
    ),
    FinancialLog(
      id: '102',
      description: 'Apartment Rent',
      amount: 25000.00,
      type: 'expense',
      category: 'Rent',
      date: DateTime(2025, 7, 4),
      notes: 'Monthly rent for office space',
    ),
    FinancialLog(
      id: '103',
      description: 'Electricity Bill',
      amount: 8500.00,
      type: 'expense',
      category: 'Utilities',
      date: DateTime(2025, 7, 8),
    ),
    FinancialLog(
      id: '104',
      description: 'Consulting Fee',
      amount: 125000.00,
      type: 'income',
      category: 'Other',
      date: DateTime(2025, 7, 12),
      notes: 'Business strategy consultation',
    ),
    FinancialLog(
      id: '105',
      description: 'Broadband Subscription',
      amount: 4500.00,
      type: 'expense',
      category: 'Utilities',
      date: DateTime(2025, 7, 15),
    ),
    FinancialLog(
      id: '106',
      description: 'Salary Payment',
      amount: 350000.00,
      type: 'income',
      category: 'Salary',
      date: DateTime(2025, 7, 20),
      notes: 'August salary',
    ),
    FinancialLog(
      id: '107',
      description: 'Stationery Purchase',
      amount: 12000.00,
      type: 'expense',
      category: 'Other',
      date: DateTime(2025, 7, 22),
    ),
    FinancialLog(
      id: '108',
      description: 'Investment Returns',
      amount: 50000.00,
      type: 'income',
      category: 'Other',
      date: DateTime(2025, 7, 25),
      notes: 'Mutual fund dividends',
    ),
    FinancialLog(
      id: '109',
      description: 'Water Bill',
      amount: 3000.00,
      type: 'expense',
      category: 'Utilities',
      date: DateTime(2025, 7, 28),
    ),
    FinancialLog(
      id: '110',
      description: 'Performance Bonus',
      amount: 100000.00,
      type: 'income',
      category: 'Salary',
      date: DateTime(2025, 6, 30),
      notes: 'Q2 performance bonus',
    ),
    FinancialLog(
      id: '111',
      description: 'Travel Expenses',
      amount: 18000.00,
      type: 'expense',
      category: 'Other',
      date: DateTime(2025, 6, 25),
      notes: 'Client meeting travel',
    ),
    FinancialLog(
      id: '112',
      description: 'Software Subscription',
      amount: 25000.00,
      type: 'expense',
      category: 'Other',
      date: DateTime(2025, 6, 20),
      notes: 'Accounting software renewal',
    ),
  ];

  static final List<Invoice> _invoices = [
    Invoice(
      id: 'INV101',
      clientName: 'Rahul Sharma',
      clientEmail: 'rahul.sharma@example.com',
      clientAddress: '45 Park Road, Bengaluru',
      description: 'Tax Filing Services',
      amount: 95000.00,
      dueDate: DateTime(2025, 8, 10),
      createdDate: DateTime(2025, 7, 2),
      status: 'draft',
      notes: 'Personal income tax return',
    ),
    Invoice(
      id: 'INV102',
      clientName: 'Priya Patel',
      clientEmail: 'priya.patel@example.com',
      clientAddress: '12 MG Road, Ahmedabad',
      description: 'Bookkeeping Services',
      amount: 45000.00,
      dueDate: DateTime(2025, 7, 31),
      createdDate: DateTime(2025, 7, 5),
      status: 'sent',
    ),
    Invoice(
      id: 'INV103',
      clientName: 'Vikram Singh',
      clientEmail: 'vikram.singh@example.com',
      description: 'Financial Audit',
      amount: 175000.00,
      dueDate: DateTime(2025, 7, 20),
      createdDate: DateTime(2025, 6, 20),
      status: 'paid',
      notes: 'Annual audit for small business',
    ),
    Invoice(
      id: 'INV104',
      clientName: 'Anita Gupta',
      clientEmail: 'anita.gupta@example.com',
      clientAddress: '78 Residency Road, Hyderabad',
      description: 'Payroll Services',
      amount: 35000.00,
      dueDate: DateTime(2025, 8, 15),
      createdDate: DateTime(2025, 7, 10),
      status: 'draft',
    ),
    Invoice(
      id: 'INV105',
      clientName: 'Tech Innovate',
      clientEmail: 'billing@techinnovate.in',
      clientAddress: '101 IT Park, Pune',
      description: 'GST Compliance',
      amount: 120000.00,
      dueDate: DateTime(2025, 7, 25),
      createdDate: DateTime(2025, 7, 1),
      status: 'sent',
      notes: 'Monthly GST filing',
    ),
    Invoice(
      id: 'INV106',
      clientName: 'Suresh Kumar',
      clientEmail: 'suresh.kumar@example.com',
      description: 'Financial Consulting',
      amount: 80000.00,
      dueDate: DateTime(2025, 8, 5),
      createdDate: DateTime(2025, 7, 15),
      status: 'draft',
    ),
    Invoice(
      id: 'INV107',
      clientName: 'Neha Verma',
      clientEmail: 'neha.verma@example.com',
      clientAddress: '23 Connaught Place, Delhi',
      description: 'Tax Planning',
      amount: 65000.00,
      dueDate: DateTime(2025, 7, 15),
      createdDate: DateTime(2025, 6, 15),
      status: 'overdue',
      notes: 'Tax optimization strategy',
    ),
    Invoice(
      id: 'INV108',
      clientName: 'Blue Horizon Ltd',
      clientEmail: 'accounts@bluehorizon.in',
      clientAddress: '56 Marine Drive, Mumbai',
      description: 'Budget Planning',
      amount: 150000.00,
      dueDate: DateTime(2025, 8, 20),
      createdDate: DateTime(2025, 7, 20),
      status: 'draft',
    ),
    Invoice(
      id: 'INV109',
      clientName: 'Kiran Desai',
      clientEmail: 'kiran.desai@example.com',
      description: 'Investment Advisory',
      amount: 90000.00,
      dueDate: DateTime(2025, 7, 28),
      createdDate: DateTime(2025, 7, 3),
      status: 'sent',
    ),
    Invoice(
      id: 'INV110',
      clientName: 'Green Fields Inc',
      clientEmail: 'finance@greenfields.in',
      clientAddress: '89 Sector 18, Gurgaon',
      description: 'Financial Reporting',
      amount: 110000.00,
      dueDate: DateTime(2025, 8, 1),
      createdDate: DateTime(2025, 7, 5),
      status: 'paid',
      notes: 'Quarterly financial report',
    ),
    Invoice(
      id: 'INV111',
      clientName: 'Arjun Mehra',
      clientEmail: 'arjun.mehra@example.com',
      description: 'Audit Support',
      amount: 85000.00,
      dueDate: DateTime(2025, 8, 12),
      createdDate: DateTime(2025, 7, 8),
      status: 'draft',
    ),
    Invoice(
      id: 'INV112',
      clientName: 'Star Enterprises',
      clientEmail: 'billing@starent.in',
      clientAddress: '34 Koramangala, Bengaluru',
      description: 'Accounting Setup',
      amount: 130000.00,
      dueDate: DateTime(2025, 7, 30),
      createdDate: DateTime(2025, 7, 1),
      status: 'sent',
      notes: 'New accounting system implementation',
    ),
  ];

  Future<List<FinancialLog>> getFinancialLogs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_financialLogs);
  }

  Future<void> addFinancialLog(FinancialLog log) async {
    print('Adding log: ${log.toString()}');
    _financialLogs.add(log);
    print('Log added successfully. Total logs: ${_financialLogs.length}');
  }

  Future<void> deleteFinancialLog(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _financialLogs.removeWhere((log) => log.id == id);
  }

  Future<List<Invoice>> getInvoices() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_invoices);
  }

  Future<void> addInvoice(Invoice invoice) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _invoices.add(invoice);
  }

  Future<void> sendInvoice(String invoiceId, String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    print('Sending invoice $invoiceId to $email');
    final invoice = _invoices.firstWhere((inv) => inv.id == invoiceId);
    invoice.status = 'sent';
  }

  Future<void> verifyPayment(String invoiceId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Verifying payment for invoice $invoiceId');
    final invoice = _invoices.firstWhere((inv) => inv.id == invoiceId);
    invoice.status = 'paid';
  }
}