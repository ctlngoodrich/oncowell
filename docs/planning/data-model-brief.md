# Data Model Planning Brief — OncoWell

## Overview

OncoWell is a personal, on-device care navigation tool. Data stays local — there is no backend, no account system, and no cloud sync. The app reads from HealthKit and stores user-entered data on-device.

## Core Entities

### 1. Patient Profile

- **Purpose**: Store basic context about the user and their diagnosis
- **Created by**: User during onboarding (can be updated later)
- **Attributes**:
  - Name (optional, for display only)
  - Age / date of birth
  - Cancer type (e.g., prostate, lung, breast — enum or structured selection)
  - Cancer stage (if known — simplified options)
  - Diagnosis date (approximate)
  - Current treatment status (newly diagnosed, in treatment, post-treatment)
- **FHIR mapping**: Maps to `Patient` and `Condition` resources
- **Lifecycle**: Single record, updated in place

### 2. HealthKit Observations

- **Purpose**: Surface relevant vitals and activity data from HealthKit
- **Created by**: System (read from HealthKit)
- **Data types**:
  - Heart rate (HKQuantityTypeIdentifier.heartRate)
  - Resting heart rate (HKQuantityTypeIdentifier.restingHeartRate)
  - Blood pressure (HKCorrelationType.bloodPressure)
  - Weight (HKQuantityTypeIdentifier.bodyMass)
  - BMI (HKQuantityTypeIdentifier.bodyMassIndex)
  - Steps (HKQuantityTypeIdentifier.stepCount)
  - Exercise minutes (HKQuantityTypeIdentifier.appleExerciseTime)
  - Active energy burned (HKQuantityTypeIdentifier.activeEnergyBurned)
  - Sleep analysis (HKCategoryTypeIdentifier.sleepAnalysis)
- **Attributes per observation**:
  - Type
  - Value
  - Unit
  - Timestamp
  - Source (device name)
- **FHIR mapping**: Each maps to a FHIR `Observation` resource. Use LOINC codes where applicable (e.g., heart rate = LOINC 8867-4, body weight = LOINC 29463-7, blood pressure systolic = LOINC 8480-6, diastolic = LOINC 8462-4)
- **Lifecycle**: Read-only from HealthKit. App does not modify HealthKit data.
- **Storage**: Queried on demand from HealthKit, not duplicated on-device. Cache recent values for display performance.

### 3. Symptom Log Entry

- **Purpose**: Track daily symptoms and how the user is feeling
- **Created by**: User (manual entry)
- **Attributes**:
  - Date and time
  - Symptom type (pain, fatigue, nausea, appetite changes, sleep difficulty, mood, other)
  - Severity (1–5 scale or mild/moderate/severe)
  - Free-text notes (optional)
  - Body location (optional, for pain)
- **FHIR mapping**: Maps to `Observation` with category `survey`. Symptom types can use SNOMED CT codes (e.g., pain = 22253000, fatigue = 84229001, nausea = 422587007)
- **Lifecycle**: Created, immutable after creation. User can delete but not edit (preserves log integrity).

### 4. Doctor Visit Note

- **Purpose**: Capture information from medical appointments
- **Created by**: User (manual entry, typically after an appointment)
- **Attributes**:
  - Date of visit
  - Provider name (free text)
  - Facility name (free text)
  - Visit type (consultation, follow-up, second opinion, imaging, lab work)
  - Summary notes (free text)
  - Key decisions or next steps (free text)
  - Attachments: none (keep it simple — text only)
- **FHIR mapping**: Maps loosely to `Encounter` resource
- **Lifecycle**: Created, can be edited by the user

### 5. Test Result / Lab Value

- **Purpose**: Store manually entered test results and lab values
- **Created by**: User (manual entry)
- **Attributes**:
  - Date of test
  - Test name (structured selection where possible + free text fallback)
  - Common test types: PSA, CBC, metabolic panel, imaging result (CT, MRI, PET), biopsy/pathology, Gleason score
  - Value (numeric or free text depending on type)
  - Unit (auto-suggested based on test type)
  - Reference range (optional, user can enter what their report shows)
  - Notes (free text)
- **FHIR mapping**: Maps to `Observation` with `laboratory` category. Use LOINC codes for common tests (e.g., PSA = LOINC 2857-1)
- **Lifecycle**: Created, can be edited by the user. Version history not required.

