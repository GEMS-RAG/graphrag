# GraphRAG for the MUTCD RAG comparison

This repository contains the GEMS-RAG study's GraphRAG adapter, its support modules, and the Microsoft GraphRAG source required to run it. The benchmark, shared corpus, completed study indexes, comparison runner, and scoring tools are in [GEMS-RAG/rag](https://github.com/GEMS-RAG/rag).

The study uses GraphRAG's `local` query algorithm to retrieve context for a common downstream answer-model comparison. The adapter also retains the original preparation, indexing, readiness checks, and other upstream query modes. Its public method ID is `graphrag`; the saved answer-run name was `graphrag_local`.

The adapter and retrieval source are copied unchanged from the published study snapshot. The upstream revision is [`6d02c2355c3fed4c49007572fbe951d73258a37f`](https://github.com/microsoft/graphrag/tree/6d02c2355c3fed4c49007572fbe951d73258a37f). [PROVENANCE.json](PROVENANCE.json) records the source paths, revisions, and hashes.

## Setup

Use Python 3.13, matching the published study environment. From this repository, clone the hub as a sibling directory if needed, initialize the shared indexes once, and link them here:

```bash
git clone https://github.com/GEMS-RAG/rag.git ../rag
python3 ../rag/scripts/initialize_indexes.py
ln -s ../rag/indexes indexes
bash scripts/setup_environment.sh
cp .env.example .env
```

Set `OPENAI_API_KEY`, `GRAPHRAG_QUERY_LLM_MODEL`, and `GRAPHRAG_QUERY_EMBEDDING_MODEL` in `.env` to the query profile for the index being reproduced, then export them:

```bash
set -a
source .env
set +a
```

To select a different interpreter for environment setup, use `PYTHON=/path/to/python3.13 bash scripts/setup_environment.sh`.

## Query

```bash
python3 pipelines/query_graphrag.py \
  --python .venv-graphrag/bin/python \
  --api-key-env OPENAI_API_KEY \
  --query-llm-model "${GRAPHRAG_QUERY_LLM_MODEL}" \
  --query-embedding-model "${GRAPHRAG_QUERY_EMBEDDING_MODEL}" \
  query --method local --context-only --json \
  --question "What shape is a STOP sign?" --top-k 10
```

The adapter emits a JSON result with retrieved contexts. Keep the index, embedding model, query model, and retrieval depth fixed when reproducing an experiment. The saved answer comparisons used six contexts; the released retrieval-scoring workflow uses ten. Pass `--working-dir` to use another GraphRAG index. Preparation and rebuild options are available through `python3 pipelines/query_graphrag.py --help` and its subcommand help.

The study adapter is under `pipelines/`, its support code is under `src/comparison_support/`, and the upstream source is under `third_party/graphrag/`.

## Citation and attribution

Cite Edge et al. (2024), [From Local to Global: A Graph RAG Approach to Query-Focused Summarization](https://arxiv.org/abs/2404.16130), for Microsoft GraphRAG, and cite this repository for the MUTCD study adapter. [CITATION.cff](CITATION.cff) and [references.bib](references.bib) provide metadata for both.

Microsoft's MIT license and source attribution remain in [third_party/graphrag/LICENSE](third_party/graphrag/LICENSE). See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the distinction between upstream source and study-authored files.
