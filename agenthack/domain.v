module agenthack

pub enum CheckStatus {
	pass
	warn
	fail
}

pub struct CheckResult {
pub:
	id     string
	title  string
	status CheckStatus
	detail string
	weight int
}

pub struct ScoreBand {
pub:
	title   string
	score   int
	max     int
	comment string
}

pub struct ReadinessReport {
pub:
	product      string
	version      string
	prod_percent int
	checks       []CheckResult
	bands        []ScoreBand
	blockers     []string
	next_actions []string
	generated_at string
}

pub struct ContestPaths {
pub:
	contest_root string
	web_root     string
	core_root    string
}

pub struct IncidentFixture {
pub:
	case_id          string
	service          string
	severity         string
	business_impact  string
	hypothesis       string
	recommendation   string
	approval_reason  string
	recovery_metric  string
	uipath_component string
}

pub fn status_label(status CheckStatus) string {
	return match status {
		.pass { 'pass' }
		.warn { 'warn' }
		.fail { 'fail' }
	}
}
