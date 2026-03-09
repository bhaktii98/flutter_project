import 'package:flutter/material.dart';

import '../../../../core/res/app_colors.dart';
import '../../../../core/res/app_text_styles.dart';
import 'sign_in_page.dart';

class AuthLandingPage extends StatefulWidget {
  const AuthLandingPage({super.key});

  static const String routeName = '/auth-landing';

  @override
  State<AuthLandingPage> createState() => _AuthLandingPageState();
}

class _AuthLandingPageState extends State<AuthLandingPage>
    with TickerProviderStateMixin {
  late final AnimationController _bottomMenuHeightAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  late final Animation<double> _bottomMenuHeightUpAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(
        0,
        0.6,
        curve: Curves.easeInOut,
      ),
    ),
  );

  late final Animation<double> _bottomMenuHeightDownAnimation =
      Tween<double>(
    begin: 0,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(
        0.6,
        1,
        curve: Curves.easeInOut,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _bottomMenuHeightAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _bottomMenuHeightAnimationController.dispose();
    super.dispose();
  }

  Widget _buildTopIllustration() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: const Icon(
          Icons.dashboard_customize_outlined,
          size: 120,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _bottomMenuHeightAnimationController,
        builder: (context, child) {
          final height =
              MediaQuery.of(context).size.height *
                  0.3 *
                  _bottomMenuHeightUpAnimation.value -
          MediaQuery.of(context).size.height *
              0.05 *
              _bottomMenuHeightDownAnimation.value;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: AnimatedSwitcher(
              switchInCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 400),
              child: _bottomMenuHeightAnimationController.value != 1
                  ? const SizedBox()
                  : LayoutBuilder(
                      builder: (context, boxConstraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 9,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.view_kanban,
                                    color: AppColors.themeColor,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Jira Todo',
                                  style: AppTextStyles.h2,
                                ),
                              ],
                            ),
                            SizedBox(
                                height: boxConstraints.maxHeight * 0.05),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  backgroundColor: AppColors.themeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    SignInPage.routeName,
                                  );
                                },
                                child: const Text(
                                  'Login',
                                  style: AppTextStyles.button,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Stack(
        children: [
          _buildTopIllustration(),
          _buildBottomMenu(),
        ],
      ),
    );
  }
}


