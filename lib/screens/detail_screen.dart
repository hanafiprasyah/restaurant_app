import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/models/restaurants/restaurant.dart';
import 'package:restaurant_app/services/data_provider.dart';

class DetailPage extends StatefulWidget {
  final RestaurantElement data;
  const DetailPage({super.key, required this.data});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final options = const LiveOptions(
    delay: Duration.zero,
    showItemInterval: Duration(milliseconds: 250),
    showItemDuration: Duration(milliseconds: 250),
    visibleFraction: 0.025,
    reAnimateOnVisibility: false,
  );

  @override
  void initState() {
    super.initState();
    Provider.of<RestaurantDetailProvider>(context, listen: false)
        .getDetailData(widget.data.id);
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<RestaurantDetailProvider>(context);
    return Scaffold(
      body: data.loading
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.indigo, size: 15),
            )
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: false,
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        MotionToast.info(
                          title: Text("My Apologize",
                              style: GoogleFonts.quicksand()),
                          description: Text(
                            "This feature will be coming soon!",
                            style: GoogleFonts.quicksand(),
                          ),
                          dismissable: true,
                          position: MotionToastPosition.top,
                          animationType: AnimationType.fromTop,
                          animationDuration: const Duration(milliseconds: 750),
                        ).show(context);
                      },
                      icon: const Icon(Icons.favorite, color: Colors.redAccent),
                      iconSize: 32,
                    ),
                    expandedHeight: 220,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      title: null,
                      titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                      background: Hero(
                        tag: widget.data.id,
                        transitionOnUserGestures: true,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(24),
                              bottomLeft: Radius.circular(24)),
                          child: Image.network(
                            "https://restaurant-api.dicoding.dev/images/medium/${widget.data.pictureId}",
                            fit: BoxFit.cover,
                            isAntiAlias: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    /**
                     * Header on Row :
                     * 1. Back Button
                     * 2. Restaurant Name
                     * 3. Restaurant Categories
                     */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /**
                         * Back Button
                         */
                        InkWell(
                          onTap: () => Navigator.pop(context, true),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Back',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// Restaurant name & location
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.data.name,
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                              ),
                              const SizedBox(height: 4),

                              /// Categories on Chips design
                              data.data.categories!.isNotEmpty
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                        data.data.categories!.length,
                                        (index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                                color: Colors.indigo,
                                                border: Border.all(width: 0),
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: Text(
                                                data.data.categories![index]
                                                    .name,
                                                style: GoogleFonts.quicksand(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Text(
                                      'This categories is empty.',
                                      style: GoogleFonts.quicksand(),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// About restaurant (Description)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Title
                          Text(
                            'Address',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                          ),
                          const SizedBox(height: 8),

                          /// Address
                          data.data.address!.isNotEmpty
                              ? Text(
                                  '${data.data.address!}, ${data.data.city}',
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  maxLines: 6,
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.clip,
                                )
                              : Text(
                                  'This categories is empty.',
                                  style: GoogleFonts.quicksand(),
                                ),
                        ],
                      ),
                    ),

                    /// Space
                    const SizedBox(height: 16),

                    /// Space
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Title
                          Text(
                            'About',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          const SizedBox(height: 8),

                          /// Description
                          Text(
                            widget.data.description,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            maxLines: 6,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ),

                    /// Space
                    const SizedBox(height: 16),
                    /**
                     * Menus
                     *  - Foods
                     *  - Drinks
                     */
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        'Menus',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),

                    /// Space
                    const SizedBox(height: 16),

                    /// Food list
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Our Foods',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          const Expanded(
                            child: Divider(
                              indent: 8,
                              endIndent: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Space
                    const SizedBox(height: 8),

                    /**
                     * Responsive Grid for Foods
                     * Show 4 axis if constraint max width more than 768 (tablet)
                     */
                    data.loading
                        ? Center(
                            child: LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.indigo, size: 15),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              return LiveGrid.options(
                                options: options,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            constraints.maxWidth > 768 ? 4 : 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 2),
                                reverse: false,
                                addRepaintBoundaries: true,
                                scrollDirection: Axis.vertical,
                                itemCount: (data.data.menus!.foods.length),
                                itemBuilder: (context, index, animation) {
                                  return FadeTransition(
                                    opacity: Tween<double>(
                                      begin: 0,
                                      end: 1,
                                    ).animate(animation),
                                    // And slide transition
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, -0.1),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      // Paste you Widget
                                      child: Card(
                                        elevation: 4,
                                        child: Center(
                                            child: Text(data.data.menus!
                                                .foods[index].name)),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                    /// Drink list
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Our Drinks',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          const Expanded(
                            child: Divider(
                              indent: 8,
                              endIndent: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Space
                    const SizedBox(height: 8),
                    /**
                     * Responsive Grid for Drinks
                     * Show 4 axis if constraint max width more than 768 (tablet)
                     */
                    data.loading
                        ? Center(
                            child: LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.indigo, size: 15),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              return LiveGrid.options(
                                options: options,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            constraints.maxWidth > 768 ? 4 : 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 2),
                                reverse: false,
                                addRepaintBoundaries: true,
                                scrollDirection: Axis.vertical,
                                itemCount: (data.data.menus!.drinks.length),
                                itemBuilder: (context, index, animation) {
                                  return FadeTransition(
                                    opacity: Tween<double>(
                                      begin: 0,
                                      end: 1,
                                    ).animate(animation),
                                    // And slide transition
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, -0.1),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      // Paste you Widget
                                      child: Card(
                                        elevation: 4,
                                        child: Center(
                                            child: Text(data.data.menus!
                                                .drinks[index].name)),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
