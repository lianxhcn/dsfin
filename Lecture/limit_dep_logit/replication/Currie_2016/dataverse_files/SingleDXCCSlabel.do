/************************************************************************************
Program Name: SingleDXCCSlabel.do 
Description : Define Single-Level Diagnosis CCS value labels from Stata. 
Developed   : By Bob Houchens
Updated     : By David Ross on 10/28/2009.
************************************************************************************/

label define singleDXCCSlabel 0 `"No diagnosis code"', modify
label define singleDXCCSlabel 1 `"Tuberculosis"', modify
label define singleDXCCSlabel 2 `"Septicemia (except in labor)"', modify
label define singleDXCCSlabel 3 `"Bacterial infection; unspecified site"', modify
label define singleDXCCSlabel 4 `"Mycoses"', modify
label define singleDXCCSlabel 5 `"HIV infection"', modify
label define singleDXCCSlabel 6 `"Hepatitis"', modify
label define singleDXCCSlabel 7 `"Viral infection"', modify
label define singleDXCCSlabel 8 `"Other infections; including parasitic"', modify
label define singleDXCCSlabel 9 `"Sexually transmitted infections (not HIV or hepatitis)"', modify
label define singleDXCCSlabel 10 `"Immunizations and screening for infectious disease"', modify
label define singleDXCCSlabel 11 `"Cancer of head and neck"', modify
label define singleDXCCSlabel 12 `"Cancer of esophagus"', modify
label define singleDXCCSlabel 13 `"Cancer of stomach"', modify
label define singleDXCCSlabel 14 `"Cancer of colon"', modify
label define singleDXCCSlabel 15 `"Cancer of rectum and anus"', modify
label define singleDXCCSlabel 16 `"Cancer of liver and intrahepatic bile duct"', modify
label define singleDXCCSlabel 17 `"Cancer of pancreas"', modify
label define singleDXCCSlabel 18 `"Cancer of other GI organs; peritoneum"', modify
label define singleDXCCSlabel 19 `"Cancer of bronchus; lung"', modify
label define singleDXCCSlabel 20 `"Cancer; other respiratory and intrathoracic"', modify
label define singleDXCCSlabel 21 `"Cancer of bone and connective tissue"', modify
label define singleDXCCSlabel 22 `"Melanomas of skin"', modify
label define singleDXCCSlabel 23 `"Other non-epithelial cancer of skin"', modify
label define singleDXCCSlabel 24 `"Cancer of breast"', modify
label define singleDXCCSlabel 25 `"Cancer of uterus"', modify
label define singleDXCCSlabel 26 `"Cancer of cervix"', modify
label define singleDXCCSlabel 27 `"Cancer of ovary"', modify
label define singleDXCCSlabel 28 `"Cancer of other female genital organs"', modify
label define singleDXCCSlabel 29 `"Cancer of prostate"', modify
label define singleDXCCSlabel 30 `"Cancer of testis"', modify
label define singleDXCCSlabel 31 `"Cancer of other male genital organs"', modify
label define singleDXCCSlabel 32 `"Cancer of bladder"', modify
label define singleDXCCSlabel 33 `"Cancer of kidney and renal pelvis"', modify
label define singleDXCCSlabel 34 `"Cancer of other urinary organs"', modify
label define singleDXCCSlabel 35 `"Cancer of brain and nervous system"', modify
label define singleDXCCSlabel 36 `"Cancer of thyroid"', modify
label define singleDXCCSlabel 37 `"Hodgkins disease"', modify
label define singleDXCCSlabel 38 `"Non-Hodgkins lymphoma"', modify
label define singleDXCCSlabel 39 `"Leukemias"', modify
label define singleDXCCSlabel 40 `"Multiple myeloma"', modify
label define singleDXCCSlabel 41 `"Cancer; other and unspecified primary"', modify
label define singleDXCCSlabel 42 `"Secondary malignancies"', modify
label define singleDXCCSlabel 43 `"Malignant neoplasm without specification of site"', modify
label define singleDXCCSlabel 44 `"Neoplasms of unspecified nature or uncertain behavior"', modify
label define singleDXCCSlabel 45 `"Maintenance chemotherapy; radiotherapy"', modify
label define singleDXCCSlabel 46 `"Benign neoplasm of uterus"', modify
label define singleDXCCSlabel 47 `"Other and unspecified benign neoplasm"', modify
label define singleDXCCSlabel 48 `"Thyroid disorders"', modify
label define singleDXCCSlabel 49 `"Diabetes mellitus without complication"', modify
label define singleDXCCSlabel 50 `"Diabetes mellitus with complications"', modify
label define singleDXCCSlabel 51 `"Other endocrine disorders"', modify
label define singleDXCCSlabel 52 `"Nutritional deficiencies"', modify
label define singleDXCCSlabel 53 `"Disorders of lipid metabolism"', modify
label define singleDXCCSlabel 54 `"Gout and other crystal arthropathies"', modify
label define singleDXCCSlabel 55 `"Fluid and electrolyte disorders"', modify
label define singleDXCCSlabel 56 `"Cystic fibrosis"', modify
label define singleDXCCSlabel 57 `"Immunity disorders"', modify
label define singleDXCCSlabel 58 `"Other nutritional; endocrine; and metabolic disorders"', modify				    
label define singleDXCCSlabel 59 `"Deficiency and other anemia"', modify
label define singleDXCCSlabel 60 `"Acute posthemorrhagic anemia"', modify
label define singleDXCCSlabel 61 `"Sickle cell anemia"', modify
label define singleDXCCSlabel 62 `"Coagulation and hemorrhagic disorders"', modify
label define singleDXCCSlabel 63 `"Diseases of white blood cells"', modify
label define singleDXCCSlabel 64 `"Other hematologic conditions"', modify
label define singleDXCCSlabel 650 `"Adjustment disorders"', modify
label define singleDXCCSlabel 651 `"Anxiety disorders"', modify
label define singleDXCCSlabel 652 `"Attention-deficit, conduct, and disruptive behavior disorders"', modify
label define singleDXCCSlabel 653 `"Delirium, dementia, and amnestic and other cognitive disorders"', modify
label define singleDXCCSlabel 654 `"Developmental disorders"', modify
label define singleDXCCSlabel 655 `"Disorders usually diagnosed in infancy, childhood, or adolescence"', modify
label define singleDXCCSlabel 656 `"Impulse control disorders, NEC"', modify
label define singleDXCCSlabel 657 `"Mood disorders"', modify
label define singleDXCCSlabel 658 `"Personality disorders"', modify
label define singleDXCCSlabel 659 `"Schizophrenia and other psychotic disorders"', modify
label define singleDXCCSlabel 660 `"Alcohol-related disorders"', modify
label define singleDXCCSlabel 661 `"Substance-related disorders"', modify
label define singleDXCCSlabel 662 `"Suicide and intentional self-inflicted injury"', modify
label define singleDXCCSlabel 663 `"Screening and history of mental health and substance abuse codes"', modify
label define singleDXCCSlabel 670 `"Miscellaneous disorders"', modify      
label define singleDXCCSlabel 76 `"Meningitis (except that caused by tuberculosis or sexually transmitted disease)"', modify
label define singleDXCCSlabel 77 `"Encephalitis (except that caused by tuberculosis or sexually transmitted disease)"', modify
label define singleDXCCSlabel 78 `"Other CNS infection and poliomyelitis"', modify
label define singleDXCCSlabel 79 `"Parkinsons disease"', modify
label define singleDXCCSlabel 80 `"Multiple sclerosis"', modify
label define singleDXCCSlabel 81 `"Other hereditary and degenerative nervous system conditions"', modify
label define singleDXCCSlabel 82 `"Paralysis"', modify
label define singleDXCCSlabel 83 `"Epilepsy; convulsions"', modify
label define singleDXCCSlabel 84 `"Headache; including migraine"', modify
label define singleDXCCSlabel 85 `"Coma; stupor; and brain damage"', modify
label define singleDXCCSlabel 86 `"Cataract"', modify
label define singleDXCCSlabel 87 `"Retinal detachments; defects; vascular occlusion; and retinopathy"', modify
label define singleDXCCSlabel 88 `"Glaucoma"', modify
label define singleDXCCSlabel 89 `"Blindness and vision defects"', modify
label define singleDXCCSlabel 90 `"Inflammation; infection of eye (except that caused by tuberculosis or sexually transmitteddisease)"', modify
label define singleDXCCSlabel 91 `"Other eye disorders"', modify
label define singleDXCCSlabel 92 `"Otitis media and related conditions"', modify
label define singleDXCCSlabel 93 `"Conditions associated with dizziness or vertigo"', modify
label define singleDXCCSlabel 94 `"Other ear and sense organ disorders"', modify
label define singleDXCCSlabel 95 `"Other nervous system disorders"', modify
label define singleDXCCSlabel 96 `"Heart valve disorders"', modify
label define singleDXCCSlabel 97 `"Peri-; endo-; and myocarditis; cardiomyopathy (except that caused by tuberculosis or sexually transmitted disease)"', modify
label define singleDXCCSlabel 98 `"Essential hypertension"', modify
label define singleDXCCSlabel 99 `"Hypertension with complications and secondary hypertension"', modify
label define singleDXCCSlabel 100 `"Acute myocardial infarction"', modify
label define singleDXCCSlabel 101 `"Coronary atherosclerosis and other heart disease"', modify
label define singleDXCCSlabel 102 `"Nonspecific chest pain"', modify
label define singleDXCCSlabel 103 `"Pulmonary heart disease"', modify
label define singleDXCCSlabel 104 `"Other and ill-defined heart disease"', modify
label define singleDXCCSlabel 105 `"Conduction disorders"', modify
label define singleDXCCSlabel 106 `"Cardiac dysrhythmias"', modify
label define singleDXCCSlabel 107 `"Cardiac arrest and ventricular fibrillation"', modify
label define singleDXCCSlabel 108 `"Congestive heart failure; nonhypertensive"', modify
label define singleDXCCSlabel 109 `"Acute cerebrovascular disease"', modify
label define singleDXCCSlabel 110 `"Occlusion or stenosis of precerebral arteries"', modify
label define singleDXCCSlabel 111 `"Other and ill-defined cerebrovascular disease"', modify
label define singleDXCCSlabel 112 `"Transient cerebral ischemia"', modify
label define singleDXCCSlabel 113 `"Late effects of cerebrovascular disease"', modify
label define singleDXCCSlabel 114 `"Peripheral and visceral atherosclerosis"', modify
label define singleDXCCSlabel 115 `"Aortic; peripheral; and visceral artery aneurysms"', modify
label define singleDXCCSlabel 116 `"Aortic and peripheral arterial embolism or thrombosis"', modify
label define singleDXCCSlabel 117 `"Other circulatory disease"', modify
label define singleDXCCSlabel 118 `"Phlebitis; thrombophlebitis and thromboembolism"', modify
label define singleDXCCSlabel 119 `"Varicose veins of lower extremity"', modify
label define singleDXCCSlabel 120 `"Hemorrhoids"', modify
label define singleDXCCSlabel 121 `"ther diseases of veins and lymphatics"', modify
label define singleDXCCSlabel 122 `"Pneumonia (except that caused by tuberculosis or sexually transmitted disease)"', modify
label define singleDXCCSlabel 123 `"Influenza"', modify
label define singleDXCCSlabel 124 `"Acute and chronic tonsillitis"', modify
label define singleDXCCSlabel 125 `"Acute bronchitis"', modify
label define singleDXCCSlabel 126 `"Other upper respiratory infections"', modify
label define singleDXCCSlabel 127 `"Chronic obstructive pulmonary disease and bronchiectasis"', modify
label define singleDXCCSlabel 128 `"Asthma"', modify
label define singleDXCCSlabel 129 `"Aspiration pneumonitis; food/vomitus"', modify
label define singleDXCCSlabel 130 `"Pleurisy; pneumothorax; pulmonary collapse"', modify
label define singleDXCCSlabel 131 `"Respiratory failure; insufficiency; arrest (adult)"', modify
label define singleDXCCSlabel 132 `"Lung disease due to external agents"', modify
label define singleDXCCSlabel 133 `"Other lower respiratory disease"', modify
label define singleDXCCSlabel 134 `"Other upper respiratory disease"', modify
label define singleDXCCSlabel 135 `"Intestinal infection"', modify
label define singleDXCCSlabel 136 `"Disorders of teeth and jaw"', modify
label define singleDXCCSlabel 137 `"Diseases of mouth; excluding dental"', modify
label define singleDXCCSlabel 138 `"Esophageal disorders"', modify
label define singleDXCCSlabel 139 `"Gastroduodenal ulcer (except hemorrhage)"', modify
label define singleDXCCSlabel 140 `"Gastritis and duodenitis"', modify
label define singleDXCCSlabel 141 `"Other disorders of stomach and duodenum"', modify
label define singleDXCCSlabel 142 `"Appendicitis and other appendiceal conditions"', modify
label define singleDXCCSlabel 143 `"Abdominal hernia"', modify
label define singleDXCCSlabel 144 `"Regional enteritis and ulcerative colitis"', modify
label define singleDXCCSlabel 145 `"Intestinal obstruction without hernia"', modify
label define singleDXCCSlabel 146 `"Diverticulosis and diverticulitis"', modify
label define singleDXCCSlabel 147 `"Anal and rectal conditions"', modify
label define singleDXCCSlabel 148 `"Peritonitis and intestinal abscess"', modify
label define singleDXCCSlabel 149 `"Biliary tract disease"', modify
label define singleDXCCSlabel 150 `"Liver disease; alcohol-related"', modify
label define singleDXCCSlabel 151 `"Other liver diseases"', modify
label define singleDXCCSlabel 152 `"Pancreatic disorders (not diabetes)"', modify
label define singleDXCCSlabel 153 `"Gastrointestinal hemorrhage"', modify
label define singleDXCCSlabel 154 `"Noninfectious gastroenteritis"', modify
label define singleDXCCSlabel 155 `"Other gastrointestinal disorders"', modify
label define singleDXCCSlabel 156 `"Nephritis; nephrosis; renal sclerosis"', modify
label define singleDXCCSlabel 157 `"Acute and unspecified renal failure"', modify
label define singleDXCCSlabel 158 `"Chronic renal failure"', modify
label define singleDXCCSlabel 159 `"Urinary tract infections"', modify
label define singleDXCCSlabel 160 `"Calculus of urinary tract"', modify
label define singleDXCCSlabel 161 `"Other diseases of kidney and ureters"', modify
label define singleDXCCSlabel 162 `"Other diseases of bladder and urethra"', modify
label define singleDXCCSlabel 163 `"Genitourinary symptoms and ill-defined conditions"', modify
label define singleDXCCSlabel 164 `"Hyperplasia of prostate"', modify
label define singleDXCCSlabel 165 `"Inflammatory conditions of male genital organs"', modify
label define singleDXCCSlabel 166 `"Other male genital disorders"', modify
label define singleDXCCSlabel 167 `"Nonmalignant breast conditions"', modify
label define singleDXCCSlabel 168 `"Inflammatory diseases of female pelvic organs"', modify
label define singleDXCCSlabel 169 `"Endometriosis"', modify
label define singleDXCCSlabel 170 `"Prolapse of female genital organs"', modify
label define singleDXCCSlabel 171 `"Menstrual disorders"', modify
label define singleDXCCSlabel 172 `"Ovarian cyst"', modify
label define singleDXCCSlabel 173 `"Menopausal disorders"', modify
label define singleDXCCSlabel 174 `"Female infertility"', modify
label define singleDXCCSlabel 175 `"Other female genital disorders"', modify
label define singleDXCCSlabel 176 `"Contraceptive and procreative management"', modify
label define singleDXCCSlabel 177 `"Spontaneous abortion"', modify
label define singleDXCCSlabel 178 `"Induced abortion"', modify
label define singleDXCCSlabel 179 `"Postabortion complications"', modify
label define singleDXCCSlabel 180 `"Ectopic pregnancy"', modify
label define singleDXCCSlabel 181 `"Other complications of pregnancy"', modify
label define singleDXCCSlabel 182 `"Hemorrhage during pregnancy; abruptio placenta; placenta previa"', modify
label define singleDXCCSlabel 183 `"Hypertension complicating pregnancy; childbirth and the puerperium"', modify
label define singleDXCCSlabel 184 `"Early or threatened labor"', modify
label define singleDXCCSlabel 185 `"Prolonged pregnancy"', modify
label define singleDXCCSlabel 186 `"Diabetes or abnormal glucose tolerance complicating pregnancy; childbirth; or the puerperium"', modify
label define singleDXCCSlabel 187 `"Malposition; malpresentation"', modify
label define singleDXCCSlabel 188 `"Fetopelvic disproportion; obstruction"', modify
label define singleDXCCSlabel 189 `"Previous C-section"', modify
label define singleDXCCSlabel 190 `"Fetal distress and abnormal forces of labor"', modify
label define singleDXCCSlabel 191 `"Polyhydramnios and other problems of amniotic cavity"', modify
label define singleDXCCSlabel 192 `"Umbilical cord complication"', modify
label define singleDXCCSlabel 193 `"OB-related trauma to perineum and vulva"', modify
label define singleDXCCSlabel 194 `"Forceps delivery"', modify
label define singleDXCCSlabel 195 `"Other complications of birth; puerperium affecting management of mother"', modify
label define singleDXCCSlabel 196 `"Normal pregnancy and/or delivery"', modify
label define singleDXCCSlabel 197 `"Skin and subcutaneous tissue infections"', modify
label define singleDXCCSlabel 198 `"Other inflammatory condition of skin"', modify
label define singleDXCCSlabel 199 `"Chronic ulcer of skin"', modify
label define singleDXCCSlabel 200 `"Other skin disorders"', modify
label define singleDXCCSlabel 201 `"Infective arthritis and osteomyelitis (except that caused by tuberculosis or sexually transmitted disease)"', modify
label define singleDXCCSlabel 202 `"Rheumatoid arthritis and related disease"', modify
label define singleDXCCSlabel 203 `"Osteoarthritis"', modify
label define singleDXCCSlabel 204 `"Other non-traumatic joint disorders"', modify
label define singleDXCCSlabel 205 `"Spondylosis; intervertebral disc disorders; other back problems"', modify
label define singleDXCCSlabel 206 `"Osteoporosis"', modify
label define singleDXCCSlabel 207 `"Pathological fracture"', modify
label define singleDXCCSlabel 208 `"Acquired foot deformities"', modify
label define singleDXCCSlabel 209 `"Other acquired deformities"', modify
label define singleDXCCSlabel 210 `"Systemic lupus erythematosus and connective tissue disorders"', modify
label define singleDXCCSlabel 211 `"Other connective tissue disease"', modify
label define singleDXCCSlabel 212 `"Other bone disease and musculoskeletal deformities"', modify
label define singleDXCCSlabel 213 `"Cardiac and circulatory congenital anomalies"', modify
label define singleDXCCSlabel 214 `"Digestive congenital anomalies"', modify
label define singleDXCCSlabel 215 `"Genitourinary congenital anomalies"', modify
label define singleDXCCSlabel 216 `"Nervous system congenital anomalies"', modify
label define singleDXCCSlabel 217 `"Other congenital anomalies"', modify
label define singleDXCCSlabel 218 `"Liveborn"', modify
label define singleDXCCSlabel 219 `"Short gestation; low birth weight; and fetal growth retardation"', modify
label define singleDXCCSlabel 220 `"Intrauterine hypoxia and birth asphyxia"', modify
label define singleDXCCSlabel 221 `"Respiratory distress syndrome"', modify
label define singleDXCCSlabel 222 `"Hemolytic jaundice and perinatal jaundice"', modify
label define singleDXCCSlabel 223 `"Birth trauma"', modify
label define singleDXCCSlabel 224 `"Other perinatal conditions"', modify
label define singleDXCCSlabel 225 `"Joint disorders and dislocations; trauma-related"', modify
label define singleDXCCSlabel 226 `"Fracture of neck of femur (hip)"', modify
label define singleDXCCSlabel 227 `"Spinal cord injury"', modify
label define singleDXCCSlabel 228 `"Skull and face fractures"', modify
label define singleDXCCSlabel 229 `"Fracture of upper limb"', modify
label define singleDXCCSlabel 230 `"Fracture of lower limb"', modify
label define singleDXCCSlabel 231 `"Other fractures"', modify
label define singleDXCCSlabel 232 `"Sprains and strains"', modify
label define singleDXCCSlabel 233 `"Intracranial injury"', modify
label define singleDXCCSlabel 234 `"Crushing injury or internal injury"', modify
label define singleDXCCSlabel 235 `"Open wounds of head; neck; and trunk"', modify
label define singleDXCCSlabel 236 `"Open wounds of extremities"', modify
label define singleDXCCSlabel 237 `"Complication of device; implant or graft"', modify
label define singleDXCCSlabel 238 `"Complications of surgical procedures or medical care"', modify
label define singleDXCCSlabel 239 `"Superficial injury; contusion"', modify
label define singleDXCCSlabel 240 `"Burns"', modify
label define singleDXCCSlabel 241 `"Poisoning by psychotropic agents"', modify
label define singleDXCCSlabel 242 `"Poisoning by other medications and drugs"', modify
label define singleDXCCSlabel 243 `"Poisoning by nonmedicinal substances"', modify
label define singleDXCCSlabel 244 `"Other injuries and conditions due to external causes"', modify
label define singleDXCCSlabel 245 `"Syncope"', modify
label define singleDXCCSlabel 246 `"Fever of unknown origin"', modify
label define singleDXCCSlabel 247 `"Lymphadenitis"', modify
label define singleDXCCSlabel 248 `"Gangrene"', modify
label define singleDXCCSlabel 249 `"Shock"', modify
label define singleDXCCSlabel 250 `"Nausea and vomiting"', modify
label define singleDXCCSlabel 251 `"Abdominal pain"', modify
label define singleDXCCSlabel 252 `"Malaise and fatigue"', modify
label define singleDXCCSlabel 253 `"Allergic reactions"', modify
label define singleDXCCSlabel 254 `"Rehabilitation care; fitting of prostheses; and adjustment of devices"', modify
label define singleDXCCSlabel 255 `"Administrative/social admission"', modify
label define singleDXCCSlabel 256 `"Medical examination/evaluation"', modify
label define singleDXCCSlabel 257 `"Other aftercare"', modify
label define singleDXCCSlabel 258 `"Other screening for suspected conditions (not mental disorders or infectious disease)"', modify
label define singleDXCCSlabel 259 `"Residual codes; unclassified"', modify
label define singleDXCCSlabel 260 `"E Codes: All (external causes of injury and poisoning)"', modify
label define singleDXCCSlabel 2601 `"E Codes: Cut/pierceb"', modify
label define singleDXCCSlabel 2602 `"E Codes: Drowning/submersion"', modify
label define singleDXCCSlabel 2603 `"E Codes: Fall"', modify
label define singleDXCCSlabel 2604 `"E Codes: Fire/burn"', modify
label define singleDXCCSlabel 2605 `"E Codes: Firearm"', modify
label define singleDXCCSlabel 2606 `"E Codes: Machinery"', modify
label define singleDXCCSlabel 2607 `"E Codes: Motor vehicle traffic (MVT)"', modify
label define singleDXCCSlabel 2608 `"E Codes: Pedal cyclist; not MVT"', modify
label define singleDXCCSlabel 2609 `"E Codes: Pedestrian; not MVT"', modify
label define singleDXCCSlabel 2610 `"E Codes: Transport; not MVT"', modify
label define singleDXCCSlabel 2611 `"E Codes: Natural/environment"', modify
label define singleDXCCSlabel 2612 `"E Codes: Overexertion"', modify
label define singleDXCCSlabel 2613 `"E Codes: Poisoning"', modify
label define singleDXCCSlabel 2614 `"E Codes: Struck by; against"', modify
label define singleDXCCSlabel 2615 `"E Codes: Suffocation"', modify
label define singleDXCCSlabel 2616 `"E Codes: Adverse effects of medical care"', modify
label define singleDXCCSlabel 2617 `"E Codes: Adverse effects of medical drugs"', modify
label define singleDXCCSlabel 2618 `"E Codes: Other specified and classifiable"', modify
label define singleDXCCSlabel 2619 `"E Codes: Other specified; NEC"', modify
label define singleDXCCSlabel 2620 `"E Codes: Unspecified"', modify
label define singleDXCCSlabel 2621 `"E Codes: Place of occurrence"', modify
