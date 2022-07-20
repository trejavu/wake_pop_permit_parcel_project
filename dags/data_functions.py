import pandas as pd
import requests
from google.cloud import storage
from datetime import datetime

def get_parcel_data(file_name):
    DOWNLOAD_URL = "https://maps.wakegov.com/arcgis/rest/services/Property/Parcels/MapServer/0/query"

    params = {'where': "1=1", 'outFields': "*", 'returnGeometry': 'false', 'outSR':4326, 'f':'json', 'resultOffset': 0}
    response = requests.get(DOWNLOAD_URL, params=params)

    if 'exceededTransferLimit' in response.json().keys():
        exceededTransferLimit = response.json()['exceededTransferLimit']
    else:
        exceededTransferLimit = False
    data_fields = []
    results = response.json()['features']
    for feature in results:
        data_fields.append(feature['attributes'])

    while exceededTransferLimit:
        params['resultOffset'] = len(data_fields)
        response = requests.get(DOWNLOAD_URL, params=params)
        if 'exceededTransferLimit' in response.json().keys():
            exceededTransferLimit = response.json()['exceededTransferLimit']
        else:
            exceededTransferLimit = False
        results = response.json()['features']
        for feature in results:
            data_fields.append(feature['attributes'])

    parcels_df = pd.DataFrame.from_records(data_fields)
    
    parcels_df['record_date'] = datetime.now()

    cols = ['OBJECTID', 'CITY', 'CITY_DECODE', 'PLANNING_JURISDICTION', 'TYPE_USE_DECODE', 'DESIGN_STYLE_DECODE', 'LAND_CLASS_DECODE', 'BLDG_VAL', 'LAND_VAL', 'TOTAL_VALUE_ASSD', 'TOTUNITS', 'record_date']

    parcels_df[cols].to_parquet(file_name, index=False)

def get_permit_data(file_name):
    DOWNLOAD_URL = "https://maps.wakegov.com/arcgis/rest/services/Inspections/Building_Permits/MapServer/0/query"

    params = {'where': "1=1", 'outFields': "*", 'returnGeometry': 'false', 'outSR':4326, 'f':'json', 'resultOffset': 0}
    response = requests.get(DOWNLOAD_URL, params=params)

    if 'exceededTransferLimit' in response.json().keys():
        exceededTransferLimit = response.json()['exceededTransferLimit']
    else:
        exceededTransferLimit = False
    data_fields = []
    results = response.json()['features']
    for feature in results:
        data_fields.append(feature['attributes'])

    while exceededTransferLimit:
        params['resultOffset'] = len(data_fields)
        response = requests.get(DOWNLOAD_URL, params=params)
        if 'exceededTransferLimit' in response.json().keys():
            exceededTransferLimit = response.json()['exceededTransferLimit']
        else:
            exceededTransferLimit = False
        results = response.json()['features']
        for feature in results:
            data_fields.append(feature['attributes'])

    parcels_df = pd.DataFrame.from_records(data_fields)
    parcels_df['record_date'] = datetime.now()
    cols = ['OBJECTID', 'ISSUE_DATE', 'PERMIT_STATUS', 'DISTRICT', 'PERMIT_TYPE', 'WORK_CLASS', 'PROPOSED_USE', 'VALUATION', 'TOTAL_FEE_AMOUNT', 'CONTRACTOR', 'X', 'Y', 'record_date']
    parcels_df['ISSUE_DATE'] = pd.to_datetime(parcels_df['ISSUE_DATE']/1000, unit='s')

    parcels_df[cols].to_parquet(file_name, index=False)


def upload_to_gcs(bucket, object_name, local_file):
    """
    Ref: https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-python
    :param bucket: GCS bucket name
    :param object_name: target path & file-name
    :param local_file: source path & file-name
    :return:
    """
    # WORKAROUND to prevent timeout for files > 6 MB on 800 kbps upload speed.
    # (Ref: https://github.com/googleapis/python-storage/issues/74)
    storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB
    # End of Workaround

    client = storage.Client()
    bucket = client.bucket(bucket)

    blob = bucket.blob(object_name)
    blob.upload_from_filename(local_file)
