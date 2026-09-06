# HAKEM— Oyun Tasarım Dokümanı (GDD)
### Tek kişilik geliştirici için tam kapsamlı, uygulanabilir tasarım rehberi — v1.0

---

## TL;DR (Üç Madde)

- **Ne yapıyoruz:** Rakip "Futbol Hakem Simülasyonu 3D"in (JLabs) saf karar-simülasyonu boşluğunu, üzerine **kulis + şike + tehdit + sosyal hayat + ahlaki ikilem** katmanı ekleyerek dolduruyoruz. Konumlama: *New Star Soccer'ın ilişki/enerji döngüsü × Retro Bowl'un pixel-art hızlı oynanışı × Papers Please/Reigns'in ahlaki gerilimi* — hakem temasıyla. Bu birleşim pazarda yok; senin en büyük fırsatın bu.
- **Kritik tasarım kararları:** İki ayrı itibar statı (Halk İlişkisi + Federasyon İlişkisi), yarı-gizli Şüphe metriği, temiz/kirli iki cüzdan, statların "pozisyonu doğru görme oranını" matematiksel etkilediği maç sistemi, ve akıcı-net VAR (donmuş kare + scrub bar + çizgi overlay). Şike'de dört seçenek: kabul-yap / kabul-yapma (dolandır) / reddet / **ihanet (double-cross)**.
- **Monetizasyon = rakibin en büyük zayıflığını silaha çevir:** Rakibin ölümcül hatası aşırı interstitial reklam. **Retro Bowl modeli** öneriyorum: ücretsiz + tek seferlik premium satın alma, interstitial neredeyse yok, sadece opsiyonel rewarded reklam. Sebebi kanıtlı: oyuncular rewarded'ı interstitial'a **4'e 1** tercih ediyor ve ilk hafta tek rewarded izleyenlerde retention **%50+ (benchmark %13)** (Unity resmi blogu).

---

## 1. Oyun Özeti, Logline, Hedef Kitle, Tür, Platform

**Logline:** *"Sen bir futbol hakemisin. Sahada adaletin tek sahibisin — ama tribün seni linç etmeye, federasyon seni harcamaya, bahisçi seni satın almaya hazır. Her düdük bir karar, her karar bir bedel."*

**Elevator pitch:** Oyuncu, il hakemliğinden FIFA kokartına uzanan bir kariyerde maçlara hakemlik yapar; sahada penaltı/ofsayt/kart/VAR kararları verirken, saha dışında şike tekliflerini, tehditleri, ailesini ve parasını yönetir. Her hafta bir "tur"dur: atama gelir, maç oynanır, sonuçlar itibar ve şüpheye yansır, boş zaman antrenman/aile/kulis arasında bölünür.

| Özellik | Karar |
|---|---|
| **Tür** | 2D pixel-art kariyer + yaşam simülasyonu + ahlaki ikilem/kaynak yönetimi |
| **Platform** | Birincil: Android + iOS (Godot 4). İkincil: PC/Steam portu |
| **Oynanış süresi** | Snack (5 dk bir maç) veya derin oturum (NSS mantığı) |
| **Hedef kitle** | 16-35 yaş; futbol + NSS/Retro Bowl oyuncuları + Papers Please/Reigns/BitLife sevenler |
| **Pazar** | Birincil: Türkiye. Sonra: global (İngilizce lokalizasyon) |
| **Ton** | Karanlık, gerilimli, hicivli-gerçekçi |

---

## 2. Pazar Analizi ve Rakip Analizi

Rakip **Futbol Hakem Simülasyonu 3D** (JLabs Games / com.flatgames.football.referee.simulator) güçlü bir taban yakalamış (Türk stüdyosu, geniş indirme kitlesi), fakat App Store yorumları net bir düşman gösteriyor: **reklam yoğunluğu**. Doğrudan alıntılar:

> *"Oyun güzel ama her bir adımda reklam var. Her devre arası ve maç sonu reklam çok fazla."* — App Store TR yorumu

> *"The idea is good, the game is good, but there are too many ads. Every time the ball goes out, there's an ad. I deleted it after 20 minutes. And you can't even play it offline."* — nico du 98, App Store (11.12.2025); geliştiricinin bu yoruma yanıt vermek zorunda kalması sorunun ciddiyetini gösteriyor.

Rakibin ikinci zayıflığı: **derinlik yokluğu** — saf karar simülasyonu, kulis/şike/sosyal hayat katmanı yok. Güncelleme notlarından meslek seçimi (öğretmen/polis/mühendis) ve basit hikaye denemeleri eklemeye çalıştıkları görülüyor, yani pazar bu derinliği talep ediyor ama rakip yüzeysel kalıyor.

| Oyun | Güçlü Yön | Zayıf/Boşluk | Bizim Fırsatımız |
|---|---|---|---|
| **Futbol Hakem Sim. 3D** (JLabs) | Türk pazarı, geniş taban, 3D saha | Aşırı reklam, çevrimdışı yok, sığ, kulis/şike/sosyal katman yok | Derinlik + adil monetizasyon |
| **New Star Soccer** | Enerji/ilişki/dilemma döngüsü, "snack + derin" dengesi | Futbolcu odaklı, kirli/suç teması yok; oyuncular reklam+enerji sisteminden şikayetçi | Hakem perspektifi + suç/ikilem teması |
| **Retro Bowl / Retro Goal** | 16-bit pixel art, hızlı, temiz premium model | Ahlaki/sosyal katman yok | Ahlaki gerilim + yaşam sim |
| **Papers Please** | Ahlaki ikilem + bürokratik baskı ustalığı, "possibility space" | Futbol değil, tek mekan | Futbol + ikilem + kariyer |
| **Reigns** | Basit swipe + 4-stat denge, quality-based narrative | Sığ karakter gelişimi | Derin stat + saha simülasyonu |
| **BitLife** | Yaş döngüsü, stat yönetimi, sonsuz replay | Metin tabanlı, görsel yok, spor derinliği yok | Görsel maç + spor kariyeri |

**Boşluk/Fırsat analizi:** "Hakem + şike + iki ayrı itibar sistemi + tehdit + sosyal hayat + ahlaki ikilem" birleşimi hiçbir mevcut oyunda yok. NSS'in kanıtlanmış "enerji + ilişki + dilemma" iskeletini alıp, üzerine Papers Please'in ahlaki gerilimini ve gerçek Türk futbol gerçekliğini (şike davası hafızası, hakem-federasyon gerilimi) giydirmek özgün ve pazarlanabilir bir konum yaratır.

