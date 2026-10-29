import json
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
GENERATED = re.compile(
    r"^(?:[A-Za-z_]\d+(?:_\d+)*|arg\d*_*|fn\d*|tbl\d*|str\d*|flag\d*|v|[a-z_][A-Z]|[A-Z]{2})$"
)
SINGLE_CHAR = re.compile(r"^[A-Za-z]$")
KEEP_2UPPER = {"UI", "ID", "OK", "IP", "OS", "WS", "HP", "XP", "AI", "DB", "FN", "FX", "IO"}
KEYWORDS = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local",
            "nil", "not", "or", "repeat", "return", "then", "true", "until", "while", "continue", "type",
            "export", "self"}
DATATYPES = {"Color3": "color", "Vector3": "vector", "Vector2": "vector2", "UDim2": "udim2", "UDim": "udim",
             "CFrame": "cframe", "TweenInfo": "tweenInfo", "ColorSequence": "colorSequence",
             "NumberSequence": "numberSequence", "NumberRange": "numberRange", "Rect": "rect",
             "RaycastParams": "raycastParams", "OverlapParams": "overlapParams", "Ray": "ray",
             "BrickColor": "brickColor", "Font": "font", "PhysicalProperties": "physicalProperties"}
METHOD_NAMES = {"GetChildren": "children", "GetDescendants": "descendants", "GetPlayers": "players",
                "Clone": "clone", "Connect": "connection", "Once": "connection", "Create": "tween",
                "GetPropertyChangedSignal": "signal", "GetMouse": "mouse", "Raycast": "hit",
                "InvokeServer": "response", "HttpGet": "response", "GetAsync": "response",
                "JSONDecode": "data", "JSONEncode": "json", "match": "match", "gsub": "str", "sub": "str",
                "lower": "str", "upper": "str", "format": "str", "rep": "str", "find": "pos", "split": "parts",
                "GetAttribute": "attribute", "IsA": "isA", "Wait": "result", "GenerateGUID": "guid",
                "GetServerTimeNow": "serverTime"}
GLOBAL_CALLS = {"tick": "now", "time": "now", "os.clock": "now", "os.time": "now", "type": "kind",
                "typeof": "kind", "tostring": "str", "tonumber": "num", "setmetatable": "obj",
                "loadstring": "chunk", "getgenv": "genv", "getfenv": "env", "gethui": "hui",
                "request": "response", "http_request": "response",
                "string.format": "str", "string.rep": "str", "string.sub": "str", "table.concat": "str",
                "math.floor": "n", "math.clamp": "n", "math.min": "n", "math.max": "n", "math.abs": "n",
                "math.random": "n", "select": "value", "unpack": "value", "table.unpack": "value",
                "coroutine.create": "thread", "task.spawn": "thread", "task.delay": "thread",
                "Instance.new": "instance", "Drawing.new": "drawing", "newproxy": "proxy",
                "rawget": "value", "next": "key"}
GLOBAL_REFS = {"game": "gameRef", "workspace": "workspaceRef", "_G": "genv",
               "request": "httpRequest", "http_request": "httpRequest"}

WEAK = {"str", "n", "tbl", "flag", "fn", "value", "key", "kind", "num", "obj", "result"}
WEAK_1CHAR = WEAK | {"v", "arg"}

SIGNAL_PARAMS = {
    "PlayerAdded": ["player"], "PlayerRemoving": ["player"],
    "CharacterAdded": ["character"], "CharacterRemoving": ["character"], "CharacterAppearanceLoaded": ["character"],
    "Touched": ["hit"], "TouchEnded": ["hit"],
    "InputBegan": ["input", "gameProcessed"], "InputEnded": ["input", "gameProcessed"],
    "InputChanged": ["input", "gameProcessed"],
    "Heartbeat": ["deltaTime"], "RenderStepped": ["deltaTime"], "PreSimulation": ["deltaTime"],
    "PostSimulation": ["deltaTime"], "PreRender": ["deltaTime"], "Stepped": ["time", "deltaTime"],
    "ChildAdded": ["child"], "ChildRemoved": ["child"],
    "DescendantAdded": ["descendant"], "DescendantRemoving": ["descendant"],
    "HealthChanged": ["health"], "Chatted": ["message"],
    "FocusLost": ["enterPressed", "inputObject"], "Triggered": ["player"],
    "PromptTriggered": ["prompt", "player"], "PromptButtonHoldBegan": ["prompt", "player"],
    "Idled": ["idleTime"], "MouseButton1Down": ["x", "y"], "Activated": ["inputObject", "clickCount"],
    "AncestryChanged": ["child", "parent"], "AttributeChanged": ["attribute"],
    "StateChanged": ["old", "new"], "MoveToFinished": ["reached"], "Completed": ["playbackState"],
}


