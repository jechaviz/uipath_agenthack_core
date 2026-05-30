module agenthack

pub fn checkout_fixture() IncidentFixture {
	return IncidentFixture{
		case_id:          'INC-2026-0529-API'
		service:          'Checkout API'
		severity:         'SEV-2'
		business_impact:  '$18.6k at risk'
		hypothesis:       'New retry policy saturates payment-adapter threads under peak checkout load.'
		recommendation:   'Rollback feature flag checkout.retryPolicy.v2 and observe 5xx rate for 10 minutes.'
		approval_reason:  'Rollback is reversible and has a clear recovery metric.'
		recovery_metric:  'Checkout 5xx rate holds below 1% for 10 minutes.'
		uipath_component: 'Maestro Case with Agent Builder, API Workflows, Robots, Coded Agent, and Human Tasks'
	}
}

pub fn fixture_receipt_json(f IncidentFixture) string {
	return '{
  "case_id": "${f.case_id}",
  "service": "${f.service}",
  "severity": "${f.severity}",
  "business_impact": "${f.business_impact}",
  "hypothesis": "${f.hypothesis}",
  "recommendation": "${f.recommendation}",
  "approval_reason": "${f.approval_reason}",
  "recovery_metric": "${f.recovery_metric}",
  "uipath_component": "${f.uipath_component}",
  "status": "demo_ready"
}'
}
