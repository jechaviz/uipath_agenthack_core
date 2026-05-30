# uipath_agenthack V Core

Vlang core for Agentic Incident Ops.

This project owns reusable contest automation primitives:

- Submission readiness scoring.
- Repo and evidence validation.
- Synthetic incident fixtures.
- Evidence pack generation.
- Small CLI runners for CI and local release checks.

The UiPath-specific production workflow remains represented in the contest repository under `C:\git\v_projects\contests\worth_it\uipath_agenthack`, while this core stays generic enough to reuse for future automation-heavy submissions.

## Commands

```powershell
v run cmd\uipath_agenthack --help
v run cmd\uipath_agenthack validate --contest C:\git\v_projects\contests\worth_it\uipath_agenthack --web C:\git\websites\uipath_agenthack
v run cmd\uipath_agenthack score --contest C:\git\v_projects\contests\worth_it\uipath_agenthack
v run cmd\uipath_agenthack pack --contest C:\git\v_projects\contests\worth_it\uipath_agenthack
```

## Quality

```powershell
v fmt -w .
v test .
```
