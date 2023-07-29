import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../API/url.dart';
import '../Model/product.dart';

class ProductViewModel extends ChangeNotifier {
  final dio = Dio();

  //nilai yang didapat pada api akan di simpan pada variabel  _listProduct
  List<Product> _listProduct = [];
  List<Product> get listProduct => _listProduct;

  List<Product> _filteredByName = [];
  List<Product> get filteredByName => _filteredByName;

  //variabel yang akan digunakan untuk on refresh
  final RefreshController _refreshController = RefreshController();
  RefreshController get refreshController => _refreshController;

  //mengambil data dari api menggunakan Dio Http
  Future<void> fetchProduct() async {
    try {
      final response = await dio.get(Url.listProduct);

      if (response.statusCode == 200) {
        final responseData = response.data as List;
        _listProduct =
            responseData.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception("Gagal Mengambil Data");
      }
      // menyimpan setiap perubahan
      notifyListeners();
      //memberi tahu widget smart refresher bahwa proses refresh telah selesai
      _refreshController.refreshCompleted();
    } catch (e) {
      throw Exception(e);
    }
  }

  //menambahkan fungsi search product berdasarkan nama
  Future<void> searchByname(String keyword) async {
    if (keyword.isEmpty) {
      _filteredByName = _listProduct;
    } else if (keyword.isNotEmpty) {
      _filteredByName = _listProduct = _listProduct
          .where((product) =>
              product.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    notifyListeners();
    _refreshController.refreshCompleted();
  }
}
