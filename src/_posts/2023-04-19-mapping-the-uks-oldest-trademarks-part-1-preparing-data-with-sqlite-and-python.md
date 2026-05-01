---
title: Mapping the UK's oldest trademarks, part 1.
slug: mapping-the-uks-oldest-trademarks-part-1-preparing-data-with-sqlite-and-python
createdAt: 2023-04-06 22:41:32.000000000 Z
updatedAt: 2023-04-19 11:43:50.000000000 Z
publishedAt: 2023-04-19 11:00:00.000000000 Z
FeatureImage: "/images/2023/04/cover-2.png"
date: 2023-04-19 11:00:00 UTC
layout: post
categories: creating-with-data
---

_The first of two parts, this video covers the data-gathering/prep side in [creating this map of the UK's oldest trademarks](https://creating-with-data.glitch.me/trademarks/index.html)._

How do you interrogate a 1M+ row CSV with (almost) all the trademarks filed for registration in the UK?

In this video, we take a look at the data held by the Intellectual Property Office, in particular, trademark filings that date back 1870s. We walk through the dataset and use Python to create an SQLite database of the same data. As a first data gathering and preparation step to creating a map visualisation, we use SQL to extract the oldest filing for each UK postcode area.

See below for code and notes.

**Notes**

- In the video I mention the Nice class system, [on the IPO website you can discover classes by searching goods and services](https://www.search-uk-trade-mark-classes.service.gov.uk/searchclasses), and it'll tell you what classes are associated with your search term.

**Links**

- [Intellectual Property Office](https://www.gov.uk/government/organisations/intellectual-property-office) (IPO)
- [IPO: Search for a trademark](https://trademarks.ipo.gov.uk/ipo-tmtext)
- [IPO: Trademark Data Release](https://www.gov.uk/government/publications/ipo-trade-mark-data-release)
- [Open data explained Domestic Applications](https://www.gov.uk/government/publications/ipo-trade-mark-data-release/ipo-data-explained-2016)
- [DB Browser for SQLite](https://sqlitebrowser.org/)
- [Full trademarks dataset (at the time of writing)](/files/2023/04/opendatadomestic.zip)
- [History of trademarks in the UK (Wikipedia)](https://en.wikipedia.org/wiki/United_Kingdom_trade_mark_law)

**Code**

create\_db.py

```python
import sqlite3
from sqlite3 import Error

def create_connection(db_file):
    """ create a database connection to a SQLite database """
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        print(sqlite3.version)
    except Error as e:
        print(e)
    finally:
        if conn:
            conn.close()

if __name__ == '__main__':
    create_connection(r"trademarks.db")
```

process\_data.py

```python
import sqlite3

# Load csv results into list
with open('OpenDataDomestic.txt', 'r', encoding='utf16') as f:
  file_data = list(f)
rows = []
for row in file_data:
  rows.append(row.strip().split('|'))

rows.pop(0) # remove the headings row
print("Rows to insert %s" % len(rows))

# Connect to or create an sqlite database
conn = sqlite3.connect('trademarks.db')
c = conn.cursor()

print("Creating table")
# Create a table for the data
c.execute('''CREATE TABLE trademarks
             (id INTEGER PRIMARY KEY AUTOINCREMENT, Trade_Mark text, Hyperlink text, Mark_Text text, Name text, Postcode text, Region text, Country text, Status text, Category_of_Mark text, Mark_Type text, Series text, No_of_Marks_in_Series integer, Filed text, Published text, Registered text, Expired text, Renewal_Due_Date text, Class1 integer, Class2 integer, Class3 integer, Class4 integer, Class5 integer, Class6 integer, Class7 integer, Class8 integer, Class9 integer, Class10 integer, Class11 integer, Class12 integer, Class13 integer, Class14 integer, Class15 integer, Class16 integer, Class17 integer, Class18 integer, Class19 integer, Class20 integer, Class21 integer, Class22 integer, Class23 integer, Class24 integer, Class25 integer, Class26 integer, Class27 integer, Class28 integer, Class29 integer, Class30 integer, Class31 integer, Class32 integer, Class33 integer, Class34 integer, Class35 integer, Class36 integer, Class37 integer, Class38 integer, Class39 integer, Class40 integer, Class41 integer, Class42 integer, Class43 integer, Class44 integer, Class45 integer)''')

# Import into table
print("Importing into table")
inserts = 0; failed_rows = [];

for row in rows:
  # Insert the data into the table
  if len(row) > 62:
    failed_rows.append(row)
    continue # skip the rows of the wrong size
  c.execute("INSERT INTO trademarks (Trade_Mark, Hyperlink, Mark_Text, Name, Postcode, Region, Country, Status, Category_of_Mark, Mark_Type, Series, No_of_Marks_in_Series, Filed, Published, Registered, Expired, Renewal_Due_Date, Class1, Class2, Class3, Class4, Class5, Class6, Class7, Class8, Class9, Class10, Class11, Class12, Class13, Class14, Class15, Class16, Class17, Class18, Class19, Class20, Class21, Class22, Class23, Class24, Class25, Class26, Class27, Class28, Class29, Class30, Class31, Class32, Class33, Class34, Class35, Class36, Class37, Class38, Class39, Class40, Class41, Class42, Class43, Class44, Class45) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", row)
  inserts+=1

conn.commit()
conn.close()

print("Successful: %s" % inserts)
print("Failed: %s" % len(failed_rows))

# Write out failed rows into a separate csv to sort out later
with open('failed_rows.csv', 'w', encoding='utf16') as f:
  for row in failed_rows:
    f.write('|'.join(row))
    f.write('\n')

```

add\_postcode\_areas.py

```python
import sqlite3
import re

# Connect to or create an sqlite database
conn = sqlite3.connect('trademarks.db')
c = conn.cursor()

rows = c.execute('SELECT * FROM trademarks').fetchall()

valid_postcode_areas = ['AB','AL','B','BA','BB','BD','BH','BL','BN','BR','BS','BT','CA','CB','CF','CH','CM','CO','CR','CT','CV','CW','DA','DD','DE','DG','DH','DL','DN','DT','DY','E','EC','EH','EN','EX','FK','FY','G','GL','GU','GY','HA','HD','HG','HP','HR','HS','HU','HX','IG','IM','IP','IV','JE','KA','KT','KW','KY','L','LA','LD','LE','LL','LN','LS','LU','M','ME','MK','ML','N','NE','NG','NN','NP','NR','NW','OL','OX','PA','PE','PH','PL','PO','PR','RG','RH','RM','S','SA','SE','SG','SK','SL','SM','SN','SO','SP','SR','SS','ST','SW','SY','TA','TD','TF','TN','TQ','TR','TS','TW','UB','W','WA','WC','WD','WF','WN','WR','WS','WV','YO','ZE']

for row in rows:
  row_id = row[0]
  if (row_id % 5000) == 0: #COMMIT EVERY 5000
    conn.commit()
    print("At id %s, changes effected:  %s" % (row_id, conn.total_changes))
    c = conn.cursor()
  postcode = row[5]
  pmatch = re.match('[a-zA-Z]+', postcode)
  if pmatch and pmatch.group(0) in valid_postcode_areas:
    c.execute("UPDATE trademarks SET postcode_area = '%s' WHERE id=%s;" % (pmatch.group(0), row_id));
  else:
    pass
    #print("No regex match, skipping id %s: %s" % (row_id, postcode))

conn.commit()
print("Done, changes effected:  %s" % (conn.total_changes))
conn.close()

# NB- above requires create a column for the data
# print("Add a column for postcode areas")
# c.execute('''ALTER TABLE trademarks ADD postcode_area text;''')
# conn.commit()
```

SQL Queries

```SQL
# Basic query

SELECT * FROM trademarks LIMIT 10;

# Final query

SELECT *
FROM (
  SELECT * FROM trademarks WHERE Filed is not "" ORDER BY Filed ASC
) AS sub
GROUP BY postcode_area LIMIT 150;
```


<!-- GHOST_RECOVERED_EMBEDS -->
<figure class="kg-card kg-embed-card"><iframe width="575" height="325" src="https://www.youtube.com/embed/esRoPoC0Ebg?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen title="Mapping the UK's oldest trademarks // Part 1: Preparing data with SQLite and Python"></iframe></figure>

<!-- /GHOST_RECOVERED_EMBEDS -->
