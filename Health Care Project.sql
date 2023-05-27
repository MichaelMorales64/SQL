/* In this SQL project, I analyze healthcare data to gain insights into patient information, medical trends, and hospital performance.*/

--Skills used: JOINs, Subqueries, GROUP BY, HAVING, ORDER BY, CONCAT 


CREATE TABLE patient_encounters (
  encounter_id INTEGER,
  patient_nbr INTEGER,
  race VARCHAR(255),
  gender VARCHAR(255),
  age VARCHAR(255),
  weight VARCHAR(255),
  admission_type_id INTEGER,
  discharge_disposition_id INTEGER,
  admission_source_id INTEGER,
  time_in_hospital INTEGER,
  payer_code VARCHAR(255),
  medical_specialty VARCHAR(255),
  num_lab_procedures INTEGER,
  num_procedures INTEGER,
  num_medications INTEGER,
  number_outpatient INTEGER,
  number_emergency INTEGER,
  number_inpatient INTEGER,
  diag_1 VARCHAR(255),
  diag_2 VARCHAR(255),
  diag_3 VARCHAR(255),
  number_diagnoses INTEGER,
  max_glu_serum VARCHAR(255),
  A1Cresult VARCHAR(255),
  metformin VARCHAR(255),
  repaglinide VARCHAR(255),
  nateglinide VARCHAR(255),
  chlorpropamide VARCHAR(255),
  glimepiride VARCHAR(255),
  acetohexamide VARCHAR(255),
  glipizide VARCHAR(255),
  glyburide VARCHAR(255),
  tolbutamide VARCHAR(255),
  pioglitazone VARCHAR(255),
  rosiglitazone VARCHAR(255),
  acarbose VARCHAR(255),
  miglitol VARCHAR(255),
  troglitazone VARCHAR(255),
  tolazamide VARCHAR(255),
  examide VARCHAR(255),
  citoglipton VARCHAR(255),
  insulin VARCHAR(255),
  glyburide_metformin VARCHAR(255),
  glipizide_metformin VARCHAR(255),
  glimepiride_pioglitazone VARCHAR(255),
  metformin_rosiglitazone VARCHAR(255),
  metformin_pioglitazone VARCHAR(255),
  change VARCHAR(255),
  diabetesMed VARCHAR(255),
  readmitted VARCHAR(255)
);
-- Getting a general view of the data
select * from patient_encounters
limit 10;

--What is the length of time patients are staying in the hospital?
select
  	distinct(p.race)
  , avg(p.time_in_hospital)
  
from
  patient_encounters p
 
group by
    p.race 
 
order by
 avg(p.time_in_hospital) desc;
 
--Is there a racial bias for the amount of lab procedures patients receive?

select
  	distinct(p.race)
  , avg(p.num_lab_procedures) as avg_lab_procedures
  
from
  patient_encounters p
 
group by
  	p.race 
 
order by
 avg_lab_procedures desc;
 
--Which departments perform the most lab procedures?

select
  	p.medical_specialty
  , avg(p.num_lab_procedures) as avg_procedures
  
from
  patient_encounters p
 
group by
  	p.medical_specialty
	
order by
 avg_procedures desc;
 
--Let's narrow down the list

select
  	p.medical_specialty
  , round(avg(p.num_lab_procedures),1) as avg_procedures
  , COUNT(*) AS count 
  
from
  patient_encounters p
 
group by
  	p.medical_specialty
	
having	
	count(*) > 50 
	and avg(p.num_lab_procedures) > 30
	
order by
 avg_procedures desc;
 
--Do lab procedures mean longer stays in the hospital?

select
    p.num_lab_procedures
  , case 
	 when num_lab_procedures <= 25 then 'few'
	 when num_lab_procedures <= 55 then 'average'
	 else 'many'
	end as procedure_freq
		
from
  patient_encounters p;
  
--Consolidated information, shows there is a correlation between time in hospital and lab procedures done. 

select
    avg(time_in_hospital) as avg_time_in_hospital
  ,	case 
	 when num_lab_procedures <= 25 then 'few'
	 when num_lab_procedures <= 55 then 'average'
	 else 'many'
  end as procedure_freq

from patient_encounters

group by 
  case 
	 when num_lab_procedures <= 25 then 'few'
	 when num_lab_procedures <= 55 then 'average'
	 else 'many'
  end
  
order by avg_time_in_hospital desc;

--When patients discharge, do they readmit to the hospital in under 30 days? 8800+ rows (Yes)

select
    distinct p.patient_nbr
  , p.readmitted
from
  patient_encounters p
  
where 
 p.readmitted = '<30'

group by
    p.patient_nbr
  , p.readmitted;
  
  
--Top 50 patients with the longest stay in hospital and most lab procedures done 

select 
    distinct p.patient_nbr 
  , MAX(p.time_in_hospital) AS max_time_in_hospital 
  , max(p.num_lab_procedures) AS max_num_lab_procedures
  
from 
    patient_encounters p
	
group by  
    p.patient_nbr
	
order by 
    max_time_in_hospital DESC
  , max_num_lab_procedures DESC
  , p.patient_nbr
 
limit 50; 

-- Using CONCAT function to focus on top 50 patients with longest stay in hospital, most procedures done, and if readmitted in <30 days.

select 
    CONCAT('Patient ', p.patient_nbr
		   , ' was ', p.race
		   , ' and was ',
           CASE p.readmitted WHEN '<30' THEN 'readmitted' ELSE 'not readmitted' END,
           '. They spent ', p.max_time_in_hospital,
		   ' days in the hospital with ', p.max_num_lab_procedures,
		   ' lab procedures done.') 
		   AS patient_info
from 
    (select distinct
        p.patient_nbr, 
        p.race, 
        p.readmitted,
        max(p.time_in_hospital) as max_time_in_hospital, 
        max(p.num_lab_procedures) as max_num_lab_procedures
    from 
        patient_encounters p
    group by 
        p.patient_nbr, 
        p.race, 
        p.readmitted
    order by 
        max_time_in_hospital desc, 
        max_num_lab_procedures desc 
    limit 50) p;
	
--Are any of the these returning patients (>30days) coming through the emergency room? 

select 
    distinct p.patient_nbr 
  ,	p.time_in_hospital

from 
    patient_encounters p
	
where 
    p.admission_type_id = 1 -- Patients who came through the emergency room
    and p.readmitted = '>30' -- Readmitted in more than 30 days
	
limit 50;