---

## 3. Temel Oyun Döngüsü (Core Loop)

Bir "tur" = **bir hafta**. Bir sezon ≈ 34 hafta. Kariyer birkaç sezon (yaş/yıpranma ile sınırlı).

```
┌─────────────────── HAFTA BAŞI (ANA EKRAN / HUB) ───────────────────┐
│                                                                     │
│  Atama gelir (MHK/gözlemci) ──► Maç türü, lig, önem, risk seviyesi  │
│                         │                                           │
│         ┌───────────────┴───────────────┐                          │
│         ▼                               ▼                           │
│  [MAÇ ÖNCESİ OLAY]                  (olay yoksa                     │
│  Şike teklifi / Tehdit               doğrudan maça)                 │
│  ► Kabul-yap / Kabul-yapma /                                        │
│    Reddet / İhanet                                                  │
│         │                               │                           │
│         └───────────────┬───────────────┘                          │
│                         ▼                                           │
│  ══════════════════ MAÇ (3-6 POZİSYON) ══════════════════          │
│  Pozisyonu gör (statlara göre netlik) ► Karar ver ► (VAR?)          │
│                         │                                           │
│                         ▼                                           │
│  MAÇ SONU: Gözlemci notu • Halk İlişkisi ± • Federasyon ± •         │
│            Para (temiz/kirli) • Şüphe ± • Enerji −                  │
│                         │                                           │
│                         ▼                                           │
│  HAFTA ARASI (Enerji/Zaman Bütçesi):                               │
│  Antrenman • Sosyal Hayat • Harcama/Aklama • Kulis                  │
│                         │                                           │
│                         ▼                                           │
│  [RASTGELE OLAY] Soruşturma • Aile krizi • Medya dalgası • Tehdit   │
│                         │                                           │
│                         └──────────► HAFTA BAŞI'na dön              │
└─────────────────────────────────────────────────────────────────────┘
```

**Tasarım felsefesi (Papers Please dersi):** Baskı, mekaniğin kendisinden doğmalı — Papers Please'te "aileni beslemek için hızlı ve doğru çalışman gerekir; hız hata getirir, hata para cezası getirir" döngüsü gerilimi yaratır. Bizde muadili: *Temiz para kariyerini sürdürmeye yetmez → şike cazip → ama şike Şüphe biriktirir → soruşturma kariyeri bitirir.* Bu gerginlik oyunun kalbidir.

---

## 4. Tüm Stat ve Sistemler

### 4.1 İlişki / Durum Statları (0-100)

Reigns'in "dört pilar dengesi" mantığını (çok düşük = ölüm, aşırı yüksek de bazen tuzak) hakeme uyarladık; ama Reigns'ten farkı, statların birbirini besleyen derin bir simülasyon oluşturması.

#### HALK İLİŞKİSİ (Taraftar/Kamuoyu İtibarı)
| Aralık | Durum | Ne Olur |
|---|---|---|
| 0-20 | **Linç bölgesi** | Her maçta taraftar tehdidi olasılığı ×3; tribün olayları; fiziksel saldırı riski açılır |
| 21-50 | Baskı altında | Sürekli eleştiri, medya provokasyonu |
| 51-80 | Saygın hakem | Nötr; küçük hatalar affedilir |
| 81-100 | Kamuoyu favorisi | Tehdit direnci +%20; skandalları medya yumuşatır |

Artıran: doğru+tutarlı kararlar, cesur doğru kararlar (derbide penaltı vermek). Azaltan: hatalı kararlar, şike ifşası, favori takıma sürekli aleyhte karar.

#### FEDERASYON İLİŞKİSİ (MHK/Kurumsal Otorite)
| Aralık | Durum | Ne Olur |
|---|---|---|
| 0-20 | **Sürgün** | Alt lig atamaları; terfi imkansız; soruşturmada koruma yok |
| 21-50 | Riskli | Terfi durur; kötü maçlar atanır |
| 51-80 | Güvenilir | Normal atama akışı |
| 81-100 | Kayrılan | Üst lig/derbi atamaları; **soruşturmada Şüphe azaltıcı koruma** (2011 davasındaki federasyon-kulüp yakınlığı gerçeğine gönderme) |