### 6. Appointment

- **Purpose**: Track upcoming and past medical appointments, with optional audio recording and transcription
- **Created by**: User (manual entry)
- **Attributes**:
  - Date and time
  - Provider name
  - Facility name
  - Appointment type (consultation, treatment, follow-up, imaging, lab work, second opinion)
  - Prepared questions (link to Question List)
  - Notes (free text, for post-appointment reflection)
  - Status (upcoming, completed, cancelled)
  - Audio recording (optional, stored on-device)
  - Transcription (generated from audio via on-device speech recognition)
  - Smart summary (plain-language summary of key points from the transcription, generated via an intelligence layer)
  - Highlighted topics (auto-extracted from transcription: decisions made, next steps, medications mentioned, follow-up instructions)
- **FHIR mapping**: Maps to `Appointment` resource. Transcription and summary are app-internal.
- **Lifecycle**: upcoming → in-progress (recording) → completed or cancelled

### 6a. Appointment Transcript

- **Purpose**: Store and enrich the transcription of a recorded appointment
- **Created by**: System (from audio recording via speech recognition + intelligence layer)
- **Attributes**:
  - Associated appointment ID
  - Raw transcript text (timestamped segments)
  - Plain-language summary (key takeaways in simple terms)
  - Extracted topics:
    - Decisions made
    - Next steps / action items
    - Medications discussed
    - Follow-up instructions
    - Questions answered (mapped back to Question List if available)
  - Medical terms used (linked to Glossary for inline definitions)
  - Confidence flag (disclaimer that transcription may contain errors)
- **FHIR mapping**: App-internal. No direct FHIR mapping needed.
- **Lifecycle**: Generated after recording stops. User can review, annotate, or delete. Immutable transcript with editable annotations.

### 7. Question List

