PRAGMA foreign_keys = ON;
CREATE TABLE uyeler(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ad TEXT NOT NULL,
    yas INTEGER(yas>13),
    sehir TEXT DEFAULT "Erzincan",
    kayıt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE kitaplar(
    id INTEGER PRIMARY KEY,
    ad TEXT NOT NULL UNIQUE
);

CREATE TABLE odunc (
    uye_id INTEGER,
    kitap_id INTEGER,
    PRIMARY KEY (uye_id, kitap_id),
    FOREIGN KEY (uye_id) REFERENCES uyeler(id) ON DELETE CASCADE,
    FOREIGN KEY (kitap_id) REFERENCES kitaplar(id)
);

INSERT INTO kitaplar (ad) VALUES
('Nutuk'),
('Karamazov Kardeiler'),
('Suç ve Ceza'),
('Oblomov'),
('Kürk Mantolu Madonna');

INSERT INTO uyeler (ad, yas, sehir) VALUES
('Ahmet Yılmaz', 25, 'İstanbul'),
('Ayşe Kaya', 19, 'Ankara'),
('Mustafa Aydın', 40,'Hatay'),
('Elif Yıldız', 17,'Malatya'),
('Caner Şahin', 33,'Van'),
('Ali Öztürk', 22, 'İzmir'),
('Selin Doğan', 21, 'Antalya'),
('Zeynep Arslan', 28, 'Bursa'),
('Yusuf Beytekin',23, 'Malatya');

-- Şehir girilmemiş.
INSERT INTO uyeler (ad, yas) VALUES
('Mehmet Demir', 30),
('Fatma Çelik', 15);

INSERT INTO uyeler (ad, yas) VALUES ('Kerem Ak', 10);
-- Amaç: 13 yaş ve altını reddetmek.

INSERT INTO odunc (uye_id, kitap_id) VALUES (99, 1);
-- Hata: 99 numaralı üye yok.

INSERT INTO odunc (uye_id, kitap_id, gun) VALUES
(1, 1, 15),
(1, 2, 30),
(2, 2, 7),
(2, 3, 45),
(3, 1, 3),
(3, 4, 14),
(4, 3, 21),
(4, 5, 10),
(5, 4, 35),
(5, 5, 40),
(6, 1, 12),
(6, 3, 28),
(7, 2, 5),
(7, 4, 18),
(8, 3, 42),
(8, 5, 8),
(9, 1, 25),
(9, 5, 30),
(10, 2, 20),
(10, 4, 45);

SELECT uyeler.ad as uye_Adı, kitaplar.ad as kitap_adı, odung,gun FROM odunc
INNER JOIN uyeler ON odunc.uye_id = uyeler.id
INNER JOIN kitaplar ON odunc.kitap_id = kitaplar.id;
WHERE odunc.gun>30
WHERE uyeler.sehir = 'Erzincan'

SELECT uyeler.ad AS uye_adi, kitaplar.ad AS kitap_adi, odunc.gun FROM uyeler
LEFT JOIN odunc ON uyeler.id = odunc.uye_id
LEFT JOIN kitaplar ON odunc.kitap_id = kitaplar.id;

SELECT
    uyeler.ad AS uye_adi,
    COUNT(odunc.kitap_id) AS alinan_kitap_sayisi,
    AVG(odunc.gun) AS ortalama_sure,
    MAX(odunc.gun) AS en_uzun_sure
FROM uyeler
INNER JOIN odunc ON uyeler.id = odunc.uye_id
GROUP BY uyeler.id, uyeler.ad
HAVING AVG(odunc.gun) > 20;

SELECT
    kitaplar.ad AS kitap_adi,
    COUNT(odunc.uye_id) AS odunc_alinma_sayisi
FROM kitaplar
LEFT JOIN odunc ON kitaplar.id = odunc.kitap_id
GROUP BY kitaplar.id, kitaplar.ad;

SELECT
    sehir,
    COUNT(*) AS uye_sayisi
FROM uyeler
GROUP BY sehir
ORDER BY uye_sayisi DESC;

SELECT ad
FROM uyeler
WHERE id IN (
    SELECT uye_id
    FROM odunc
    WHERE gun > 30
);

SELECT kitaplar.ad
FROM kitaplar
LEFT JOIN odunc ON kitaplar.id = odunc.kitap_id
WHERE odunc.kitap_id IS NULL;

SELECT *
FROM odunc
WHERE gun > (
    SELECT AVG(gun)
    FROM odunc
);

SELECT
    uye_id,
    kitap_id,
    gun,
    CASE
        WHEN gun > 30 THEN 'Gecikmiş'
        WHEN gun BETWEEN 15 AND 30 THEN 'Uyarı'
        ELSE 'Normal'
    END AS durum
FROM odunc;

SELECT
    ad,
    yas,
    CASE
        WHEN yas <= 18 THEN 'Genç'
        ELSE 'Yetişkin'
    END AS yas_grubu
FROM uyeler;

SELECT
    CASE
        WHEN gun > 30 THEN 'Gecikmiş'
        WHEN gun BETWEEN 15 AND 30 THEN 'Uyarı'
        ELSE 'Normal'
    END AS durum,
    COUNT(*) AS toplam_kayit
FROM odunc
GROUP BY durum;

CREATE INDEX idx_uyeler_ad ON uyeler(ad);

ALTER TABLE uyeler ADD COLUMN eposta TEXT;

CREATE UNIQUE INDEX idx_uyeler_eposta_unique ON uyeler(eposta);

UPDATE uyeler SET eposta = 'ahmet@example.com' WHERE id = 1;
UPDATE uyeler SET eposta = 'ahmet@example.com' WHERE id = 2;

