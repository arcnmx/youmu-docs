#!/bin/bash
set -eu

[ -d youmu/.git ] || git clone https://github.com/arcnmx/youmu
(unset CARGO_TARGET_DIR && cd youmu && git fetch origin && git reset --hard origin/master && cargo build --release)
find "$CARGO_TARGET_DIR/debug/.fingerprint" -name "doc-*" -exec rm -f "{}" \; || true
./youmu/target/release/youmu konpaku -o ./docs ./crates.yml
.travis/publish_docs.sh
