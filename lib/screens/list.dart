import 'dart:convert';

import 'package:belajar_array_crud/screens/create.dart';
import 'package:flutter/cupertino.dart';
import 'package:belajar_array_crud/models/mahasiswa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final storage = const FlutterSecureStorage();

  final List<Mahasiswa> _listMahasiswa = [];

  @override
  initState() {
    super.initState();
    _getDataFromStorage();
  }

  _getDataFromStorage() async {
    String? data = await storage.read(key: 'list_mahasiswa');
    if (data != null) {
      final dataDecoded = jsonDecode(data);
      if (dataDecoded is List) {
        setState(() {
          _listMahasiswa.clear();
          for (var item in dataDecoded) {
            _listMahasiswa.add(Mahasiswa.fromJson(item));
          }
        });
      }
    }
  }

  _saveDataToStorage() async {
    final List<Object> tmp = [];
    for (var item in _listMahasiswa) {
      tmp.add(item.toJson());
    }

    await storage.write(
      key: 'list_mahasiswa',
      value: jsonEncode(tmp),
    );
  }

  _showPopupMenuItem(BuildContext context, int index) {
    final mahasiswaClicked = _listMahasiswa[index];

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Menu untuk mahasiswa ${mahasiswaClicked.nama}'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => CreateEditScreen(
                    mode: FormMode.edit,
                    mahasiswa: mahasiswaClicked,
                  ),
                ),
              );
              if (result is Mahasiswa) {
                setState(() {
                  _listMahasiswa[index] = result;
                });
                _saveDataToStorage();
              }
            },
            child: const Text('Edit'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text('Apakah anda yakin?'),
                  content: Text(
                      'Data mahasiswa ${mahasiswaClicked.nama} akan dihapus'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Tidak'),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _listMahasiswa.removeAt(index);
                        });
                      },
                      child: const Text('Iya'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Data Mahasiswa'),
        trailing: GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const CreateEditScreen(
                  mode: FormMode.create,
                ),
              ),
            );
            if (result is Mahasiswa) {
              setState(() {
                _listMahasiswa.add(result);
              });
              _saveDataToStorage();
            }
          },
          child: Icon(
            CupertinoIcons.add_circled,
            size: 22,
          ),
        ),
      ),
      child: SafeArea(
        child: ListView.separated(
          itemCount: _listMahasiswa.length,
          itemBuilder: (context, index) {
            final item = _listMahasiswa[index];
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: GestureDetector(
                onTap: () => _showPopupMenuItem(context, index),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.nama} (${item.nim})'),
                    Text(
                      '${item.fakultas} / ${item.jurusan} / ${item.prodi} / ${item.kelas}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      ),
    );
  }
}
