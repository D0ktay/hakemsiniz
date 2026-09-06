# Hakemsiniz

Hakem kariyeri + kulis/şike temalı 2D mobil oyun. Godot 4.7 (Mobile render).
Tasarım detayları için [docs/GDD.md](docs/GDD.md).

## Gereksinimler

- [Godot 4.7.2](https://godotengine.org/download)

## Geliştirme

Projeyi Godot editöründe açmak için `project.godot` dosyasını kullanın. VSCode ile
GDScript geliştirmesi için `.vscode/` klasöründeki ayarlar hazır gelir
(`geequlim.godot-tools` eklentisi gereklidir).

## Mevcut durum (MVP çekirdek döngü)

GDD §17'deki MVP kapsamının ilk sürümü uygulandı:

- `scripts/resources/referee_stats.gd` — tüm karakter ve durum statları (Resource)
- `scripts/autoload/game_manager.gd` — hafta döngüsü, kayıt/yükleme (`user://savegame.tres`)
- `scripts/autoload/match_manager.gd` — pozisyon üretimi, Görme Oranı formülü (§5.2), basit VAR (§5.3)
- `scripts/autoload/offer_system.gd` — şike teklifi üretimi (kabul/reddet)
- `scenes/hub.tscn`, `scenes/match.tscn`, `scenes/offer.tscn` — 3 temel ekran

Henüz yok: tehdit sistemi, sosyal hayat, antrenman, kariyer terfi, ihanet seçeneği,
soruşturma/kanıt sistemi, sonlar, pixel-art görseller (Faz 2-4, bkz. GDD §17-19).

Test etmek için Godot editöründe projeyi açıp F5 ile çalıştırın (ana sahne: Hub).
