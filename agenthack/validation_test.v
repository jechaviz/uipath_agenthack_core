module agenthack

fn test_readiness_percent_counts_weighted_passes() {
	checks := [
		CheckResult{
			id:     'a'
			title:  'A'
			status: .pass
			weight: 10
		},
		CheckResult{
			id:     'b'
			title:  'B'
			status: .fail
			weight: 10
		},
	]
	assert readiness_percent(checks) == 50
}

fn test_fixture_receipt_has_case_id() {
	receipt := fixture_receipt_json(checkout_fixture())
	assert receipt.contains('INC-2026-0529-API')
	assert receipt.contains('demo_ready')
}

fn test_line_guard_counts_current_module() {
	files := guarded_files('.')
	assert files.len > 0
	assert line_limit_violations('.', 600).len == 0
}
