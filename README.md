# Covid API

# Usage

### Countries

- **METHOD**: GET
- **URL**: `https://api.trackingcovid.com/api/countries`
- **RESPONSE**:

```json
{"Georgia": [],
"Latvia": [],
"Jamaica": [],
"Poland": [],
"Canada": [
  "British Columbia",
  "Ontario",
  "Alberta",
  "Quebec",
  "New Brunswick",
  "Manitoba",
  "Saskatchewan",
  "Grand Princess"
  ],
 ...
 }
```

### By Country

- **METHOD**: GET
- **URL**: `https://api.rackingcovid.com/api/confirmed/<country>`
  - ex: https://api.trackingcovid.com/api/confirmed/Canada
- **RESPONSE**

```json
{
  "country": "Canada",
  "cases": [0, 0, 1,...],
  "predictions": [0.6292397306678004, 0.6990728897808295, ...],
  "prediction_type": "weighted_exponential",
  "start": "2020-01-22"
}
```

### By Countries

- **METHOD**: GET
- **URL**: `https://api.trackingcovid.com/api/confirmed/?countries=<countries>`
  - ex: https://api.trackingcovid.com/api/confirmed?countries=Canada,US
- **RESPONSE**

```json
{
  "regions": {},
  "countries": {
    "Canada": {
      "cases": [
        0,
        0,
        1,
        ...
      ],
      "predictions": [
        0.6292397306678004,
        0.6990728897808295,
        ...
      ],
      "prediction_type": "weighted_exponential",
      "country": "Canada",
      "start": "2020-01-22"
    },
    "US": {
      "country": "US",
      "cases": [
        0,
        0,
        1,
        ...
      ],
      "predictions": [
        0.1602764754993061,
        0.19285269106150466,
        ...
      ],
      "prediction_type": "weighted_exponential",
      "start": "2020-01-22"
    }
  }
}
```

### By Regions

- **METHOD**: GET
- **URL**: `https://api.trackingcovid.com/api/confirmed/?regions=<regions>`
- ex: https://api.trackingcovid.com/api/confirmed?regions=Georgia,Ontario
- **RESPONSE**

```json
{"regions":
  {"Ontario": {
    "cases": [0, 0, 1,...],
    "predictions": [0.6292397306678004, 0.6990728897808295, ...],
    "prediction_type": "weighted_exponential",
    "region": "Ontario",
    "start": "2020-01-22"
   },
  "Georgia": {
    "region": "Georgia",
    "cases": [0, 0, 1,...],
    "predictions": [0.1602764754993061, 0.19285269106150466, ...],
    "prediction_type": "weighted_exponential",
    "start": "2020-01-22"
   },
  },
  "countries": {}
}
```

### By Countries & Regions

- **METHOD**: GET
- **URL**: `https://api.trackingcovid.com/api/confirmed/?countries=<countries>&regions=<regions>`
- ex: https://api.trackingcovid.com/api/confirmed?regions=Georgia,Ontario&countries=US,Canada,Japan
- **RESPONSE**

```json
{
  "regions": {
    "Ontario": {
      "cases": [
        0,
        0,
        1,
        ...
      ],
      "predictions": [
        0.6292397306678004,
        0.6990728897808295,
        ...
      ],
      "prediction_type": "weighted_exponential",
      "region": "Ontario",
      "start": "2020-01-22"
    },
    "Georgia": {
      "region": "Georgia",
      "cases": [
        0,
        0,
        1,
        ...
      ],
      "predictions": [
        0.1602764754993061,
        0.19285269106150466,
        ...
      ],
      "prediction_type": "weighted_exponential",
      "start": "2020-01-22"
    }
  },
  "countries": {
    "Canada": {
      "cases": [
        0,
        0,
        1,
        ...
      ],
      "predictions": [
        0.6292397306678004,
        0.6990728897808295,
        ...
      ],
      "prediction_type": "weighted_exponential",
      "country": "Canada",
      "start": "2020-01-22"
    },
    "US": {
      "country": "US",
      "cases": [
        0,
        0,
        1,
        ...
      ],
      "predictions": [
        0.1602764754993061,
        0.19285269106150466,
        ...
      ],
      "prediction_type": "weighted_exponential",
      "start": "2020-01-22"
    },
    ...
  }
}
```

## Sources

All data from: [Johns Hopkins CSSE](https://github.com/CSSEGISandData/COVID-19)
