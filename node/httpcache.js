'use strict';

// Offline HTTP bodies: a script that bootstraps itself with
//   local lib = game:HttpGet("https://.../Chilli%20Library")
// gets nil from the sandbox (there is no network) and dies on the assert. With
// a cache the same call answers the body that ships next to the sample, so the
// bootstrap continues and the run reaches code the trace could never see.
//
// This feeds the runtime's existing `CFG.http_map` (canned answers, keyed by url
// or "METHOD url", `*` suffix for a prefix match), so nothing about how the
// sandbox answers a request changes -- only what it has to answer with.
//
// The mapping is explicit -- url to file, in index.json -- because a body served
// for the wrong url builds a library out of something the script never got, and
// the trace would then describe a program that does not exist.

const fs = require('node:fs');
const path = require('node:path');

const loaded = new Map();

function readBody(root, url, rel) {
  if (typeof rel === 'string' && rel) {
    const file = path.resolve(root, rel);
    if (file !== root && !file.startsWith(root + path.sep)) {
      throw new Error(`--http-cache: index.json entry ${url} points outside the cache (${rel})`);
    }
    if (!fs.existsSync(file)) {
      throw new Error(`--http-cache: ${url} needs ${rel}, which is not in ${root}`);
    }
    return { status: 200, body: fs.readFileSync(file, 'utf8') };
  }
  if (rel && typeof rel === 'object' && !Array.isArray(rel)) {
    const entry = readBody(root, url, rel.file);
    if (rel.status) entry.status = Number(rel.status);
    if (rel.headers) entry.headers = rel.headers;
    return entry;
  }
  throw new Error(`--http-cache: index.json entry ${url} must be a file name or {file, status?, headers?}`);
}

function loadHttpCache(dir, log) {
  const root = path.resolve(dir);
  const hit = loaded.get(root);
  if (hit) return hit.map;

  let stat = null;
  try { stat = fs.statSync(root); } catch {}
  if (!stat || !stat.isDirectory()) {
    throw new Error(`--http-cache needs a directory (${dir})`);
  }

  const indexPath = path.join(root, 'index.json');
  const map = Object.create(null);
  let count = 0;

  if (fs.existsSync(indexPath)) {
    let index;
    try {
      index = JSON.parse(fs.readFileSync(indexPath, 'utf8'));
    } catch (err) {
      throw new Error(`--http-cache: ${indexPath} is not valid JSON (${err.message})`);
    }
    if (!index || typeof index !== 'object' || Array.isArray(index)) {
      throw new Error(`--http-cache: ${indexPath} must map url -> file`);
    }
    for (const [url, rel] of Object.entries(index)) {
      map[url] = readBody(root, url, rel);
      count++;
    }
  }

  if (log !== false) {
    if (count) {
      process.stderr.write(`[*] http cache: ${count} url(s) served from ${root}\n`);
    } else {
      process.stderr.write(`[!] http cache: ${root} has no index.json (or it is empty); `
        + 'every game:HttpGet still answers nil\n');
    }
  }

  loaded.set(root, { map });
  return map;
}

module.exports = { loadHttpCache };
