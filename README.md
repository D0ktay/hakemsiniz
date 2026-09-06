# Hakemsiniz

Hakem kariyeri + kulis/şike temalı 2D mobil oyun. Godot 4.7 (Mobile render).
Tasarım detayları için [docs/GDD.md](docs/GDD.md).

## Gereksinimler

- [Godot 4.7.2](https://godotengine.org/download)

## Geliştirme

Projeyi Godot editöründe açmak için `project.godot` dosyasını kullanın. VSCode ile
GDScript geliştirmesi için `.vscode/` klasöründeki ayarlar hazır gelir
(`geequlim.godot-tools` eklentisi gereklidir).

## Mevcut durum

GDD'deki MVP (§17) ve Faz 2-3 sistemlerinin (§7-13) mantık katmanı uygulandı:

| Sistem | Dosya | GDD |
|---|---|---|
| Statlar (Resource) | `scripts/resources/referee_stats.gd` | §4 |
| Hafta döngüsü, kayıt/yükleme | `scripts/autoload/game_manager.gd` | §3 |
| Pozisyon + Görme Oranı + basit VAR | `scripts/autoload/match_manager.gd` | §5 |
| Şike (4 seçenek: yap/dolandır/reddet/ihanet) | `scripts/autoload/offer_system.gd` | §6 |
| Tehdit (şantaj/taraftar/saldırı) | `scripts/autoload/threat_system.gd` | §7 |
| Kariyer terfi, fitness testi, sonlar | `scripts/autoload/career_system.gd` | §11-13 |
| Aklama, avukat, koruma, ev | `scripts/autoload/economy_system.gd` | §10 |
| Ekranlar | `scenes/*.tscn` (hub, match, offer, threat, training, social, shop, career, ending) | §15 |

**Henüz yok:**
- Pixel-art görseller / animasyon — şu an sade UI (buton + label), hiç sprite yok.
- VAR'ın tam 5 adımlı akışı (§5.3) — şu an tek panelli basitleştirilmiş versiyon.
- NPC hafızasının olay/diyalog sistemine bağlanması (gözlemci ikilemi, medya dalgası, sahte tehdit ayrımı vb. §20 özgün mekanikler).
- Reklam/IAP entegrasyonu (§18) — bilinçli olarak ertelendi, içerik netleşmeden eklenmemeli.
- iOS export — Windows'ta Xcode projesi üretilebilir ama derleme/imzalama için Mac + Xcode şart.

Test etmek için Godot editöründe projeyi açıp F5 ile çalıştırın (ana sahne: Hub).
