import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/screens/login_screen.dart';
import 'package:instagram_clone/features/feed/presentation/screens/feed_screen.dart';
import 'package:instagram_clone/features/post/presentation/screens/create_post_screen.dart';
import 'package:instagram_clone/features/post/presentation/screens/video_explore_tab.dart';
import 'package:instagram_clone/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:instagram_clone/features/profile/presentation/screens/profile_screen.dart';
import 'package:instagram_clone/features/common_widgets/app_bar.dart';
import 'package:instagram_clone/core/di/injection_container.dart' as di;

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // قائمة الشاشات لتجنب إعادة بنائها في كل مرة
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // تهيئة AnimationController
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // تهيئة قائمة الشاشات مرة واحدة
    // هذا يتطلب أن يكون state.user متاحاً هنا، سنقوم بتمريره لاحقاً
    // في هذا المثال، سنقوم ببناء ProfileScreen داخل BlocBuilder
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _animationController.forward().then((_) {
        setState(() {
          _selectedIndex = index;
        });
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // **التعديل الأول: إضافة SafeArea حول BlocConsumer**
    // هذا يضمن أن التطبيق بأكمله (بما في ذلك شاشة التحميل) لا يتداخل مع شريط الحالة
    return SafeArea(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            // التأكد من أن الانتقال يحدث خارج الـ build method
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            });
          }
        },
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;
            // **التعديل الثاني: تم نقل Scaffold إلى هنا**
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: _getAppBarForScreen(_selectedIndex),
              body: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: [
                        const FeedScreen(),
                        const CreatePostScreen(),
                        VideoExploreTab(),
                        // لا يزال من الضروري حل مشكلة get_it هنا
                        BlocProvider<ProfileBloc>(
                          create: (_) => di.sl<ProfileBloc>(),
                          child: ProfileScreen(userId: user.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
              bottomNavigationBar: _buildInstagramBottomNavBar(),
            );
          }
          // شاشة التحميل
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF262626)),
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget? _getAppBarForScreen(int index) {
    // بناء AppBar بناءً على الشاشة المحددة
    switch (index) {
      case 0: // Feed Screen
        return const CustomAppBar(
          title: 'Instagram',
          showDefaultActions: true,
        );
      case 1: // Create Post Screen
        return const CustomAppBar(
          title: 'New Post',
          showDefaultActions: false,
          showBackButton: true,
        );
      case 2: // Video Explore Screen
        return const CustomAppBar(
          title: 'Reels',
          showDefaultActions: false,
        );
      case 3: // Profile Screen
        // يمكنك تخصيص شريط الملف الشخصي هنا إذا أردت
        return const CustomAppBar(
          title: 'Profile',
          showDefaultActions: false,
        );
      default:
        return null; // لا يوجد شريط علوي للشاشات الأخرى
    }
  }

  Widget _buildInstagramBottomNavBar() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFDBDBDB),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.home_outlined,
            filledIcon: Icons.home,
            index: 0,
            label: 'Home',
          ),
          _buildNavItem(
            icon: Icons.add_box_outlined,
            filledIcon: Icons.add_box,
            index: 1,
            label: 'Create',
          ),
          _buildNavItem(
            icon: Icons.video_collection_outlined,
            filledIcon: Icons.video_collection,
            index: 2,
            label: 'Reels',
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            filledIcon: Icons.person,
            index: 3,
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData filledIcon,
    required int index,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? filledIcon : icon,
              size: 28,
              color: isSelected
                  ? const Color(0xFF262626)
                  : const Color(0xFF8E8E8E),
            ),
            const SizedBox(height: 4),
            // يمكنك إزالة النقطة أو الإبقاء عليها حسب التصميم
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: isSelected ? 2 : 0,
              width: 20,
              color: const Color(0xFF262626),
            ),
          ],
        ),
      ),
    );
  }
}
