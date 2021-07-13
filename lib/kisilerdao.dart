import 'package:kisiler_uygulamasi/Kisiler.dart';
import 'package:kisiler_uygulamasi/VeritabaniYardimcisi.dart';

class kisilerdao {

  Future<List<Kisiler>> tumKisiler() async {

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT * FROM kisiler");

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kisiler(satir["kisi_id"], satir["kisi_ad"], satir["kisi_tel"]);
    });

  }

  Future<List<Kisiler>> KisiArama(String aramaKelimesi) async {

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT * FROM kisiler WHERE kisi_ad like '%$aramaKelimesi%'");

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kisiler(satir["kisi_id"], satir["kisi_ad"], satir["kisi_tel"]);
    });

  }

  Future<void> KisiEkle(String kisi_ad,String kisi_tel) async {

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    var bilgiler = Map<String,dynamic>();
    bilgiler["kisi_ad"] = kisi_ad;
    bilgiler["kisi_tel"] = kisi_tel;

    await db.insert("kisiler", bilgiler);
  }

  Future<void> KisiGuncelle(int kisi_id,String kisi_ad,String kisi_tel) async {

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    var bilgiler = Map<String,dynamic>();
    bilgiler["kisi_ad"] = kisi_ad;
    bilgiler["kisi_tel"] = kisi_tel;

    await db.update("kisiler", bilgiler,where: "kisi_id = ?",whereArgs: [kisi_id]);
  }

  Future<void> KisiSil(int kisi_id) async {

    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.delete("kisiler",where: "kisi_id = ?",whereArgs: [kisi_id]);
  }



}