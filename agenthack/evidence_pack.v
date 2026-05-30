module agenthack

import json
import os

pub fn write_evidence_pack(paths ContestPaths) !string {
	report := build_readiness_report(paths)
	out_dir := os.join_path(paths.contest_root, 'evidence', 'generated')
	os.mkdir_all(out_dir)!
	report_path := os.join_path(out_dir, 'readiness_report.json')
	fixture_path := os.join_path(out_dir, 'checkout_fixture_receipt.json')
	os.write_file(report_path, json.encode_pretty(report))!
	os.write_file(fixture_path, fixture_receipt_json(checkout_fixture()))!
	return out_dir
}

pub fn markdown_report(report ReadinessReport) string {
	mut lines := []string{}
	lines << '# Agentic Incident Ops Readiness Report'
	lines << ''
	lines << '- Product: ${report.product}'
	lines << '- Version: ${report.version}'
	lines << '- Prod readiness: ${report.prod_percent}%'
	lines << '- Generated: ${report.generated_at}'
	lines << ''
	lines << '## Checks'
	for check in report.checks {
		lines << '- ${status_label(check.status)}: ${check.title} (${check.weight})'
	}
	lines << ''
	lines << '## Score Bands'
	for band in report.bands {
		lines << '- ${band.title}: ${band.score}/${band.max} - ${band.comment}'
	}
	lines << ''
	lines << '## Next Actions'
	for item in report.next_actions {
		lines << '- ${item}'
	}
	return lines.join('\n')
}
