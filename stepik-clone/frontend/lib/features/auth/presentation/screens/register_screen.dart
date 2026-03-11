// frontend/lib/features/auth/presentation/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stepik_clone/features/auth/presentation/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null && next.error!.isNotEmpty && !next.isWaitlisted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
      if (next.token != null) {
        context.go('/dashboard');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: authState.isWaitlisted
          ? _buildWaitlistUI(authState.error)
          : _buildRegisterForm(authState.isLoading),
    );
  }

  Widget _buildRegisterForm(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Пароль', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          if (isLoading)
            const CircularProgressIndicator()
          else
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).register(
                  _emailController.text,
                  _passwordController.text,
                );
              },
              child: const Text('Зарегистрироваться'),
            ),
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text('Уже есть аккаунт? Войти'),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitlistUI(String? errorMsg) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.group_off, size: 64, color: Colors.orange),
          const SizedBox(height: 16),
          Text(
            errorMsg ?? 'Достигнут лимит пользователей',
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            child: const Text('Вернуться ко входу'),
          )
        ],
      ),
    );
  }
}
