module main

import agenthack
import json
import os

const default_contest_root = 'C:\\git\\v_projects\\contests\\worth_it\\uipath_agenthack'
const default_web_root = 'C:\\git\\websites\\uipath_agenthack'

fn main() {
	args := os.args[1..]
	if args.len == 0 || args[0] in ['--help', '-h', 'help'] {
		print_help()
		return
	}
	paths := paths_from_args(args)
	match args[0] {
		'validate' {
			run_validate(paths)
		}
		'score' {
			run_score(paths)
		}
		'pack' {
			run_pack(paths)
		}
		'fixture' {
			println(agenthack.fixture_receipt_json(agenthack.checkout_fixture()))
		}
		else {
			eprintln('Unknown command: ${args[0]}')
			print_help()
			exit(2)
		}
	}
}

fn print_help() {
	println('uipath_agenthack commands:')
	println('  validate --contest <path> --web <path>')
	println('  score --contest <path> --web <path>')
	println('  pack --contest <path> --web <path>')
	println('  fixture')
}

fn paths_from_args(args []string) agenthack.ContestPaths {
	return agenthack.ContestPaths{
		contest_root: arg_value(args, '--contest', default_contest_root)
		web_root:     arg_value(args, '--web', default_web_root)
		core_root:    os.getwd()
	}
}

fn arg_value(args []string, key string, fallback string) string {
	for i, value in args {
		if value == key && i + 1 < args.len {
			return args[i + 1]
		}
	}
	return fallback
}

fn run_validate(paths agenthack.ContestPaths) {
	checks := agenthack.validate_submission(paths)
	for check in checks {
		println('${agenthack.status_label(check.status)} | ${check.title} | ${check.detail}')
	}
	prod := agenthack.readiness_percent(checks)
	if prod < 80 {
		exit(1)
	}
}

fn run_score(paths agenthack.ContestPaths) {
	report := agenthack.build_readiness_report(paths)
	println(json.encode_pretty(report))
}

fn run_pack(paths agenthack.ContestPaths) {
	out_dir := agenthack.write_evidence_pack(paths) or {
		eprintln(err.msg())
		exit(1)
	}
	println(out_dir)
}
