import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:restaurant_rlutter_ui/generated/i18n.dart';
import 'package:restaurant_rlutter_ui/src/controllers/checkout_controller.dart';
import 'package:restaurant_rlutter_ui/src/elements/CreditCardsWidget.dart';
import 'package:restaurant_rlutter_ui/src/helpers/helper.dart';
import 'package:restaurant_rlutter_ui/src/models/route_argument.dart';
import 'package:restaurant_rlutter_ui/src/repository/settings_repository.dart';

class CheckoutWidget extends StatefulWidget {
//  RouteArgument routeArgument;
//  CheckoutWidget({Key key, this.routeArgument}) : super(key: key);
  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends StateMVC<CheckoutWidget> {
  CheckoutController _con;

  _CheckoutWidgetState() : super(CheckoutController()) {
    _con = controller;
  }
  @override
  void initState() {
    _con.listenForCarts(withAddOrder: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).checkout,
          style: Theme
              .of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.payment,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).payment_mode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.display1,
                    ),
                    subtitle: Text(
                      S.of(context).select_your_preferred_payment_mode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                new CreditCardsWidget(
                    creditCard: _con.creditCard,
                    onChanged: (creditCard) {
                      _con.updateCreditCard(creditCard);
                    }),
                SizedBox(height: 40),
                setting.payPalEnabled
                    ? Text(
                        S.of(context).or_checkout_with,
                        style: Theme.of(context).textTheme.caption,
                      )
                    : SizedBox(
                        height: 0,
                      ),
                SizedBox(height: 40),
                setting.payPalEnabled
                    ? SizedBox(
                        width: 320,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/PayPal');
                          },
                          padding: EdgeInsets.symmetric(vertical: 12),
                          color: Theme.of(context).focusColor.withOpacity(0.2),
                          shape: StadiumBorder(),
                          child: Image.asset(
                            'assets/img/paypal2.png',
                            height: 28,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 230,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Theme
                            .of(context)
                            .focusColor
                            .withOpacity(0.15),
                        offset: Offset(0, -2),
                        blurRadius: 5.0)
                  ]),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            S.of(context).subtotal,
                            style: Theme.of(context).textTheme.body2,
                          ),
                        ),
                        Helper.getPrice(_con.subTotal,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subhead)
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'ضريبة (${setting.defaultTax}%)',
                            style: Theme.of(context).textTheme.body2,
                          ),
                        ),
                        Helper.getPrice(_con.taxAmount,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subhead)
                      ],
                    ),
                    Divider(height: 30),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            S.of(context).total,
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        Helper.getPrice(_con.total,
                            style: Theme
                                .of(context)
                                .textTheme
                                .title)
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/OrderSuccess',
                              arguments: new RouteArgument(
                                  param: 'Credit Card (Stripe Gateway)'));
//                                      Navigator.of(context).pushReplacementNamed('/Checkout',
//                                          arguments:
//                                              new RouteArgument(param: [_con.carts, _con.total, setting.defaultTax]));
                        },
                        padding: EdgeInsets.symmetric(vertical: 14),
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                        child: Text(
                          S.of(context).confirm_payment,
                          textAlign: TextAlign.start,
                          style:
                          TextStyle(color: Theme
                              .of(context)
                              .primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
