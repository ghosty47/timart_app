import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:timart_app/database/product_manager.dart';
import 'package:timart_app/widgets/form_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> products = [];

  bool isLoading = true;

  void refreshProducts() async {
    final data = await SQLHelper.getProducts();
    setState(() {
      products = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshProducts();
    print('num of products ${products.length}');
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  MoneyMaskedTextController costpriceController = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  MoneyMaskedTextController sellingpriceController = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  GlobalKey<FormState> addProductFormKey = GlobalKey<FormState>();

  Future<void> addProduct() async {
    await SQLHelper.addProduct(
      nameController.text,
      quantityController.text,
      costpriceController.text,
      sellingpriceController.text,
    );
    refreshProducts();
  }

  Future<void> updateProduct(int id) async {
    await SQLHelper.updateProduct(
      id,
      nameController.text,
      quantityController.text,
      costpriceController.text,
      sellingpriceController.text,
    );
    refreshProducts();
  }

  void deleteProduct(int id) async {
    await SQLHelper.deleteProduct(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Product Deleted Successfully',
        ),
      ),
    );
    refreshProducts();
  }

  void addProductBottomSheetModal(int? id) {
    if (id != null) {
      final existingProduct = products.firstWhere((element) => element['id'] == id);
      nameController.text = existingProduct['name'];
      quantityController.text = existingProduct['quantity'];
      costpriceController.text = existingProduct['costprice'];
      sellingpriceController.text = existingProduct['sellingprice'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Form(
          key: addProductFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              formField(
                label: 'Product name',
                hintText: 'Carrot',
                controller: nameController,
                validator: (input) {
                  if (input!.isEmpty) {
                    return "Product name cannot be empty";
                  }
                  return null;
                },
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              formField(
                label: 'Quantity',
                hintText: '3',
                keyboardType: TextInputType.number,
                controller: quantityController,
                validator: (input) {
                  if (input!.isEmpty) {
                    return "Quantity cannot be empty";
                  }
                  return null;
                },
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              formField(
                label: 'Cost price',
                hintText: '2,000',
                controller: costpriceController,
                validator: (input) {
                  if (input!.isEmpty) {
                    return "cost price cannot be empty";
                  }
                  return null;
                },
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              formField(
                label: 'Selling price',
                hintText: '5,000',
                controller: sellingpriceController,
                validator: (input) {
                  if (input!.isEmpty) {
                    return "selling price cannot be empty";
                  }
                  return null;
                },
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (addProductFormKey.currentState!.validate()) {
                    if (id == null) {
                      await addProduct();
                      Navigator.of(context).pop();
                    }
                  }
                  if (id != null) {
                    await updateProduct(id);
                    Navigator.of(context).pop();
                  }

                  nameController.text = '';
                  quantityController.text = '';
                  costpriceController.text = '';
                  sellingpriceController.text = '';
                },
                child: Text(id == null ? 'Create new product' : 'Update product'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Timart Solution'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => Card(
          color: Colors.green,
          margin: const EdgeInsets.all(20),
          child: ListTile(
            title: Text(products[index]['name']),
            subtitle: Text(products[index]['quantity']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => addProductBottomSheetModal(products[index]['id']),
                    icon: const Icon(Icons.edit),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () => deleteProduct(products[index]['id']),
                    icon: const Icon(Icons.delete),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addProductBottomSheetModal(null),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
