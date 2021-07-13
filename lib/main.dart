import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kisiler_uygulamasi/KisiDetaySayfa.dart';
import 'package:kisiler_uygulamasi/KisiKayitSayfa.dart';
import 'package:kisiler_uygulamasi/Kisiler.dart';
import 'package:kisiler_uygulamasi/kisilerdao.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {



  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  Future<List<Kisiler>> tumKisileriGoster() async {
    var kisilerListesi =await kisilerdao().tumKisiler();
    return kisilerListesi;

  }

  Future<List<Kisiler>> aramaYap(String aramaKelimesi) async {
    var kisilerListesi = await kisilerdao().KisiArama(aramaKelimesi);
    return kisilerListesi;

  }

  Future<void> sil(int kisi_id) async {
    await kisilerdao().KisiSil(kisi_id);
  }

  Future<bool> uygulamayiKapat() async {
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
            uygulamayiKapat();
        }, icon: Icon(Icons.arrow_back)) ,
        title: aramaYapiliyorMu ?
            TextField(
              decoration: InputDecoration(hintText: "Arama için birşey yazınız"),
              onChanged: (aramaSonuc){
                print("Arama Sonucu : $aramaSonuc");
                setState(() {
                  aramaKelimesi = aramaSonuc;
                });
              },
            )
            : Text("Kişiler Uygulaması"),
        actions: [
          aramaYapiliyorMu ?
          IconButton(onPressed: (){
            setState(() {
              aramaYapiliyorMu = false;
              aramaKelimesi = "";
            });
          }, icon: Icon(Icons.cancel))
           : IconButton(onPressed: (){
              setState(() {
              aramaYapiliyorMu = true;
              });
             }, icon: Icon(Icons.search_rounded))
        ],
      ),
      body:WillPopScope(
        onWillPop: uygulamayiKapat,
        child: FutureBuilder<List<Kisiler>>(
          future: aramaYapiliyorMu ? aramaYap(aramaKelimesi) : tumKisileriGoster(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              var kisilerListesi = snapshot.data;
              return ListView.builder(
                itemCount: kisilerListesi!.length,
                itemBuilder: (context,indeks){
                  var kisi = kisilerListesi[indeks];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => KisiDetaySayfa(kisi: kisi,)));
                    },
                    child: Card(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(kisi.kisi_ad,style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(kisi.kisi_tel,),
                            IconButton(onPressed: (){
                              sil(kisi.kisi_id);
                            }, icon: Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }else{
              return Center();
            }
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Kişi Ekle",
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => KisiKayitSayfa()));
        },
      ),
    );
  }
}
