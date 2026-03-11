// frontend/lib/features/admin_panel/presentation/screens/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/admin_panel/presentation/providers/admin_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Панель администратора'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(adminProvider.notifier).loadAdminData(),
          ),
        ],
      ),
      body: state.isLoading && state.stats == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsGrid(state.stats),
                  const SizedBox(height: 32),
                  _buildTabs(context, state),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic>? stats) {
    if (stats == null) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Пользователи', '${stats['total_users']} / ${stats['user_limit']}', Icons.people, Colors.blue),
        _buildStatCard('Курсы', '${stats['total_courses']}', Icons.school, Colors.green),
        _buildStatCard('Записи', '${stats['total_enrollments']}', Icons.assignment, Colors.orange),
        _buildStatCard('Лист ожидания', '${stats['waitlist_count']}', Icons.hourglass_empty, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context, AdminState state) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TabBar(
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Пользователи'),
              Tab(text: 'Лист ожидания'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildUserList(state.users),
                _buildWaitlist(state.waitlist),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(List users) {
    if (users.isEmpty) return const Center(child: Text('Нет пользователей'));
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(user.email),
          subtitle: Text('Роль: ${user.role}'),
          trailing: const Icon(Icons.more_vert),
        );
      },
    );
  }

  Widget _buildWaitlist(List waitlist) {
    if (waitlist.isEmpty) return const Center(child: Text('Лист ожидания пуст'));
    return ListView.builder(
      itemCount: waitlist.length,
      itemBuilder: (context, index) {
        final entry = waitlist[index];
        return ListTile(
          leading: const Icon(Icons.mail_outline),
          title: Text(entry['email']),
          subtitle: Text('Добавлен: ${entry['added_at']}'),
          trailing: IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () {
              // TODO: Logic to approve waitlist entry
            },
          ),
        );
      },
    );
  }
}
