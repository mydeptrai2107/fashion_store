import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:flutter/material.dart';

class ProductContainer extends StatelessWidget {
  final String title, subtitle, price;
  final String id;
  final String imagelink;
  final IconButton fav;
  final int quantity;
  const ProductContainer({
    super.key,
    this.title = 'Best Seller',
    required this.subtitle,
    required this.imagelink,
    required this.price,
    required this.id,
    required this.quantity,
    required this.fav,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.all(
          Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(16),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(imagelink),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(top: 0, right: 0, child: fav),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColor.backgroundColor,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: 'Raleway-Medium',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///
class CartContainer extends StatelessWidget {
  final String imagelink;
  final String title;
  final String subtitle;
  final String price;

  const CartContainer({
    super.key,
    required this.imagelink,
    required this.price,
    required this.subtitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.all(
          Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.all(
                  Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(imagelink),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColor.backgroundColor,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: 'Raleway-Medium',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowProductContainer extends StatelessWidget {
  final String title, subtitle, price;
  final String imagelink;
  final IconButton fav;
  final int quantity;
  final VoidCallback onclick;

  const ShowProductContainer(
      {super.key,
      this.title = 'Best Seller',
      required this.subtitle,
      required this.imagelink,
      required this.price,
      required this.quantity,
      required this.fav,
      required this.onclick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onclick,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(12))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.all(
                          Radius.circular(16),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(imagelink),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(top: 0, right: 0, child: fav),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColor.backgroundColor),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        fontFamily: 'Raleway-Medium',
                        fontSize: 17,
                        color: Colors.black),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
