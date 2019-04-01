* Encoding: UTF-8.
*open the Landlord registered data. 


GET DATA
  /TYPE=XLSX
  /FILE='C:\Users\bml12m\Dropbox\Housing project\Private rental Project\Landlord '+
    'Reg\Edinburgh\16177 Response Data.xlsx'
  /SHEET=name 'Query1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.


*Create a unique number.

  COMPUTE id=$CASENUM.
  FORMAT id (F8.0).
  EXECUTE.


*Save file.


SAVE OUTFILE='C:\Users\bml12m\Dropbox\Housing project\Private rental Project\Landlord Reg\Edinburgh\Edinburgh_LR.sav'
  /COMPRESSED.


*Make all postcodes upper case.
String postcode (A8).

Compute postcode =UPCASE( PropertyPostcode).
Execute.



*Open the isd postcode file.
GET
  FILE='D:\Housing project\Private rental Project\Landlord '+
    'Reg\Scottish_Postcode_Directory_2017_1.sav'.
ALTER TYPE ALL(A=AMIN).
DATASET NAME DataSet2 WINDOW=FRONT.


*merge postcode file.
*Sort both files before running merge.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /TABLE='DataSet2'
  /RENAME pc8=postcode
  /BY postcode.
EXECUTE.


SAVE OUTFILE='C:\Users\bml12m\Dropbox\Housing project\Private rental Project\Landlord Reg\Edinburgh\Edinburgh_LR.sav'
  /COMPRESSED.

*Create Datazone file.
DATASET ACTIVATE DataSet1.
DATASET DECLARE DZ_Edinburgh.
AGGREGATE
  /OUTFILE='DZ_Edinburgh'
  /BREAK=DataZone2011
  /NumberofProperties=SUM(NumberofProperties).

SAVE OUTFILE='C:\Users\bml12m\Dropbox\Housing project\Private rental Project\Landlord Reg\Edinburgh\DZEdinburgh_LR.sav'
  /COMPRESSED.

DATASET DECLARE Edinburgh_LandlordsReg_DZ2.
AGGREGATE
  /OUTFILE='Edinburgh_LandlordsReg_DZ2'
  /BREAK=DataZone2011
  /HHC2011=SUM(HHC2011) 
  /Pop2011=SUM(Pop2011) 
  /HHC2001=SUM(HHC2001) 
  /Pop2001=SUM(Pop2001) 
  /Grid_Reference_Easting=FIRST(Grid_Reference_Easting) 
  /Grid_Reference_Northing=FIRST(Grid_Reference_Northing) 
  /Latitude=FIRST(Latitude) 
  /Longitude=FIRST(Longitude)
  /LandlordReg_Properties=sum(NumberofProperties).



*Add in Household type from census.

GET DATA
  /TYPE=XLSX
  /FILE='C:\Users\bml12m\Dropbox\Housing project\Private rental Project\Landlord '+
    'Reg\Edinburgh\Householdtype2011V1.xlsx'
  /SHEET=name 'QS113SC'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet3 WINDOW=FRONT.


SAVE OUTFILE='C:\Users\bml12m\Dropbox\Housing project\Private rental Project\Landlord Reg\Edinburgh\HouseholdsCensus2011.sav'
  /COMPRESSED.

DATASET ACTIVATE DataSet4.
MATCH FILES /FILE=*
  /TABLE='DataSet2'
  /RENAME Datazone=DataZone2011
  /BY DataZone2011.
EXECUTE.


GET 
  FILE='C:\Users\bml12m\Dropbox\Housing project\Private rental Project\SPSS files\DZ2011PR2011.sav'. 
DATASET NAME DataSet2 WINDOW=FRONT.


*Import Tenure from the census.


MATCH FILES /FILE=*
  /TABLE='DataSet2'
  /RENAME DataZone=DataZone2011
  /BY DataZone2011.
EXECUTE.


SAVE OUTFILE='C:\Users\bml12m\Dropbox\Housing project\Private rental Project\Landlord Reg\Edinburgh\DZEdinburgh_extended.sav'
  /COMPRESSED.


SAVE TRANSLATE OUTFILE='C:\Users\bml12m\Dropbox\Housing project\Private rental Project\Landlord Reg\Edinburgh\DZEdinburgh_LR.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.



