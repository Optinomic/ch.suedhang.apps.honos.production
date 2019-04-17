
SELECT

-- START:  Optinoimc Default
  survey_response_view.patient_id as optinomic_patient_id,
  survey_response_view.stay_id as optinomic_stay_id,
  survey_response_view.event_id as optinomic_event_id,
  survey_response_view.survey_response_id as optinomic_survey_response_id,
  survey_response_view.filled as optinomic_survey_filled,
  ((cast(response AS json))->>'id') as optinomic_limesurvey_id,
  -- END:  Optinoimc Default

  patient.cis_pid as cis_pid,
  stay.cis_fid as cis_fid,
  CONCAT(patient.cis_pid, '00', RIGHT((stay.cis_fid/100)::text,2)) as medstatfid,
  stay.cis_fid/100 as fid,
  ((cast(response AS json))->>'FID') as fid_survey,

  'PH' as Rekordart,
  71286515 as betriebsnummer_bur,

  CASE WHEN ((cast(response AS json))->>'q401V04')~E'^\\d+$' THEN ((cast(response AS json))->>'q401V04')::integer ELSE 3 END as zeitpunkt_honos,
  ((cast(response AS json))->>'q401V05') as dropoutcode_honos,
  ((cast(response AS json))->>'q401V06') as spezifikation_dropout_honos_andere,

  CASE (CASE WHEN ((cast(response AS json))->>'q401V04')~E'^\\d+$' THEN ((cast(response AS json))->>'q401V04')::integer ELSE 3 END)
  WHEN 1 THEN to_char(stay.start, 'YYYYMMDD')
  WHEN 2 THEN 
    CASE (CASE WHEN (to_char(stay.stop, 'YYYYMMDD') IS NULL OR to_char(stay.stop, 'YYYYMMDD') = '') THEN 1 ELSE 2 END)
    WHEN 1 THEN TO_CHAR(TO_DATE(((cast(response AS json))->>'q402V00'), 'YYYY-MM-DD'), 'YYYYMMDD')
    WHEN 2 THEN to_char(stay.stop, 'YYYYMMDD')
    END
  ELSE TO_CHAR(TO_DATE(((cast(response AS json))->>'q402V00'), 'YYYY-MM-DD'), 'YYYYMMDD')
  END as datum_erhebung_honos,
 

  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.1' || ((cast(response AS json))->>'H1[402V01]')
    ELSE '94.A1.19'
  END as honos_h1,
  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.2' || ((cast(response AS json))->>'H1[402V02]')
    ELSE '94.A1.29'
  END as honos_h2,
  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.3' || ((cast(response AS json))->>'H1[402V03]')
    ELSE '94.A1.39'
  END as honos_h3,
  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.4' || ((cast(response AS json))->>'H1[402V04]')
    ELSE '94.A1.49'
  END as honos_h4,
  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.5' || ((cast(response AS json))->>'H1[402V05]')
    ELSE '94.A1.59'
  END as honos_h5,
  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.6' || ((cast(response AS json))->>'H1[402V06]')
    ELSE '94.A1.69'
  END as honos_h6,
  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.7' || ((cast(response AS json))->>'H1[402V07]')
    ELSE '94.A1.79'
  END as honos_h7,
  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.8' || ((cast(response AS json))->>'H1[402V08]')
    ELSE '94.A1.89'
  END as honos_h8,
  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.9' || ((cast(response AS json))->>'H2[402V11]')
    ELSE '94.A1.99'
  END as honos_h9,
  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.A' || ((cast(response AS json))->>'H2[402V12]')
    ELSE '94.A1.A9'
  END as honos_h10,
  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.B' || ((cast(response AS json))->>'H2[402V13]')
    ELSE '94.A1.B9'
  END as honos_h11,
  CASE WHEN ((cast(response AS json))->>'q401V05') = '0' 
    THEN '94.A1.C' || ((cast(response AS json))->>'H2[402V14]')
    ELSE '94.A1.C9'
  END as honos_h12,

  ((cast(response AS json))->>'H1[402V01]') as honos_h1_uncoded,
  ((cast(response AS json))->>'H1[402V02]') as honos_h2_uncoded,
  ((cast(response AS json))->>'H1[402V03]') as honos_h3_uncoded,
  ((cast(response AS json))->>'H1[402V04]') as honos_h4_uncoded,
  ((cast(response AS json))->>'H1[402V05]') as honos_h5_uncoded,
  ((cast(response AS json))->>'H1[402V06]') as honos_h6_uncoded,
  ((cast(response AS json))->>'H1[402V07]') as honos_h7_uncoded,
  ((cast(response AS json))->>'H1[402V08]') as honos_h8_uncoded,
  ((cast(response AS json))->>'q402V09') as honos_h8a_uncoded,
  ((cast(response AS json))->>'q402V10') as honos_h8b_uncoded,
  ((cast(response AS json))->>'H2[402V11]') as honos_h9_uncoded,
  ((cast(response AS json))->>'H2[402V12]') as honos_h10_uncoded,
  ((cast(response AS json))->>'H2[402V13]') as honos_h11_uncoded,
  ((cast(response AS json))->>'H2[402V14]') as honos_h12_uncoded

FROM "survey_response_view"
LEFT JOIN patient ON(survey_response_view.patient_id = patient.id)
LEFT JOIN stay ON(survey_response_view.stay_id = stay.id)
WHERE module = 'ch.suedhang.apps.honos.production'
AND date_trunc('day', now()::timestamp) = date_trunc('day', survey_response_view.filled::timestamp)
AND ((cast(response AS json))->>'q401V04') != ''
AND stay.cis_fid is not null
AND survey_response_view.patient_id != '1169'
AND survey_response_view.patient_id != '387'
AND survey_response_view.patient_id != '1'
ORDER BY  patient.cis_pid, stay.cis_fid;
