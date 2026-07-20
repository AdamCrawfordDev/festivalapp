"""
Import the Outlook Origins 2026 timetable into festival ID 1.

Run from the Django backend directory:

    python manage.py shell < import_outlook_2026.py

Times are interpreted in Europe/Zagreb. Sets ending after midnight are
automatically assigned to the following calendar day. Artists are
created once per festival and then linked to each set.
"""

from datetime import datetime, timedelta
from zoneinfo import ZoneInfo

from django.db import transaction

from festivals.models import Artist, Festival, Set, Stage


FESTIVAL_ID = 1
TIMEZONE = ZoneInfo("Europe/Zagreb")

STAGE_NAMES = [
    "Yard",
    "Beach",
    "Cove 2.0",
    "The Source",
    "Olive Grove",
    "Barbarella's",
    "Boat Parties",
]

# (date, stage, start, end, artist)
SETS = [
    # Thursday 23 July
    ("2026-07-23", "Yard", "19:00", "22:00", "Sam Binga & Chimpo"),
    ("2026-07-23", "Yard", "22:00", "23:00", "Frazer Ray (Live)"),
    ("2026-07-23", "Yard", "23:00", "00:00", "G33 ft. Killa P"),
    ("2026-07-23", "Yard", "00:00", "01:00", "Just Jane"),
    ("2026-07-23", "Yard", "01:00", "02:00", "Amy Kisnorbo"),
    ("2026-07-23", "Yard", "02:00", "03:30", "Neffa-T ft. Chunky"),
    ("2026-07-23", "Yard", "03:30", "05:00", "Sully"),

    ("2026-07-23", "Beach", "13:00", "16:00", "Dubrunner"),
    ("2026-07-23", "Beach", "16:00", "17:00", "Marysia Osu & Kibir La Amlak (Live) — Opening Performance"),
    ("2026-07-23", "Beach", "17:00", "18:00", "Bexblu"),
    ("2026-07-23", "Beach", "18:00", "19:15", "Stones Taro"),
    ("2026-07-23", "Beach", "19:15", "20:30", "Deena Abdelwahed"),
    ("2026-07-23", "Beach", "20:30", "21:30", "State of Eff"),
    ("2026-07-23", "Beach", "21:30", "23:00", "Mor Elian"),
    ("2026-07-23", "Beach", "23:00", "01:30", "Nervous Horizon: TSVI, Ehua & Josi Devil"),
    ("2026-07-23", "Beach", "01:30", "03:00", "Amor Satyr & Siu Mata"),
    ("2026-07-23", "Beach", "03:00", "04:30", "Doctor Jeep"),

    ("2026-07-23", "Cove 2.0", "12:00", "14:00", "High N Irie Residents"),
    ("2026-07-23", "Cove 2.0", "14:00", "16:00", "Sharari"),
    ("2026-07-23", "Cove 2.0", "16:30", "18:00", "Kisa"),
    ("2026-07-23", "Cove 2.0", "18:00", "19:30", "Donsurf"),
    ("2026-07-23", "Cove 2.0", "19:30", "21:00", "Kasia"),
    ("2026-07-23", "Cove 2.0", "21:00", "22:30", "Dmonk"),
    ("2026-07-23", "Cove 2.0", "22:30", "00:00", "Shy One"),
    ("2026-07-23", "Cove 2.0", "00:00", "01:30", "Yaw Evans"),
    ("2026-07-23", "Cove 2.0", "01:30", "03:30", "Brakery Residents"),

    ("2026-07-23", "Olive Grove", "17:00", "18:00", "Ska Lah"),
    ("2026-07-23", "Olive Grove", "18:00", "19:00", "Oris Jay vs Darqwan"),
    ("2026-07-23", "Olive Grove", "19:00", "20:00", "Slaughter Mob ft. Footsie"),
    ("2026-07-23", "Olive Grove", "20:00", "21:00", "Cyrus"),
    ("2026-07-23", "Olive Grove", "21:00", "22:00", "El-B ft. SP:MC"),
    ("2026-07-23", "Olive Grove", "22:00", "23:00", "DJ Chefal (Dubplate Set)"),
    ("2026-07-23", "Olive Grove", "23:00", "00:00", "Horsepower Productions"),
    ("2026-07-23", "Olive Grove", "00:00", "01:30", "Introspekt"),
    ("2026-07-23", "Olive Grove", "01:30", "02:30", "Youngsta ft. Crazy D"),
    ("2026-07-23", "Olive Grove", "02:30", "03:30", "Carré"),
    ("2026-07-23", "Olive Grove", "03:30", "05:00", "Re:Ni"),

    ("2026-07-23", "The Source", "12:00", "14:00", "Sista Kesh I-A"),
    ("2026-07-23", "The Source", "14:00", "16:00", "Karakara"),
    ("2026-07-23", "The Source", "16:00", "17:30", "Anna Andersrum"),
    ("2026-07-23", "The Source", "17:30", "19:00", "Sass"),
    ("2026-07-23", "The Source", "19:00", "20:00", "Midrib (Jazz & Soul Set)"),
    ("2026-07-23", "The Source", "20:00", "21:00", "Phossa"),
    ("2026-07-23", "The Source", "21:00", "22:30", "Mixtress Presents: Everything Is Fine"),
    ("2026-07-23", "The Source", "22:30", "23:30", "Zuri"),
    ("2026-07-23", "The Source", "23:30", "00:30", "Sam Binga (Downtempo Set)"),
    ("2026-07-23", "The Source", "00:30", "01:30", "Element: Jay Carder (Live)"),
    ("2026-07-23", "The Source", "01:30", "03:00", "Element: Ze-Na"),
    ("2026-07-23", "The Source", "03:00", "05:00", "Comf: From Sand to Silt"),

    # Friday 24 July
    ("2026-07-24", "Yard", "19:00", "20:30", "Hijnx & Drone"),
    ("2026-07-24", "Yard", "20:30", "21:30", "Paige Eliza"),
    ("2026-07-24", "Yard", "21:30", "22:30", "Cesco"),
    ("2026-07-24", "Yard", "22:30", "00:00", "Alix Perez ft. SP:MC"),
    ("2026-07-24", "Yard", "00:00", "01:00", "Visages ft. Strategy"),
    ("2026-07-24", "Yard", "01:00", "02:00", "Napes ft. T-Man"),

    ("2026-07-24", "Beach", "13:00", "15:00", "Lioness Power"),
    ("2026-07-24", "Beach", "15:00", "16:00", "Breaka ft. Sgt Pokes (Live)"),
    ("2026-07-24", "Beach", "16:00", "17:30", "Dr. Obi Meets Anja G, Sistah Tena & Roo D"),
    ("2026-07-24", "Beach", "17:30", "19:00", "Channel One ft. Ras Sherby"),
    ("2026-07-24", "Beach", "19:00", "20:30", "Iration Steppas ft. Dego Ranking"),
    ("2026-07-24", "Beach", "20:30", "22:00", "Om Unit"),
    ("2026-07-24", "Beach", "22:00", "23:00", "Jailing"),
    ("2026-07-24", "Beach", "23:00", "00:00", "Big Dope P"),
    ("2026-07-24", "Beach", "00:00", "02:00", "Kode 9 & DJ Spinn ft. Footwork Dancers King Charles, Kelli Forman, Tiger, Nik & Malt Bev"),
    ("2026-07-24", "Beach", "02:00", "03:00", "K Means"),

    ("2026-07-24", "Olive Grove", "16:00", "17:00", "TW: Footwork Dance Class ft. King Charles"),
    ("2026-07-24", "Olive Grove", "17:00", "18:30", "Opium Hum"),
    ("2026-07-24", "Olive Grove", "18:30", "20:00", "Yushh"),
    ("2026-07-24", "Olive Grove", "20:00", "22:00", "Aya & Slickback"),
    ("2026-07-24", "Olive Grove", "22:00", "00:00", "Batu"),
    ("2026-07-24", "Olive Grove", "00:00", "01:30", "Gyrofield"),

    ("2026-07-24", "Cove 2.0", "14:00", "15:30", "Oloica"),
    ("2026-07-24", "Cove 2.0", "15:30", "17:00", "Babilonska"),
    ("2026-07-24", "Cove 2.0", "17:00", "18:30", "Ben Sleia"),
    ("2026-07-24", "Cove 2.0", "18:30", "20:00", "Jon Dat"),
    ("2026-07-24", "Cove 2.0", "20:00", "22:00", "GD4YA: Kode9 & Sully"),
    ("2026-07-24", "Cove 2.0", "22:00", "23:00", "Nio-B"),
    ("2026-07-24", "Cove 2.0", "23:00", "00:00", "Axle"),
    ("2026-07-24", "Cove 2.0", "00:00", "01:00", "Henry Greenleaf"),
    ("2026-07-24", "Cove 2.0", "01:00", "02:00", "Midrib"),

    ("2026-07-24", "The Source", "14:00", "16:00", "Lovellious"),
    ("2026-07-24", "The Source", "16:00", "17:00", "Talk: Rave as Resistance"),
    ("2026-07-24", "The Source", "17:00", "18:00", "Bakey (Soul Set)"),
    ("2026-07-24", "The Source", "18:00", "19:30", "Yuko A"),
    ("2026-07-24", "The Source", "19:30", "21:00", "D'Monk"),
    ("2026-07-24", "The Source", "21:00", "22:00", "Ynez"),
    ("2026-07-24", "The Source", "22:00", "23:00", "Marysia Osu (Live Harp)"),
    ("2026-07-24", "The Source", "23:00", "00:00", "Kibir La Amlak"),
    ("2026-07-24", "The Source", "00:00", "01:30", "Sharari (Ambient Meditation)"),
    ("2026-07-24", "The Source", "01:00", "03:00", "Formella Presents Moss System"),

    ("2026-07-24", "Barbarella's", "00:00", "02:00", "Ikonika"),
    ("2026-07-24", "Barbarella's", "02:00", "03:00", "The Bug ft. Flowdan & Warrior Queen"),
    ("2026-07-24", "Barbarella's", "03:00", "04:00", "O.B.F ft. Jayahadadream, Charlie P & Junior Roy"),
    ("2026-07-24", "Barbarella's", "04:00", "06:00", "Neffa-T & Tim Reaper ft. Footsie"),

    ("2026-07-24", "Boat Parties", "12:30", "15:30", "Subdub"),
    ("2026-07-24", "Boat Parties", "16:15", "19:15", "GD4YA"),
    ("2026-07-24", "Boat Parties", "20:00", "23:00", "Bait"),

    # Saturday 25 July
    ("2026-07-25", "Yard", "19:00", "20:00", "Shy One ft. Chunky"),
    ("2026-07-25", "Yard", "20:00", "21:00", "SLM: Asian Brat & Hendy ft. Jolie P, Cola B & Jayahadadream"),
    ("2026-07-25", "Yard", "21:00", "22:00", "Scratchclart & Menzi Present Room vs Grime ft. Tona Delazy, Logan & Jamz"),
    ("2026-07-25", "Yard", "22:00", "22:30", "Ralph"),
    ("2026-07-25", "Yard", "22:30", "00:00", "Skee Mask (Grime Set) ft. Logan & Jamz"),
    ("2026-07-25", "Yard", "00:00", "01:00", "Roll Deep"),
    ("2026-07-25", "Yard", "01:00", "02:00", "Chamber 45 & Si*Bl ft. Cola B, Kibo, Kruz Leone & Duppy"),

    ("2026-07-25", "Cove 2.0", "14:00", "15:30", "Selectatec"),
    ("2026-07-25", "Cove 2.0", "15:30", "17:00", "Fujita Pinnacle"),
    ("2026-07-25", "Cove 2.0", "17:00", "19:00", "Tim Reaper"),
    ("2026-07-25", "Cove 2.0", "19:00", "20:00", "Oolongbru & Kumuqat Tang"),
    ("2026-07-25", "Cove 2.0", "20:00", "21:00", "A.Fruit"),
    ("2026-07-25", "Cove 2.0", "21:00", "22:00", "Traka"),
    ("2026-07-25", "Cove 2.0", "22:00", "23:00", "Coido"),
    ("2026-07-25", "Cove 2.0", "23:00", "00:30", "Khxdeej"),
    ("2026-07-25", "Cove 2.0", "00:30", "02:00", "Phasmid"),

    ("2026-07-25", "The Source", "14:00", "15:00", "Ob-Server"),
    ("2026-07-25", "The Source", "15:00", "16:00", "Noah"),
    ("2026-07-25", "The Source", "16:00", "17:00", "Talk: Need for Speed"),
    ("2026-07-25", "The Source", "17:00", "18:00", "Dub&Dal: Pia Collada"),
    ("2026-07-25", "The Source", "18:00", "19:00", "Dub&Dal: Khxdeej"),
    ("2026-07-25", "The Source", "19:00", "20:00", "Dub&Dal: Lush Lata"),
    ("2026-07-25", "The Source", "20:00", "21:00", "Dub&Dal: Annida"),
    ("2026-07-25", "The Source", "21:00", "22:00", "Dub&Dal: O.M. Theorem (Live)"),
    ("2026-07-25", "The Source", "22:00", "23:30", "Beatrice M. — Everything Reminds Me of Dubstep (Live)"),
    ("2026-07-25", "The Source", "23:30", "00:30", "Alicia (90s Chillout Set)"),
    ("2026-07-25", "The Source", "00:30", "01:30", "Seb (Deep Footwork Set)"),
    ("2026-07-25", "The Source", "01:30", "03:00", "Tekhole Presents Soulscape"),

    ("2026-07-25", "Olive Grove", "17:00", "19:00", "Simon Scott"),
    ("2026-07-25", "Olive Grove", "19:00", "21:00", "Fabio & Grooverider (Acid House Set)"),
    ("2026-07-25", "Olive Grove", "21:00", "22:30", "Double O (Bleep Set)"),
    ("2026-07-25", "Olive Grove", "22:30", "00:00", "Chinese Daughter (94–96 Jungle Set)"),
    ("2026-07-25", "Olive Grove", "00:00", "01:30", "DJ Flight (Blue Note Set) ft. MC Chickaboo"),

    ("2026-07-25", "Beach", "13:00", "14:30", "Yami & Rich Reason"),
    ("2026-07-25", "Beach", "14:30", "15:30", "Chunky (DJ)"),
    ("2026-07-25", "Beach", "15:30", "17:00", "Chimpo & Warrior Queen"),
    ("2026-07-25", "Beach", "17:00", "18:00", "Salo"),
    ("2026-07-25", "Beach", "18:00", "19:00", "Archangel ft. T-Man"),
    ("2026-07-25", "Beach", "19:00", "20:00", "Yan ft. Strategy"),
    ("2026-07-25", "Beach", "20:00", "21:00", "Takuya Nakamura"),
    ("2026-07-25", "Beach", "21:00", "22:00", "Breakage ft. SP:MC"),
    ("2026-07-25", "Beach", "22:00", "23:00", "Daisy"),
    ("2026-07-25", "Beach", "23:00", "00:30", "Osmosis Jones & Oldboy"),
    ("2026-07-25", "Beach", "00:30", "02:00", "Silva Bumpa"),
    ("2026-07-25", "Beach", "02:00", "03:00", "Saidah"),

    ("2026-07-25", "Barbarella's", "00:00", "01:00", "EZ Riser"),
    ("2026-07-25", "Barbarella's", "01:00", "02:00", "Elisa do Brasil ft. T-Man"),
    ("2026-07-25", "Barbarella's", "02:00", "03:00", "Skeptical & MC GQ"),
    ("2026-07-25", "Barbarella's", "03:00", "04:30", "Goldie & MC GQ"),
    ("2026-07-25", "Barbarella's", "04:30", "06:00", "DJ Storm & Chickaboo"),

    ("2026-07-25", "Boat Parties", "12:30", "15:30", "1985 Music"),
    ("2026-07-25", "Boat Parties", "13:30", "16:30", "Seasoning"),
    ("2026-07-25", "Boat Parties", "16:15", "19:15", "Antidoto Club"),
    ("2026-07-25", "Boat Parties", "17:15", "20:15", "NLDC"),
    ("2026-07-25", "Boat Parties", "22:00", "23:00", "Unknown–Untitled"),
    ("2026-07-25", "Boat Parties", "21:00", "00:00", "Tropical Waste Presents 160 Unity"),

    # Sunday 26 July
    ("2026-07-26", "Yard", "19:00", "20:00", "Thys"),
    ("2026-07-26", "Yard", "20:00", "21:00", "Nectax & Melba"),
    ("2026-07-26", "Yard", "21:00", "23:00", "Louisett, Hughesee & Dwarde"),
    ("2026-07-26", "Yard", "23:00", "00:00", "Samurai Breaks ft. Che3kz"),
    ("2026-07-26", "Yard", "00:00", "01:00", "Cheetah"),
    ("2026-07-26", "Yard", "01:00", "02:00", "SLM: Betsy Mae & Selectatec ft. Jolie P & Jayahadadream"),

    ("2026-07-26", "Beach", "13:00", "15:00", "Basic Chanel & Alicia"),
    ("2026-07-26", "Beach", "15:00", "16:30", "Donna Leake"),
    ("2026-07-26", "Beach", "16:30", "18:00", "Joe Armon-Jones (DJ)"),
    ("2026-07-26", "Beach", "18:00", "19:00", "Soa420 ft. Jammz"),
    ("2026-07-26", "Beach", "19:00", "20:00", "Darwin ft. Sgt Pokes"),
    ("2026-07-26", "Beach", "20:00", "21:30", "Beatrice M. & Pinch ft. SP:MC"),
    ("2026-07-26", "Beach", "21:30", "22:30", "Commodo x Rocks Foe"),
    ("2026-07-26", "Beach", "22:30", "23:30", "Ema ft. SP:MC"),
    ("2026-07-26", "Beach", "23:30", "01:00", "Jsparrow & J:Kenzo ft. Sgt Pokes"),
    ("2026-07-26", "Beach", "01:00", "03:00", "Glume, Phossa, Samba & Yoofee"),

    ("2026-07-26", "Olive Grove", "17:00", "18:00", "Patricccio"),
    ("2026-07-26", "Olive Grove", "18:00", "19:30", "Ophélie"),
    ("2026-07-26", "Olive Grove", "19:30", "20:30", "Dangermami"),
    ("2026-07-26", "Olive Grove", "20:30", "21:30", "Manami"),
    ("2026-07-26", "Olive Grove", "21:30", "22:30", "DJ Plead (Live)"),
    ("2026-07-26", "Olive Grove", "22:30", "00:00", "CCL"),
    ("2026-07-26", "Olive Grove", "00:00", "01:30", "Objekt"),

    ("2026-07-26", "Cove 2.0", "14:00", "16:00", "Double Clapperz"),
    ("2026-07-26", "Cove 2.0", "16:00", "17:00", "Peroli"),
    ("2026-07-26", "Cove 2.0", "17:00", "18:30", "LWS & Skills"),
    ("2026-07-26", "Cove 2.0", "18:30", "20:30", "Raji Rags & Jay Carder"),
    ("2026-07-26", "Cove 2.0", "20:30", "22:00", "Guns"),
    ("2026-07-26", "Cove 2.0", "22:00", "23:30", "Denham Audio"),
    ("2026-07-26", "Cove 2.0", "23:30", "00:30", "Yung.Raj"),
    ("2026-07-26", "Cove 2.0", "00:30", "02:00", "Globex Corp"),

    ("2026-07-26", "The Source", "14:00", "16:00", "Arnii"),
    ("2026-07-26", "The Source", "16:00", "17:00", "Talk: Who Decides What We Hear"),
    ("2026-07-26", "The Source", "17:00", "18:30", "Neffa-T (Ambient Set)"),
    ("2026-07-26", "The Source", "18:30", "20:00", "Manami"),
    ("2026-07-26", "The Source", "20:00", "21:00", "Ostad"),
    ("2026-07-26", "The Source", "21:00", "22:00", "Noli (Live Viola)"),
    ("2026-07-26", "The Source", "22:00", "23:00", "Ruminant"),
    ("2026-07-26", "The Source", "23:00", "03:00", "Club Cosmos: Marylou, Simon Scott & Bugs Groove"),

    ("2026-07-26", "Boat Parties", "12:30", "15:30", "Local Action vs Headset"),
    ("2026-07-26", "Boat Parties", "13:30", "16:30", "Locus Sound vs Infernal Sounds"),
    ("2026-07-26", "Boat Parties", "16:15", "19:15", "Deep Medi"),
    ("2026-07-26", "Boat Parties", "17:15", "20:15", "Awkwardly Social"),
    ("2026-07-26", "Boat Parties", "20:00", "23:00", "Dametalmessiah"),
    ("2026-07-26", "Boat Parties", "21:00", "00:00", "Rupture"),

    ("2026-07-26", "Barbarella's", "00:00", "01:30", "Lioness Power, Sinai (DJ), Dubrunner & Breakfake"),
    ("2026-07-26", "Barbarella's", "01:30", "03:00", "Bakey"),
    ("2026-07-26", "Barbarella's", "03:00", "04:30", "Ben UFO"),
    ("2026-07-26", "Barbarella's", "04:30", "06:00", "Nikana & Yungfya ft. Blackeye MC"),

    # Monday 27 July
    ("2026-07-27", "Yard", "19:00", "20:30", "Jaz Imsky"),
    ("2026-07-27", "Yard", "20:30", "22:00", "Felixculpah"),
    ("2026-07-27", "Yard", "22:00", "23:00", "Wraz"),
    ("2026-07-27", "Yard", "23:00", "00:00", "Goth-Trad"),
    ("2026-07-27", "Yard", "00:00", "02:00", "Mala ft. Sgt Pokes"),
    ("2026-07-27", "Yard", "02:00", "03:00", "Sir Spyro"),
    ("2026-07-27", "Yard", "03:00", "04:30", "Silkie"),

    ("2026-07-27", "Beach", "13:00", "14:30", "Hanamercy & Sinai (DJ)"),
    ("2026-07-27", "Beach", "14:30", "16:00", "Millie McKee"),
    ("2026-07-27", "Beach", "16:00", "17:00", "Sub Basics"),
    ("2026-07-27", "Beach", "17:00", "18:00", "Azu Tiwaline (Live)"),
    ("2026-07-27", "Beach", "18:00", "19:30", "Richard Akingbehin"),
    ("2026-07-27", "Beach", "19:30", "20:30", "Tikiman Live with Scion"),
    ("2026-07-27", "Beach", "20:30", "22:00", "Livwutang"),
    ("2026-07-27", "Beach", "22:00", "23:30", "Mia Koden"),
    ("2026-07-27", "Beach", "23:30", "01:00", "Tasha"),
    ("2026-07-27", "Beach", "01:00", "02:30", "Simon Scott"),
    ("2026-07-27", "Beach", "02:30", "03:30", "Batki & Ob-Server"),
    ("2026-07-27", "Beach", "03:30", "04:30", "Rishi"),
    ("2026-07-27", "Beach", "04:30", "05:30", "Barker (Live)"),

    ("2026-07-27", "Olive Grove", "18:00", "19:30", "Vxrgo"),
    ("2026-07-27", "Olive Grove", "19:30", "21:00", "Fez the Kid"),
    ("2026-07-27", "Olive Grove", "21:00", "22:00", "Decibella"),
    ("2026-07-27", "Olive Grove", "22:00", "23:00", "Loxy"),
    ("2026-07-27", "Olive Grove", "23:00", "00:00", "Foul Play"),
    ("2026-07-27", "Olive Grove", "00:00", "01:00", "Double O ft. Blackeye MC"),
    ("2026-07-27", "Olive Grove", "01:00", "02:30", "Octo Octa (DNB Set) ft. MC Chickaboo"),
    ("2026-07-27", "Olive Grove", "02:30", "04:00", "Mantra ft. MC Chickaboo"),

    ("2026-07-27", "Cove 2.0", "14:00", "15:00", "High N Irie Residents"),
    ("2026-07-27", "Cove 2.0", "15:00", "16:30", "Skimir (Live)"),
    ("2026-07-27", "Cove 2.0", "16:30", "18:00", "Bugs Groove"),
    ("2026-07-27", "Cove 2.0", "18:00", "19:00", "Highrise"),
    ("2026-07-27", "Cove 2.0", "19:00", "20:00", "Douvelle19"),
    ("2026-07-27", "Cove 2.0", "20:00", "21:30", "Mia Lily & Big Kani"),
    ("2026-07-27", "Cove 2.0", "21:30", "22:30", "Severine"),
    ("2026-07-27", "Cove 2.0", "22:30", "00:00", "DJ Plead"),
    ("2026-07-27", "Cove 2.0", "00:00", "01:00", "Alicia"),
    ("2026-07-27", "Cove 2.0", "01:00", "02:00", "Marylou"),
    ("2026-07-27", "Cove 2.0", "02:00", "03:30", "Krotone"),

    ("2026-07-27", "The Source", "14:00", "16:00", "Ophélie"),
    ("2026-07-27", "The Source", "16:00", "17:00", "TBC"),
    ("2026-07-27", "The Source", "17:00", "18:00", "Ray Laurél"),
    ("2026-07-27", "The Source", "18:00", "19:00", "Yoofee"),
    ("2026-07-27", "The Source", "19:00", "20:00", "Darwin & Sgt Pokes"),
    ("2026-07-27", "The Source", "20:00", "21:00", "Dangermami (RNB Set)"),
    ("2026-07-27", "The Source", "21:00", "22:00", "Basic Chanel (Trip Hop Set)"),
    ("2026-07-27", "The Source", "22:00", "23:30", "CCL Presents Liquidtime"),
    ("2026-07-27", "The Source", "23:30", "01:00", "Ro-Ish Presents: Screaming Into the Void"),
    ("2026-07-27", "The Source", "01:00", "03:00", "Genoe"),

    ("2026-07-27", "Boat Parties", "12:30", "15:30", "TECSPE:C"),
    ("2026-07-27", "Boat Parties", "13:30", "16:30", "Tokio Station x Sexyladymassive"),
    ("2026-07-27", "Boat Parties", "16:15", "19:15", "Travis Presents"),
    ("2026-07-27", "Boat Parties", "17:15", "20:15", "Exodus"),
    ("2026-07-27", "Boat Parties", "20:00", "23:00", "23 Degrees"),
    ("2026-07-27", "Boat Parties", "21:00", "00:00", "Big Fat Rave"),
]


