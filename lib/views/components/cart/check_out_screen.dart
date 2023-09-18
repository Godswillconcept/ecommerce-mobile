// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({
    super.key,
  });

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  int _currentStep = 0;
  String? _selectedMonth;
  String? _selectedDay;
  String? _selectedRegion;
  bool _switchValue = false;
  bool isChecked = false;
  int _radioValue = 1;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController cardName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  final _contactFormKey = GlobalKey<FormState>();
  final _cardFormKey = GlobalKey<FormState>();

  List<String> _regions = [
    'Asia',
    'Africa',
    'Europe',
    'North America',
    'South America',
    'Australia/Oceania',
  ];
  List<String> _months = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];

  List<String> _days = List.generate(31, (index) => (index + 1).toString());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Stepper(
              currentStep: _currentStep,
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                }
              },
              onStepContinue: () {
                if (_currentStep < 2) {
                  setState(() {
                    _currentStep += 1;
                  });
                }
              },
              steps: [
                Step(
                  title: Text('Delivery'),
                  subtitle: Text('Contact Information'),
                  content: Container(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _contactFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              label: Text("Name"),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent.shade100,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              label: Text("Email"),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent.shade100,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          IntlPhoneField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent.shade100,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedRegion,
                                hint: Text('Select Region'),
                                isExpanded: true,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedRegion = value!;
                                  });
                                },
                                items: _regions.map((String region) {
                                  return DropdownMenuItem<String>(
                                    value: region,
                                    child: Text(region),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: addressController,
                            decoration: InputDecoration(
                              label: Text("Address"),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent.shade100,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: zipController,
                            decoration: InputDecoration(
                              label: Text("Zip Code"),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent.shade100,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                          CheckboxListTile(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            title: Text("Save my address"),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blueAccent,
                              ),
                              alignment: Alignment.center,
                              width: double.maxFinite,
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Save Information",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  isActive: _currentStep == 0,
                ),
                Step(
                  title: Text('Payment'),
                  subtitle: Text('Order Summary'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.maxFinite,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        margin: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "Items",
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        child: Text('(3)'),
                                      ),
                                    ],
                                  ),
                                ),
                                Text("\$2.00"),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Shipping"),
                                Text("\$2.00"),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("VAR"),
                                Text("\$2.00"),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "\$2.00",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Payment method",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: RadioListTile(
                          selectedTileColor: Colors.blue,
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: (newVal) {
                            setState(() {
                              _radioValue = newVal!;
                            });
                          },
                          title: Text(
                            "Paypal",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          secondary: Image.asset(
                            "images/payments/1.png",
                            height: 30,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: RadioListTile(
                          dense: true,
                          selectedTileColor: Colors.blue,
                          value: 2,
                          groupValue: _radioValue,
                          onChanged: (newVal) {
                            setState(() {
                              _radioValue = newVal!;
                            });
                          },
                          title: Text(
                            "Visa",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          secondary: Image.asset(
                            "images/payments/2.png",
                            height: 30,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: RadioListTile(
                          dense: true,
                          selectedTileColor: Colors.blue,
                          value: 3,
                          groupValue: _radioValue,
                          onChanged: (newVal) {
                            setState(() {
                              _radioValue = newVal!;
                            });
                          },
                          title: Text(
                            "MasterCard",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          secondary: Image.asset(
                            "images/payments/4.png",
                            height: 30,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blueAccent,
                          ),
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Pay \$134",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep == 1,
                ),
                Step(
                  title: Text('Card Detail'),
                  subtitle: Text('Credit card Information'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Form(
                          key: _cardFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: cardName,
                                decoration: InputDecoration(
                                  label: Text("Name on Card"),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent.shade100,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: cardNumber,
                                decoration: InputDecoration(
                                  label: Text("Card Number"),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent.shade100,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedMonth,
                                          hint: Text('MM'),
                                          isExpanded: true,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedMonth = value!;
                                            });
                                          },
                                          items: _months.map((String month) {
                                            return DropdownMenuItem<String>(
                                              value: month,
                                              child: Text(month),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Day',
                                          hintText: 'DD',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      onChanged: (value) {
                                        _selectedDay = value;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'CVV',
                                        hintText: 'CVV',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        _selectedDay = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Save Card',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'You can remove this card anything',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value: _switchValue,
                                onChanged: (bool value) {
                                  setState(() {
                                    _switchValue = value;
                                  });
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.blueAccent,
                                  ),
                                  alignment: Alignment.center,
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep == 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
