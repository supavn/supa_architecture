import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supa_architecture/blocs/authentication/authentication_bloc.dart';

class TenantSelectionScreen extends StatelessWidget {
  final List<dynamic> tenants;

  const TenantSelectionScreen({
    super.key,
    required this.tenants,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Organization'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select an organization to continue:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tenants.length,
                itemBuilder: (context, index) {
                  final tenant = tenants[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.business),
                      title: Text(tenant.name ?? 'Organization ${index + 1}'),
                      subtitle: tenant.description != null
                          ? Text(tenant.description!)
                          : null,
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.read<AuthenticationBloc>().add(
                              LoginWithSelectedTenantEvent(tenant: tenant),
                            );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