- **Purpose**: Prepare questions for doctor appointments
- **Created by**: User + system-suggested questions based on content they have viewed
- **Attributes**:
  - Title (e.g., "Questions for Dr. Smith — April 10")
  - Associated appointment (optional link)
  - Questions: ordered list of items, each with:
    - Question text
    - Category (treatment details, side effects, recovery, second opinions, provider evaluation)
    - Source (user-written or suggested from content)
    - Answer notes (free text, for recording the doctor's response)
    - Checked/unchecked (to track which were asked)
- **FHIR mapping**: App-internal. No direct FHIR equivalent needed.
- **Lifecycle**: Created as draft, used during appointment, can be archived after

### 8. Treatment Content (Static)

- **Purpose**: Educational content about treatment options, bundled with the app
- **Created by**: App developer (you), sourced from NCCN, AMA, ACS
- **Attributes**:
  - Content ID
  - Title
  - Body text (plain language)
  - Source citation (organization, guideline name, year)
  - Source URL (for reference)
  - Category (treatment overview, side effects, recovery, provider selection, terminology)
  - Treatment type (surgery, radiation, general)
  - Related terms (links to Glossary entries)
  - Content version / last reviewed date
- **FHIR mapping**: App-internal. Not a clinical data type.
- **Lifecycle**: Static, bundled at build time. Updated with app releases.

### 9. Glossary Term

- **Purpose**: Plain-language definitions of medical terminology
- **Created by**: App developer, sourced from NCCN/AMA/ACS
- **Attributes**:
  - Term
  - Plain-language definition
  - Source citation
  - Related content (links to Treatment Content)
- **FHIR mapping**: App-internal.
- **Lifecycle**: Static, bundled at build time.

## Entity Relationships

```
Patient Profile
  ├── has many → HealthKit Observations (read from HealthKit)
  ├── has many → Symptom Log Entries
  ├── has many → Doctor Visit Notes
  ├── has many → Test Results / Lab Values
  ├── has many → Appointments
  │                 ├── has one (optional) → Question List
  │                 └── has one (optional) → Appointment Transcript
  └── views → Treatment Content
                └── references → Glossary Terms
```

- All user-entered entities belong to the single Patient Profile
- An Appointment can optionally link to a Question List
- Treatment Content references Glossary Terms for inline definitions
- HealthKit Observations are queried, not stored as app entities

## FHIR and Terminology Recommendations

### FHIR Resource Mapping Summary

| Entity | FHIR Resource | Notes |
|--------|--------------|-------|
| Patient Profile | Patient + Condition | Patient demographics + cancer diagnosis |
| HealthKit Observations | Observation (vital-signs) | Standard vital sign profiles |
| Symptom Log | Observation (survey) | SNOMED CT for symptom types |
| Doctor Visit Note | Encounter | Loose mapping, primarily free text |
| Test Result / Lab | Observation (laboratory) | LOINC for common lab tests |
| Appointment | Appointment | Standard scheduling resource |
| Question List | — | App-internal, no FHIR mapping needed |
| Treatment Content | — | App-internal, static educational content |
| Glossary Term | — | App-internal, static reference |

### Terminology

- **LOINC**: For lab tests and vital signs (PSA, CBC, heart rate, blood pressure, weight)
- **SNOMED CT**: For symptom types and cancer diagnosis coding
- **ICD-10**: For cancer diagnosis codes if structured coding is desired

### Library Recommendations (Swift / Spezi)

- **[apple/FHIRModels](https://github.com/apple/FHIRModels)**: Use for FHIR resource types if data export or sharing is implemented later
- **[StanfordSpezi/SpeziFHIR](https://github.com/StanfordSpezi/SpeziFHIR)**: Use if integrating FHIR into the Spezi module architecture
- **HealthKit framework**: Native Apple framework for reading health data

For this personal app, FHIR modeling is recommended as a design pattern (use FHIR-aligned attributes and terminology codes) but full FHIR serialization is optional. If sharing/export is added later, the data structure will already be FHIR-ready.

## Storage

All data is on-device only:

- **HealthKit data**: Queried from HealthKit on demand, not duplicated
- **User-entered data**: Stored locally using SwiftData or a lightweight persistence layer
- **Static content**: Bundled as JSON or Swift data structures at build time

No cloud sync, no backend, no network requests for data storage.

## Governance and Data Quality

- **Provenance**: HealthKit data carries source device metadata. User-entered data is implicitly from the user.
- **Validation**: Numeric lab values should validate against reasonable ranges (e.g., PSA > 0). Dates should not be in the future for past events.
- **Units**: Use standard units and auto-suggest based on test type (e.g., ng/mL for PSA, mmHg for blood pressure)
- **Privacy**: All data stays on-device. No analytics, no telemetry. HealthKit access requires explicit user permission.
- **Deletion**: User can delete any entry they created. Clearing all data should be available in settings.
- **No PHI leaves the device**: Caregiver sharing generates a summary — the user controls what is included.

## Appointment Recording and Intelligence Layer

- **Audio capture**: Use AVFoundation for on-device audio recording. Microphone permission required.
- **Speech recognition**: Use Apple Speech framework for on-device transcription (no audio leaves the device).
- **Intelligence layer**: Use on-device models (Apple Intelligence / Core ML) to generate plain-language summaries, extract key topics, and link medical terms to the glossary.
- **Privacy**: Audio and transcripts stay on-device. The user controls recording start/stop and can delete recordings at any time.
- **Consent note**: The app should remind the user to inform their doctor that they are recording the appointment, as recording laws vary by state.
- **Disclaimer**: Transcriptions are approximate — the app should display a clear note that the transcript may contain errors and should not be treated as an official medical record.

## Unresolved Questions

1. **Cancer type scope**: Should the app support multiple cancer types at launch, or focus on one (e.g., prostate cancer) and expand later?
2. **Lab result structure**: Some results are numeric (PSA = 4.2 ng/mL), others are narrative (pathology report). How much structure is needed for narrative results?
3. **HealthKit data retention for display**: How far back should the app query HealthKit data? Last 30 days? 90 days? Since diagnosis date?
4. **Question suggestion logic**: How should the app decide which questions to suggest? Based on content viewed, diagnosis type, or appointment type?
5. **Export format**: If the user wants to share data with a new doctor, should the app support a structured export (FHIR JSON, PDF) in the future?
6. **Recording intelligence**: Should the smart summary and topic extraction use Apple's on-device intelligence only, or is a call to an external LLM (e.g., Claude API) acceptable for higher-quality summaries? On-device keeps everything private; an API call would produce better results but sends audio/transcript off-device.
7. **Recording consent UX**: How prominently should the app remind users about recording consent laws? A one-time notice, or every time they start recording?