**Kritik tasarım:** Bu iki stat sık sık çatışır (NSS'te patron-taraftar dengesi gibi). Federasyonun istediği karar (susmak, kayırmak) Halk'ı düşürebilir; Halk'ın alkışladığı karar Federasyonu kızdırabilir. Bu çatışma oyunun ana ikilem motorudur.

#### ŞÜPHE (0-100, yarı-gizli)
Şike/kirli para faaliyetinin federasyon ve kolluk radarındaki izi. Oyuncu tam değerini görmez; bir "termometre + risk ışığı" (yeşil/sarı/kırmızı) görür. **70+ → soruşturma tetiklenir.** (Formül §8'de.)

#### PARA — İKİ AYRI CÜZDAN
- **Temiz para:** Maaş, maç ücreti, sponsorluk. Serbestçe harcanır.
- **Kirli para:** Şike geliri. Aklanmadan büyük harcama yapılırsa Şüphe artar.

#### STRES/ENERJİ (0-100)
Haftalık aktivite bütçesi (NSS mantığı). Maç, antrenman, kulis tüketir; dinlenme, aile yeniler. **Düşük enerji → pozisyon görme oranı düşer** (§5 formülü) ve son 15 dakikada hata artar.

#### AİLE/İLİŞKİ (0-100, alt-statlar: Eş, Çocuk, Ebeveyn)
İhmal → ilişki düşer → boşanma/kriz olayları (ör. avukat masrafı, moral çöküşü → enerji tavanı düşer).

### 4.2 Karakter Statları (1-99) — Sahadaki Performans

| Stat | Ne Yapar | Etkilediği | Gerçek Temel |
|---|---|---|---|
| **Çeviklik** | Pozisyona hızlı ulaşma | Pozisyonu <10m'den görme olasılığı | Hakem bir maçta 10-13 km koşar |
| **Kondisyon** | Maç boyu enerji korunumu | Son 15 dk hata oranı; yıllık fitness testi | FIFA testi: 6×40m sprint + 75m/25m interval |
| **Konsantrasyon** | Kritik anı kaçırmama | Kritik pozisyonu "görme" tetiği | Hakem maçta ~137 gözlemlenebilir karar verir |
| **Görüş/Pozisyon Alma** | Doğru açı ve mesafe | **Görme oranının ana çarpanı** | <10m + iyi açı = doğru karar oranı çok yüksek |
| **Otorite/Karizma** | Saha hakimiyeti | Oyuncu itirazı, kart sonrası kaos yönetimi | — |
| **Soğukkanlılık** | Baskı altında akıl | VAR/tehdit anında karar süresi, blöf sezme | Son 15 dk'da hata oranı zirve yapar |

**Gerçek dünya temellendirmesi (statları meşrulaştıran veriler):**
- Yayımlanmış çalışmalar (Castagna vd., *Frontiers in Physiology*, 2026) elit hakemlerin maç başına **10-13 km** koştuğunu, mesafenin yaklaşık %10-15'inin >18 km/h yüksek hızda olduğunu gösteriyor. Premier Lig verisinde (Weston, 2008/09) sprint eşiği >25.2 km/h. → **Kondisyon** ve **Çeviklik** statlarının temeli.
- Norveç üst ligi çalışmasında hakemler müdahale ettiklerinde vakaların **%98'inde doğru karar** verdi; ortalama mesafe 13-15 m. FIFA Konfederasyon Kupası 2009 analizinde hata oranı **%14**, ve son 15 dakikada **%23'e** fırlıyor. → **Görüş** statı ve **son dakika cezası** buradan geliyor.
- Penaltı çalışması (Frontiers, 2020): mesafe **<10m iken doğru karar %83**, iyi açıda %88, iyi görüş açısında %86. → Çeviklik'in "yakına ulaşma" bonusunun sayısal temeli.

Kullanıcının verdiği örnek — *"çevik olmazsa daha az fırsatı yakalayabilir"* — birebir bu mekanikle karşılanıyor: düşük Çeviklik = pozisyona geç ulaşma = uzaktan/kötü açıdan bakma = eksik bilgiyle karar.

---

## 5. Maç Sistemi

### 5.1 Pozisyon Türleri
Penaltı • Ofsayt • Faul (sarı/kırmızı) • El (kasıtlı/kasıtsız) • Gol çizgisi (top çizgiyi tam geçti mi) • Avantaj • Oyuncu kimliği hatası. Son dördü aynı zamanda **VAR'ın 4 resmi kategorisidir** (§5.3).

Her pozisyon bir "zorluk cezası" taşır (aşağıdaki formülde). Örn. çizgi golü ve milimetrik ofsayt yüksek zorluk; ceza sahasında bariz penaltı düşük zorluk.

### 5.2 Pozisyon Sunumu ve "Doğru Görme" Formülü

Her pozisyon kısa bir pixel-art animasyondur. **Oyuncuya, karakterin statlarına göre "gördüğü kadarı" gösterilir.** Düşük Görüş'te animasyon bulanık/hızlı akar, oyuncular üst üste biner (temas belirsiz); yüksek Görüş'te net açı ve yavaşlama.

```
GörmeOranı = clamp(
    0.50                                       // baz
  + 0.30 × (Görüş / 99)                        // ana çarpan
  + 0.15 × (Konsantrasyon / 99)                // kritik anı yakalama
  + 0.10 × (Çeviklik / 99) × MesafeYakınlık    // <10m'e ulaşma
  − 0.20 × (1 − Enerji / 100)                  // yorgunluk cezası
  − ZorlukCezası[pozisyonTürü]                 // 0.05–0.30
  − (dakika > 75 ? 0.10 : 0)                   // son dakika cezası
, 0.05, 0.98)
```

- **MesafeYakınlık** = Çeviklik'e bağlı olasılıkla 1.0 (yakın) veya 0.4 (uzak).
- **GörmeOranı**, "doğru cevabın oyuncuya net gösterilme olasılığıdır." Düşükse oyuncu **eksik/yanıltıcı bilgiyle** karar verir (dalış mı gerçek faul mü ayırt edemez). Yüksekse doğru karar vurgulanır.
- Bu, kullanıcının istediği "stat → pozisyonu doğru görme yeteneği" ilişkisinin matematiksel gövdesidir.

**Örnek hesap:** Görüş 60, Konsantrasyon 50, Çeviklik 40 (uzak, MesafeYakınlık 0.4), Enerji 70, penaltı (ZorlukCezası 0.10), 80. dakika:
`0.50 + 0.30×0.606 + 0.15×0.505 + 0.10×0.404×0.4 − 0.20×0.30 − 0.10 − 0.10 = 0.50 + 0.182 + 0.076 + 0.016 − 0.06 − 0.10 − 0.10 = 0.514` → oyuncu pozisyonu %51 netlikte görür: riskli karar.

### 5.3 VAR İnceleme Mekaniği (AKICI ve NET — kullanıcının özel vurgusu)

**Gerçek protokol (IFAB/FIFA), oyunlaştırma temeli:**
- VAR yalnızca **4 durumda** devreye girer: gol, penaltı, direkt kırmızı kart, oyuncu kimliği hatası.
- Eşik: **"açık ve bariz hata" (clear and obvious error)** — orijinal karar ancak net hata varsa değişir.
- Nihai karar **her zaman saha hakeminindir** (on-field review, OFR). VAR sadece "kontrol et" der.
- Modern hız: Yarı-otomatik ofsayt teknolojisi (SAOT), FIFA Hakem Komitesi Başkanı Pierluigi Collina'ya göre ortalama ofsayt inceleme süresini **~70 saniyeden ~20-25 saniyeye** düşürdü (ESPN/Telegraph, Temmuz 2022); sistem 12 kamera + topta saniyede 500 kez veri gönderen sensör + oyuncu başına 29 nokta (saniyede 50 kez) kullanıyor.

**VAR ekranı akışı (5 adım, tek dokunuşluk, net UI):**

```
1. SİNYAL      → VAR odası telsizle "kontrol et" der (balon). Oyuncu TV işareti yapar,
                 monitöre yürür (kısa animasyon).
2. DONMUŞ KARE → Ekranda pozisyon donar. Altta büyük SCRUB BAR (zaman çizgisi).
                 Parmakla ileri/geri kaydır = yavaş çekim. Konsantrasyon yüksekse
                 "kritik kare" parlar/işaretlenir.
3. ÇİZGİ OVERLAY → Ofsaytta: tek dokunuşla kırmızı(hücum)/mavi(savunma) çizgi çizilir.
                 "Otomatik çizgi" mağaza upgrade'i = SAOT temsili, çizgiyi hizalar.
4. AÇI/ZOOM    → 2-3 kamera açısı arası geçiş + pinch-zoom. Yüksek Görüş = ekstra açı.
5. KARAR       → İki büyük buton: [KARARI DEĞİŞTİR] / [KARARI KORU].
                 Şüphe ve ilişki sonuçları burada belirginleşir (şike varsa "kasıtlı
                 yanlış karar" fırsatı = yüksek kirli ödül + yüksek Şüphe).
```

**"Akıcı ve net" nasıl sağlanıyor:** (a) tek elle, büyük dokunmatik hedefler; (b) scrub bar anlık tepki verir; (c) çizgi ve zoom otomatik hizalanır; (d) gereksiz menü yok — 5 adım maksimum. Rakibin "kamera açılarıyla tekrar izleme" özelliğini alıp, karar sonuçlarını (itibar/şüphe) ekleyerek derinleştiriyoruz.

### 5.4 Karar Verme UI'ı ve Zaman Baskısı
Pozisyon sonrası **3-5 saniyelik geri sayan halka** (Papers Please'in zaman baskısı dersi). **Soğukkanlılık** statı süreyi uzatır (yüksekse +2 sn). Butonlar bağlama göre: `Penaltı / Devam / Sarı Kart / Kırmızı Kart / VAR'a Git`. Süre biterse "kararsız kaldın" cezası (otomatik "devam" + Otorite düşüşü).

---

## 6. Şike Sistemi

### 6.1 Teklif Üretim Mantığı

```
TeklifOlasılığı = BazOran[ligSeviyesi]
               × MaçÖnemÇarpanı(derbi/küme düşme = ×2.5)
               × (1 + (100 − Federasyonİlişkisi)/200)   // düşük federasyon = daha savunmasız
               × (1 + geçmişKabulSayısı × 0.1)          // bir kez kabul edince tekrar gelir
```

**Kaynaklar (NPC tipleri):** Kulüp yöneticisi • Bahisçi/mafya • Aracı ("aracılar üzerinden görüşme" — 2011 şike davasında Aziz Yıldırım iddianamesindeki gerçek yönteme gönderme). Büyüklük lig seviyesiyle ölçeklenir (il liginde küçük, Süper Lig derbisinde devasa).

### 6.2 Seçim Ağacı (Tam Sonuç Tablosu)

| Seçim | Kirli Para | Şüphe | Teklif eden NPC | Ek Sonuç | Risk |
|---|---|---|---|---|---|
| **Reddet** | 0 | 0 | Güven −10 | Tekrar tehdit/teklif gelebilir | Düşük |
| **Kabul et + yap** | +Tam | +15 | Güven +20 | Maç sonucu manipüle; gözlemci fark edebilir | Orta-Yüksek |
| **Kabul et + yapma (dolandır)** | +Tam | +5 | **Kin +80** | NPC intikam moduna geçer (tehdit/ifşa) | Çok Yüksek |
| **İhanet (double-cross)** | Kısmi + ödül | −5 (federasyon ödülü) | **Kin +100**, karşı taraf Güven +15 | Federasyon İlişkisi +15, koruma | En Yüksek |

**İhanet (double-cross) detayı:** Teklifi kabul edip parayı al, ama gizlice federasyona/karşı tarafa bildir. Ödül: Federasyon İlişkisi sıçrar, olası nakit ödül, Şüphe temizlenir. Bedel: teklif eden mafya/kulüp seni ölümüne düşman belleyip (Kin 100) fiziksel tehdit/şantaj başlatır. Bu, oyunun en gerilimli high-risk/high-reward hamlesidir.

### 6.3 NPC Hafıza ve Güven Sistemi
Her NPC bir Resource: `{guven: 0-100, kin: 0-100, guc: tehdit_kapasitesi, hafiza: [geçmiş etkileşimler]}`. Reigns'in "önceki seçimler kartları yeniden derler" mantığı burada uygulanır: dolandırdığın bir bahisçi haftalar sonra şantajla geri döner; ihanet ettiğin kulüp medyaya belge sızdırır. Bu, "her seçim anlamlı hissedilir" etkisini yaratır (Reigns tasarımcısı François Alliot'nun quality-based narrative yaklaşımı).

---

## 7. Tehdit ve Baskı Sistemi

**Gerçek dünya temellendirmesi (oyunun bu katmanını tümüyle meşrulaştıran vaka):** 11 Aralık 2023'te Süper Lig hakemi Halil Umut Meler, MKE Ankaragücü başkanı Faruk Koca tarafından maç sonunda sahada yumruklandı; yerde tekmelendi ve Koca'nın *"seni bitiririm / seni öldüreceğim"* tehdidine maruz kaldı (Reuters/Anadolu Ajansı). Sonuç: TFF tüm ligleri süresiz erteledi; PFDK Koca'ya 5 yıl (3 yılı aştığı için sürekli hak mahrumiyetine = ömür boyu men'e dönüşen) ceza verdi; Ankara mahkemesi "kamu görevlisini kasten yaralama"dan 3 yıl 7 ay hapis verdi; Ankaragücü'ne 2 milyon TL para cezası + 5 maç seyircisiz oynama cezası verildi (ESPN/AA). Bu vaka, oyundaki tehdit ve fiziksel saldırı olaylarına gerçekçi bir zemin sağlar.

| Tehdit Türü | Tetikleyici | Oyuncu Yanıtları | Sonuçlar |
|---|---|---|---|
| **Taraftar tehdidi** | Halk < 30 | Görmezden gel / Koruma tut / Polise git | Stres +; koruma para; polis Halk'ı biraz artırır |
| **Mafya/bahisçi tehdidi** | Dolandırma sonrası / ret | Boyun eğ (şike yap) / Diren / Federasyona bildir | Kirli para veya şiddet olayı |
| **Şantaj** | Geçmiş kabul + düşman NPC | Öde / Reddet / Kendin ifşa et (zararı azalt) | Para kaybı / Şüphe patlaması |
| **Fiziksel saldırı** | Halk çok düşük + derbi | Dava aç / Sus | **Sakatlık** → enerji tavanı düşer, maç kaçırma; dava Halk'ı artırır |

**Sahte tehdit (özgün mekanik, §20/7):** Bazı tehditler blöftür. **Soğukkanlılık** yüksekse "bu blöf" ipucu görünür; düşükse gereksiz yere para/taviz verirsin.

---

## 8. Şüphe / Yakalanma / Soruşturma Sistemi

### 8.1 Şüphe Artış Formülü
```
ΔŞüphe (haftalık) =
    5 × (şikeBüyüklüğü / ortalamaŞikeBüyüklüğü)
  + 3 × (gösterişliHarcama / haftalıkGelir)          // lüks araba/ev kirli parayla
  + 2 × (aklanmamışKirliPara > eşik ? 1 : 0)
  + 4 × (yakalananNPC bu hafta ifşa verdi ? 1 : 0)
  − 2 × (Federasyonİlişkisi > 80 ? 1 : 0)            // kurumsal koruma
  − 1                                                 // doğal soğuma (zamanla unutulur)
```

**Gerçek temel — "bahis anomalisi" göstergesi:** UEFA'nın Betting Fraud Detection System'i (Sportradar ile) her yıl Avrupa'da **yaklaşık 32.000 maçı** izler (UEFA.com resmi açıklaması); Sportradar Integrity Services ise 2024'te dünya çapında 70 spor dalında **850.000'den fazla maçı** izleyip **1.108 şüpheli maç** tespit etti (GlobeNewswire, 9 Ocak 2025). Sistem, hesaplanan oranlarla gerçek bahis oranlarını karşılaştırıp anomali arar; CAS kararlarında "sahadaki şüpheli aksiyonlar + rakip şüphesi + geç gol paterni" gibi dış faktörlerle birleşince delil sayılır. Oyunda bunu **maç ekranındaki "bahis hareketi" ikonu** temsil eder: bariz şike yaparsan anomali ışığı yanar, Şüphe sıçrar.

### 8.2 Soruşturma Mekaniği
- **Şüphe ≥ 70 → federasyon soruşturması açılır.** UI: "Hakkında soruşturma başlatıldı" bildirimi + geri sayım.
- **Kanıt sistemi:** Her kirli işlem gizli bir "kanıt puanı" bırakır. Soruşturma bu puanları toplar.
- **Avukat:** Para karşılığı kanıt puanı siler/geciktirir (ama gösterişli avukat masrafı da dikkat çeker).
- **Koruma:** Tehdit şiddetini azaltır, kanıta etkisi yok.
- **Federasyon İlişkisi:** 80+ ise soruşturma yavaşlar veya kapanabilir (2011 davasındaki federasyon-kulüp yakınlığı, "Tahkim Kurulu kararlarına örgüt lehine müdahale" iddialarına gönderme).

### 8.3 Ceza Türleri (gerçek TFF çerçevesi)
**TFF Futbol Disiplin Talimatı Madde 58 ("Müsabaka Sonucunu Etkileme"):** İhlal veya ihlale teşebbüs **hakem tarafından** işlenirse → **sürekli hak mahrumiyeti** (ömür boyu men). Süreli ceza 15 günden az, 3 yıldan fazla olamaz; 3 yılı aşan ceza otomatik olarak sürekli hak mahrumiyetine döner.

**Önemli ayrım (oyunun korumas gereken nüans):** 2025 Türk futbolu bahis skandalında TFF, 31 Ekim 2025'te **149 hakeme 8-12 ay hak mahrumiyeti** verdi — ama bu **bahis oynama** (FDT Madde 57) cezasıdır, kanıtlanmış **şike** (Madde 58) değil. Şike ömür boyu men getirirken, bahis daha hafif cezalandırılır. Oyun bu ayrımı korumalı: küçük ihlaller (bahis benzeri) hafif, kanıtlanmış şike ölümcül.

**Oyun içi ceza kademesi:** Uyarı/kınama → para cezası → geçici men (maç kaçırma, gelir kaybı) → sürekli hak mahrumiyeti + olası hapis (bkz. §13 "Yakalandın" sonu).

---

## 9. Sosyal Hayat ve Özel Hayat Sistemi

**NPC havuzu:** Eş • Çocuk • Ebeveyn • Hakem arkadaşı (bilgi/dedikodu kaynağı) • Gözlemci (notunu etkiler) • Gazeteci (skandal örtbas/ifşa).

**Zaman/enerji bütçesi (NSS dilemma mantığı):** Her hafta sınırlı "boş zaman bloğu" var. Klasik dilemma: *"Bu akşam çocuğunun maçına mı gideceksin, yoksa kulis yemeğine mi?"* Her seçim bir ilişkiyi besler, diğerini ihmal eder.

**İhmal sonuçları:**
- Aile/İlişki 0'a inerse: boşanma olayı (para bölünmesi + moral), çocukla kopukluk (enerji tavanı −).
- Gazeteci ilişkisi iyi tutulursa: skandal patladığında Halk düşüşü yumuşar.
- Hakem arkadaşları: şike teklifleri ve federasyon dedikoduları hakkında önceden ipucu verir.

---

## 10. Ekonomi

**Gerçek gelir temeli (oyunun "temiz para yetmiyor → şike cazip" gerilimini kuran veriler):** TFF verilerine göre 2024-25 sezonunda 97 Türk hakeme toplam **62.338.895 TL** ödendi; en çok kazanan Cihan Aydın 23 maçta **1.678.375 TL** aldı (Takvim/TFF). Hacıosmanoğlu döneminde maç başı ücret %75 zamla 30 bin→**52 bin TL**'ye, aylık maaş 120 bin→**200 bin TL**'ye çıkarıldı (Ekonomi Hattı). Üst klasman hakemi aylık 45-70 bin TL / maç başı 20-35 bin TL, VAR maç başı ~26 bin TL (Haberler.com). **Kritik nokta:** Alt liglerde bu rakamlar çok düşük — oyunda kariyerin başında temiz para kıttır, şike orantısız cazip görünür. Bu, tasarımın merkezindeki ahlaki gerilimin ekonomik motorudur.

| Gelir Kaynağı | Tür | Not |
|---|---|---|
| Aylık maaş | Temiz | Lig seviyesiyle ölçeklenir |
| Maç başı ücret | Temiz | Atama başına |
| Sponsorluk | Temiz | Halk İlişkisi + itibar gerektirir |
| Şike | **Kirli** | Yüksek ama Şüphe biriktirir |

| Harcama | İşlev |
|---|---|
| Ev | Enerji yenileme bonusu (NSS "property" mantığı) |
| Araba | İtibar/gösteriş — ama kirli parayla alınırsa Şüphe |
| Avukat | Soruşturmada kanıt silme |
| Koruma | Tehdit azaltma |
| Antrenman/eğitim | Stat artışı |
| Aile/hediye | İlişki bakımı |

**Kirli para aklama:** Kirli → temiz dönüşümü işletme/gayrimenkul üzerinden, **%20-30 kayıp oranıyla** ve zaman gecikmesiyle. **Aklanmamış kirli parayla gösterişli harcama Şüphe'yi artırır** (formül §8.1). Bu, "parayı kazandın ama harcayamıyorsun" gerginliğini yaratır — Papers Please'in "kazandığın ama aileye yetmeyen para" gerilimi gibi.

---

## 11. Karakter Geliştirme

- **Antrenman:** Enerji harca → stat artır. Artış eğrisi logaritmik (yüksek statı yükseltmek daha pahalı) — grind'i sınırlar.
- **Yaş/yıpranma:** ~40 yaştan sonra Çeviklik ve Kondisyon yılda düşmeye başlar. FIFA yaş sınırı **45** (gerçek TFF/FIFA kuralı). Yaşlandıkça saha statları düşer ama Otorite/Soğukkanlılık deneyimle yükselir.
- **Yıllık vize/fitness sınavı:** Her sezon başı fitness testi (6×40m sprint + interval mini-oyun). **Geçemezsen o sezon maç alamazsın** — gerçek TFF kuralı ("koşu testini geçmek zorunlu; geçemezsen maç yönetme hakkını kaybedersin"). Antrenman stat düşüşünü yavaşlatır.

---

## 12. Kariyer İlerlemesi

**Gerçek TFF basamakları:** Aday Hakem → İl Hakemi → Bölgesel Hakem → Ulusal Hakem (3. Lig → 2. Lig → 1. Lig) → Üst Klasman Hakemi (Süper Lig) → FIFA Kokartlı Hakem. Terfi kriteri: gözlemci not ortalaması + yıllık fitness/teori sınavı + MHK onayı + Federasyon İlişkisi.

| Seviye | Maç Başı Gelir | Şike Teklifi | Şüphe Hassasiyeti | Tehdit Riski |
|---|---|---|---|---|
| Aday/İl | Çok düşük | Nadir, küçük | Düşük | Düşük |
| Bölgesel | Düşük | Küçük | Düşük | Düşük |
| Ulusal (3.-1. Lig) | Orta | Orta sıklık/tutar | Orta | Orta |
| Üst Klasman (Süper Lig) | Yüksek | Sık, büyük | Yüksek | Yüksek |
| FIFA Kokartlı | Çok yüksek | Uluslararası, devasa | Çok yüksek (BFDS radarı) | Yüksek |

**Tasarım eğrisi:** Yükseldikçe ödül ve risk birlikte artar (Papers Please'in "her gün kural karmaşıklaşır" tırmanışı). FIFA seviyesinde tek bir şike bile BFDS anomalisi ve global soruşturma tetikleyebilir.

---

## 13. Sonlar (Endings)

| Son | Tetikleyici Koşul | Ton |
|---|---|---|
| **Efsane Hakem** | FIFA kokartı + Halk > 80 + Şüphe hiç 40 aşmamış | Onurlu emeklilik, heykel |
| **Kukla** | Federasyon > 85 ama Halk < 30 (tamamen kayırmalı) | Güvende ama itibarsız |
| **Sürgün** | Federasyon < 15, kariyer alt liglerde çürür | Unutulma |
| **Yakalandın** | Şüphe 100 + soruşturma delili yeterli | Sürekli hak mahrumiyeti + hapis |
| **Kaçış** | Yüksek kirli para + zamanında bırakma (Şüphe patlamadan) | Yurtdışına kaçış, tedirgin zenginlik |
| **Trajik Son** | Halk ≈ 0 + tetiklenen fiziksel saldırı | Kariyer/sağlık biter (Meler vakası ilhamı) |

New game+ / replay: BitLife ve NSS'in "öldün, yeni hayat" mantığı — her sonda bir "kariyer skoru" ve "nasıl hatırlandın" özeti; yeni oyunda küçük başlangıç bonusu.

---

## 14. Görsel Yön ve Sanat Stili

- **Stil:** 16-bit pixel art (Retro Bowl / Retro Goal referansı) — okunur, hızlı üretilebilir, nostaljik.
- **Tema paleti (karanlık/gerilimli):** Taban antrasit/koyu lacivert (#1a1a2e, #16213e); saha koyu yeşil (gece maçı hissi); **kritik vurgu kırmızı** (kart, tehdit, kırmızı ışık Şüphe); **altın/sarı** (para, kupa). Şike/tehdit ekranlarında kırmızımsı vinyet ve karartma.
- **UI prensipleri:** Minimalist, tek elle oynanabilir, büyük dokunmatik hedefler (>48px), okunur pixel font (Türkçe karakter desteği — ç,ğ,ı,ö,ş,ü şart). Bilgi hiyerarşisi net: statlar üstte küçük ikon+bar (Reigns'in 4 pilar barı gibi), aksiyon altta büyük buton.
- **Ekran mockup açıklamaları:**
  - *Maç ekranı:* Üstte skor+dakika+enerji bar; ortada pixel-art saha/pozisyon animasyonu; altta karar butonları + geri sayan halka.
  - *VAR ekranı:* Donmuş kare tam ekran; altta kalın scrub bar; sağda açı/zoom/çizgi ikonları; en altta iki büyük karar butonu.
  - *Teklif ekranı:* Karanlık oda, gölgeli NPC portresi, zarf/para animasyonu; 4 seçenek dikey liste; her seçenekte küçük risk ikonu (Reigns'in "bu stat etkilenecek" noktaları gibi).

---

## 15. Tüm Ekranların Listesi ve Akışı

**Ekranlar:** Ana Ekran (Hub) • Maç Ekranı • VAR Ekranı • Teklif Ekranı • İlişki/Sosyal Ekran • Mağaza (harcama/aklama) • Antrenman Ekranı • Kariyer/Terfi Ekranı • Soruşturma Ekranı • Ayarlar • Ana Menü/Kayıt.

```
                    ┌──────────── ANA MENÜ ────────────┐
                    │  Yeni Oyun / Devam / Ayarlar     │
                    └──────────────┬───────────────────┘
                                   ▼
        ┌═══════════════════ ANA EKRAN (HUB) ═══════════════════┐
        │   [Antrenman] [Sosyal] [Mağaza] [Kariyer] [Ayarlar]   │
        │                        │                              │
        │                 [ATAMAYI OYNA]                        │
        └────────────────────────┬──────────────────────────────┘
                                 ▼
                    ┌─── MAÇ ÖNCESİ OLAY? ───┐
                    │  (Teklif / Tehdit)     │◄──► [Teklif Ekranı]
                    └───────────┬────────────┘
                                ▼
                        [MAÇ EKRANI] ◄──────► [VAR EKRANI]
                                │
                                ▼
                        [MAÇ SONU ÖZET]
                                │
                     (Şüphe ≥70?) ──► [SORUŞTURMA EKRANI]
                                │
                                └──────► ANA EKRAN
```

Navigasyon kuralı: Hub her şeyin merkezi; maç akışı doğrusal (geri dönülemez — karar ağırlığı için); soruşturma ve tehdit hub'a "araya giren" modal olarak gelir.

---

## 16. Teknik Mimari (Godot 4)

### 16.1 Klasör Yapısı
```
res://
├── scenes/
│   ├── main.tscn          # giriş, autoload bootstrap
│   ├── hub.tscn           # ana ekran
│   ├── match.tscn         # maç
│   ├── var_review.tscn    # VAR ekranı
│   ├── offer.tscn         # şike teklifi
│   ├── social.tscn        # ilişki ekranı
│   ├── shop.tscn          # mağaza/aklama
│   ├── training.tscn
│   ├── career.tscn
│   └── investigation.tscn
├── scripts/
│   ├── autoload/          # singleton'lar (aşağıda)
│   ├── systems/           # oyun mantığı sınıfları
│   └── ui/                # ekran kontrolcüleri
├── resources/
│   ├── stats/             # RefereeStats.tres
│   ├── offers/            # *.tres şike şablonları
│   ├── npcs/              # NPC.tres
│   └── events/            # Event.tres
├── data/
│   ├── dialogues/*.json   # diyalog/olay ağaçları
│   └── positions/*.json   # maç pozisyon tanımları
└── assets/ (sprites/, audio/, fonts/)
```
Godot best practice: küçük projede sadeleştir, içerik büyüdükçe böl. Custom `Resource` = Unity'nin ScriptableObject'i; stat/item/olay verisi için ideal.

### 16.2 Autoload/Singleton Script'ler
`GameManager` (oyun durumu, hafta ilerletme) • `StatManager` (tüm statlar, eşik kontrolü, sinyal yayını) • `MatchManager` (pozisyon üretimi, görme oranı, VAR akışı) • `OfferSystem` (şike üretimi, seçim ağacı) • `SuspicionSystem` (Şüphe formülü, soruşturma) • `ThreatSystem` (tehdit üretimi/yanıt) • `RelationshipManager` (NPC güven/kin/hafıza) • `EconomyManager` (temiz/kirli cüzdan, aklama) • `EventSystem` (haftalık olay havuzu, sinyal bus) • `SaveSystem` (kaydet/yükle).

### 16.3 Veri Modeli (Resource + JSON)
Godot'ta iki yaklaşım birlikte: **Resource** (@export'lu class, `ResourceSaver.save()` ile hem veri hem save) statik/tasarım verisi için; **JSON** diyalog/olay ağaçları için (motordan bağımsız, editör dostu — ileride motor değiştirsen taşınır).

```gdscript
class_name RefereeStats extends Resource
# Karakter statları (1-99)
@export var agility := 30
@export var stamina := 30
@export var concentration := 30
@export var vision := 30
@export var authority := 30
@export var composure := 30
# İlişki/durum statları (0-100)
@export var public_rel := 50
@export var federation_rel := 50
@export var suspicion := 0
@export var energy := 100
@export var family_rel := 60
# Ekonomi (iki cüzdan)
@export var clean_money := 0
@export var dirty_money := 0
# Kariyer
@export var league_tier := 0   # 0=aday ... 5=FIFA
@export var age := 25
```

Şike teklifi JSON şeması:
```json
{
  "id": "offer_042",
  "source": "mafia",
  "amount": 500000,
  "match_id": "m_15",
  "trust_required": 20,
  "outcomes": {
    "accept_do":   {"dirty": 500000, "suspicion": 15, "npc_trust": 20},
    "accept_skip": {"dirty": 500000, "suspicion": 5,  "npc_kin": 80},
    "reject":      {"npc_trust": -10},
    "betray":      {"federation_rel": 15, "npc_kin": 100, "reward": 200000, "suspicion": -5}
  }
}
```

### 16.4 Olay/Event Sistemi
`EventSystem` sinyal tabanlı (signal bus). Her hafta sonunda `check_conditions()` global state'e göre uygun olayları havuzdan çeker — **Reigns'in quality-based narrative'i**: mevcut stat durumuna göre olay kartları yeniden derlenir, böylece kısmen rastgele kısmen "yazılmış" olaylar karışır ve her olay anlamlı hissedilir. Diyalog için hazır çözüm: açık kaynak Godot JSON dialogue sistemleri (ör. `gd_dialogue`) + branching + callback (bir seçim `start_investigation()` gibi fonksiyon tetikler). Save: "Persist" grubundaki node'lar `save()` döndürür → JSON satır satır dosyaya; veya doğrudan `RefereeStats` resource'unu `ResourceSaver` ile kaydet. Şema değişince göç (migration) planı şart (versiyon alanı ekle).

---

## 17. Geliştirme Yol Haritası (Tek Kişilik Ekip)

### MVP — İlk Çalışan Prototip (en önemli faz)
**Kesin kapsam:** 1 lig • tek stat seti (6 karakter + 4 durum statı) • 3 pozisyon türü (penaltı/ofsayt/faul) • basit VAR (donmuş kare + scrub + çizgi) • 1 şike teklif tipi (yalnızca kabul/red) • Şüphe + iki cüzdan + Halk/Federasyon statları • 3 ekran (hub + maç + teklif) • save/load. **Amaç: "karar hissi" ve core loop eğlenceli mi?** sorusunu cevaplamak. Zorluk: orta. Süre (tek kişi, part-time): birkaç ay.

### Fazlar
| Faz | İçerik | Zorluk |
|---|---|---|
| **Faz 2** | Tehdit sistemi, sosyal hayat, antrenman, kariyer terfi, VAR upgrade'leri | Orta |
| **Faz 3** | İhanet/double-cross, tam soruşturma+kanıt+avukat, aklama, tüm sonlar, NPC hafıza | Yüksek |
| **Faz 4** | Pixel-art cila, ses/müzik, çoklu lig, İngilizce lokalizasyon, mağaza optimizasyonu | Orta |

**Önceliklendirme (tek kişi kuralı):** Önce *core loop + karar hissi* (MVP), sonra *ekonomik/ahlaki gerilim* (Faz 2-3), en son *cila* (Faz 4). Sanat işini erken dondurma — placeholder sprite ile mekaniği kanıtla, sonra sanata yatırım yap.

---

## 18. Monetizasyon Planı

**Rakibin dersi net:** Aşırı interstitial reklam kullanıcıyı kaçırıyor (yorumlar bunu haykırıyor). Kanıtlı veriler:
- Oyuncular rewarded reklamı interstitial'a **4'e 1** tercih ediyor (Tapjoy/Unity).
- İlk hafta tek bir rewarded reklam izleyen oyuncularda 30-gün retention **%50+**, benchmark ise **%13** (Unity resmi blogu).
- Agresif interstitial ilk oturumda oyuncuların **%15-25'ini** kaçırabiliyor; interstitial'ın gelire etkisi engagement/retention üzerinden dolaylı ve genelde negatif.

**Önerilen model — Retro Bowl yolu:** Retro Bowl "hiç ücretli reklam vermeden, sadece TikTok/Apple öne çıkarmasıyla App Store #1" oldu; temiz premium algısı büyümeyi organik besledi.
1. **Ücretsiz indirilir + tek seferlik "Premium/Reklamsız" satın alma** (ana gelir).
2. **İlk oturumda HİÇ interstitial yok** (ilk 60-90 sn ve onboarding'de reklam yasak — D1 retention'ı korur).
3. **Interstitial kullanılacaksa:** yalnızca doğal kırılımlarda (sezon sonu), min. 2-3 dk aralık, atlanabilir.
4. **Rewarded reklam = tamamen opsiyonel ve temaya gömülü:** "avukat ücretini reklam izleyerek karşıla", "ekstra antrenman seansı", "fitness testi için ikinci deneme". Oyuncuya değer verir, rahatsız etmez.
5. **Çevrimdışı oyna** (rakibin çevrimdışı olmaması büyük şikayet — bunu satış argümanı yap).

---

## 19. Riskler ve Açık Sorular

- **Denge riski (en kritik):** Şike çok kârlı olursa herkes yapar, ahlaki gerilim kaybolur; çok riskli olursa kimse denemez. Çözüm: risk-ödül eğrisini playtestle ince ayarla; Şüphe soğuma hızı ve BFDS anomali eşiği ana kaldıraçlar.
- **Hukuki/telif riski:** Gerçek kulüp/hakem/başkan isimleri **kullanılamaz**. Kurgusal isimler ("Sarı-Lacivertliler", "Başkent United"), jenerik lig ("Ulusal Süper Lig"). 2011 şike davası, Meler-Koca vakası, gerçek hakem ücretleri yalnızca **ilham ve mekanik temel** olarak kullanılır — birebir kişi/olay canlandırması yapılamaz (iftira/kişilik hakları riski).
- **Mağaza politikası riski:** Şike/suç teması "suç işleme rehberi" gibi sunulmamalı — sonuç-odaklı, hicivli, cezalandırıcı kurgu (Papers Please/GTA gibi meşru çerçeve). App Store/Play "gambling" politikalarına dikkat: gerçek bahis değil, kurgusal.
- **Teknik risk:** VAR scrub bar'ın mobilde akıcılığı (yavaş çekim animasyonu performansı — sprite sheet optimizasyonu gerekir); save şema göçü (versiyon alanı şart).
- **Açık soru 1:** Enerji sistemi NSS gibi cezalandırıcı mı olacak (grind hissi riski) yoksa daha cömert mi? → Playtest kararı.
- **Açık soru 2:** Şüphe oyuncuya ne kadar görünür olmalı? Tam gizli = adaletsiz his; tam görünür = gerilim kaybı. Öneri: yarı-görünür termometre.
- **Açık soru 3:** Kariyer uzunluğu — tek uzun kariyer mi (BitLife/NSS), yoksa kısa tekrar oynanabilir seanslar mı (Reigns)? Öneri: ~3-4 sezonluk orta uzunlukta kariyer + new game+.

---

## 20. Özgün Ek Mekanik Önerileri (kullanıcının listelemediği yaratıcı fikirler)

1. **"Kayıt/Sigorta" mekaniği:** Kabul ettiğin şikelerin gizli kaydını tutabilirsin — ihanet/şantaj için koz (karşı tarafı da batırırsın) ama ev araması olursa **delil** olur. Klasik risk-ödül.
2. **Medya/sosyal medya dalgası:** Her kritik karar sonrası "trend" olur; algoritma Halk İlişkisini anlık ±20 sallar. Gazeteci ilişkin yüksekse dalgayı yumuşatabilirsin.
3. **Gözlemci ikilemi:** Maçını değerlendiren gözlemci de yozlaşabilir — notunu satın alabilirsin (Federasyon İlişkisi yükselir ama yeni bir Şüphe/kin kaynağı doğar).
4. **VAR odası kariyeri:** Kariyerin ilerisinde VAR hakemi olarak uzaktan maç yönlendirme opsiyonu — sahada olmadan karar manipüle etme (farklı risk profili, Türkiye'de yerli/yabancı VAR tartışması gerçeğine gönderme).
5. **İtibar mirası & "nasıl hatırlanacaksın" skoru:** Kariyer sonu bir belgesel/anı özeti; new game+ için küçük bonus. BitLife'ın "yaşam özeti"nin ahlaki versiyonu.
6. **Derbi baskısı:** Büyük maçlarda tüm statlar zorlanır (Görme oranı −, zaman baskısı +), teklif ve tehdit olasılığı katlanır — ama ödül ve terfi ivmesi de en yüksek.
7. **Sahte tehdit (blöf) sistemi:** Bazı tehditler blöftür; **Soğukkanlılık** yüksekse blöfü sezersin ve gereksiz taviz vermezsin. Düşükse blöfe kanıp para/itibar kaybedersin.
8. **"Temiz Kal" challenge modu:** Hiç şike kabul etmeden FIFA kokartına ulaşma — zor mod, özel rozet. Papers Please'in "kimseyi haksız çevirme" idealizm meydan okumasının muadili.

---

*Bu doküman, gerçek TFF/FIFA hakemlik yapısı, VAR protokolü, şike tespit sistemleri, hakem ücretleri ve başarılı mobil oyun tasarım kalıpları üzerine yapılan araştırmayla temellendirilmiştir. Tüm gerçek vakalar (2011 şike davası, Meler-Koca olayı, 2025 bahis skandalı, hakem ücretleri) yalnızca mekanik temellendirme ve ilham amacıyla kullanılmalı; oyunda kurgusal isimler ve durumlarla soyutlanmalıdır.*
