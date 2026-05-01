---
title: Exploring data from Companies House
slug: exploring-data-from-companies-house
createdAt: 2023-04-06 21:56:31.000000000 Z
updatedAt: 2023-05-30 16:11:40.000000000 Z
publishedAt: 2023-04-07 14:58:00.000000000 Z
FeatureImage: "/images/2023/05/cover-1.png"
date: 2023-04-07 14:58:00 UTC
layout: post
categories: creating-with-data
---

This video is an introduction to getting data from Companies House. It shows the steps of how you can get company details using both the web interface and the API.

In it, I discuss the limitations of the API, particularly when it comes to searching and retrieving non-standard details on multiple companies.  More or less these are the steps I needed to take when creating the [Tech Companies in Edinburgh](https://creating-with-data.glitch.me/edi-tech/index.html) visualisation for [my talk at the Edinburgh.js](<%= url_for("_posts/2023-04-07-principles-of-d3-js-a-talk-at-edinburgh-js.md") %>).

Tools used:

- Python with CSV, HTTPX, and JSON libraries (see below for code)
- cURL
- LibreOffice Calc

<!-- GHOST_RECOVERED_EMBEDS -->
<figure class="kg-card kg-embed-card">
<iframe width="575" height="325" src="https://www.youtube.com/embed/OOvx7TaJNVw?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen title="Exploring data from Companies House"></iframe></figure>

<!-- /GHOST_RECOVERED_EMBEDS -->


**Notes**

companies.py

```python
import httpx
import json
import csv
import time

with open('Companies-House-search-results.csv', newline='') as f:
  reader = csv.reader(f)
  data = list(reader)

for row in data:
  company_number = row[1]
  print(company_number)

auth_token="insert-your-key"

officer_results = []
for row in data:
  company_number = row[1]
  print(company_number)
  response = httpx.get("https://api.company-information.service.gov.uk/company/%s/officers" % company_number, auth=(auth_token, ""))
  result = json.loads(response.content)
  result["company_number"] = company_number # result doesnt have the number, we will save it here
  officer_results.append(result)
  time.sleep(2.1)

with open('details.csv', 'w', newline='') as file:
  writer = csv.writer(file)
  writer.writerow(["company_number", "active_officers", "sole_directorship"])
  for result in officer_results:
    resigned_count = result.get("resigned_count", 0)
    active_count   = result.get("active_count", 0)
    sole_directorship = (resigned_count == 0 and active_count == 1)
    writer.writerow([result.get("company_number", ""), result.get("active_count", ""), sole_directorship])
```

**Links**

- ['Principles of D3' @ Edinburgh.js Meetup](https://youtu.be/ypmCTiqTZAk?t=939)
- [Companies House Company Search](https://www.gov.uk/get-information-about-a-company)
- [Companies House Public Data API reference](https://developer-specs.company-information.service.gov.uk/companies-house-public-data-api/reference)


