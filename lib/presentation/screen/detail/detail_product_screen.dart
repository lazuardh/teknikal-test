import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/View Model/product_view_model.dart';

class DetailProduct extends StatelessWidget {
  const DetailProduct({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final fetchData = Provider.of<ProductViewModel>(context);
    final selectedProduct = fetchData.listProduct[index];
    final size = MediaQuery.of(context).size;
    return Scaffold(
        //app bar
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: const Text(
            "Detail Product",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          //menambah tinggi app bar
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(size.height * 0.32),
              child: SizedBox(
                width: size.width * 0.9,
                height: size.height * 0.32,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  //cover yang diambil dari api disimpan disini
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: selectedProduct.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text Hamburger
              Text(
                selectedProduct.name,
                style: TextStyle(fontSize: 20, color: Colors.grey[600]),
              ),
              //teks harga
              Text(
                "Rp. ${selectedProduct.price.toString()}",
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black),
              ),
              // membuat spasi 1
              SizedBox(height: size.height * 0.02),
              const Text(
                "Description",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              //deskripsi
              Text(
                selectedProduct.desc,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ));
  }
}
