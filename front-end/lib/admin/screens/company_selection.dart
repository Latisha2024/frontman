import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'admin_dashboard.dart';
import '../controllers/company_controller.dart';
import '../controllers/manage_users.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final data = await CompanyController.getCompanies();

      // Try to ensure we also show the current or last selected company even if inactive
      Company? current;
      try {
        current = await CompanyController.getCurrentCompany();
      } catch (_) {}

      final merged = [...data];
      // Merge current company if not in list
      if (current != null && !merged.any((c) => c.id == current!.id)) {
        merged.insert(0, current);
      }

      // Also merge last selected company if available and not in list
      final lastSelected = CompanySelection.selectedCompany;
      if (lastSelected != null && !merged.any((c) => c.id == lastSelected.id)) {
        try {
          final latest = await CompanyController.getCompanyById(lastSelected.id);
          merged.insert(0, latest);
        } catch (_) {
          merged.insert(0, lastSelected);
        }
      }

      setState(() {
        companies = merged;
        currentCompany = current ?? currentCompany;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading companies: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _loadCurrentCompany() async {
    try {
      final c = await CompanyController.getCurrentCompany();
      if (!mounted) return;
      setState(() {
        currentCompany = c;
      });
    } catch (e) {
      // It's fine if current company is not set
    }
  }

  Future<void> _switchCompany(Company company) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      await CompanyController.switchCompany(company.id);
      CompanySelection.selectedCompany = company;
      CompanySelection.currentCompany = company;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to ${company.name}'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
      );
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
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Sign out',
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('auth_token');
            if (!context.mounted) return;
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCompanies,
          ),
          IconButton(
            icon: const Icon(Icons.add_business),
            tooltip: 'Create Company',
            onPressed: () => _showCreateOrEditDialog(),
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
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
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

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        final isCurrent = currentCompany?.id == company.id;
        return _buildCompanyCard(company, isCurrent);
      },
    );
  }

  Widget _buildCompanyCard(Company company, bool isCurrentCompany) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.backgroundGray.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: isCurrentCompany
            ? Border.all(color: Colors.green.withOpacity(0.6), width: 1)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.secondaryBlue,
                  radius: 25,
                  child: company.logoUrl != null && company.logoUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            company.logoUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                company.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              );
                            },
                          ),
                        )
                      : Text(
                          company.name.isNotEmpty ? company.name.substring(0, 1).toUpperCase() : 'C',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              company.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          buildActiveChip(company.isActive),
                          if (isCurrentCompany) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green.withOpacity(0.3)),
                              ),
                              child: const Text(
                                'CURRENT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (company.description.isNotEmpty)
                        Text(
                          company.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : () => _showViewDialog(company),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.textPrimary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : () => _showCreateOrEditDialog(existing: company),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.textPrimary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : () => _showAssignAdminDialog(company),
                    icon: const Icon(Icons.person_add, size: 16),
                    label: const Text('Assign'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.textPrimary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : () => _confirmDelete(company),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : () => _switchCompany(company),
                icon: const Icon(Icons.swap_horiz, size: 16),
                label: const Text('Select this company'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActiveChip(bool isActive) {
    final color = isActive ? AppColors.success : AppColors.textSecondary;
    final icon = isActive ? Icons.check_circle : Icons.circle;
    final text = isActive ? 'ACTIVE' : 'INACTIVE';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateOrEditDialog({Company? existing}) async {
    // Initialize with provided values
    final nameController = TextEditingController(text: existing?.name ?? '');
    final descController = TextEditingController(text: existing?.description ?? '');
    final logoController = TextEditingController(text: existing?.logoUrl ?? '');
    final formKey = GlobalKey<FormState>();
    bool isActive = existing?.isActive ?? true;

    // If editing, try to hydrate from backend to avoid stale values (especially isActive)
    if (existing != null) {
      try {
        final latest = await CompanyController.getCompanyById(existing.id);
        nameController.text = latest.name;
        descController.text = latest.description;
        logoController.text = latest.logoUrl ?? '';
        isActive = latest.isActive;
      } catch (_) {
        // fallback to existing values if fetch fails
      }
    }

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) => AlertDialog(
            title: Text(existing == null ? 'Create Company' : 'Edit Company'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                    ),
                    TextFormField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 2,
                    ),
                    TextFormField(
                      controller: logoController,
                      decoration: const InputDecoration(labelText: 'Logo URL'),
                    ),
                    if (existing != null)
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Active'),
                        value: isActive,
                        onChanged: (v) => setStateDialog(() => isActive = v),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  try {
                    setState(() => isLoading = true);
                    Company saved;
                    if (existing == null) {
                      saved = await CompanyController.createCompany(
                        name: nameController.text,
                        description: descController.text,
                        logoUrl: logoController.text.isNotEmpty ? logoController.text : null,
                      );
                    } else {
                      saved = await CompanyController.updateCompany(
                        id: existing.id,
                        name: nameController.text,
                        description: descController.text,
                        logoUrl: logoController.text.isNotEmpty ? logoController.text : null,
                        isActive: isActive,
                      );
                    }
                    CompanySelection.selectedCompany = saved;
                    if (mounted) Navigator.pop(ctx);
                    await _loadCompanies();
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                    );
                  } finally {
                    if (mounted) setState(() => isLoading = false);
                  }
                },
                child: Text(existing == null ? 'Create' : 'Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(Company company) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Company'),
        content: Text('Are you sure you want to delete "${company.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      setState(() => isLoading = true);
      await CompanyController.deleteCompany(company.id);
      await _loadCompanies();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company deleted'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _showAssignAdminDialog(Company company) async {
    final queryController = TextEditingController();
    final usersController = AdminManageUsersController();
    List<User> results = [];
    User? selected;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) => AlertDialog(
            title: Text('Assign Admin to ${company.name}')
                ,
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: queryController,
                    decoration: const InputDecoration(
                      labelText: 'Search by username',
                      hintText: 'Type username to search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) async {
                      final list = await usersController.searchUsersApi(queryController.text);
                      final q = queryController.text.trim().toLowerCase();
                      final filtered = list.where((u) => u.name.toLowerCase().contains(q)).toList();
                      setStateDialog(() => results = filtered);
                    },
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final list = await usersController.searchUsersApi(queryController.text);
                        final q = queryController.text.trim().toLowerCase();
                        final filtered = list.where((u) => u.name.toLowerCase().contains(q)).toList();
                        setStateDialog(() => results = filtered);
                      },
                      icon: const Icon(Icons.search, size: 16),
                      label: const Text('Search'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: results.isEmpty
                        ? Text(
                            'No results',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final user = results[index];
                              return ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.secondaryBlue,
                                  child: Text(
                                    user.name.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(user.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                subtitle: Text(user.email, style: const TextStyle(fontSize: 12)),
                                trailing: selected?.id == user.id
                                    ? const Icon(Icons.check, color: Colors.green)
                                    : TextButton(
                                        onPressed: () => setStateDialog(() => selected = user),
                                        child: const Text('Select'),
                                      ),
                                onTap: () => setStateDialog(() => selected = user),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: selected == null
                    ? null
                    : () async {
                        try {
                          setState(() => isLoading = true);
                          await CompanyController.assignAdminToCompany(
                            companyId: company.id,
                            adminId: selected!.id,
                          );
                          if (mounted) Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Assigned ${selected!.name} to ${company.name}'), backgroundColor: Colors.green),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                          );
                        } finally {
                          if (mounted) setState(() => isLoading = false);
                        }
                      },
                child: const Text('Assign'),
              ),
            ],
          ),
        );
      },
    );
    usersController.dispose();
  }

  Future<void> _showViewDialog(Company company) async {
    // Optionally fetch latest details by ID
    Company detailed = company;
    try {
      detailed = await CompanyController.getCompanyById(company.id);
    } catch (_) {}

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(detailed.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (detailed.logoUrl != null && detailed.logoUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(detailed.logoUrl!, height: 80, fit: BoxFit.cover),
                ),
              ),
            Text('Description: ${detailed.description.isNotEmpty ? detailed.description : '-'}'),
            const SizedBox(height: 8),
            Text('Active: ${detailed.isActive ? 'Yes' : 'No'}'),
            if (detailed.createdAt != null) ...[
              const SizedBox(height: 8),
              Text('Created: ${detailed.createdAt}'),
            ],
            if (detailed.updatedAt != null) ...[
              const SizedBox(height: 4),
              Text('Updated: ${detailed.updatedAt}'),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          TextButton(onPressed: () { Navigator.pop(ctx); _showCreateOrEditDialog(existing: detailed); }, child: const Text('Edit')),
        ],
      ),
    );
  }
}