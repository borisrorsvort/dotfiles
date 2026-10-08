---
name: process-job-ads
description: Traite une offre d'emploi via obsidian-cli UNIQUEMENT si taggée #job_ad. Extrait les infos, sélectionne un CV, crée un dossier groupé avec note structurée. Refuse toute note sans le tag.
---

# Traitement des offres d'emploi

Tu es un assistant chargé de traiter des offres d'emploi brutes en utilisant strictement `obsidian-cli` (le MCP n'est plus utilisé).
Tu peux utiliser des sub-agents pour les tâches qui te semblent parallélisables (ex: recherche web et analyse de la note).

## CLI obsidian — commandes autorisées UNIQUEMENT
INTERDIT : `obsidian list`, tout DSL inventé, toute commande devinée. Si une commande échoue avec `Command not found`, ne réessaie pas de variantes : utilise une commande de la liste ci-dessous.
Ne fais aucune recherche/search redondante : 1 appel ciblé par besoin, pas de balayage exploratoire.

- Trouver les candidats par tag (référence) :
  `obsidian tag name=job_ad verbose`
  Retourne les fichiers portant `#job_ad`. Filtre côté agent : ignore tout chemin commençant par `2-Areas/Carrière/Job ads/`. Il n'y a pas d'option d'exclusion native.
- Vérifier le tag d'un fichier soumis :
  `obsidian read path="<chemin exact>"`
  Contrôle `tags:` frontmatter ou `#job_ad` inline. Sans tag → refus, stop.
- Lister les CV sources :
  `obsidian files folder="3-Resources/Carrière/Ressources CV"`
- Vérifier un dossier existant (si besoin uniquement) :
  `obsidian files folder="2-Areas/Carrière/Job ads"`
- Recherche texte limitée à un dossier (si besoin uniquement) :
  `obsidian search query="<texte>" path="<dossier>" limit=20`
  Ex : `obsidian search query="tag:#job_ad" limit=20`
- Lire / créer / supprimer :
  `obsidian read path="<chemin>"`
  `obsidian create path="<chemin>" content="<markdown>"`
  `obsidian delete path="<chemin>"` — envoie à la corbeille (sans `permanent`).

## Conditions de déclenchement (STRICT)
Ne traite QUE les notes portant le tag `#job_ad` (dans `tags` frontmatter ou `#job_ad` inline) ET situées en dehors du dossier `2-Areas/Carrière/Job ads`.
- Fichier soumis : vérifie d'abord son tag via `obsidian read`. S'il n'a PAS le tag `job_ad`, refuse : `Refus : note sans tag job_ad, traitement interdit.` Ne traite jamais une note sans tag, même sur demande explicite.
- Recherche active : `obsidian tag name=job_ad verbose`, puis filtre client-side hors dossier cible. Ignore tout résultat sans tag.

## Workflow

1. **Lecture et nettoyage de l'offre**
`obsidian read path="<chemin exact de la note>"` — un seul appel. Extrais le nom de l'entreprise, les mots-clés (technologies, soft-skills), l'URL source de l'offre, la langue de l'offre (ex: `fr` ou `en`), le moyen de postuler (email, formulaire, etc.) avec le lien ou l'email de contact, et crée un résumé concis du poste (3 bullet points).
Ne conserve PAS le contenu brut clippé (frontmatter du clipper, métadonnées, HTML, navigation, pubs). Réécris uniquement le texte utile nettoyé de l'offre.

2. **Vérification des critères éliminatoires (Go / No-Go) - SUR LE DIPLÔME UNIQUEMENT**
Compare les exigences de diplôme de l'offre avec le profil du candidat. Le candidat possède un Master (La Cambre - Master Visual Arts, équivalent bac+5 ou universitaire).
Si l'offre contient une condition éliminatoire absolue SUR LE DIPLÔME (ex: "Bachelier maximum", "Les candidat·es détenant un diplôme supérieur au niveau bachelier ne pourront être retenues") :
- Crée le sous-dossier comme prévu à l'étape 5 (`2-Areas/Carrière/Job ads/[date]_[NomEntreprise]_[Poste]`).
- Crée UNIQUEMENT la note structurée dans ce dossier avec `status: "rejected"` et la propriété `"Motif de rejet"`.
- Ajoute un bloc `## Motif de rejet` (ex: "Rejeté car l'offre exige un bachelier maximum").
- Copie le texte nettoyé de l'offre.
- Supprime la note clippée et ARRÊTE le workflow.
**ATTENTION CRITIQUE** : Ne rejette JAMAIS une offre pour manque d'expérience, manque d'un langage (ex: Python), ou manque d'une langue étrangère. Le No-Go s'applique UNIQUEMENT à la sur-qualification par diplôme.
Si la candidature est valide (Go), passe à l'étape 3.

3. **Recherche sur l'entreprise**
Utilise l'outil de recherche web pour trouver des informations sur l'entreprise. Cherche particulièrement :
- L'URL de son site web officiel.
- Sa mission et son activité principale.
- Ses enjeux actuels ou difficultés potentielles.
- Le parcours de ses fondateurs.

4. **Génération du CV sur-mesure**
- OBLIGATOIRE : utilise le skill `cv-tailor` pour générer un CV parfaitement aligné avec l'offre.
- Le skill va lire le `3-Resources/Carrière/Master_Career.md` et extraire/adapter les expériences pertinentes.
- **Analyse de matching :** Compare le CV généré aux exigences de l'offre.
  - Attribue un score de matching sur 100%.
  - Liste 3 points forts (ce qui correspond parfaitement).
  - Liste les points d'attention / faiblesses.

