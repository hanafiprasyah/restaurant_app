import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/model/restaurant.dart';

class DetailPage extends StatelessWidget {
  final Restaurant data;
  const DetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              expandedHeight: 220,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                title: null,
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                background: Hero(
                  tag: data.id,
                  transitionOnUserGestures: true,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24)),
                    child: Image.network(
                      data.pictureId,
                      fit: BoxFit.cover,
                      isAntiAlias: true,
                      filterQuality: FilterQuality.medium,
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
               * 3. Restaurant Location
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
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                          data.name,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                        ),
                        const SizedBox(height: 4),

                        /// Location with icon on Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              data.city,
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(Icons.pin_drop,
                                  color: Colors.grey, size: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// Space
              const SizedBox(height: 16),

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
                      data.description,
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
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth > 768 ? 4 : 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2),
                    reverse: false,
                    addRepaintBoundaries: true,
                    scrollDirection: Axis.vertical,
                    itemCount: (data.menus.foods.length),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        child:
                            Center(child: Text(data.menus.foods[index].name)),
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
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth > 768 ? 4 : 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2),
                    reverse: false,
                    addRepaintBoundaries: true,
                    scrollDirection: Axis.vertical,
                    itemCount: (data.menus.drinks.length),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        child:
                            Center(child: Text(data.menus.drinks[index].name)),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
