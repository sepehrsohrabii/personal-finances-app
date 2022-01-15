import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/colors.dart';
import '../../routes/app_navigator.dart';
import 'categories_cubit/categories_screen_cubit.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late CategoriesScreenCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<CategoriesScreenCubit>();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesScreenCubit, CategoriesScreenState>(
      builder: _buildState,
    );
  }

  Widget _buildState(BuildContext context, CategoriesScreenState state) {
    return Scaffold(
      body: CupertinoPageScaffold(
        backgroundColor: AppColors.greyBackground,
        child: NestedScrollView(
          headerSliverBuilder: (ctx, inner) => [
            CupertinoSliverNavigationBar(
              largeTitle: Text('Categorías'),
              previousPageTitle: 'Ajustes',
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      AppNavigator.navigateToEditCategoryPage(
                        context,
                        (_) => cubit.getUserCategories(),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
          body: _buildBody(context, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CategoriesScreenState state) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return FutureBuilder(
        future: cubit.getUserCategories(),
        builder: (context, snapshot) {
          final categories = state.categories;
          return ListView.separated(
            padding: EdgeInsets.only(top: 8),
            itemCount: state.categories.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 2),
            itemBuilder: (BuildContext context, int index) {
              final category = categories[index];
              return ListTile(
                title: Text(categories[index].name),
                leading: CircleAvatar(
                  maxRadius: 20,
                  child: Icon(
                    IconData(
                      category.icon,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: AppColors.white,
                  ),
                  backgroundColor: Color(category.color),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => AppNavigator.navigateToEditCategoryPage(
                  context,
                  (_) => cubit.getUserCategories(),
                  category: category,
                ),
              );
            },
          );
        },
      );
    }
  }
}
