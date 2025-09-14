import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../constants/colors.dart';
import '../../authpage/auth_services.dart';
import 'admin_dashboard.dart';

// Company data structure matching backend API
class Company {
  final String id;
  final String name;
  final String description;
  final String? logoUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Company({
    required this.id,
    required this.name,
    required this.description,
    this.logoUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      logoUrl: json['logoUrl'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class CompanySelection {
  static Company? selectedCompany;
  static Company? currentCompany;
}

class CompanySelectionScreen extends StatefulWidget {
  const CompanySelectionScreen({Key? key}) : super(key: key);

  @override
  State<CompanySelectionScreen> createState() => _CompanySelectionScreenState();
}

class _CompanySelectionScreenState extends State<CompanySelectionScreen> {
  List<Company> companies = [];
  bool isLoading = true;
  String? errorMessage;
  Company? currentCompany;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
    _loadCurrentCompany();
  }

  Future<void> _loadCompanies() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await AuthService().dio.get('/admin/companies');

      if (response.statusCode == 200) {
        final List<dynamic> companiesData = response.data;
        setState(() {
          companies = companiesData
              .map((json) => Company.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load companies';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading companies: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _loadCurrentCompany() async {
    try {
      final response = await AuthService().dio.get('/admin/companies/current');

      if (response.statusCode == 200) {
        setState(() {
          currentCompany = Company.fromJson(response.data['company']);
        });
      }
    } catch (e) {
      // Current company might not be set, which is okay
      print('No current company set: $e');
    }
  }

  Future<void> _switchCompany(Company company) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await AuthService().dio.post(
        '/admin/companies/${company.id}/switch',
      );

      if (response.statusCode == 200) {
        // Update the selected company
        CompanySelection.selectedCompany = company;
        CompanySelection.currentCompany = company;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Switched to ${company.name}'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to admin dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
        );
      } else {
        setState(() {
          errorMessage = 'Failed to switch company';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error switching company: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Company'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCompanies,
          ),
        ],
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome, Admin!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please select a company to manage:',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              if (currentCompany != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Current: ${currentCompany!.name}',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Expanded(child: _buildContent()),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCompanies,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (companies.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No companies available',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        final isCurrentCompany = currentCompany?.id == company.id;

        return _buildCompanyCard(company, isCurrentCompany);
      },
    );
  }

  Widget _buildCompanyCard(Company company, bool isCurrentCompany) {
    return Card(
      elevation: isCurrentCompany ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrentCompany
            ? const BorderSide(color: Colors.green, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isLoading ? null : () => _switchCompany(company),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: isCurrentCompany
                  ? [Colors.green, Colors.green.shade700]
                  : [AppColors.primaryBlue, AppColors.secondaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCurrentCompany) ...[
                const Icon(Icons.check_circle, color: Colors.white, size: 24),
                const SizedBox(height: 8),
              ],
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: company.logoUrl != null && company.logoUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          company.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.business,
                              color: Colors.white,
                              size: 30,
                            );
                          },
                        ),
                      )
                    : const Icon(Icons.business, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 8),
              Text(
                company.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (company.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  company.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (isCurrentCompany) ...[
                const SizedBox(height: 8),
                const Text(
                  'CURRENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