def duck_type_members(members):
    """Infer a semantic Roblox/Luau name from the set of properties/methods accessed on a value."""
    if not members:
        return None
    m = set(members)
    if m & {"TouchEnabled", "KeyboardEnabled", "MouseEnabled", "GetFocusedTextBox"}:
        return "UserInputService"
    if m & {"Heartbeat", "RenderStepped", "PreSimulation", "PostSimulation"}:
        return "RunService"
    if m & {"LocalPlayer", "GetPlayers", "PlayerAdded", "PlayerRemoving"}:
        return "Players"
    if m & {"JSONDecode", "JSONEncode", "GenerateGUID"}:
        return "HttpService"
    if m & {"TeleportToPlaceInstance", "TeleportAsync"}:
        return "TeleportService"
    if "Create" in m and m <= {"Create", "GetValue"}:
        return "TweenService"
    if m & {"CurrentCamera", "GetServerTimeNow"}:
        return "workspaceRef"
    if m & {"HumanoidRootPart"}:
        return "character"
    if m & {"WalkSpeed", "JumpPower", "JumpHeight", "HipHeight"}:
        return "humanoid"
    if m & {"UserId", "DisplayName"} and "Character" in m:
        return "player"
    if m & {"CanvasPosition", "CanvasSize", "ScrollingDirection", "AutomaticCanvasSize"}:
        return "scrollingFrame"
    if "CornerRadius" in m:
        return "uiCorner"
    if m & {"ApplyStrokeMode"} or ("Thickness" in m and "Color" in m and len(m) <= 5):
        return "uiStroke"
    if m & {"FillDirection", "HorizontalAlignment", "VerticalAlignment"} and "SortOrder" in m:
        return "listLayout"
    if m & {"PaddingTop", "PaddingBottom", "PaddingLeft", "PaddingRight"}:
        return "uiPadding"
    if {"R", "G", "B"} <= m:
        return "color"
    if {"X", "Y", "Z"} <= m:
        return "vector"
    if m & {"LookVector", "RightVector", "UpVector"}:
        return "cframe"
    if m & {"TextXAlignment", "TextYAlignment", "TextScaled", "TextWrapped"} and "Text" in m:
        return "textLabel"
    if m & {"relogin", "startsInMs"} or {"sess", "acct"} <= m:
        return "session"
    if m & {"tpOk", "inDim"} or ("cleanup" in m and len(m) >= 3):
        return "state"
    return None


KEEP_NUM_SUFFIX = ("vector2", "vector3", "udim2", "color3", "bit32", "utf8", "base64", "sha256", "slot", "v", "n", "fn", "tbl", "arg", "str", "flag")


def strip_num_suffix(nm):
    """Strip disambiguation counter suffix (`genv2` -> `genv`, `Players2` -> `Players`) while preserving type digits."""
    if not nm:
        return nm
    low = nm.lower()
    if low in ("vector2", "vector3", "udim2", "color3", "bit32", "utf8", "base64", "sha256"):
        return nm
    base = re.sub(r"\d+$", "", nm)
    if base and base.lower() not in ("slot", "v", "n", "fn", "tbl", "arg", "str", "flag"):
        return base
    return nm


def string_semantic_name(s):
    """Infer a descriptive identifier for URLs, file names, and asset IDs."""
    if not s:
        return None
    if s.startswith(("http://", "https://", "wss://", "ws://")):
        is_ws = s.startswith(("wss://", "ws://"))
        suffix = " ws url" if is_ws else " url"
        rest = re.sub(r"^[a-z]+://", "", s)
        parts = [p for p in re.split(r"[/?#=&]+", rest) if p]
        if len(parts) >= 2:
            seg = re.sub(r"\.\w+$", "", parts[-1])
            if re.match(r"^[A-Za-z][A-Za-z0-9_-]{1,24}$", seg):
                return camel(seg + suffix)
        if parts:
            host = parts[0].split(":")[0].split(".")[0]
            if host and host not in ("www", "api") and re.match(r"^[A-Za-z][A-Za-z0-9_-]{1,20}$", host):
                return camel(host + suffix)
        return "wsUrl" if is_ws else "apiUrl"
    if s.startswith("rbxassetid://"):
        return "assetId"
    if re.match(r"^[A-Za-z0-9_-]{2,36}\.(?:json|txt|cfg|lua|luau)$", s):
        stem = re.sub(r"\.\w+$", "", s)
        return camel(stem + " file")
    return None


def str_arg_name(call):
    """f("RouterClient") -> RouterClient, x.get("TradeAPI/SendTrade") -> sendTrade:
    a call whose first argument names what it returns."""
    args = call.get("args") or []
    s = const_str(args[0]) if args else None
    if not s:
        return None
    last = re.split(r"[/.:\\]", s)[-1]
    if re.match(r"^[A-Za-z_]\w{1,40}$", last) and last not in KEYWORDS:
        return last if last[:1].isupper() and not last.isupper() else camel(last)
    return None


def loc(s):
    a, b = s.split(" - ")
    l1, c1 = a.split(",")
    l2, c2 = b.split(",")
    return (int(l1), int(c1)), (int(l2), int(c2))


