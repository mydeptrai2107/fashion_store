import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/round_button.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/dialog.dart';
import 'package:ecommerce_app/utils/formatter.dart';
import 'package:ecommerce_app/utils/general_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final auth = FirebaseAuth.instance;
  dynamic userdata;
  var phone = '';
  var email = '';
  String address = '';
  PersistentShoppingCart cart = PersistentShoppingCart();

  final db = FirebaseFirestore.instance.collection('User Data');
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();

  String paymentMethod = "cod";

  @override
  void initState() {
    fetchdata();

    super.initState();
  }

  Future fetchdata() async {
    try {
      DocumentSnapshot db2 = await db.doc(auth.currentUser!.uid).get();
      userdata = db2.data();
      setState(() {
        email = userdata['Email'];
      });
      phone = userdata['phone'];
      address = userdata['address'] ?? '';
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    final utils = Provider.of<GeneralUtils>(context);

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f9),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.cartscreen);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        backgroundColor: const Color(0xfff7f7f9),
        title: const Text('Thanh toán'),
        centerTitle: true,
        titleTextStyle: TextStyling.apptitle,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 17, right: 17, top: 25),
          child: Container(
            height: screenheight * 0.9,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Thông tin liên hệ',
                    style: TextStyle(
                      color: Color(0xff1A2530),
                      fontFamily: 'Raleway-Medium',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Image.asset('images/email.png'),
                      const SizedBox(
                        width: 17,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            email,
                            style: const TextStyle(
                              fontFamily: 'Poppins-Medium',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1A2530),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontFamily: 'Poppins-Medium',
                              fontSize: 12,
                              color: Color(0xff707BB1),
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: screenwidth * 0.01),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // ignore: sized_box_for_whitespace
                                    content: Container(
                                        height: 196,
                                        width: 335,
                                        child: Column(
                                          children: [
                                            const Text(
                                              'Enter Your Email',
                                              style: TextStyle(
                                                fontFamily: 'Raleway-Bold',
                                                fontSize: 16,
                                                color: Color(
                                                  0xff2B2B2B,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              controller: emailcontroller,
                                              decoration: InputDecoration(
                                                  hintText: 'Enter Email',
                                                  hintStyle:
                                                      TextStyling.hinttext,
                                                  filled: true,
                                                  fillColor:
                                                      const Color(0xffF7F7F9),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12))),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                utils.showloading(true);
                                                db
                                                    .doc(auth.currentUser!.uid)
                                                    .update({
                                                  'Email': emailcontroller.text
                                                      .toString()
                                                }).then((value) {
                                                  utils.showloading(false);
                                                  GeneralUtils()
                                                      .showsuccessflushbar(
                                                          'Phone number added',
                                                          context);
                                                  fetchdata();
                                                }).onError((error, stackTrace) {
                                                  utils.showloading(false);
                                                  GeneralUtils()
                                                      .showerrorflushbar(
                                                          error.toString(),
                                                          context);
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 130,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: AppColor
                                                        .backgroundColor),
                                                child: utils.load
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : const Center(
                                                        child: Text(
                                                          'Submit',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Raleway-Bold',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                              ),
                                            )
                                          ],
                                        )),
                                  );
                                });
                          },
                          icon: Image.asset('images/edit.png'))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Image.asset('images/phone.png'),
                      const SizedBox(
                        width: 17,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            phone,
                            style: const TextStyle(
                                fontFamily: 'Poppins-Medium',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1A2530)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Phone',
                            style: TextStyle(
                              fontFamily: 'Poppins-Medium',
                              fontSize: 12,
                              color: Color(0xff707BB1),
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: screenwidth * 0.14),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  // ignore: sized_box_for_whitespace
                                  content: Container(
                                      height: 196,
                                      width: 335,
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Nhập số điện thoại',
                                            style: TextStyle(
                                              fontFamily: 'Raleway-Bold',
                                              fontSize: 16,
                                              color: Color(
                                                0xff2B2B2B,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: phonecontroller,
                                            decoration: InputDecoration(
                                              hintText: 'Nhận số điện thoại',
                                              hintStyle: TextStyling.hinttext,
                                              filled: true,
                                              fillColor:
                                                  const Color(0xffF7F7F9),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              db
                                                  .doc(auth.currentUser!.uid)
                                                  .update({
                                                'phone': phonecontroller.text
                                                    .toString()
                                              }).then((value) {
                                                GeneralUtils()
                                                    .showsuccessflushbar(
                                                        'Phone number added',
                                                        context);
                                                fetchdata();
                                              }).onError((error, stackTrace) {
                                                GeneralUtils()
                                                    .showerrorflushbar(
                                                        error.toString(),
                                                        context);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      AppColor.backgroundColor),
                                              child: const Center(
                                                child: Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Raleway-Bold',
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              });
                        },
                        icon: Image.asset('images/edit.png'),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.location_on_outlined),
                      const SizedBox(
                        width: 23,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Poppins-Medium',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1A2530),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Địa chỉ',
                              style: TextStyle(
                                fontFamily: 'Poppins-Medium',
                                fontSize: 12,
                                color: Color(0xff707BB1),
                              ),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  // ignore: sized_box_for_whitespace
                                  content: Container(
                                      height: 196,
                                      width: 335,
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Nhập số địa',
                                            style: TextStyle(
                                              fontFamily: 'Raleway-Bold',
                                              fontSize: 16,
                                              color: Color(
                                                0xff2B2B2B,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: addresscontroller,
                                            decoration: InputDecoration(
                                              hintText: 'Nhận địa chỉ',
                                              hintStyle: TextStyling.hinttext,
                                              filled: true,
                                              fillColor:
                                                  const Color(0xffF7F7F9),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              db
                                                  .doc(auth.currentUser!.uid)
                                                  .update({
                                                'address': addresscontroller
                                                    .text
                                                    .toString()
                                              }).then((value) {
                                                GeneralUtils()
                                                    .showsuccessflushbar(
                                                        'Address added',
                                                        context);
                                                fetchdata();
                                              }).onError((error, stackTrace) {
                                                GeneralUtils()
                                                    .showerrorflushbar(
                                                        error.toString(),
                                                        context);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      AppColor.backgroundColor),
                                              child: const Center(
                                                child: Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                    fontFamily: 'Raleway-Bold',
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              });
                        },
                        icon: Image.asset('images/edit.png'),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.payment_outlined),
                      const SizedBox(
                        width: 23,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hình thức thanh toán",
                            style: const TextStyle(
                              fontFamily: 'Poppins-Medium',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1A2530),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            paymentMethod,
                            style: TextStyle(
                              fontFamily: 'Poppins-Medium',
                              fontSize: 12,
                              color: Color(0xff707BB1),
                            ),
                          )
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                            StateSetter setState) =>
                                        SizedBox(
                                      height: 196,
                                      width: 335,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          const Text(
                                            'Chọn hình thức thanh toán',
                                            style: TextStyle(
                                              fontFamily: 'Raleway-Bold',
                                              fontSize: 16,
                                              color: Color(
                                                0xff2B2B2B,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          RadioListTile<String>(
                                            title: const Text(
                                                'Thanh toán khi nhận hàng'),
                                            value: 'cod',
                                            groupValue: paymentMethod,
                                            onChanged: (value) {
                                              setState(
                                                () => paymentMethod = value!,
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                          RadioListTile<String>(
                                            title:
                                                const Text('Thanh toán Stripe'),
                                            value: 'stripe',
                                            groupValue: paymentMethod,
                                            onChanged: (value) {
                                              setState(
                                                () => paymentMethod = value!,
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                          setState(() {});
                        },
                        icon: Image.asset('images/edit.png'),
                      )
                    ],
                  ),
                  Spacer(),
                  cart.showTotalAmountWidget(
                    cartTotalAmountWidgetBuilder: (totalAmount) => Visibility(
                      visible: totalAmount == 0.0 ? false : true,
                      child: Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Thành tiền',
                                  style: TextStyle(
                                    fontFamily: 'Raleway-SemiBold',
                                    color: Color(0xff707B81),
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  Formatter.formatCurrency(
                                      cart.calculateTotalPrice().toInt()),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    color: Color(0xff1A2530),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Giảm giá',
                                  style: TextStyle(
                                    fontFamily: 'Raleway-SemiBold',
                                    color: Color(0xff707B81),
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(),
                                const Text(
                                  '0',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    color: Color(0xff1A2530),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Tổng cộng',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    color: Color(0xff1A2530),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  Formatter.formatCurrency(
                                      cart.calculateTotalPrice().toInt()),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    color: Color(0xff1A2530),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            RoundButtonTwo(
                              onpress: () async {
                                await makePayment(
                                    context,
                                    cart
                                        .calculateTotalPrice()
                                        .toInt()
                                        .toString());
                              },
                              title: 'Thanh toán',
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> makePayment(BuildContext context, String price) async {
    if (paymentMethod == "cod") {
      try {
        await placeOrder();
        if (!context.mounted) return;
        showDialogSuccess(context, 'Đơn hàng đã được đặt thành công');
      } catch (e) {
        showDialogFail(context, 'Đơn hàng đã được đặt không thành công');
      }

      return;
    }
    try {
      await initPaymentSheet(context, price);
    } catch (err) {
      if (!context.mounted) return;
      showDialogFail(context, err.toString());
    }
  }

  Future<void> initPaymentSheet(BuildContext context, String price) async {
    try {
      final data = await createPaymentIntent(price, 'vnd');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Prospects',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
          style: ThemeMode.dark,
        ),
      );

      await Stripe.instance.presentPaymentSheet().then(
        (value) async {
          if (!context.mounted) return;
          await placeOrder();
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      showDialogFail(context, e.toString());
      rethrow;
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51OIMAyHdpKm7MB8qBrZGoxMpc6vV5DLsNr37XUCn0kAOgZ9S2UeEOFAvj0QjvyjWSEyZCCkjw1J39OtU11vnKnra00L0jED0P7',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> placeOrder() async {
    final orderDb = FirebaseFirestore.instance.collection('Orders');

    try {
      String orderId = DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> cartData = cart.getCartData();
      List<PersistentShoppingCartItem> cartItems =
          List<PersistentShoppingCartItem>.from(cartData['cartItems'] ?? []);

      List<Map<String, dynamic>> items =
          cartItems.map((item) => item.toJson()).toList();

      await orderDb.doc(orderId).set({
        'orderId': orderId,
        'userId': auth.currentUser!.uid,
        'email': email,
        'phone': phone,
        'address': address,
        'totalPrice': cartData['totalPrice'] ?? 0,
        'items': items,
        'payment': paymentMethod == 'cod' ? 'Chưa thanh toán' : 'Đã thanh toán',
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      cart.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đơn hàng đã được đặt thành công!')),
      );

      Navigator.pushNamed(context, RouteNames.navbarscreen);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra, vui lòng thử lại!')),
      );
    }
  }
}