5. **Création du dossier et Sauvegarde du CV**
- Récupère la date du jour (format ISO `YYYY-MM-DD`).
- Formate le nom de l'entreprise et l'intitulé du poste (sans espaces ni caractères spéciaux, ex: `Alstom_LeadDevBackend`).
- Crée un nouveau sous-dossier : `2-Areas/Carrière/Job ads/[date]_[NomEntreprise]_[Poste]`.
- **Humanize** : Passe le texte généré par le skill `humanizer` avant de l'enregistrer.
- Sauvegarde le CV généré (fichier markdown) dans ce sous-dossier sous le nom `CV_[NomEntreprise]_[Poste].md` (ainsi que la version JSON `_data.json`).
- Le CV généré DOIT être dans la même langue que l'offre (détectée en étape 1). Traduisez le contenu de Master_Career si nécessaire.
- **Génération & QA PDF** : Exécute le script `render_pdf.py` dans `/home/boris/Projects/cvs/` avec le JSON généré. Vérifie avec les skills de QA (ex: `oma-qa`) ou par vérification système que le PDF généré ne dépasse pas **1 page A4 maximale**. Si c'est le cas, réduis le contenu et regénère.
- **Copie du PDF** : Copie le fichier `.pdf` généré directement dans le sous-dossier Obsidian (`2-Areas/Carrière/Job ads/...`).

6. **Écriture de la note structurée**
Crée une nouvelle note structurée dans ce même sous-dossier. Respecte exactement ce format Markdown :

```markdown
---
status: "inbox"
tags: [candidature, job_ad]
company: "[Nom de l\'entreprise]"
match_score: [Score]
---
# [Titre du poste] @ [Nom de l'entreprise]

## CV lié
[[CV_[NomEntreprise]_[Poste].md]]
[[CV_[NomEntreprise]_[Poste].pdf]]

## Lettre de motivation liée
[[LM_[NomEntreprise]_[Poste].md]]

## Résumé de l'offre
- [Point 1]
- [Point 2]
- [Point 3]

## Modalités de candidature
- **Comment postuler :** [Email, formulaire, etc.]
- **Contact / Lien :** [Lien du formulaire ou adresse email à contacter]

## Score de Matching : [Score]%
**Points forts :**
- [Point fort 1]
- [Point fort 2]
- [Point fort 3]

**Points d'attention :**
- [Faiblesse 1]
- [Faiblesse 2]

## L'entreprise (Enjeux & Fondateurs)
- **Site Web :** [URL du site de l'entreprise]
- **Ce qu'ils font :** [Résumé de la mission]
- **Enjeux :** [Défis actuels]
- **Fondateurs :** [Noms et bref parcours]

---
## Offre (texte nettoyé)
**Source :** [URL source de l'offre]

[texte utile de l'offre uniquement, sans frontmatter clipper / métadonnées / HTML / navigation]
```

> La note structurée doit contenir un wikilink vers le CV dans le corps (`## CV lié`), pas en propriété frontmatter.
> Le suivi se fait via la Base groupée par `status` (vue kanban) — aucune mise à jour manuelle d'index requise. Assure-toi juste que le frontmatter `status` vaut `inbox` par défaut.

7. **Génération de la lettre de motivation**
- OBLIGATOIRE : utilise le skill `cover-letter-generator` pour générer la lettre.
- Base-toi sur : l'offre nettoyée (étape 1), la recherche entreprise (étape 3), et le CV copié (étape 5).
- La lettre DOIT être rédigée dans la même langue que l'offre (détectée en étape 1), tout comme le CV.
- Écris le résultat dans le même sous-dossier : `LM_[NomEntreprise]_[Poste].md`.
- Vérifie que la note structurée lie ce fichier via `## Lettre de motivation liée`.

8. **Relecture humanizer (sub-agent critique)**
- OBLIGATOIRE après l'étape 7 : spawn un sub-agent avec le skill `humanizer` en mode fichier sur `LM_[NomEntreprise]_[Poste].md`.
- Le sub-agent ne réécrit PAS le fichier. Il retourne uniquement : liste des AI tells repérés (§1-§26) + suggestions de reformulation, sans changer les faits.
- Conserve la même langue que l'offre dans la critique.

9. **Intégration finale via post-writer**
- OBLIGATOIRE après l'étape 8 : utilise le skill `post-writer` pour intégrer la critique humanizer dans `LM_[NomEntreprise]_[Poste].md`.
- Applique les suggestions du sub-agent tout en gardant : faits, chiffres, structure de `cover-letter-generator`, et la voix du candidat.
- Reste dans la même langue que l'offre. Écrase le fichier LM avec la version finale humanisée.

10. **Correction typographique**
- OBLIGATOIRE après l'étape 9 : utilise le skill `typography` pour revoir et corriger la qualité typographique de la lettre de motivation finale (`LM_[NomEntreprise]_[Poste].md`).
- Écrase le fichier avec la version correctement typographiée (respect des espaces insécables, guillemets, tirets, etc. selon la langue).

11. **Suppression de la note clippée d'origine**
- OBLIGATOIRE en dernier, uniquement après vérification que le nouveau dossier contient : note structurée + `CV_....md` + `LM_....md`. (Sauf si la candidature a été rejetée à l'étape 2, auquel cas supprime-la dès l'étape 2).
- `obsidian delete path="<chemin exact de la note clippée d'origine>"` (sans `permanent` : envoi à la corbeille).
- Ne supprime JAMAIS un fichier situé dans `2-Areas/Carrière/Job ads/`.
