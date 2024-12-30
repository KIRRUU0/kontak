import 'package:flutter/material.dart';
import 'kontak.dart';
import 'api_service.dart'; // Import ApiService

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController nomorController = TextEditingController();
  final ApiService apiService = ApiService('https://677281ccee76b92dd49283ce.mockapi.io/kontak_list');
  List<Kontak> kontaks = [];
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchKontaks();
  }

  Future<void> fetchKontaks() async {
    try {
      List<Kontak> fetchedKontaks = await apiService.fetchKontaks();
      setState(() {
        kontaks = fetchedKontaks;
      });
    } catch (e) {
      // Tangani kesalahan
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Kontak List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                hintText: 'Nama Lengkap',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nomorController,
              keyboardType: TextInputType.number,
              maxLength: 12,
              decoration: const InputDecoration(
                hintText: 'Nomor Telepon',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String nama = namaController.text.trim();
                    String nomor = nomorController.text.trim();
                    if (nama.isNotEmpty && nomor.isNotEmpty) {
                      Kontak newKontak = Kontak(nama: nama, nomor: nomor);
                      await apiService.addKontak(newKontak); // Simpan kontak ke API
                      fetchKontaks(); // Refresh daftar kontak
                      namaController.clear();
                      nomorController.clear();
                    }
                  },
                  child: const Text('Simpan'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String nama = namaController.text.trim();
                    String nomor = nomorController.text.trim();
                    if (selectedIndex >= 0 && nama.isNotEmpty && nomor.isNotEmpty) {
                      Kontak updatedKontak = Kontak(nama: nama, nomor: nomor);
                      await apiService.updateKontak(selectedIndex, updatedKontak); // Update kontak di API
                      fetchKontaks(); // Refresh daftar kontak
                      selectedIndex = -1;
                      namaController.clear();
                      nomorController.clear();
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            kontaks.isEmpty 
              ? const Text('Tidak ada data', style: TextStyle(fontSize: 15))
              : const SizedBox(),
            Expanded(
              child: ListView.builder(
                itemCount: kontaks.length,
                itemBuilder: (context, index) => getRow(index, kontaks),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRow(int index, List<Kontak> kontaks) {
    return Card(
      child: ListTile(
        title: Text(kontaks[index].nama),
        subtitle: Text(kontaks[index].nomor),
        onTap: () {
          setState(() {
            selectedIndex = index;
            namaController.text = kontaks[index].nama;
            nomorController.text = kontaks[index].nomor;
          });
        },
      ),
    );
  }
}
