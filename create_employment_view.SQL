/* Create a view of total employment within HCT station areas by year */

CREATE VIEW employment.v_hct_station_areas_employment
AS
SELECT wf.data_year,
       CASE WHEN SUM(wf.jobcount_covered) < 0.4 THEN '0'
            WHEN SUM(i.private_sector) = 0 THEN CAST(CAST(ROUND(SUM(wf.jobcount_covered),0) AS int) AS nvarchar)
            WHEN SUM(i.private_sector) IN(1,2) 
              OR MAX(wf.jobcount_raw * i.private_sector) / SUM(wf.jobcount_raw * i.private_sector) > 0.8
              OR SUM(wf.jobcount_raw * i.private_sector * (CASE WHEN wf.confid_firm_id = 0 THEN 0 ELSE 1 END)) / sum(wf.jobcount_raw * i.private_sector) > 0.8 THEN 'S'
            ELSE CAST(ROUND(SUM(wf.jobcount_all),0) AS int) END AS total_emp
FROM employment.workplace_facts AS wf
  INNER JOIN employment.industry_dims AS i ON wf.industry_id = i.industry_id
  INNER JOIN employment.workplace_location_dims AS wl ON wf.workplace_location_id = wl.workplace_location_id
  INNER JOIN ElmerGeo.dbo.HCT_STATION_AREAS AS hct ON wl.Shape.STIntersects(hct.Shape) = 1
WHERE wf.source_id < (8 - 1)
GROUP BY wf.data_year
;
