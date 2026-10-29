'use strict';

// The original trace-folding/formatting modules are not present in this
// checkout. Preserve the recorded text instead of guessing at control flow or
// removing lines that might belong to a multi-line string. Consequently a
// trace may contain harmless `--@` instrumentation comments. A trace is an
// observation, not recovered source code.
function tidy(text) {
  return text;
}

module.exports = { tidy };
