import 'package:flutter/material.dart';
import 'package:role_based_app/admin/controllers/company_controller.dart';

class AdminAppBarTitle extends StatelessWidget {
  final String pageTitle;
  const AdminAppBarTitle({super.key, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Company?>
      (
      future: CompanyController.getCurrentCompany(),
      builder: (context, snapshot) {
        final company = snapshot.data;
        final logoUrl = company?.logoUrl;
        final companyName = (company?.name?.isNotEmpty == true) ? company!.name : 'Company';

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Logo(logoUrl: logoUrl, fallbackChar: companyName.isNotEmpty ? companyName[0].toUpperCase() : 'C'),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  companyName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  pageTitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Logo extends StatelessWidget {
  final String? logoUrl;
  final String fallbackChar;
  const _Logo({required this.logoUrl, required this.fallbackChar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: (logoUrl != null && logoUrl!.isNotEmpty)
          ? Image.network(
              logoUrl!,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => _fallback(),
            )
          : _fallback(),
    );
  }

  Widget _fallback() {
    return Center(
      child: Text(
        fallbackChar,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