def camel(s):
    """'UICorner' -> 'uiCorner', 'Humanoid Root' -> 'humanoidRoot'; None if unusable."""
    parts = re.findall(r"[A-Za-z0-9]+", s)
    if not parts:
        return None
    if len(parts) > 1:
        parts = [p.capitalize() if p.isupper() else p for p in parts]
    w = "".join(p[:1].upper() + p[1:] for p in parts)
    m = re.match(r"^([A-Z]+)([A-Z][a-z].*)$", w)
    if m:
        w = m.group(1).lower() + m.group(2)
    else:
        m = re.match(r"^([A-Z]+)$", w)
        w = w.lower() if m else w[:1].lower() + w[1:]
    if w[:1].isdigit():
        w = "n" + w
    return w[:32] if w else None


def singular(name):
    if not name:
        return None
    if name == "children":
        return "child"
    if name.endswith("ies") and len(name) > 4:
        return name[:-3] + "y"
    if name.endswith("s") and not name.endswith("ss") and len(name) > 3:
        return name[:-1]
    return None


def const_str(e):
    return e.get("value") if e and e.get("type") == "AstExprConstantString" else None


def const_slot_int(e):
    if e and e.get("type") == "AstExprConstantNumber":
        v = e.get("value")
        if isinstance(v, (int, float)) and v == int(v) and 0 <= int(v) <= 100000:
            return int(v)
    return None


def dotted(e):
    """'a.b.c' for global/index-name chains, else None."""
    if e.get("type") == "AstExprGlobal":
        return e["global"]
    if e.get("type") == "AstExprIndexName" and e.get("op") == ".":
        d = dotted(e["expr"])
        return d + "." + e["index"] if d else None
    return None


