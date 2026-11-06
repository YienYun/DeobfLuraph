'use strict';

// The offline Roblox model must answer a property read with the *datatype* the
// real API promises, including when the object's class is unknown.
//
// Two gaps were found by running a live Chilli hub build: the Roblox API dump
// in runtime/roblox_api.luau had no GuiObject/LayerCollector entry (Frame's own
// entry only lists Style), so `frame.Position` came back as an untyped
// Instance; and an unknown class had no fallback at all, so
// `playerGui:FindFirstChild("LeftCenter").Position.X.Scale` stayed userdata.
// Luau refuses `userdata <= number` before it looks at metamethods, so the
// library died there instead of running.

const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');
const { spawnSync } = require('node:child_process');

const ROOT = path.resolve(__dirname, '..', '..');
const harness = require(path.join(ROOT, 'node', 'harness'));

function run(source) {
    const text = harness.buildHarness(source, { time_budget: 60, dump_strings: false }, {});
    const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'sandbox-'));
    const hpath = path.join(dir, 'harness.luau');
    fs.writeFileSync(hpath, text, 'latin1');
    const res = spawnSync(harness.findLuau(), [hpath], {
        encoding: 'utf8',
        timeout: 180000,
        maxBuffer: 64 * 1024 * 1024,
    });
    fs.rmSync(dir, { recursive: true, force: true });
    const printed = (res.stdout || '').split('\n').filter((l) => /^print\(/.test(l));
    return { printed, status: (res.stdout || '') + (res.stderr || '') };
}

test('a known GUI class answers its inherited properties', () => {
    const { printed } = run(`
local frame = Instance.new("Frame")
local label = Instance.new("TextLabel")
print(typeof(frame.Position), typeof(frame.Position.X), typeof(frame.Position.X.Scale),
      typeof(frame.AnchorPoint), typeof(frame.Visible), typeof(label.Text))
`);
    assert.deepEqual(printed, [
        'print("UDim2", "UDim", "number", "Vector2", "boolean", "string")',
    ]);
});

test('an unknown child still gets the datatype of the property it reads', () => {
    // playerGui:FindFirstChild("LeftCenter") is a real GUI frame whose class no
    // API dump can tell us: the members still decide (only a UDim2 has .X.Scale)
    const { printed } = run(`
local gui = game:GetService("CoreGui")
local frame = gui:FindFirstChild("LeftCenter")
local position = frame.Position
print(typeof(position.X), typeof(position.X.Scale), typeof(frame.Size.Y.Offset))
local ok, verdict = pcall(function() return position.X.Scale <= -0.5 end)
print(ok, verdict)
`);
    assert.deepEqual(printed, [
        'print("UDim", "number", "number")',
        'print(true, false)',
    ]);
});

test('a name the API dump disagrees about stays untyped', () => {
    // Value is a bool on one class and a string on another: guessing would put
    // an invented type in the output, so the name alone decides nothing.
    const { printed } = run(`
local gui = game:GetService("CoreGui")
local unknown = gui:FindFirstChild("Anything")
print(typeof(unknown.Value))
`);
    assert.deepEqual(printed, ['print("Instance")']);
});
