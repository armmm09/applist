
class Siswa {
  int? id;
  String? nama;
  String? nis;
  int? kelas;
  String? photo;

  Siswa({
    this.id,
    this.nama,
    this.nis,
    this.kelas,
    this.photo,
  });

  Siswa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    nis = json['nis'];
    kelas = json['kelas'];
    photo = json['photo'];
  }

  set isHighlighted(bool isHighlighted) {}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nis': nis,
      'kelas': kelas,
      'photo': photo,
    };
  }
}