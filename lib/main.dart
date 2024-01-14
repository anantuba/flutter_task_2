import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ShoppingCart(),
    );
  }
}

class ShoppingCartItem extends StatefulWidget {
  final String? itemName;
  final String? itemImage;
  final String? itemColor;
  final String? itemSize;
  final double unitPrice; // Added unitPrice as a parameter

  const ShoppingCartItem({
    Key? key,
    this.itemName,
    this.itemImage,
    this.itemColor,
    this.itemSize,
    required this.unitPrice,
  }) : super(key: key);

  @override
  ShoppingCartItemState createState() => ShoppingCartItemState();
}

class ShoppingCartItemState extends State<ShoppingCartItem> {
  int itemCount = 1;
  double totalAmount = 0; // Updated to initialize with 0

  @override
  void initState() {
    super.initState();
    updateTotalAmount();
  }

  void updateTotalAmount() {
    setState(() {
      totalAmount = widget.unitPrice * itemCount;
    });
  }

  void showAddToBagDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Congratulations!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          content: Text(
            "You have added \n $itemCount ${widget.itemName ?? ""} on your bag!",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: AppButtonStyle(),
                child: const Text(
                  "OKAY",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Image.asset(
                widget.itemImage ?? 'asset/images/default_image.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.itemName ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Color: ${widget.itemColor}   Size: ${widget.itemSize}',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (itemCount > 1) {
                              setState(() {
                                itemCount--;
                                updateTotalAmount();
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 10,),
                        Text(itemCount.toString()),
                        const SizedBox(width: 10,),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              itemCount++;
                              updateTotalAmount();
                              if (itemCount == 5) {
                                showAddToBagDialog();
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 70,),
                        Text(
                          '\$${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ButtonStyle AppButtonStyle() {
  return ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.redAccent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))));
}



class ShoppingCart extends StatelessWidget {
  final List<Map<String, dynamic>> itemList = [
    {"name": "Pullover", "color": "Black", "size": "L", "image": "asset/images/pullover.png", "unitPrice": 51.0},
    {"name": "T-Shirt", "color": "Gray", "size": "L", "image": "asset/images/tshirt.png", "unitPrice": 30.0},
    {"name": "Sport Dress", "color": "Black", "size": "M", "image": "asset/images/sportdress.png", "unitPrice": 43.0}
  ];

  MySnackBar(message, context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  ShoppingCart({Key? key});

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;

    itemList.forEach((item) {
      totalAmount += item["unitPrice"] * (item["quantity"] ?? 1);
    });
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'My Bag',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return ShoppingCartItem(
                  itemName: itemList[index]["name"],
                  itemImage: itemList[index]["image"],
                  itemColor: itemList[index]["color"],
                  itemSize: itemList[index]["size"],
                  unitPrice: itemList[index]["unitPrice"],
                );
              },
            ),
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total amount:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '124\$',
                  // '\$${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: 343, // Set the desired width
              height: 48, // Set the desired height
              child: ElevatedButton(
                onPressed: () {
                  MySnackBar("Congratulations! Checkout successful.", context);
                },
                style: AppButtonStyle(),
                child: const Text(
                  "CHECK OUT",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}