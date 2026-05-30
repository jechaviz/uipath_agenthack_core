module agenthack

import time

pub fn build_readiness_report(paths ContestPaths) ReadinessReport {
	checks := validate_submission(paths)
	prod := readiness_percent(checks)
	return ReadinessReport{
		product:      'Agentic Incident Ops'
		version:      '0.3.0'
		prod_percent: prod
		checks:       checks
		bands:        score_bands(prod)
		blockers:     blockers_from_checks(checks)
		next_actions: next_actions(prod)
		generated_at: time.now().format_rfc3339()
	}
}

pub fn score_bands(prod int) []ScoreBand {
	return [
		ScoreBand{
			title:   'Workflow depth'
			score:   if prod >= 50 { 90 } else { 60 }
			max:     100
			comment: 'Maestro Case, agents, robots, human gates, and receipts are mapped.'
		},
		ScoreBand{
			title:   'Demo clarity'
			score:   if prod >= 60 { 84 } else { 55 }
			max:     100
			comment: 'The command-center MVP shows the full incident lifecycle.'
		},
		ScoreBand{
			title:   'Submission readiness'
			score:   prod
			max:     100
			comment: 'Remaining gaps are live UiPath run, final video, deck, and Devpost submit.'
		},
		ScoreBand{
			title:   'Competitive edge'
			score:   if prod >= 70 { 88 } else { 68 }
			max:     100
			comment: 'Differentiation is evidence receipts plus governed production action.'
		},
	]
}

pub fn blockers_from_checks(checks []CheckResult) []string {
	mut blockers := []string{}
	for check in checks {
		if check.status == .fail {
			blockers << check.title
		}
	}
	return blockers
}

pub fn next_actions(prod int) []string {
	if prod >= 90 {
		return ['Record final video', 'Fill Devpost draft', 'Run final secret review']
	}
	return [
		'Build live UiPath Maestro Case in Labs',
		'Capture production screenshots',
		'Create public deck link',
		'Run Devpost draft automation',
	]
}
