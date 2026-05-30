module agenthack

import os

const guarded_extensions = ['.v', '.vue', '.js', '.css', '.html', '.md', '.json']

pub fn line_limit_violations(root string, limit int) []string {
	mut violations := []string{}
	for path in guarded_files(root) {
		lines := count_lines(path)
		if lines >= limit {
			violations << '${relative_path(root, path)}:${lines}'
		}
	}
	return violations
}

pub fn guarded_files(root string) []string {
	mut files := []string{}
	collect_guarded_files(root, mut files)
	files.sort()
	return files
}

fn collect_guarded_files(dir string, mut files []string) {
	for name in os.ls(dir) or { []string{} } {
		path := os.join_path(dir, name)
		if os.is_dir(path) {
			if should_skip_dir(name) {
				continue
			}
			collect_guarded_files(path, mut files)
		} else if is_guarded_file(name) {
			files << path
		}
	}
}

fn is_guarded_file(name string) bool {
	lower := name.to_lower()
	for ext in guarded_extensions {
		if lower.ends_with(ext) {
			return true
		}
	}
	return false
}

fn should_skip_dir(name string) bool {
	clean := name.to_lower()
	return clean in ['.git', '.browser', 'bin', 'dist', 'node_modules', 'out', 'playwright-report',
		'test-results']
}

fn count_lines(path string) int {
	text := os.read_file(path) or { return 0 }
	if text == '' {
		return 0
	}
	return text.split_into_lines().len
}

fn relative_path(root string, path string) string {
	base := os.real_path(root).replace('\\', '/').trim_right('/')
	full := os.real_path(path).replace('\\', '/')
	prefix := base + '/'
	if full.starts_with(prefix) {
		return full[prefix.len..]
	}
	return full
}