def build_datetime(date_text: str, time_text: str) -> datetime:
    value = datetime.strptime(
        f"{date_text} {time_text}",
        "%Y-%m-%d %H:%M",
    )
    return value.replace(tzinfo=TIMEZONE)


@transaction.atomic
def run_import():
    festival = Festival.objects.get(id=FESTIVAL_ID)

    stages = {}
    for name in STAGE_NAMES:
        stage, created = Stage.objects.get_or_create(
            festival=festival,
            name=name,
        )
        stages[name] = stage
        print(
            f"{'Created' if created else 'Found'} stage: {name}"
        )

    artists = {}
    for *_, artist_name in SETS:
        normalized_name = artist_name.strip()

        if normalized_name in artists:
            continue

        artist, created = Artist.objects.get_or_create(
            festival=festival,
            name=normalized_name,
        )
        artists[normalized_name] = artist

        print(
            f"{'Created' if created else 'Found'} artist: "
            f"{normalized_name}"
        )

    created_count = 0
    existing_count = 0

    for (
        date_text,
        stage_name,
        start_text,
        end_text,
        artist_name,
    ) in SETS:
        start = build_datetime(date_text, start_text)
        end = build_datetime(date_text, end_text)

        # Timetable rows after midnight belong to the night that began
        # on the printed date. Move both timestamps forward where needed.
        if start.hour < 12:
            start += timedelta(days=1)

        if end.hour < 12:
            end += timedelta(days=1)

        if end <= start:
            end += timedelta(days=1)

        normalized_name = artist_name.strip()

        _, created = Set.objects.get_or_create(
            stage=stages[stage_name],
            artist=artists[normalized_name],
            start_time=start,
            end_time=end,
        )

        if created:
            created_count += 1
        else:
            existing_count += 1

    print()
    print(f"Festival: {festival.name} (ID {festival.id})")
    print(f"Stages available: {len(stages)}")
    print(f"Artists available: {len(artists)}")
    print(f"Sets created: {created_count}")
    print(f"Sets already present: {existing_count}")
    print(f"Total rows processed: {len(SETS)}")


run_import()
