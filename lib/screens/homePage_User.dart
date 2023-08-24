import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/user_model.dart';

class SiswaView extends StatefulWidget {
  const SiswaView({Key? key}) : super(key: key);

  @override
  State<SiswaView> createState() => _SiswaViewState();
}


class _SiswaViewState extends State<SiswaView> {
  List<Siswa> daftarSiswa = [
    Siswa(
      id: 1,
      nama: 'John Doe',
      nis: '2020-001',
      kelas: 5,
      photo: 'https://upload.wikimedia.org/wikipedia/en/8/8a/AstaWSJIssue362015.png',
    ),
  ];
  TextEditingController searchController = TextEditingController();

  List<Siswa> searchResults = [];

  

  void search(String query) {
    setState(() {
      searchResults = daftarSiswa.where((siswa) {
        return (siswa.nama ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (siswa.nis ?? '').toLowerCase().contains(query.toLowerCase()) ||
            siswa.id.toString() == query;
      }).toList();
    });
  }

  void update(int id, Map<String, dynamic> value) {
    try {
      int index = daftarSiswa.indexWhere((element) => element.id == id);
      Map<String, dynamic> data = {...value};
      data['id'] = id;

      if (index != -1) {
        final siswa = Siswa.fromJson(data);
        daftarSiswa[index] = siswa;
        setState(() {});
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void remove(int id) {
    try {
      daftarSiswa.removeWhere((e) => e.id == id);
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  void create(Map<String, dynamic> value) {
    try {
      int id = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> data = {...value};
      data['id'] = id;

      final siswa = Siswa.fromJson(data);
      daftarSiswa.add(siswa);
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Siswa (${daftarSiswa.length})' ,style: GoogleFonts.montserrat()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search.......',
              ),
              onChanged: (value) {
                search(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, i) {
                final siswa = searchResults[i];
                String? nama = siswa.nama;
                String? nis = siswa.nis;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12)),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(29),
                
              ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(siswa.photo ?? ''),
                              radius: 30,
                            ),
                            SizedBox(width: 10),
                            
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(nama!,
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(nis!),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FormSiswa(siswa: siswa),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    update(siswa.id!, value);
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.mode_edit_outlined,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => remove(siswa.id!),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FormSiswa()))
              .then((value) {
            if (value != null) {
              create(value);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FormSiswa extends StatefulWidget {
  final Siswa? siswa;
  const FormSiswa({Key? key, this.siswa}) : super(key: key);

  @override
  State<FormSiswa> createState() => _FormSiswaState();
}

class _FormSiswaState extends State<FormSiswa> {
  final nama = TextEditingController();
  final nis = TextEditingController();
  final kelas = TextEditingController();
  final photo = TextEditingController();

  @override
  void initState() {
    if (widget.siswa?.id != null) {
      nama.text = widget.siswa?.nama ?? '';
      nis.text = widget.siswa?.nis ?? '';
      kelas.text = widget.siswa?.kelas.toString() ?? '';
      photo.text = widget.siswa?.photo ?? '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.siswa?.id == null ? 'Tambah Siswa' : 'Edit Siswa'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: nama,
            decoration: const InputDecoration(
              hintText: 'Nama Siswa...',
              hintStyle: TextStyle(color: Colors.black45),
              contentPadding: EdgeInsets.all(20),
            ),
          ),
          TextField(
            controller: nis,
            decoration: const InputDecoration(
              hintText: 'NIS...',
              hintStyle: TextStyle(color: Colors.black45),
              contentPadding: EdgeInsets.all(20),
            ),
          ),
          TextField(
            controller: kelas,
            decoration: const InputDecoration(
              hintText: 'Kelas...',
              hintStyle: TextStyle(color: Colors.black45),
              contentPadding: EdgeInsets.all(20),
            ),
          ),
          TextField(
            controller: photo,
            decoration: const InputDecoration(
              hintText: 'URL Foto...',
              hintStyle: TextStyle(color: Colors.black45),
              contentPadding: EdgeInsets.all(20),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'nama': nama.text,
              'nis': nis.text,
              'kelas': int.tryParse(kelas.text) ?? 0,
              'photo': photo.text,
            });
          },
          child: const Text('Submit'),
        ),
      ),
    );
  }
}
