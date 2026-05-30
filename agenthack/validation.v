module agenthack

import os

pub fn validate_submission(paths ContestPaths) []CheckResult {
	mut checks := []CheckResult{}
	checks << file_check(paths.contest_root, 'README.md', 'README exists', 10)
	checks << file_check(paths.contest_root, 'LICENSE', 'MIT license exists', 8)
	checks << file_check(paths.contest_root, 'docs/DEVPOST_SUBMISSION_PACKET.md',
		'Devpost packet exists', 10)
	checks << file_check(paths.contest_root, 'docs/JUDGE_GUIDE.md', 'Judge guide exists', 8)
	checks << file_check(paths.contest_root, 'docs/COMPETITIVE_BATTLECARD.md',
		'Competitive battlecard exists', 8)
	checks << file_check(paths.contest_root, 'docs/SECURITY_AND_GOVERNANCE.md',
		'Security and governance exists', 8)
	checks << file_check(paths.contest_root, 'docs/UIPATH_LIVE_BUILD_RUNBOOK.md',
		'UiPath live build runbook exists', 8)
	checks << file_check(paths.contest_root, 'docs/UIPATH_WORKFLOW_PROPOSAL.md',
		'UiPath workflow proposal exists', 10)
	checks << file_check(paths.contest_root, 'uipath/agentic_incident_ops.case_blueprint.json',
		'Maestro case blueprint exists', 10)
	checks << file_check(paths.contest_root, 'evidence/codex-agent-usage.md',
		'Coding agent evidence exists', 8)
	checks << file_check(paths.contest_root, 'automation/devpost_fill_draft.mjs',
		'Devpost automation exists', 8)
	checks << file_check(paths.web_root, 'index.html', 'Web command center exists', 8)
	checks << file_check(paths.web_root, 'src/App.vue', 'Vue SFC shell exists', 8)
	checks << content_check(paths.contest_root, 'README.md', 'UiPath Maestro Case',
		'README names track', 5)
	checks << content_check(paths.contest_root, 'README.md', 'OpenAI Codex',
		'README documents coding agent', 5)
	checks << content_check(paths.contest_root, 'docs/PROD100_CHECKLIST.md',
		'Live UiPath Automation Cloud workflow is built', 'Checklist tracks live UiPath gap', 5)
	checks << stale_link_check(paths.contest_root)
	checks << line_guard_check(paths.contest_root, 'contest hub line guard')
	checks << line_guard_check(paths.web_root, 'web app line guard')
	checks << line_guard_check(paths.core_root, 'V core line guard')
	return checks
}

pub fn readiness_percent(checks []CheckResult) int {
	mut score := 0
	mut max := 0
	for check in checks {
		max += check.weight
		if check.status == .pass {
			score += check.weight
		} else if check.status == .warn {
			score += check.weight / 2
		}
	}
	if max == 0 {
		return 0
	}
	return int(score * 100 / max)
}

fn file_check(root string, rel string, title string, weight int) CheckResult {
	path := os.join_path(root, rel)
	if os.exists(path) {
		return CheckResult{
			id:     rel
			title:  title
			status: .pass
			detail: path
			weight: weight
		}
	}
	return CheckResult{
		id:     rel
		title:  title
		status: .fail
		detail: 'missing: ${path}'
		weight: weight
	}
}

fn content_check(root string, rel string, needle string, title string, weight int) CheckResult {
	path := os.join_path(root, rel)
	text := os.read_file(path) or {
		return CheckResult{
			id:     rel + ':' + needle
			title:  title
			status: .fail
			detail: 'missing: ${path}'
			weight: weight
		}
	}
	if text.contains(needle) {
		return CheckResult{
			id:     rel + ':' + needle
			title:  title
			status: .pass
			detail: needle
			weight: weight
		}
	}
	return CheckResult{
		id:     rel + ':' + needle
		title:  title
		status: .warn
		detail: 'needle not found: ${needle}'
		weight: weight
	}
}

fn stale_link_check(root string) CheckResult {
	bad := 'contests-worth-it-uipath_agenthack'
	files := ['README.md', 'docs/DEVPOST_SUBMISSION_PACKET.md', 'docs/PUBLIC_REPO_PLAN.md',
		'automation/devpost_submission.json']
	for rel in files {
		text := os.read_file(os.join_path(root, rel)) or { continue }
		if text.contains(bad) {
			return CheckResult{
				id:     'stale-link:${rel}'
				title:  'No stale GitHub repo links'
				status: .fail
				detail: rel
				weight: 8
			}
		}
	}
	return CheckResult{
		id:     'stale-link'
		title:  'No stale GitHub repo links'
		status: .pass
		detail: 'clean'
		weight: 8
	}
}

fn line_guard_check(root string, title string) CheckResult {
	violations := line_limit_violations(root, 600)
	if violations.len == 0 {
		return CheckResult{
			id:     title
			title:  title
			status: .pass
			detail: 'all source files under 600 lines'
			weight: 8
		}
	}
	return CheckResult{
		id:     title
		title:  title
		status: .fail
		detail: violations.join('; ')
		weight: 8
	}
}
