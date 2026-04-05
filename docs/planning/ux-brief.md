# UX Planning Brief — OncoWell

## User Segments

### Primary: Patient (Dad)
- 65 years old, independent, wants to own his healthcare decisions
- Comfortable downloading and using apps, but not a power user
- Does not currently use MyChart or patient portals
- Trusts established medical institutions and credentialed sources
- Key constraint: medical jargon is a barrier; plain language is essential

### Secondary: Family Caregiver (Daughter)
- Helps organize and interpret medical information
- Does not need a separate account — reviews information together or receives shared summaries
- Acts as a bridge between the app and the healthcare system

## Core Journeys

### 1. First Launch and Setup
- Brief welcome explaining what the app does and what it does not do (not a substitute for medical advice)
- Connect HealthKit to pull relevant vitals (heart rate, blood pressure, activity, etc.)
- Enter basic diagnosis context (cancer type, stage if known, current status)
- No account creation required — this is a personal, on-device tool

### 2. Understand Treatment Options
- Browse surgery vs. radiation therapy side by side
- Each option includes: what it involves, recovery timeline, common side effects, success rates, quality-of-life considerations
- All content sourced from NCCN guidelines, AMA, and ACS
- Every piece of information displays its source clearly (e.g., "Source: NCCN Guidelines for Patients, 2025")
- Medical terms are defined inline — tap any term to see a plain-language explanation

### 3. See How It Applies to Me
- View personal health data from HealthKit alongside treatment considerations
- Manually add test results, lab values, or notes from doctor visits
- Highlight which factors are relevant to each treatment option (e.g., "Your activity level may affect recovery from surgery")

### 4. Evaluate Providers
- Guidance on what to look for in a provider: surgeon volume, hospital cancer center designation, multidisciplinary tumor boards
- Explanation of academic medical center vs. community hospital tradeoffs
- Checklist of questions to ask when evaluating a provider
- Sources: ACS facility accreditation info, NCCN member institutions

### 5. Prepare for Appointments
- Build a personalized question list based on what the user has been reading
- Suggest questions organized by topic (treatment details, side effects, recovery, second opinions)
- Export or share the question list (print, share with caregiver)

### 6. Track Health Data
- View HealthKit vitals over time (heart rate, blood pressure, weight, activity)
- Log symptoms, side effects, or how they are feeling (simple daily check-in)
- Add notes from doctor visits or test results
- Timeline view showing health data and key events together

### 7. Share with Caregiver
- Generate a plain-language summary of current status, tracked data, and upcoming questions
- Share via text or email to family caregiver

## Onboarding Strategy

Keep it minimal — three steps maximum:

1. **Welcome screen**: One sentence on what OncoWell does. "Understand your treatment options, track your health, and prepare for your next appointment."
2. **HealthKit permission**: Explain what data will be accessed and why. Allow skipping — the app should still work without it.
3. **Diagnosis context**: Ask cancer type and general stage. Use simple multiple-choice, not free text. Allow skipping and filling in later.

First valuable action should happen within 60 seconds: browsing treatment options or viewing a HealthKit summary.

### What we do NOT ask during onboarding
- No account creation
- No email or phone number
- No lengthy questionnaires
- No permissions that are not immediately useful

## Day-to-Day Workflow

### What prompts the user to return
- Upcoming appointment (reminder to review questions)
- New health data available from HealthKit
- Gentle weekly check-in prompt ("How are you feeling this week?")

### What they see first
- Home screen showing: health snapshot (recent vitals), next appointment reminder if set, and quick access to treatment comparison and question builder

### What they are expected to do
- Nothing is mandatory. The app is a reference tool, not a task manager.
- Optional: log a symptom, review a treatment topic, add a question for their doctor

### When they skip or fall behind
- No streaks, no guilt. If they have not opened the app in a while, welcome them back with a simple "Pick up where you left off" prompt.
- No data is lost; HealthKit backfills automatically.

## Engagement Strategy

### Principles
- **Informational, not behavioral.** The app helps the user understand and prepare — it does not try to change their behavior.
- **No manipulation.** No streaks, no gamification, no dark patterns.
- **Gentle reminders only.** One notification before an appointment ("Your appointment is tomorrow — review your questions?"). Weekly optional check-in. Nothing more.
- **Progress = understanding.** Show what topics they have explored, what questions they have prepared — not compliance metrics.

### What we avoid
- Alert fatigue: maximum 2 notifications per week
- Shame or guilt for not engaging
- AI-generated medical recommendations
- Anything that could be mistaken for a diagnosis or treatment plan

## Accessibility and Inclusion

### Readability
- All content written at a 6th-grade reading level or below
- Medical terms always include a plain-language definition
- Short paragraphs, bullet points, clear headers

### Visual Design
- Large text as default (minimum 16pt body text)
- High contrast color scheme
- Clear visual hierarchy — most important information is most prominent
- Support for Dynamic Type (iOS system text scaling)

### Assistive Technology
- Full VoiceOver support
- All interactive elements properly labeled
- No information conveyed by color alone

### Cognitive Load
- One decision per screen when possible
- Clear navigation — the user should always know where they are and how to go back
- No time pressure on any interaction

### Trust and Cultural Considerations
- Sources displayed prominently — the user should never wonder "where did this come from?"
- Language is neutral and empowering: "Here are your options" not "You should consider..."
- Acknowledge uncertainty: "Talk to your doctor about how this applies to your situation"

## Unresolved Risks and Open Questions

1. **Content accuracy and freshness**: NCCN/AMA/ACS guidelines update periodically. How will content be kept current in a personal app without a backend? May need a content versioning strategy or manual update process.
2. **Scope of health data**: Which specific HealthKit data types are most relevant to a surgery-vs-radiation decision? Need to confirm with clinical context.
3. **Provider evaluation data**: Publicly available provider quality data is limited and varies by region. The app may need to guide the user on how to find this information rather than providing it directly.
4. **Caregiver sharing mechanism**: Simplest approach is a shareable text/PDF summary. Need to confirm this is sufficient vs. a more interactive shared view.
5. **Content liability**: The app should include clear disclaimers that it is an educational tool, not medical advice. Wording matters for trust.
