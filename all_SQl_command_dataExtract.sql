
create view pv as (
  select provider_id,measure_name,
    case when measure_id = "ED_2b" then score end as edscore,
    case when measure_id = "SEP_1" then score end as sescore,
    case when measure_id = "OP_22" then score end as opscore
    
  from tae
  group by provider_id
);

select * from pv where edscore>0 or opscore>0 or sescore>0;


select hospital_general_information.Facility_ID,
		timely_and_effective_care.Measure_Name, --timely_and_effective_care.Measure_ID,
        timely_and_effective_care.Score,
        hcahps.HCAHPS_Question,
        hcahps.HCAHPS_Answer_Percent,
        hcahps.Measure_ID
		
	From timely_and_effective_care
    join hospital_general_information on timely_and_effective_care.Facility_ID=hospital_general_information.Facility_ID
    join hcahps on hospital_general_information.Facility_ID = hcahps.Facility_ID
    where hcahps.Measure_ID like 'H_RECMND_D%' OR hcahps.Measure_ID LIKE 'H_RECMND_P%'
    and timely_and_effective_care.Measure_ID like "ED_2%" ;


alter table timely_and_effective_care change Score Score varchar(20);
alter table hcahps change HCAHPS_Answer_Percent HCAHPS_Answer_Percent varchar(20);
alter table hcahps change `Patient Survey Star Rating` Patient_Survey_Star_Rating varchar(200);

select Patient_Survey_Star_Rating from hcahps;

   
    
create table tae(
provider_id varchar(45) ,
measure_id varchar(45) ,
measure_name varchar(450) ,
score int(11)
);

create table hca(
provider_id varchar(45), 
hcahps_measure_id varchar(450), 
hcahps_question varchar(450), 
hcahps_answer_description varchar(450), 
hcahps_answer_percent int(111), 
patient_survey_star_rating int(111),
number_of_completed_surveys varchar(450) 
);
  
create table hgi(
provider_id varchar(45) , 
hospital_name varchar(500) ,
hospital_type varchar(450), 
hospital_ownership varchar(450) 
);

Alter table hca drop column patient_survey_star_rating;
Alter table hgi add hospital_overall_rating int(11);
select * from hgi;
select * from tae;
select * from hca where hcahps_measure_id like 'H_RECMND_D%' or hcahps_measure_id like 'H_RECMND_P%';
select provider_id, score as ed_score from tae where measure_id LIKE 'ED_%' ;

select hgi.provider_id,
		hgi.hospital_overall_rating,
		tae.measure_name,
        tae.score,
        hca.hcahps_question,
        hca.hcahps_answer_percent,
        hca.hcahps_measure_id,
        hca.number_of_completed_surveys,
        tae.measure_id
	from tae
    join hgi on tae.provider_id=hgi.provider_id
    join hca on hgi.provider_id = hca.provider_id
	where tae.measure_id = 'OP_22'
    
    -- in ('ED_2b','OP_18b','OP_22','SEP_1','IMM_3')
    -- and tae.score >= 0
    -- or hca.hcahps_answer_percent >= 0;
  --  hca.hcahps_measure_id in('H_RECMN_DN','H_RECMN_PN','H_RECMN_DY','H_RECMN_PY')
  
  
  

 
  ------------------------------------------------------------------------------------------
  
create table fn(
facility_id varchar(450), 
measure_code varchar(450), 
measure_score int(111),
measure_desc varchar(4500),
recommend varchar(4500),
label int(111),
hca_ans varchar(4500), 
ans_percent int(111), 
rating int(111));

  
  create view pv1 as (
  select facility_id,  
measure_code,  
-- measure_score , 
measure_desc,  
recommend ,
label,  
hca_ans , 
ans_percent ,
rating,  
  
    case when measure_code = "ED_2b" then measure_score end as ed_score,
    case when measure_code = "SEP_1" then measure_score end as sep_score,
    case when measure_code = "OP_22" then measure_score end as op_score,
    case when measure_code = "OP_18b" then measure_score end as op18_score
  from fn
  group by facility_id
);
  
 select * from pv1; 
  		

  create table edonly(
facility_id varchar(450), 
measure_code varchar(450), 
score int(111),
hcahps_question varchar(4500),
h_measure_id varchar(4500),
label int(111),
ans_percent int(111));

 select * from edonly; 

create view pv_edonly as (
  select facility_id,  
measure_code,  
-- measure_score , 
-- measure_desc,  
hcahps_question ,
label,  
h_measure_id , 
ans_percent , 
  
    case when measure_code = "ED2" then score end as ed_score,
    -- case when measure_code = "SEP_1" then score end as sep_score,
    case when measure_code = "Left before being seen" then score end as op22_score,
    case when measure_code = "OP 18" then score end as op18_score
  from edonly
  group by facility_id
);
  
select * from tae; 