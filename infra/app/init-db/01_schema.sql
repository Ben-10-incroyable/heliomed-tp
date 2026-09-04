-- Jeu de donnees FICTIF representant les donnees de sante d'HelioMed.
-- Aucune donnee reelle : uniquement des enregistrements inventes pour le TP.

CREATE TABLE IF NOT EXISTS patients (
    id              SERIAL PRIMARY KEY,
    nom             TEXT NOT NULL,
    prenom          TEXT NOT NULL,
    date_naissance  DATE,
    email           TEXT,
    telephone       TEXT,
    numero_dossier  TEXT UNIQUE,
    cree_le         TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS rendez_vous (
    id              SERIAL PRIMARY KEY,
    patient_id      INTEGER REFERENCES patients(id),
    praticien       TEXT,
    specialite      TEXT,
    motif           TEXT,           -- donnee de sante : sensible (RGPD art. 9)
    debut           TIMESTAMPTZ,
    fin             TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS journal_acces (
    id          SERIAL PRIMARY KEY,
    utilisateur TEXT,
    action      TEXT,
    patient_id  INTEGER,
    horodatage  TIMESTAMPTZ DEFAULT now()
);

INSERT INTO patients (nom, prenom, date_naissance, email, telephone, numero_dossier) VALUES
    ('Martin',  'Claire', '1984-03-12', 'claire.martin@example.invalid',  '0600000001', 'HM-0001'),
    ('Dubois',  'Yanis',  '1996-11-02', 'yanis.dubois@example.invalid',   '0600000002', 'HM-0002'),
    ('Nguyen',  'Léa',    '1972-07-25', 'lea.nguyen@example.invalid',     '0600000003', 'HM-0003')
ON CONFLICT DO NOTHING;

INSERT INTO rendez_vous (patient_id, praticien, specialite, motif, debut, fin) VALUES
    (1, 'Dr Bernard', 'Cardiologie',  'Suivi hypertension',    now() + interval '2 day', now() + interval '2 day 30 minute'),
    (2, 'Dr Aloui',   'Dermatologie', 'Controle grain de beaute', now() + interval '5 day', now() + interval '5 day 20 minute'),
    (3, 'Dr Bernard', 'Cardiologie',  'Bilan annuel',          now() + interval '9 day', now() + interval '9 day 45 minute')
ON CONFLICT DO NOTHING;
