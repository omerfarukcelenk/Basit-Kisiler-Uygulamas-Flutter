import 'package:flutter/material.dart';
import 'package:kisiler_uygulamasi/kisilerdao.dart';
import 'package:kisiler_uygulamasi/main.dart';

import 'Kisiler.dart';

class KisiDetaySayfa extends StatefulWidget {

  late Kisiler kisi;


  KisiDetaySayfa({required this.kisi});

  @override
  _KisiDetaySayfaState createState() => _KisiDetaySayfaState();
}

class _KisiDetaySayfaState extends State<KisiDetaySayfa> {

  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();

  Future<void> guncelle(int kisi_id,String kisi_ad, String kisi_tel) async {
    await kisilerdao().KisiGuncelle(kisi_id, kisi_ad, kisi_tel);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));

  }

  @override
  void initState() {
    super.initState();
    var kisi = widget.kisi;
    tfKisiAdi.text = kisi.kisi_ad;
    tfKisiTel.text = kisi.kisi_tel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kişi Detay"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              TextField(
                controller: tfKisiAdi,
                decoration: InputDecoration(hintText: "Kişi Ad"),
              ),

              TextField(
                controller: tfKisiTel,
                decoration: InputDecoration(hintText: "Kişi Telefon Numarası"),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.update),
        tooltip: "Kişi Güncelle",
        onPressed: (){
          guncelle(widget.kisi.kisi_id, tfKisiAdi.text, tfKisiTel.text);
        },
        label: Text("Güncelle"),
      ),
    );  }
}
