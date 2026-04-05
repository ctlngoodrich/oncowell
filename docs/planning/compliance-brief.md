# Compliance Planning Brief — OncoWell

## 1. Scope Summary

- **Product purpose**: Personal care navigation tool helping a patient understand treatment options, track health data, and prepare for doctor appointments
- **User groups**: Single patient (primary), family caregiver (secondary, receives shared summaries)
- **Jurisdictions**: United States (personal use only)
- **Distribution**: Not published on the App Store. Installed via Xcode for personal use.
- **Data categories**: HealthKit vitals/activity, manually entered symptoms/labs/notes, appointment recordings and transcripts, static educational content

## 2. Likely Compliance Domains

| Domain | Assessment | Rationale |
|--------|-----------|-----------|
| HIPAA | **Unlikely** | No covered entity involved. The app is a personal tool — the user is managing their own data on their own device. No business associate relationship exists. |
| IRB / Human Subjects | **Unlikely** | Not a research study. No enrollment, no protocol, no data collection for research purposes. |
| FDA / Software as Medical Device | **Unlikely** | The app does not diagnose, recommend treatment, or drive clinical action. Content is informational and sourced from published guidelines. No clinical claims are made. |
| GDPR | **Unlikely** | No EU/UK users. Single personal user in the US. |
| App Store Review | **Not applicable** | App is not being distributed via the App Store. |

## 3. Key Risks

Even for a personal tool, a few things are worth noting:

### Recording consent laws
- Audio recording of doctor appointments is subject to state wiretapping/eavesdropping laws
- Some states require all-party consent (e.g., California, Florida, Illinois) while others require only one-party consent
- **Mitigation**: The app should display a clear reminder to inform the doctor before recording. This is a user responsibility, but the app should make it easy to remember.

### Transcription accuracy
- On-device speech recognition is imperfect, especially with medical terminology
- A user could make decisions based on an inaccurate transcript
- **Mitigation**: Display a persistent disclaimer on all transcripts: "This transcript is auto-generated and may contain errors. Always confirm important details with your healthcare provider."

### Content currency
- NCCN/AMA/ACS guidelines change over time. Bundled static content will become outdated.
- **Mitigation**: Include the content version date prominently. Add a notice: "This information was current as of [date]. Check with your doctor or visit [source URL] for the latest guidelines."

### Intelligence layer privacy (if using external API)
- If transcript summarization uses an external LLM API, audio or transcript text would leave the device
- This would introduce a third-party data processor handling sensitive health information
- **Mitigation**: Prefer on-device intelligence. If an API is used, the user should be informed and consent explicitly. Consider this decision carefully.

## 4. Required Decisions

1. **On-device vs. API intelligence**: If all processing stays on-device (Apple Speech, Apple Intelligence / Core ML), no data leaves the device and compliance is minimal. If an external API is used for better summary quality, you need to evaluate that provider's data handling practices.

2. **Recording consent UX**: Decide whether to show a recording consent reminder every time, or once with a "don't show again" option. Given the legal variability, showing it every time is safer.

3. **Content disclaimers**: Finalize the exact disclaimer language for educational content and transcripts. Keep it simple and visible, not buried in settings.

## 5. Recommended Controls

Even though formal compliance frameworks do not apply, these are good practices for a health-related personal tool:

### Data stays on-device
- No cloud sync, no analytics, no telemetry
- HealthKit data queried on demand, not duplicated
- User-entered data stored locally only

### User control
- User can delete any data they created (symptoms, notes, labs, recordings, transcripts)
- "Delete all data" option available in settings
- User controls what is included in caregiver-shared summaries

### Transparency
- Every piece of educational content shows its source and date
- Transcripts show accuracy disclaimers
- App clearly states it is not a medical device and does not provide medical advice

### Recording safeguards
- Recording requires explicit user action (tap to start)
- Reminder about informing the doctor before recording
- Recordings stored on-device only
- User can delete recordings at any time

### HealthKit permissions
- Request only the specific data types needed
- Explain why each data type is being requested
- App works without HealthKit if the user declines

## 6. Disclaimers to Include in the App

1. **General**: "OncoWell is an educational and organizational tool. It does not provide medical advice, diagnosis, or treatment recommendations. Always consult your healthcare provider for medical decisions."

2. **Content**: "Information sourced from [NCCN/AMA/ACS] guidelines, current as of [date]. Medical guidelines change — verify with your doctor or visit [source] for updates."

3. **Transcription**: "This transcript was generated automatically and may contain errors. Do not rely on it as an accurate medical record. Confirm important details with your healthcare provider."

4. **Recording**: "Please inform your healthcare provider before recording any appointment. Recording laws vary by state."

## Summary

OncoWell's compliance footprint is minimal because it is a personal, on-device tool that makes no clinical claims. The main areas to be thoughtful about are recording consent, transcription accuracy disclaimers, content freshness, and the on-device vs. API decision for the intelligence layer. No formal compliance reviews (HIPAA, IRB, FDA) are likely needed.

*This brief is product guidance, not legal advice. If the app's scope changes (e.g., App Store distribution, cloud features, research use), compliance should be reassessed.*
