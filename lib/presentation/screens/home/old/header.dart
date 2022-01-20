import 'package:budgets/presentation/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_screen_cubit.dart';

class HomeHeader extends SliverPersistentHeader {
  HomeHeader() : super(delegate: HeaderDelegate());
}

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Header();
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  double get maxExtent => 235;

  @override
  double get minExtent => 235;
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: kDefaultPadding),
          height: 205,
          color: AppColors.greyBackground,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  top: kDefaultPadding,
                  bottom: kDefaultPadding,
                ),
                height: 170,
                width: size.width,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(60),
                  //   bottomRight: Radius.circular(60),
                  // ),
                ),
              ),
              Positioned(
                top: 0,
                left: 25,
                child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
                  builder: (_, state) {
                    if (state.isLoading) {
                      return CircularProgressIndicator.adaptive();
                    } else {
                      return Text(
                        'Hi ${state.userName!.value.split(' ')[0]}!',
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
