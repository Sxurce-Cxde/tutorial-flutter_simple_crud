import 'package:belajar_array_crud/models/mahasiswa.dart';
import 'package:flutter/cupertino.dart';

enum FormMode { create, edit }

class CreateEditScreen extends StatefulWidget {
  const CreateEditScreen({super.key, required this.mode, this.mahasiswa});

  final FormMode mode;
  final Mahasiswa? mahasiswa;

  @override
  State<CreateEditScreen> createState() => _CreateEditScreenState();
}

class _CreateEditScreenState extends State<CreateEditScreen> {
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();
  final TextEditingController _fakultasController = TextEditingController();

  @override
  initState() {
    super.initState();
    if (widget.mode == FormMode.edit) {
      _nimController.text = widget.mahasiswa!.nim;
      _namaController.text = widget.mahasiswa!.nama;
      _kelasController.text = widget.mahasiswa!.kelas;
      _prodiController.text = widget.mahasiswa!.prodi;
      _jurusanController.text = widget.mahasiswa!.jurusan;
      _fakultasController.text = widget.mahasiswa!.fakultas;
    }
  }

  getMhs() {
    return Mahasiswa(
      nim: _nimController.text,
      nama: _namaController.text,
      kelas: _kelasController.text,
      prodi: _prodiController.text,
      jurusan: _jurusanController.text,
      fakultas: _fakultasController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Data Mahasiswa'),
        trailing: GestureDetector(
          onTap: () {
            Navigator.pop(context, getMhs());
          },
          child: Text(widget.mode == FormMode.create ? 'Tambah' : 'Edit'),
        ),
      ),
      child: SafeArea(
        child: CupertinoFormSection(
          header: Text(widget.mode == FormMode.create
              ? 'Tambah Data Mahasiswa'
              : 'Edit Data Mahasiswa'),
          children: [
            CupertinoFormRow(
              prefix: Text('NIM'),
              child: CupertinoTextFormFieldRow(
                controller: _nimController,
                placeholder: 'Masukkan NIM',
              ),
            ),
            CupertinoFormRow(
              prefix: Text('Nama'),
              child: CupertinoTextFormFieldRow(
                controller: _namaController,
                placeholder: 'Masukkan Nama',
              ),
            ),
            CupertinoFormRow(
              prefix: Text('Kelas'),
              child: CupertinoTextFormFieldRow(
                controller: _kelasController,
                placeholder: 'Masukkan Kelas',
              ),
            ),
            CupertinoFormRow(
              prefix: Text('Prodi'),
              child: CupertinoTextFormFieldRow(
                controller: _prodiController,
                placeholder: 'Masukkan Prodi',
              ),
            ),
            CupertinoFormRow(
              prefix: Text('Jurusan'),
              child: CupertinoTextFormFieldRow(
                controller: _jurusanController,
                placeholder: 'Masukkan Jurusan',
              ),
            ),
            CupertinoFormRow(
              prefix: Text('Fakultas'),
              child: CupertinoTextFormFieldRow(
                controller: _fakultasController,
                placeholder: 'Masukkan Fakultas',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