class Namer:
    def __init__(self, text):
        import tempfile
        import harness
        self.text = text
        with tempfile.NamedTemporaryFile("w", suffix=".luau", delete=False, encoding="utf-8", newline="\n") as f:
            f.write(text)
            path = f.name
        try:
            r = harness.run_luau_ast(path)
            if r.returncode != 0:
                raise SyntaxError("not valid Luau: %s" % r.stderr.decode("latin-1").strip()[:500])
            out = r.stdout
        finally:
            os.remove(path)
        self.root = json.loads(out.decode("latin-1"))["root"]
        self.locals = {}
        self.globals = set()
        self.order = []

    def local_info(self, node, scope):
        key = node["location"]
        info = self.locals.get(key)
        if info is None:
            info = self.locals[key] = {
                "name": node["name"], "decl": loc(key)[0], "scope": scope,
                "refs": [loc(key)[0]], "spans": [loc(key)],
                "hint": None, "hints": [], "members": set(), "inst_names": [],
                "empty_tbl_init": False, "reassigned": False, "raw_use": False,
                "slot_spans": [], "slot_hints": {}, "slot_members": {},
            }
            self.order.append(key)
        return info

    def _record_slot_access(self, e):
        """If `e` is `T[<const int>]` on a tracked local `T`, record the slot span and return `(info, k)`."""
        if e.get("type") == "AstExprIndexExpr" and e["expr"].get("type") == "AstExprLocal":
            k = const_slot_int(e.get("index"))
            if k is not None:
                info = self.locals.get(e["expr"]["local"]["location"])
                if info is not None:
                    a, b = loc(e["expr"]["location"])
                    _, end_all = loc(e["location"])
                    info["refs"].append(a)
                    info["spans"].append((a, b))
                    info["slot_spans"].append((b, end_all, k))
                    return info, k
        return None, None

    def collect(self):
        self.visit_block(self.root)

    def visit_block(self, blk):
        end = loc(blk["location"])[1]
        for st in blk["body"]:
            self.visit_stat(st, end)

    def visit_stat(self, st, block_end):
        t = st["type"]
        if t == "AstStatLocal":
            for v in st.get("values", []):
                self.visit_expr(v)
            stend = loc(st["location"])[1]
            vals = st.get("values", [])
            for i, var in enumerate(st["vars"]):
                start = loc(st["location"])[0] if len(st["vars"]) == 1 and len(vals) == 1 \
                    and vals[0]["type"] == "AstExprFunction" else stend
                info = self.local_info(var, (start, block_end))
                if i < len(vals):
                    val = vals[i]
                    info["hints"].append((val, 0))
                    if val.get("type") == "AstExprTable" and not val.get("entries"):
                        info["empty_tbl_init"] = True
                elif vals and vals[-1]["type"] == "AstExprCall":
                    info["hints"].append((vals[-1], i - len(vals) + 1))
            return
        if t == "AstStatLocalFunction":
            info = self.local_info(st["name"], (loc(st["location"])[0], block_end))
            info["hints"].append((st["func"], 0))
            self.visit_expr(st["func"])
            return
        if t == "AstStatAssign":
            vals = st["values"]
            for v in vals:
                self.visit_expr(v)
            for i, var in enumerate(st["vars"]):
                s_info, s_k = self._record_slot_access(var)
                if s_info is not None:
                    if i < len(vals):
                        s_info["slot_hints"].setdefault(s_k, []).append(vals[i])
                else:
                    self.visit_expr(var)
            for var, v in zip(st["vars"], vals):
                if v.get("type") == "AstExprBinary" and v.get("op") == "Or":
                    v = v["left"]
                if var.get("type") == "AstExprIndexName" and v.get("type") == "AstExprLocal":
                    info = self.locals.get(v["local"]["location"])
                    if info is not None:
                        info.setdefault("prop", camel(var["index"]))
                if var.get("type") == "AstExprIndexName" and var.get("index") == "Name" \
                        and var["expr"].get("type") == "AstExprLocal" and const_str(v):
                    info = self.locals.get(var["expr"]["local"]["location"])
                    if info is not None:
                        nm = camel(const_str(v))
                        if nm and nm not in KEYWORDS:
                            info["inst_names"].append(nm)
            for i, var in enumerate(st["vars"]):
                if var["type"] == "AstExprLocal":
                    info = self.locals.get(var["local"]["location"])
                    if info is not None:
                        info["reassigned"] = True
                        if i < len(vals):
                            info["hints"].append((vals[i], 0))
                        elif vals and vals[-1]["type"] == "AstExprCall":
                            info["hints"].append((vals[-1], i - len(vals) + 1))
            return
        if t == "AstStatFor":
            for k in ("from", "to", "step"):
                if st.get(k):
                    self.visit_expr(st[k])
            body = loc(st["body"]["location"])
            info = self.local_info(st["var"], (body[0], body[1]))
            info["hint"] = "i"
            info["loop_var"] = True
            self.visit_block(st["body"])
            return
        if t == "AstStatForIn":
            for v in st["values"]:
                self.visit_expr(v)
            body = loc(st["body"]["location"])
            names = self.forin_names(st)
            for idx_v, (var, nm) in enumerate(zip(st["vars"], names)):
                info = self.local_info(var, (body[0], body[1]))
                info["hint"] = nm
                info["loop_var"] = True
                if idx_v == 0 and len(st["vars"]) >= 2:
                    info["forin_first"] = True
            self.visit_block(st["body"])
            return
        if t in ("AstStatBlock",):
            self.visit_block(st)
            return
        if t == "AstStatIf":
            self.visit_expr(st["condition"])
            self.visit_block(st["thenbody"])
            e = st.get("elsebody")
            if e is not None:
                if e["type"] == "AstStatIf":
                    self.visit_stat(e, block_end)
                else:
                    self.visit_block(e)
            return
        if t == "AstStatWhile":
            self.visit_expr(st["condition"])
            self.visit_block(st["body"])
            return
        if t == "AstStatRepeat":
            self.visit_block(st["body"])
            self.visit_expr(st["condition"])
            return
        if t == "AstStatCompoundAssign":
            s_info, _ = self._record_slot_access(st["var"])
            if s_info is None:
                if st["var"].get("type") == "AstExprLocal":
                    info = self.locals.get(st["var"]["local"]["location"])
                    if info is not None:
                        info["reassigned"] = True
                self.visit_expr(st["var"])
            self.visit_expr(st["value"])
            return

        for k, v in st.items():
            if isinstance(v, dict) and v.get("type", "").startswith("AstExpr"):
                self.visit_expr(v)
            elif isinstance(v, list):
                for x in v:
                    if isinstance(x, dict) and x.get("type", "").startswith("AstExpr"):
                        self.visit_expr(x)

    def visit_expr(self, e):
        t = e.get("type")
        if t == "AstExprLocal":
            info = self.locals.get(e["local"]["location"])
            if info is not None:
                a, b = loc(e["location"])
                info["refs"].append(a)
                info["spans"].append((a, b))
                info["raw_use"] = True
            return
        if t == "AstExprGlobal":
            self.globals.add(e["global"])
            return
        if t == "AstExprIndexExpr":
            s_info, _ = self._record_slot_access(e)
            if s_info is not None:
                return
        if t == "AstExprIndexName":
            ex = e.get("expr", {})
            if ex.get("type") == "AstExprLocal":
                info = self.locals.get(ex["local"]["location"])
                if info is not None:
                    info["members"].add(e["index"])
            elif ex.get("type") == "AstExprIndexExpr":
                s_info, s_k = self._record_slot_access(ex)
                if s_info is not None:
                    s_info["slot_members"].setdefault(s_k, set()).add(e["index"])
                    return
        if t == "AstExprCall":
            f = e.get("func", {})
            if f.get("type") == "AstExprIndexExpr" and f["expr"].get("type") == "AstExprLocal" \
                    and const_str(f.get("index")) is None and const_slot_int(f.get("index")) is None:
                info = self.locals.get(f["expr"]["local"]["location"])
                if info is not None:
                    info["dispatch"] = True

            if f.get("type") == "AstExprIndexName" and f.get("index") in ("Connect", "Once", "ConnectParallel") \
                    and f["expr"].get("type") == "AstExprIndexName" and e.get("args"):
                params = SIGNAL_PARAMS.get(f["expr"]["index"])
                if params:
                    for k, v in e.items():
                        if k != "args" and isinstance(v, dict) and v.get("type", "").startswith("AstExpr"):
                            self.visit_expr(v)
                    for a in e["args"]:
                        self.visit_expr(a)
                    self.callback_params(e["args"][0], params)
                    return
            if f.get("type") == "AstExprLocal" and len(e.get("args") or []) >= 2 \
                    and e["args"][0].get("type") == "AstExprIndexName":
                f_info = self.locals.get(f["local"]["location"])
                if f_info and any(h.get("type") == "AstExprFunction" and self.function_name(h) == "trackConnection"
                                  for h, _ in f_info.get("hints", [])):
                    params = SIGNAL_PARAMS.get(e["args"][0]["index"])
                    if params:
                        self.visit_expr(f)
                        for a in e["args"]:
                            self.visit_expr(a)
                        self.callback_params(e["args"][1], params)
                        return
        if t == "AstExprBinary" and e.get("op") == "Concat" and e["right"].get("type") == "AstExprLocal":
            m = re.match(r"^([A-Za-z][A-Za-z ]{0,30}?)\s*[:=]\s*$", const_str(e["left"]) or "")
            info = self.locals.get(e["right"]["local"]["location"]) if m else None
            if info is not None:
                info.setdefault("label", camel(m.group(1)))
        if t == "AstExprFunction":
            body = loc(e["body"]["location"])
            arg_names = [a["name"] for a in e["args"]]
            for idx_a, a in enumerate(e["args"]):
                info = self.local_info(a, (loc(e["location"])[0], body[1]))
                info["hint"] = info["hint"] or "arg"
                info["is_param"] = True
                if arg_names.count(a["name"]) > 1 and idx_a < len(arg_names) - 1:
                    info["dup_param"] = True
            self.visit_block(e["body"])
            return
        for k, v in e.items():
            if isinstance(v, dict) and "type" in v:
                if v["type"] == "AstStatBlock":
                    self.visit_block(v)
                elif v["type"].startswith("AstExpr"):
                    self.visit_expr(v)
            elif isinstance(v, list):
                for x in v:
                    if isinstance(x, dict) and x.get("type", "").startswith("AstExpr"):
                        self.visit_expr(x)
                    elif isinstance(x, dict) and "value" in x and isinstance(x["value"], dict):
                        if isinstance(x.get("key"), dict):
                            self.visit_expr(x["key"])
                        self.visit_expr(x["value"])

    def callback_params(self, fn, params):
        """Name the parameters of a function (literal, or a local holding one) after the signal's."""
        if fn.get("type") == "AstExprLocal":
            info = self.locals.get(fn["local"]["location"])
            funcs = [h for h, _ in (info or {}).get("hints", []) if h.get("type") == "AstExprFunction"]
            if not funcs:
                return
            fn = funcs[0]
        if fn.get("type") != "AstExprFunction":
            return
        for a, nm in zip(fn["args"], params):
            info = self.locals.get(a["location"])
            if info is not None and info["hint"] in (None, "arg"):
                info["hint"] = nm

    def function_name(self, fn):
        """Infer descriptive function names from toggle, factory, wrapper, and getter bodies."""
        body = fn.get("body", {}).get("body", [])
        if not body:
            return None
        st = body[0]
        if st["type"] == "AstStatAssign" and len(st["vars"]) == 1 and len(st["values"]) == 1:
            var, val = st["vars"][0], st["values"][0]
            if var.get("type") == "AstExprIndexName" and val.get("type") == "AstExprUnary" \
                    and val.get("op") == "Not" and self.same(var, val["expr"]):
                return camel("toggle " + var["index"])
        last = body[-1]
        if len(body) == 1 and last["type"] == "AstStatReturn" and len(last.get("list", [])) == 1:
            ret = last["list"][0]
            if ret.get("type") == "AstExprCall":
                f = ret.get("func", {})
                if f.get("type") == "AstExprIndexName":
                    m = f["index"]
                    if m in ("GetService", "GetServerTimeNow", "FireServer", "InvokeServer",
                             "JSONDecode", "JSONEncode", "WaitForChild", "FindFirstChild"):
                        return camel(m)
                    if m.startswith(("Get", "Is", "Has", "Find", "Create")):
                        return camel(m)
            nm = self.infer(ret)
            if nm and nm not in WEAK and nm not in ("v", "arg"):
                return camel("get " + nm) if not nm.startswith(("get", "is", "has")) else nm
        if last["type"] == "AstStatReturn" and len(last.get("list", [])) == 1 \
                and last["list"][0].get("type") == "AstExprLocal":
            where = last["list"][0]["local"]["location"]
            for st in body:
                if st["type"] == "AstStatLocal" and len(st["vars"]) == 1 and st.get("values") \
                        and st["vars"][0]["location"] == where:
                    v = st["values"][0]
                    if v.get("type") == "AstExprCall" and dotted(v["func"]) in ("Instance.new", "Drawing.new") \
                            and v.get("args") and const_str(v["args"][0]):
                        return camel("create " + const_str(v["args"][0]))
                    if v.get("type") == "AstExprCall" and v["func"].get("type") == "AstExprIndexName" \
                            and v["func"]["index"] == "Connect":
                        return "trackConnection"
        return None

    def same(self, a, b):
        """Same variable path (locals by declaration, globals by name, .x chains)."""
        if a.get("type") != b.get("type"):
            return False
        t = a["type"]
        if t == "AstExprLocal":
            return a["local"]["location"] == b["local"]["location"]
        if t == "AstExprGlobal":
            return a["global"] == b["global"]
        if t == "AstExprIndexName":
            return a["index"] == b["index"] and self.same(a["expr"], b["expr"])
        return False

    def forin_names(self, st):
        n = len(st["vars"])
        vals = st["values"]
        first = vals[0] if vals else {}
        fn = dotted(first.get("func", {})) if first.get("type") == "AstExprCall" else None
        base = None
        if first.get("type") == "AstExprCall" and first.get("args"):
            a = first["args"][0]
            if a.get("type") == "AstExprLocal":
                base = ("local", a["local"]["location"])
            elif a.get("type") == "AstExprCall" and a["func"].get("type") == "AstExprIndexName":
                base = ("name", METHOD_NAMES.get(a["func"]["index"]))
            elif a.get("type") == "AstExprIndexName":
                base = ("name", camel(a["index"]))
        if first.get("type") == "AstExprCall" and first["func"].get("type") == "AstExprIndexName" \
                and first["func"]["index"] == "gmatch":
            return (["match"] + ["match%d" % i for i in range(2, n + 1)])[:n]
        key = "i" if fn == "ipairs" else "k"
        names = [key, ("v", base)] + ["v%d" % i for i in range(3, n + 1)]
        return names[:n]

    def infer(self, e, idx=0, _seen=()):
        t = e.get("type")
        if t == "AstExprLocal":
            src = self.locals.get(e["local"]["location"])
            if src is None or id(src) in _seen:
                return None
            if src.get("reassigned") and e.get("location"):
                use_pos = loc(e["location"])[0]
                last_nm = None
                for h_expr, h_idx in src.get("hints", ()):
                    if h_expr.get("location") and loc(h_expr["location"])[0] < use_pos:
                        cand = self.infer(h_expr, h_idx, _seen + (id(src),))
                        if cand:
                            last_nm = cand
                if last_nm and last_nm not in WEAK_1CHAR:
                    return strip_num_suffix(last_nm)
            if "new" in src and src["new"] not in WEAK_1CHAR and len(src["new"]) > 1:
                return strip_num_suffix(src["new"])
            nm = self.base_name(src, _seen + (id(src),))
            return strip_num_suffix(nm) if nm and nm not in WEAK_1CHAR else None
        if t == "AstExprGlobal":
            return GLOBAL_REFS.get(e["global"])
        if t == "AstExprCall":
            f = e["func"]
            d = dotted(f)
            if d in ("pcall", "xpcall"):
                return ["ok", "result"][min(idx, 1)]
            if idx > 0:
                return None
            if d == "require" and e["args"]:
                a = e["args"][0]
                if a.get("type") == "AstExprIndexName":
                    return a["index"]
                if a.get("type") == "AstExprCall" and a["func"].get("type") == "AstExprIndexName" \
                        and a["func"]["index"] in ("WaitForChild", "FindFirstChild") and a.get("args"):
                    nm = const_str(a["args"][0])
                    if nm and re.match(r"^[A-Za-z_]\w*$", nm):
                        return nm
                return "module"
            if d in ("Instance.new", "Drawing.new") and e["args"] and const_str(e["args"][0]):
                return camel(const_str(e["args"][0]))
            if d and "." in d and d.split(".")[0] in DATATYPES:
                return DATATYPES[d.split(".")[0]]
            if d in GLOBAL_CALLS:
                return GLOBAL_CALLS[d]
            if f.get("type") == "AstExprIndexName" and f.get("op") == ":":
                m = f["index"]
                arg = const_str(e["args"][0]) if e["args"] else None
                if m == "GetService" and arg and re.match(r"^[A-Za-z]\w*$", arg):
                    return arg
                if m in ("FindFirstChild", "WaitForChild", "FindFirstChildOfClass", "FindFirstChildWhichIsA",
                         "FindFirstAncestor", "FindFirstAncestorOfClass", "FindFirstAncestorWhichIsA") and arg:
                    return camel(arg)
                if m == "IsA" and arg:
                    return camel("is " + arg)
                if m in METHOD_NAMES:
                    return METHOD_NAMES[m]
                if m.startswith("Get") and len(m) > 3:
                    return camel(m[3:])
                return str_arg_name(e)
            if f.get("type") == "AstExprCall":
                inner = dotted(f.get("func", {}))
                if inner == "loadstring":
                    return "lib"
            if f.get("type") == "AstExprLocal":
                src = self.locals.get(f["local"]["location"])
                src_nm = strip_num_suffix((src.get("new") or "") if src else "")
                if src_nm == "getService" and e.get("args"):
                    arg = const_str(e["args"][0])
                    if arg and re.match(r"^[A-Za-z]\w*$", arg):
                        return arg
                nm = str_arg_name(e)
                if nm:
                    return nm
                for a in e.get("args") or []:
                    s = const_str(a)
                    if s is not None:
                        s = re.sub(r"\s*:\s*\w*$", "", s)
                        ok = re.match(r"^[A-Z][A-Za-z0-9 _]{1,30}$", s) and camel(s) not in KEYWORDS
                        return camel(s) if ok else None
            return str_arg_name(e)
        if t == "AstExprIndexName":
            d = dotted(e)
            if d in ("syn.request", "http.request"):
                return "httpRequest"
            if d and "." in d:
                head, tail = d.split(".", 1)
                if head == "bit32" and "." not in tail:
                    return camel(tail)
                if head in DATATYPES and "." not in tail:
                    return camel(head + " " + tail)
                if head in ("math", "string", "table", "task", "coroutine", "os", "buffer", "utf8") and "." not in tail:
                    return camel(head + " " + tail) if tail in KEYWORDS or tail in ("new", "create", "find", "sub", "format") else camel(tail)
            return camel(e["index"])
        if t == "AstExprIndexExpr":
            s = const_str(e.get("index"))
            return camel(s) if s else None
        if t == "AstExprFunction":
            return self.function_name(e) or "fn"
        if t == "AstExprTable":
            keys = {ent["key"]["value"] for ent in e.get("entries", [])
                    if isinstance(ent.get("key"), dict) and ent["key"].get("type") == "AstExprConstantString"}
            if keys & {"tpOk", "inDim"} or ("cleanup" in keys and len(keys) >= 2):
                return "state"
            if keys & {"Callback", "Title"} and len(keys) >= 2:
                return "options"
            return "tbl"
        if t == "AstExprBinary":
            if e["op"] == "Or":
                left = self.infer(e["left"], 0, _seen)
                if left and left not in WEAK:
                    return left
                return self.infer(e["right"], 0, _seen) or left
            if e["op"] == "And":
                right = self.infer(e["right"], 0, _seen)
                if right and right not in WEAK:
                    return right
                return self.infer(e["left"], 0, _seen) or right
            if e["op"].startswith("Compare"):
                return "flag"
            if e["op"] == "Concat":
                return "str"
            return "n"
        if t == "AstExprUnary":
            return "flag" if e["op"] == "Not" else "n"
        if t == "AstExprConstantBool":
            return "flag"
        if t == "AstExprConstantString":
            return string_semantic_name(e.get("value")) or "str"
        if t == "AstExprConstantNumber":
            return "n"
        if t == "AstExprGroup":
            return self.infer(e["expr"], idx, _seen)
        if t == "AstExprIfElse":
            return self.infer(e["trueExpr"], 0, _seen) or self.infer(e["falseExpr"], 0, _seen)
        return None

    def base_name(self, info, _seen=()):
        if info.get("spill"):
            return "ctx"
        if len(info["refs"]) == 1 and (info.get("forin_first") or info.get("dup_param")):
            return "_"
        duck = None if (info.get("is_param") and info.get("reassigned")) else duck_type_members(info["members"])
        h = info["hint"]
        if h == "arg":
            if duck:
                return duck
            if info.get("label") or info.get("prop"):
                return info.get("label") or info["prop"]
        if isinstance(h, tuple):
            key, base = h
            if base is not None:
                if base[0] == "local":
                    src = self.locals.get(base[1])
                    nm = singular(src.get("new")) if src else None
                    if nm:
                        return nm
                else:
                    nm = singular(base[1])
                    if nm:
                        return nm
            return duck or key
        if h:
            return h
        # Check if multiple distinct Instance.new classes were assigned to a scratch UI variable
        inst_classes = {
            const_str(ex["args"][0])
            for ex, idx in info["hints"]
            if idx == 0 and ex.get("type") == "AstExprCall"
            and dotted(ex["func"]) == "Instance.new" and ex.get("args") and const_str(ex["args"][0])
        }
        if len(inst_classes) >= 2:
            return "uiElement"
        if len(inst_classes) == 1 and len(info["hints"]) == 1 and len(info["inst_names"]) == 1:
            return info["inst_names"][0]
        for expr, idx in info["hints"]:
            nm = self.infer(expr, idx, _seen)
            if nm:
                if nm == "tbl" and info.get("dispatch"):
                    return "handlers"
                if nm in WEAK:
                    if duck:
                        return duck
                    if info.get("label") or info.get("prop"):
                        return info.get("label") or info["prop"]
                return nm
        return duck or info.get("label") or "v"

    def _should_rename(self, info):
        nm = info["name"]
        if nm == "_":
            if len(info["refs"]) <= 1:
                return False
            base = self.base_name(info)
            return bool(base and base not in WEAK_1CHAR)
        if info.get("spill"):
            return True
        if len(info["refs"]) == 1 and (info.get("forin_first") or info.get("dup_param")):
            return True
        if nm in KEEP_2UPPER:
            return False
        if GENERATED.match(nm):
            return True
        if SINGLE_CHAR.match(nm):
            if info.get("loop_var"):
                return True
            base = self.base_name(info)
            return bool(base and base not in WEAK_1CHAR)
        return False

    def _assign_spill_fields(self, info):
        all_keys = sorted({k for _, _, k in info["slot_spans"]})
        used = set(KEYWORDS)
        field_map = {}
        for k in all_keys:
            base = None
            for expr in info["slot_hints"].get(k, ()):
                nm = self.infer(expr)
                if nm and nm not in WEAK_1CHAR:
                    base = nm
                    break
                if nm and base is None:
                    base = nm
            if not base or base in WEAK_1CHAR:
                duck = duck_type_members(info["slot_members"].get(k))
                if duck:
                    base = duck
            if not base or base == "v":
                base = "slot%d" % k
            if not re.match(r"^[A-Za-z_]\w*$", base) or base in KEYWORDS:
                base = "slot%d" % k
            n = 1
            while True:
                cand = base if n == 1 else "%s%d" % (base, n)
                if cand not in used:
                    break
                n += 1
            used.add(cand)
            field_map[k] = cand
        info["slot_field_map"] = field_map

    def run(self):
        self.collect()
        for info in self.locals.values():
            if info["empty_tbl_init"] and not info["reassigned"] and not info["raw_use"] \
                    and len(info["slot_spans"]) >= 2 and len(info["slot_hints"]) >= 2 \
                    and all(b0[0] == b1[0] for b0, b1, _ in info["slot_spans"]):
                info["spill"] = True

        taken = {}
        reserved = self.globals | KEYWORDS
        ordered = sorted(self.order, key=lambda k: self.locals[k]["decl"])
        # First lock in genuinely descriptive existing names so generated ones never collide with them
        for key in ordered:
            info = self.locals[key]
            info["refs"].sort()
            nm = info["name"]
            if (nm != "_" and not GENERATED.match(nm) and not SINGLE_CHAR.match(nm)) or nm in KEEP_2UPPER:
                if not info.get("spill"):
                    info["new"] = nm
                    taken.setdefault(nm, []).append(info)
            elif nm == "_" and len(info["refs"]) <= 1:
                info["new"] = "_"
                taken.setdefault("_", []).append(info)

        # Next assign names in declaration order so downstream copies (`local b = a`) inherit `a["new"]`
        for key in ordered:
            info = self.locals[key]
            if "new" in info:
                continue
            if not self._should_rename(info):
                nm = info["name"]
                if nm not in reserved and self.fits(nm, info, taken):
                    info["new"] = nm
                    taken.setdefault(nm, []).append(info)
                    continue
            base = self.base_name(info)
            if base == "_" and len(info["refs"]) == 1:
                if self.fits_discard(info, taken):
                    info["new"] = "_"
                    taken.setdefault("_", []).append(info)
                    continue
                base = "unused"
            if not base or not re.match(r"^[A-Za-z_]\w*$", base) or base in reserved:
                base = (base or "v") + "_"
                if not re.match(r"^[A-Za-z_]\w*$", base):
                    base = "v"
            n = 1
            while True:
                cand = base if n == 1 else "%s%d" % (base, n)
                if cand not in reserved and self.fits(cand, info, taken):
                    break
                n += 1
            info["new"] = cand
            taken.setdefault(cand, []).append(info)

        for info in self.locals.values():
            if info.get("spill"):
                self._assign_spill_fields(info)

        return self.rewrite()

    def fits_discard(self, info, taken):
        """Allow `_` for an unread local whenever no other `_` is read inside `info`'s scope."""
        s0, s1 = info["scope"]
        for other in taken.get("_", ()):
            if any(s0 <= r <= s1 for r in other["refs"][1:]):
                return False
        return True

    def fits(self, cand, info, taken):
        """No other local named `cand` has a scope overlapping this one's: a
        generated name never shadows (Luau lint: LocalShadow), even where it
        would be legal because the outer one isn't referenced inside."""
        s0, s1 = info["scope"]
        for other in taken.get(cand, ()):
            o0, o1 = other["scope"]
            if s0 < o1 and o0 < s1:
                return False
        return True

    def rewrite(self):
        lines = self.text.split("\n")
        edits = {}
        total = skipped = 0
        for info in self.locals.values():
            if info.get("spill") and info.get("slot_field_map"):
                fmap = info["slot_field_map"]
                for b0, b1, k in info["slot_spans"]:
                    edits.setdefault(b0[0], []).append((b0[1], b1[1], None, "." + fmap[k]))
                    total += 1
            if info["new"] == info["name"]:
                continue
            for (a, b) in info["spans"]:
                edits.setdefault(a[0], []).append((a[1], b[1], info["name"], info["new"]))
                total += 1
        for ln, lst in edits.items():
            s = lines[ln].encode("utf-8")
            for c0, c1, old, new in sorted(lst, key=lambda x: (x[0], x[1]), reverse=True):
                seg = s[c0:c1]
                ok = (seg == old.encode("utf-8")) if old is not None else (
                    seg.lstrip().startswith(b"[") and seg.rstrip().endswith(b"]")
                )
                if ok:
                    s = s[:c0] + new.encode("utf-8") + s[c1:]
                else:
                    skipped += 1
            lines[ln] = s.decode("utf-8")
        if skipped:
            print("[!] naming: %d/%d rename(s) skipped (source offset drift); "
                  "affected locals keep their original names" % (skipped, total), file=sys.stderr)
        return "\n".join(lines)


def rename_text(text):
    return Namer(text).run()


def main():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("file")
    ap.add_argument("-o", "--output")
    a = ap.parse_args()
    with open(a.file, encoding="utf-8") as f:
        text = f.read()
    out = rename_text(text)
    with open(a.output or a.file, "w", encoding="utf-8", newline="\n") as f:
        f.write(out)


if __name__ == "__main__":
    main()
