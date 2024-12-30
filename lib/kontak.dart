class Kontak {
  String nama;
  String nomor;

  Kontak({required this.nama, required this.nomor});

  @override
  String toString() {
    return 'Kontak(nama: $nama, nomor: $nomor)';
  }
}
