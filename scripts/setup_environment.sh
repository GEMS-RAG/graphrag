#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PYTHON_EXECUTABLE="${PYTHON:-python3.13}"
"${PYTHON_EXECUTABLE}" -m venv "${ROOT}/.venv-graphrag"
"${ROOT}/.venv-graphrag/bin/python" -m pip install --upgrade pip
packages=()
for package in "${ROOT}"/third_party/graphrag/packages/*; do
  if [[ -f "${package}/pyproject.toml" ]]; then
    packages+=("-e" "${package}")
  fi
done
"${ROOT}/.venv-graphrag/bin/python" -m pip install "${packages[@]}"
