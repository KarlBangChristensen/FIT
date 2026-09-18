# FIT

Paper + simulation code on empirical critical values for Rasch item-fit statistics (infit/outfit,
residual-based fit). LaTeX manuscript backed by R (and some legacy SAS) simulation work.

## Layout
- `main.tex`, `Appendix-A-RMP.tex`, `Appendix-B-Shiny.tex`, `Christensen-SAMC.tex`, `biblio.bib` —
  manuscript and appendices.
- Root R scripts: `amtsEx.R` (AMTS worked example), `RASCHplot_patches.R`. Simulation results are
  cached as `.RData`/`.csv` at the root (`amtsstats*.RData`, `amtsdelta.csv`, `amtsoutfit.csv`,
  `amtstheta.csv`, etc.) and are large/regenerable — don't hand-edit, regenerate via the R scripts
  if they need to change.
- `AMTS.csv`, `AMTSsimu/`, `SPADI.csv`/`.sas`, `knox*.sas7bdat`/`.sas`/`.log`, `dich10/` — example
  and simulation datasets (AMTS, SPADI, Knox scales) used to illustrate the fit statistics, mixing
  R and legacy SAS.
- `pdf/` — reference literature on Rasch fit statistics (Smith, Wright, Wu & Adams, etc.) — read
  these before changing how a fit statistic is computed or described.
- Root `.RData`/`.Rhistory` — live RStudio session state (this one is large, ~8MB).

## Git — two remotes
- `origin` → GitHub (`KarlBangChristensen/FIT`).
- `overleaf` → the Overleaf project — `.tex` files are co-edited there.
- Pull from `overleaf` before editing `.tex`; resolve conflicts rather than force-pushing.
- Several PDFs currently sit untracked at the root (`git status`) — check before assuming a PDF is
  already committed.

## Conventions
- R is the active language for new work; SAS files (`knoxsimu.sas`, `SPADI.sas`) are legacy/kept
  for reproducibility, not being extended.
- No automated tests — validate changes by comparing simulation output against the manuscript's
  reported critical values/tables.

## Working across two laptops
- This repo lives on a shared network drive (`H:\`) reachable from both of the user's physical
  locations — it's one working tree, not two clones, so there's no push/pull needed just to switch
  locations. Just start a fresh Claude Code session on whichever laptop is in use.
- Claude's session history and memory are local to each laptop and don't carry over — anything
  durable enough to matter belongs in this file, not in a remembered preference.
- If a previous session ended abruptly (laptop went to sleep mid-write), check for a stale
  `.git/index.lock` before running git commands — it can be left behind and will block commits.
- The `claude` CLI (separate from this desktop app) is installed per-machine, under the Windows
  user profile (`%USERPROFILE%\.local\bin`) — it does **not** come along via the shared `H:\`
  drive. Each laptop needs a one-time setup: run `irm https://claude.ai/install.ps1 | iex` in
  PowerShell, close/reopen PowerShell, then add the install folder to PATH:
  ```powershell
  $currentPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
  [Environment]::SetEnvironmentVariable('PATH', "$currentPath;$env:USERPROFILE\.local\bin", 'User')
  ```
  Close/reopen PowerShell once more and confirm with `claude --version`.
