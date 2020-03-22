## HoNOS (Health of the Nations Outcome Scale)

### Zusammenfassung

Fremdeinschätzung von Gesundheit und sozialer Funktionsfähigkeit mittels 12 Items durch eine therapeutische Fachperson.

### Administrator

#### Schnittstelle

Die Schnittstelle wurde am 1. Juni 2019 auf `Navision` angepasst. Das Ausgabeverzeichnis lautet `/media/hl7_files/PROD/FROM_OPTINOMIC/`.

#### Komplettexport

In der SQL-Toolbox kann die [navision_interface.sql](https://github.com/Optinomic/ch.suedhang.apps.honos.production/blob/master/includes/navision_interface.sql#L105) Abfrage ausgeführt werden. Lediglich [diese Zeile](https://github.com/Optinomic/ch.suedhang.apps.honos.production/blob/master/includes/navision_interface.sql#L105) gilt es auszuklammern, da wir nicht nur Exporte vom aktuellen Tag exportieren wollen.  

Für den CSV-Export muss die Abfrage mit folgenden Parametern ausgegeben werden:    
`{ direct: "True", format: "csv", delimiter: ",", crlf: "True" }`
