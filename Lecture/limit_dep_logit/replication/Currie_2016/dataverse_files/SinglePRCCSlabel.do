/************************************************************************************
Program Name: SinglePRCCSlabel.do 
Description : Define Single-Level Procedure CCS value labels from Stata. 
Developed   : By Bob Houchens
Updated     : By David Ross on 10/28/2009.
************************************************************************************/

label define singlePRCCSlabel 0 `"No procedure code"', modify
label define singlePRCCSlabel 1 `"Incision and excision of CNS"', modify
label define singlePRCCSlabel 2 `"Insertion; replacement; or removal of extracranial ventricular shunt"', modify
label define singlePRCCSlabel 3 `"Laminectomy; excision intervertebral disc"', modify
label define singlePRCCSlabel 4 `"Diagnostic spinal tap"', modify
label define singlePRCCSlabel 5 `"Insertion of catheter or spinal stimulator and injection into spinal canal"', modify
label define singlePRCCSlabel 6 `"Decompression peripheral nerve"', modify
label define singlePRCCSlabel 7 `"Other diagnostic nervous system procedures"', modify
label define singlePRCCSlabel 8 `"Other non-OR or closed therapeutic nervous system procedures"', modify
label define singlePRCCSlabel 9 `"Other OR therapeutic nervous system procedures"', modify
label define singlePRCCSlabel 10 `"Thyroidectomy; partial or complete"', modify
label define singlePRCCSlabel 11 `"Diagnostic endocrine procedures"', modify
label define singlePRCCSlabel 12 `"Other therapeutic endocrine procedures"', modify
label define singlePRCCSlabel 13 `"Corneal transplant"', modify
label define singlePRCCSlabel 14 `"Glaucoma procedures"', modify
label define singlePRCCSlabel 15 `"Lens and cataract procedures"', modify
label define singlePRCCSlabel 16 `"Repair of retinal tear; detachment"', modify
label define singlePRCCSlabel 17 `"Destruction of lesion of retina and choroid"', modify
label define singlePRCCSlabel 18 `"Diagnostic procedures on eye"', modify
label define singlePRCCSlabel 19 `"Other therapeutic procedures on eyelids; conjunctiva; cornea"', modify
label define singlePRCCSlabel 20 `"Other intraocular therapeutic procedures"', modify
label define singlePRCCSlabel 21 `"Other extraocular muscle and orbit therapeutic procedures"', modify
label define singlePRCCSlabel 22 `"Tympanoplasty"', modify
label define singlePRCCSlabel 23 `"Myringotomy"', modify
label define singlePRCCSlabel 24 `"Mastoidectomy"', modify
label define singlePRCCSlabel 25 `"Diagnostic procedures on ear"', modify
label define singlePRCCSlabel 26 `"Other therapeutic ear procedures"', modify
label define singlePRCCSlabel 27 `"Control of epistaxis"', modify
label define singlePRCCSlabel 28 `"Plastic procedures on nose"', modify
label define singlePRCCSlabel 29 `"Dental procedures"', modify
label define singlePRCCSlabel 30 `"Tonsillectomy and/or adenoidectomy"', modify
label define singlePRCCSlabel 31 `"Diagnostic procedures on nose; mouth and pharynx"', modify
label define singlePRCCSlabel 32 `"Other non-OR therapeutic procedures on nose; mouth and pharynx"', modify
label define singlePRCCSlabel 33 `"Other OR therapeutic procedures on nose; mouth and pharynx"', modify
label define singlePRCCSlabel 34 `"Tracheostomy; temporary and permanent"', modify
label define singlePRCCSlabel 35 `"Tracheoscopy and laryngoscopy with biopsy"', modify
label define singlePRCCSlabel 36 `"Lobectomy or pneumonectomy"', modify
label define singlePRCCSlabel 37 `"Diagnostic bronchoscopy and biopsy of bronchus"', modify
label define singlePRCCSlabel 38 `"Other diagnostic procedures on lung and bronchus"', modify
label define singlePRCCSlabel 39 `"Incision of pleura; thoracentesis; chest drainage"', modify
label define singlePRCCSlabel 40 `"Other diagnostic procedures of respiratory tract and mediastinum"', modify
label define singlePRCCSlabel 41 `"Other non-OR therapeutic procedures on respiratory system"', modify
label define singlePRCCSlabel 42 `"Other OR Rx procedures on respiratory system and mediastinum"', modify
label define singlePRCCSlabel 43 `"Heart valve procedures"', modify
label define singlePRCCSlabel 44 `"Coronary artery bypass graft (CABG)"', modify
label define singlePRCCSlabel 45 `"Percutaneous transluminal coronary angioplasty (PTCA)"', modify
label define singlePRCCSlabel 46 `"Coronary thrombolysis"', modify
label define singlePRCCSlabel 47 `"Diagnostic cardiac catheterization; coronary arteriography"', modify
label define singlePRCCSlabel 48 `"Insertion; revision; replacement; removal of cardiac pacemaker or cardioverter/defibrillator"', modify
label define singlePRCCSlabel 49 `"Other OR heart procedures"', modify
label define singlePRCCSlabel 50 `"Extracorporeal circulation auxiliary to open heart procedures"', modify
label define singlePRCCSlabel 51 `"Endarterectomy; vessel of head and neck"', modify
label define singlePRCCSlabel 52 `"Aortic resection; replacement or anastomosis"', modify
label define singlePRCCSlabel 53 `"Varicose vein stripping; lower limb"', modify
label define singlePRCCSlabel 54 `"Other vascular catheterization; not heart"', modify
label define singlePRCCSlabel 55 `"Peripheral vascular bypass"', modify
label define singlePRCCSlabel 56 `"Other vascular bypass and shunt; not heart"', modify
label define singlePRCCSlabel 57 `"Creation; revision and removal of arteriovenous fistula or vessel-to-vessel cannula for di a"', modify
label define singlePRCCSlabel 58 `"Hemodialysis"', modify
label define singlePRCCSlabel 59 `"Other OR procedures on vessels of head and neck"', modify
label define singlePRCCSlabel 60 `"Embolectomy and endarterectomy of lower limbs"', modify
label define singlePRCCSlabel 61 `"Other OR procedures on vessels other than head and neck"', modify
label define singlePRCCSlabel 62 `"Other diagnostic cardiovascular procedures"', modify
label define singlePRCCSlabel 63 `"Other non-OR therapeutic cardiovascular procedures"', modify
label define singlePRCCSlabel 64 `"Bone marrow transplant"', modify
label define singlePRCCSlabel 65 `"Bone marrow biopsy"', modify
label define singlePRCCSlabel 66 `"Procedures on spleen"', modify
label define singlePRCCSlabel 67 `"Other therapeutic procedures; hemic and lymphatic system"', modify
label define singlePRCCSlabel 68 `"Injection or ligation of esophageal varices"', modify
label define singlePRCCSlabel 69 `"Esophageal dilatation"', modify
label define singlePRCCSlabel 70 `"Upper gastrointestinal endoscopy; biopsy"', modify
label define singlePRCCSlabel 71 `"Gastrostomy; temporary and permanent"', modify
label define singlePRCCSlabel 72 `"Colostomy; temporary and permanent"', modify
label define singlePRCCSlabel 73 `"Ileostomy and other enterostomy"', modify
label define singlePRCCSlabel 74 `"Gastrectomy; partial and total"', modify
label define singlePRCCSlabel 75 `"Small bowel resection"', modify
label define singlePRCCSlabel 76 `"Colonoscopy and biopsy"', modify
label define singlePRCCSlabel 77 `"Proctoscopy and anorectal biopsy"', modify
label define singlePRCCSlabel 78 `"Colorectal resection"', modify
label define singlePRCCSlabel 79 `"Local excision of large intestine lesion (not endoscopic)"', modify
label define singlePRCCSlabel 80 `"Appendectomy"', modify
label define singlePRCCSlabel 81 `"Hemorrhoid procedures"', modify
label define singlePRCCSlabel 82 `"Endoscopic retrograde cannulation of pancreas (ERCP)"', modify
label define singlePRCCSlabel 83 `"Biopsy of liver"', modify
label define singlePRCCSlabel 84 `"Cholecystectomy and common duct exploration"', modify
label define singlePRCCSlabel 85 `"Inguinal and femoral hernia repair"', modify
label define singlePRCCSlabel 86 `"Other hernia repair"', modify
label define singlePRCCSlabel 87 `"Laparoscopy (GI only)"', modify
label define singlePRCCSlabel 88 `"Abdominal paracentesis"', modify
label define singlePRCCSlabel 89 `"Exploratory laparotomy"', modify
label define singlePRCCSlabel 90 `"Excision; lysis peritoneal adhesions"', modify
label define singlePRCCSlabel 91 `"Peritoneal dialysis"', modify
label define singlePRCCSlabel 92 `"Other bowel diagnostic procedures"', modify
label define singlePRCCSlabel 93 `"Other non-OR upper GI therapeutic procedures"', modify
label define singlePRCCSlabel 94 `"Other OR upper GI therapeutic procedures"', modify
label define singlePRCCSlabel 95 `"Other non-OR lower GI therapeutic procedures"', modify
label define singlePRCCSlabel 96 `"Other OR lower GI therapeutic procedures"', modify
label define singlePRCCSlabel 97 `"Other gastrointestinal diagnostic procedures"', modify
label define singlePRCCSlabel 98 `"Other non-OR gastrointestinal therapeutic procedures"', modify
label define singlePRCCSlabel 99 `"Other OR gastrointestinal therapeutic procedures"', modify
label define singlePRCCSlabel 100 `"Endoscopy and endoscopic biopsy of the urinary tract"', modify
label define singlePRCCSlabel 101 `"Transurethral excision; drainage; or removal urinary obstruction"', modify
label define singlePRCCSlabel 102 `"Ureteral catheterization"', modify
label define singlePRCCSlabel 103 `"Nephrotomy and nephrostomy"', modify
label define singlePRCCSlabel 104 `"Nephrectomy; partial or complete"', modify
label define singlePRCCSlabel 105 `"Kidney transplant"', modify
label define singlePRCCSlabel 106 `"Genitourinary incontinence procedures"', modify
label define singlePRCCSlabel 107 `"Extracorporeal lithotripsy; urinary"', modify
label define singlePRCCSlabel 108 `"Indwelling catheter"', modify
label define singlePRCCSlabel 109 `"Procedures on the urethra"', modify
label define singlePRCCSlabel 110 `"Other diagnostic procedures of urinary tract"', modify
label define singlePRCCSlabel 111 `"Other non-OR therapeutic procedures of urinary tract"', modify
label define singlePRCCSlabel 112 `"Other OR therapeutic procedures of urinary tract"', modify
label define singlePRCCSlabel 113 `"Transurethral resection of prostate (TURP)"', modify
label define singlePRCCSlabel 114 `"Open prostatectomy"', modify
label define singlePRCCSlabel 115 `"Circumcision"', modify
label define singlePRCCSlabel 116 `"Diagnostic procedures; male genital"', modify
label define singlePRCCSlabel 117 `"Other non-OR therapeutic procedures; male genital"', modify
label define singlePRCCSlabel 118 `"Other OR therapeutic procedures; male genital"', modify
label define singlePRCCSlabel 119 `"Oophorectomy; unilateral and bilateral"', modify
label define singlePRCCSlabel 120 `"Other operations on ovary"', modify
label define singlePRCCSlabel 121 `"Ligation or occlusion of fallopian tubes"', modify
label define singlePRCCSlabel 122 `"Removal of ectopic pregnancy"', modify
label define singlePRCCSlabel 123 `"Other operations on fallopian tubes"', modify
label define singlePRCCSlabel 124 `"Hysterectomy; abdominal and vaginal"', modify
label define singlePRCCSlabel 125 `"Other excision of cervix and uterus"', modify
label define singlePRCCSlabel 126 `"Abortion (termination of pregnancy)"', modify
label define singlePRCCSlabel 127 `"Dilatation and curettage (D&C); aspiration after delivery or abortion"', modify
label define singlePRCCSlabel 128 `"Diagnostic dilatation and curettage (D&C)"', modify
label define singlePRCCSlabel 129 `"Repair of cystocele and rectocele; obliteration of vaginal vault"', modify
label define singlePRCCSlabel 130 `"Other diagnostic procedures; female organs"', modify
label define singlePRCCSlabel 131 `"Other non-OR therapeutic procedures; female organs"', modify
label define singlePRCCSlabel 132 `"Other OR therapeutic procedures; female organs"', modify
label define singlePRCCSlabel 133 `"Episiotomy"', modify
label define singlePRCCSlabel 134 `"Cesarean section"', modify
label define singlePRCCSlabel 135 `"Forceps; vacuum; and breech delivery"', modify
label define singlePRCCSlabel 136 `"Artificial rupture of membranes to assist delivery"', modify
label define singlePRCCSlabel 137 `"Other procedures to assist delivery"', modify
label define singlePRCCSlabel 138 `"Diagnostic amniocentesis"', modify
label define singlePRCCSlabel 139 `"Fetal monitoring"', modify
label define singlePRCCSlabel 140 `"Repair of current obstetric laceration"', modify
label define singlePRCCSlabel 141 `"Other therapeutic obstetrical procedures"', modify
label define singlePRCCSlabel 142 `"Partial excision bone"', modify
label define singlePRCCSlabel 143 `"Bunionectomy or repair of toe deformities"', modify
label define singlePRCCSlabel 144 `"Treatment; facial fracture or dislocation"', modify
label define singlePRCCSlabel 145 `"Treatment; fracture or dislocation of radius and ulna"', modify
label define singlePRCCSlabel 146 `"Treatment; fracture or dislocation of hip and femur"', modify
label define singlePRCCSlabel 147 `"Treatment; fracture or dislocation of lower extremity (other than hip or femur)"', modify
label define singlePRCCSlabel 148 `"Other fracture and dislocation procedure"', modify
label define singlePRCCSlabel 149 `"Arthroscopy"', modify
label define singlePRCCSlabel 150 `"Division of joint capsule; ligament or cartilage"', modify
label define singlePRCCSlabel 151 `"Excision of semilunar cartilage of knee"', modify
label define singlePRCCSlabel 152 `"Arthroplasty knee"', modify
label define singlePRCCSlabel 153 `"Hip replacement; total and partial"', modify
label define singlePRCCSlabel 154 `"Arthroplasty other than hip or knee"', modify
label define singlePRCCSlabel 155 `"Arthrocentesis"', modify
label define singlePRCCSlabel 156 `"Injections and aspirations of muscles; tendons; bursa; joints and soft tissue"', modify
label define singlePRCCSlabel 157 `"Amputation of lower extremity"', modify
label define singlePRCCSlabel 158 `"Spinal fusion"', modify
label define singlePRCCSlabel 159 `"Other diagnostic procedures on musculoskeletal system"', modify
label define singlePRCCSlabel 160 `"Other therapeutic procedures on muscles and tendons"', modify
label define singlePRCCSlabel 161 `"Other OR therapeutic procedures on bone"', modify
label define singlePRCCSlabel 162 `"Other OR therapeutic procedures on joints"', modify
label define singlePRCCSlabel 163 `"Other non-OR therapeutic procedures on musculoskeletal system"', modify
label define singlePRCCSlabel 164 `"Other OR therapeutic procedures on musculoskeletal system"', modify
label define singlePRCCSlabel 165 `"Breast biopsy and other diagnostic procedures on breast"', modify
label define singlePRCCSlabel 166 `"Lumpectomy; quadrantectomy of breast"', modify
label define singlePRCCSlabel 167 `"Mastectomy"', modify
label define singlePRCCSlabel 168 `"Incision and drainage; skin and subcutaneous tissue"', modify
label define singlePRCCSlabel 169 `"Debridement of wound; infection or burn"', modify
label define singlePRCCSlabel 170 `"Excision of skin lesion"', modify
label define singlePRCCSlabel 171 `"Suture of skin and subcutaneous tissue"', modify
label define singlePRCCSlabel 172 `"Skin graft"', modify
label define singlePRCCSlabel 173 `"Other diagnostic procedures on skin and subcutaneous tissue"', modify
label define singlePRCCSlabel 174 `"Other non-OR therapeutic procedures on skin and breast"', modify
label define singlePRCCSlabel 175 `"Other OR therapeutic procedures on skin and breast"', modify
label define singlePRCCSlabel 176 `"Other organ transplantation"', modify
label define singlePRCCSlabel 177 `"Computerized axial tomography (CT) scan head"', modify
label define singlePRCCSlabel 178 `"CT scan chest"', modify
label define singlePRCCSlabel 179 `"CT scan abdomen"', modify
label define singlePRCCSlabel 180 `"Other CT scan"', modify
label define singlePRCCSlabel 181 `"Myelogram"', modify
label define singlePRCCSlabel 182 `"Mammography"', modify
label define singlePRCCSlabel 183 `"Routine chest X-ray"', modify
label define singlePRCCSlabel 184 `"Intraoperative cholangiogram"', modify
label define singlePRCCSlabel 185 `"Upper gastrointestinal X-ray"', modify
label define singlePRCCSlabel 186 `"Lower gastrointestinal X-ray"', modify
label define singlePRCCSlabel 187 `"Intravenous pyelogram"', modify
label define singlePRCCSlabel 188 `"Cerebral arteriogram"', modify
label define singlePRCCSlabel 189 `"Contrast aortogram"', modify
label define singlePRCCSlabel 190 `"Contrast arteriogram of femoral and lower extremity arteries"', modify
label define singlePRCCSlabel 191 `"Arterio- or venogram (not heart and head)"', modify
label define singlePRCCSlabel 192 `"Diagnostic ultrasound of head and neck"', modify
label define singlePRCCSlabel 193 `"Diagnostic ultrasound of heart (echocardiogram)"', modify
label define singlePRCCSlabel 194 `"Diagnostic ultrasound of gastrointestinal tract"', modify
label define singlePRCCSlabel 195 `"Diagnostic ultrasound of urinary tract"', modify
label define singlePRCCSlabel 196 `"Diagnostic ultrasound of abdomen or retroperitoneum"', modify
label define singlePRCCSlabel 197 `"Other diagnostic ultrasound"', modify
label define singlePRCCSlabel 198 `"Magnetic resonance imaging"', modify
label define singlePRCCSlabel 199 `"Electroencephalogram (EEG)"', modify
label define singlePRCCSlabel 200 `"Nonoperative urinary system measurements"', modify
label define singlePRCCSlabel 201 `"Cardiac stress tests"', modify
label define singlePRCCSlabel 202 `"Electrocardiogram"', modify
label define singlePRCCSlabel 203 `"Electrographic cardiac monitoring"', modify
label define singlePRCCSlabel 204 `"Swan-Ganz catheterization for monitoring"', modify
label define singlePRCCSlabel 205 `"Arterial blood gases"', modify
label define singlePRCCSlabel 206 `"Microscopic examination (bacterial smear; culture; toxicology)"', modify
label define singlePRCCSlabel 207 `"Radioisotope bone scan"', modify
label define singlePRCCSlabel 208 `"Radioisotope pulmonary scan"', modify
label define singlePRCCSlabel 209 `"Radioisotope scan and function studies"', modify
label define singlePRCCSlabel 210 `"Other radioisotope scan"', modify
label define singlePRCCSlabel 211 `"Therapeutic radiology for cancer treatment"', modify
label define singlePRCCSlabel 212 `"Diagnostic physical therapy"', modify
label define singlePRCCSlabel 213 `"Physical therapy exercises; manipulation; and other procedures"', modify
label define singlePRCCSlabel 214 `"Traction; splints; and other wound care"', modify
label define singlePRCCSlabel 215 `"Other physical therapy and rehabilitation"', modify
label define singlePRCCSlabel 216 `"Respiratory intubation and mechanical ventilation"', modify
label define singlePRCCSlabel 217 `"Other respiratory therapy"', modify
label define singlePRCCSlabel 218 `"Psychological and psychiatric evaluation and therapy"', modify
label define singlePRCCSlabel 219 `"Alcohol and drug rehabilitation/detoxification"', modify
label define singlePRCCSlabel 220 `"Ophthalmologic and otologic diagnosis and treatment"', modify
label define singlePRCCSlabel 221 `"Nasogastric tube"', modify
label define singlePRCCSlabel 222 `"Blood transfusion"', modify
label define singlePRCCSlabel 223 `"Enteral and parenteral nutrition"', modify
label define singlePRCCSlabel 224 `"Cancer chemotherapy"', modify
label define singlePRCCSlabel 225 `"Conversion of cardiac rhythm"', modify
label define singlePRCCSlabel 226 `"Other diagnostic radiology and related techniques"', modify
label define singlePRCCSlabel 227 `"Other diagnostic procedures (interview; evaluation; consultation)"', modify
label define singlePRCCSlabel 228 `"Prophylactic vaccinations and inoculations"', modify
label define singlePRCCSlabel 229 `"Nonoperative removal of foreign body"', modify
label define singlePRCCSlabel 230 `"Extracorporeal shock wave other than urinary"', modify
label define singlePRCCSlabel 231 `"Other therapeutic procedures"', modify
