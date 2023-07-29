import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tehnikal_test/presentation/routes/page_routes.dart';

import '../../data/View Model/product_view_model.dart';
import '../detail/detail_product_screen.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct>
    with TickerProviderStateMixin {
  late RefreshController refreshController;

  bool isExpand = false;
  int? isShowUp;
  int index = 0;

  late AnimationController _animationController;
  //app bar
  Widget appBarText = const Text(
    "List Product",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 25,
      color: Colors.white,
    ),
  );

  //icon yang digunakan untuk navbar
  final List<dynamic> _iconList = [
    [Icons.live_tv, "Live Show"],
    [Icons.screen_search_desktop_rounded, "Live Class"],
    [Icons.book, "E-Course"],
    [Icons.camera_outlined, "Comunity"],
  ];

  // icon yang digunakan untuk navbar yang di expand
  final List<List<dynamic>> _expandedIcon = [
    [Icons.live_tv, "Live Show"],
    [Icons.screen_search_desktop_rounded, "Live Class"],
    [Icons.book, "E-Course"],
    [Icons.camera_outlined, "Comunity"],
    [Icons.camera_outlined, "My profile"],
    [Icons.camera_outlined, "Saved Course"],
    [Icons.camera_outlined, "Recent Course"],
    [Icons.camera_outlined, "My List"],
    [Icons.camera_outlined, "My Chart"],
    [Icons.camera_outlined, "Purchase History"],
    [Icons.camera_outlined, "Marketplace Beta"],
  ];

  // inisiasi on refresh, animation builder dan fetch data
  @override
  void initState() {
    refreshController = RefreshController(initialRefresh: false);
    final fetchData = Provider.of<ProductViewModel>(context, listen: false);
    fetchData.fetchProduct();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    // melakukan perubahan text pada appbar product
    _animationController.addListener(() {
      setState(() {
        appBarText = _animationController.value == 1
            ? Row(
                children: [
                  IconButton(
                      //  mengatur perpindahan halaman
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, RouteName.listProduct, (route) => false);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  const Text(
                    "Back",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            : const Text(
                "List Product",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              );
      });
    });
    super.initState();
  }

  // menghentikan dan membersihkan animasi yang sedang berjalan
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fetchData = Provider.of<ProductViewModel>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // appbar widget yang telah di inisiasi sebelumnya di gunakan disini
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: appBarText,
      ),
      body: Stack(
        children: [
          // pengelompokan widget list, agar tidak membingunkan.
          Product(
              refreshController: refreshController,
              fetchData: fetchData,
              size: size),

          //logic untuk menyembunyikan navigasi saat expand active atau dijalankan.
          if (isShowUp == null && isShowUp != index) ...[
            Positioned(
              bottom: 40,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(30)),
                child: SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 0.09,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _iconList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // icon
                            CircleAvatar(
                              maxRadius: 15,
                              backgroundColor: Colors.red,
                              child: Icon(
                                _iconList[index][0],
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            //title
                            Text(
                              _iconList[index][1],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (isExpand = true) ...[
              Positioned(
                bottom: 90,
                left: size.width * 0.45,
                right: size.width * 0.44,
                child: GestureDetector(
                  onTap: () {
                    //melakukan perubahan text pada appbar ketika expand active, melakukan perubahan dari navigation ke expand, logic yang digunakan ketika tombol arrow up di klik akan berpindah ke ke screen yang di expand
                    if (isShowUp == null) {
                      setState(() {
                        isShowUp = index;
                        isExpand = true;
                        _animationController.value = 1;
                      });
                    } else if (isShowUp != null && isShowUp == index) {
                      setState(() {
                        isShowUp = null;
                        isExpand = false;
                        _animationController.value = 0.3;
                      });
                    }
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.greenAccent,
                    child: Icon(
                      Icons.arrow_circle_up,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ],
          //mennyembunyikan expand schroll
          if (isShowUp != null && isShowUp == index) ...[
            // expand detail navigation
            DraggableScrollableSheet(
              maxChildSize: 1,
              initialChildSize: 0.6,
              minChildSize: 0.58,
              builder: (context, scrollController) {
                return Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: const Color(0XFFFFFFFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.height * 0.05),
                        topRight: Radius.circular(size.height * 0.05),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // titile expand navigation
                          const Text(
                            "Features",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            controller: scrollController,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    4, // jumlah count expand navigation
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _expandedIcon.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // icon detail expand navigation
                                    CircleAvatar(
                                      child: Icon(
                                        _expandedIcon[index][0],
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // title icon detail expand navigation
                                    Text(
                                      _expandedIcon[index][1],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            )
          ]
        ],
      ),
    );
  }
}

// on refresh, search, dan menampilkan list product
class Product extends StatelessWidget {
  const Product({
    super.key,
    required this.refreshController,
    required this.fetchData,
    required this.size,
  });

  final RefreshController refreshController;
  final ProductViewModel fetchData;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      onRefresh: () async {
        try {
          await fetchData.fetchProduct();
          refreshController.refreshCompleted();
        } catch (e) {
          await fetchData.fetchProduct();
          refreshController.refreshFailed();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Gagal memuat data."),
          ));
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              //search by name
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  onChanged: (value) {
                    fetchData.searchByname(value);
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Your Product",
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.6,
              // menampikan list produk dalam bentuk grid menggunakan library mansory grid
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 16,
                itemCount: fetchData.listProduct.length,
                itemBuilder: (context, index) {
                  final datas = fetchData.listProduct[index];
                  return GestureDetector(
                    onTap: () {
                      //berpindah ke halaman detail
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailProduct(index: index),
                          ));
                    },
                    // card yang digunakan
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromARGB(255, 232, 230, 230),
                                blurStyle: BlurStyle.solid,
                                offset: Offset(0, 3),
                                spreadRadius: 2,
                                blurRadius: 5)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // cover list produk
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: datas.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            //nama product
                            Text(
                              datas.name,
                              style: const TextStyle(fontSize: 15),
                            ),
                            // harga produk
                            Text(
                              "Rp. ${datas.price.toString()}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
