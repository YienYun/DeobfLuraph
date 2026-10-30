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


def plural(name):
    if not name or name in KEYWORDS:
        return None
    if name.endswith(("List", "Map", "Set", "Data", "Options", "Props", "Info", "Cache", "State", "Palette", "s")):
        return name
    if name.endswith("y") and len(name) > 2 and name[-2].lower() not in "aeiou":
        return name[:-1] + "ies"
    return name + "s"


_NOISE_WORDS = {
    "the", "and", "for", "with", "from", "into", "true", "false", "nil", "none", "off",
    "all", "any", "new", "old", "get", "set", "has", "can", "auto", "is", "in", "on", "to",
    "by", "of", "at", "or", "not", "max", "min", "cur", "last", "first", "next", "prev",
    "good", "bad", "ready", "active", "most", "least", "lowest", "highest", "default",
    "main", "sub", "item", "value", "key", "data", "info", "type", "kind", "mode", "state",
}

_ROBLOX_CLASSES = {
    "Part", "BasePart", "MeshPart", "UnionOperation", "Model", "Folder", "Configuration",
    "Attachment", "Weld", "WeldConstraint", "Motor6D", "JointInstance", "Constraint",
    "BodyMover", "BodyVelocity", "BodyPosition", "BodyGyro", "LinearVelocity", "AlignPosition",
    "AlignOrientation", "Sound", "ForceField", "Highlight", "ProximityPrompt", "ClickDetector",
    "BillboardGui", "SurfaceGui", "ScreenGui", "Frame", "ScrollingFrame", "TextLabel",
    "TextButton", "TextBox", "ImageLabel", "ImageButton", "ViewportFrame", "CanvasGroup",
    "UIStroke", "UICorner", "UIGradient", "UIListLayout", "UIGridLayout", "UIPadding",
    "UIScale", "UIAspectRatioConstraint", "LuaSourceContainer", "Script", "LocalScript",
    "ModuleScript", "RemoteEvent", "RemoteFunction", "BindableEvent", "BindableFunction",
    "ParticleEmitter", "Beam", "Trail", "PointLight", "SpotLight", "SurfaceLight",
    "Accessory", "Tool", "Humanoid", "Animator", "Animation",
}

_GUI_PART_PROPS = {
    "Anchored", "BackgroundColor3", "BackgroundTransparency", "BorderColor3", "BorderSizePixel",
    "CanCollide", "CanTouch", "CanvasPosition", "CanvasSize", "CFrame", "ClipsDescendants",
    "Color", "CornerRadius", "DisplayOrder", "Enabled", "FieldOfView", "FillDirection", "Font",
    "Health", "HorizontalAlignment", "Image", "ImageColor3", "ImageTransparency", "JumpPower",
    "LayoutOrder", "LineJoinMode", "Material", "MaxHealth", "MaxTextSize", "MinTextSize",
    "MoveDirection", "Name", "Orientation", "Padding", "PaddingBottom", "PaddingLeft",
    "PaddingRight", "PaddingTop", "Position", "RichText", "Rotation", "ScrollBarThickness",
    "Size", "SortOrder", "Text", "TextColor3", "TextScaled", "TextSize", "TextStrokeColor3",
    "TextStrokeTransparency", "TextTransparency", "TextTruncate", "TextWrapped",
    "TextXAlignment", "TextYAlignment", "Thickness", "Transparency", "Value", "Velocity",
    "VerticalAlignment", "Visible", "WalkSpeed", "ZIndex",
}


def _words_of_string(s):
    if not s or len(s) > 64 or "/" in s or ":" in s or "." in s:
        return []
    raw = re.findall(r"[A-Z]?[a-z]+|[A-Z]+(?=[A-Z][a-z]|\b)", s)
    return [w.lower() for w in raw if len(w) >= 3 and w.lower() not in _NOISE_WORDS]


def _dominant_string_noun(strings, suffix="List"):
    """Find a shared domain noun across a list/set of strings (e.g. 'LimitedEgg',
    'MonsterEgg' -> 'eggList'; 'Radiant Butterfly', 'Sapphire Butterfly' -> 'butterflyList')."""
    valid = [s for s in strings if isinstance(s, str) and s.strip()]
    if len(valid) < 2:
        return None
    tail_counts = {}
    any_counts = {}
    tokenized = 0
    for s in valid:
        ws = _words_of_string(s)
        if not ws:
            continue
        tokenized += 1
        tail_counts[ws[-1]] = tail_counts.get(ws[-1], 0) + 1
        for w in set(ws):
            any_counts[w] = any_counts.get(w, 0) + 1
    if tokenized < 2:
        return None
    best_tail = max(tail_counts.items(), key=lambda kv: kv[1]) if tail_counts else (None, 0)
    if best_tail[1] >= 2 and best_tail[1] * 100 >= tokenized * 40:
        return camel(best_tail[0] + " " + suffix)
    best_any = max(any_counts.items(), key=lambda kv: kv[1]) if any_counts else (None, 0)
    if best_any[1] >= 2 and best_any[1] * 100 >= tokenized * 50:
        return camel(best_any[0] + " " + suffix)
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
                "elem_hints": [], "index_keys": [], "concat_tbl": False, "disconnect_map": False,
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
                    t_items = val.get("items") if val.get("items") is not None else val.get("entries")
                    if val.get("type") == "AstExprTable" and not t_items:
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
                if var.get("type") == "AstExprIndexExpr" and var["expr"].get("type") == "AstExprLocal" \
                        and const_slot_int(var.get("index")) is None:
                    t_info = self.locals.get(var["expr"]["local"]["location"])
                    if t_info is not None:
                        idx_e = var.get("index", {})
                        if idx_e.get("type") == "AstExprBinary" and idx_e.get("op") == "Add":
                            t_info["elem_hints"].append(v)
                        elif const_str(idx_e):
                            t_info["members"].add(const_str(idx_e))
                        else:
                            t_info["index_keys"].append(idx_e)
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
            d_call = dotted(f)
            if d_call == "table.insert" and len(e.get("args") or []) >= 2 \
                    and e["args"][0].get("type") == "AstExprLocal":
                t_info = self.locals.get(e["args"][0]["local"]["location"])
                if t_info is not None:
                    t_info["elem_hints"].append(e["args"][-1])
            elif d_call == "table.concat" and (e.get("args") or []) \
                    and e["args"][0].get("type") == "AstExprLocal":
                t_info = self.locals.get(e["args"][0]["local"]["location"])
                if t_info is not None:
                    t_info["concat_tbl"] = True
            elif f.get("type") == "AstExprIndexName" and f.get("index") == "Disconnect":
                recv = f.get("expr", {})
                if recv.get("type") == "AstExprIndexExpr" and recv["expr"].get("type") == "AstExprLocal":
                    t_info = self.locals.get(recv["expr"]["local"]["location"])
                    if t_info is not None:
                        t_info["disconnect_map"] = True
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

    def _ctor_datatype(self, e):
        """If `e` constructs a Roblox datatype (`Color3.new(...)`, local alias
        `uDim2New(...)`, etc.), return its canonical datatype name ('Color3',
        'UDim2', 'Vector2', 'Vector3', 'UDim', 'CFrame'), else None."""
        if not isinstance(e, dict) or e.get("type") != "AstExprCall":
            return None
        f = e.get("func", {})
        d = dotted(f)
        if d and "." in d:
            head = d.split(".", 1)[0]
            if head in ("Color3", "UDim2", "Vector2", "Vector3", "UDim", "CFrame", "TweenInfo", "ColorSequenceKeypoint"):
                return head
        if f.get("type") == "AstExprLocal":
            src = self.locals.get(f["local"]["location"])
            cands = [strip_num_suffix((src.get("new") or src.get("name") or "") if src else "").lower()]
            for h_ex, h_i in (src.get("hints", ()) if src else ()):
                if h_i == 0:
                    hd = dotted(h_ex)
                    if hd:
                        cands.append(hd.lower())
            for raw in cands:
                for dt in ("color3", "udim2", "vector2", "vector3", "udim", "cframe"):
                    if raw.startswith(dt):
                        return {"color3": "Color3", "udim2": "UDim2", "vector2": "Vector2",
                                "vector3": "Vector3", "udim": "UDim", "cframe": "CFrame"}[dt]
        return None

    def _scan_fn_shallow(self, blk, out):
        """Collect returns, calls, string literals, globals, and member accesses
        in a function body without descending into unrelated nested functions
        (except immediate `pcall(function() ... end)` thunks)."""
        for st in blk.get("body", ()):
            self._scan_node_shallow(st, out, allow_rets=True)

    def _scan_node_shallow(self, node, out, allow_rets=True):
        if not isinstance(node, dict):
            return
        tp = node.get("type", "")
        if tp == "AstExprFunction":
            return
        if tp.startswith("AstStat"):
            out["stmt_count"] = out.get("stmt_count", 0) + 1
        if tp == "AstStatReturn" and allow_rets:
            for r in node.get("list", ()):
                if r.get("type") != "AstExprConstantNil":
                    out["rets"].append(r)
        if tp == "AstExprConstantString":
            s = node.get("value")
            if isinstance(s, str):
                out["strs"].append(s)
            return
        if tp == "AstExprGlobal":
            out["globals"].add(node.get("global", ""))
            return
        if tp == "AstExprLocal":
            src = self.locals.get(node["local"]["location"])
            if src:
                out["local_refs"].add(strip_num_suffix(src.get("new") or src.get("name") or ""))
            return
        if tp == "AstExprCall":
            f = node.get("func", {})
            d = dotted(f)
            if d:
                out["calls"].add(d)
            elif f.get("type") == "AstExprIndexName":
                out["methods"].add(f["index"])
            elif f.get("type") == "AstExprLocal":
                src = self.locals.get(f["local"]["location"])
                if src:
                    out["local_calls"].add(strip_num_suffix(src.get("new") or src.get("name") or ""))
            # Descend into immediate `pcall(function() ... end)` / `xpcall` body for calls/props (not outer returns)
            is_pcall = d in ("pcall", "xpcall")
            if not is_pcall and f.get("type") == "AstExprLocal":
                f_src = self.locals.get(f["local"]["location"])
                if f_src and any(dotted(hx) in ("pcall", "xpcall") for hx, hi in f_src.get("hints", ()) if hi == 0):
                    is_pcall = True
            if is_pcall:
                for a_node in node.get("args", ()):
                    if isinstance(a_node, dict) and a_node.get("type") == "AstExprFunction":
                        for p_st in a_node.get("body", {}).get("body", ()):
                            self._scan_node_shallow(p_st, out, allow_rets=False)
        elif tp == "AstExprIndexName":
            out["props"].add(node.get("index", ""))
        for k, v in node.items():
            if k == "location":
                continue
            if isinstance(v, dict):
                self._scan_node_shallow(v, out, allow_rets=allow_rets)
            elif isinstance(v, list):
                for item in v:
                    if isinstance(item, dict):
                        self._scan_node_shallow(item, out, allow_rets=allow_rets)

    def function_name(self, fn):
        """Infer descriptive function names from toggle, factory, parser,
        formatter, remote, filesystem, and helper bodies."""
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
            ret_info = self.locals.get(where)
            if ret_info and "Window" in ret_info.get("members", set()):
                return "createUiLibrary"
            for st_i in body:
                if st_i["type"] == "AstStatLocal" and len(st_i["vars"]) == 1 and st_i.get("values") \
                        and st_i["vars"][0]["location"] == where:
                    v = st_i["values"][0]
                    if v.get("type") == "AstExprCall" and dotted(v["func"]) in ("Instance.new", "Drawing.new") \
                            and v.get("args") and const_str(v["args"][0]):
                        return camel("create " + const_str(v["args"][0]))
                    if v.get("type") == "AstExprCall" and v["func"].get("type") == "AstExprIndexName" \
                            and v["func"]["index"] == "Connect":
                        return "trackConnection"
                    if v.get("type") == "AstExprCall" and len(v.get("args") or []) >= 2 \
                            and v["args"][1].get("type") == "AstExprTable":
                        for ent in (v["args"][1].get("items") or v["args"][1].get("entries") or ()):
                            if isinstance(ent.get("key"), dict) and const_str(ent["key"]) == "Name" \
                                    and const_str(ent.get("value")):
                                c_nm = camel("create " + const_str(ent["value"]))
                                if c_nm and c_nm not in KEYWORDS:
                                    return c_nm

        if len(body) > 45:
            return None
        scan = {
            "rets": [], "calls": set(), "methods": set(), "local_calls": set(),
            "local_refs": set(), "globals": set(), "strs": [], "props": set(), "stmt_count": 0,
        }
        self._scan_fn_shallow(fn.get("body", {}), scan)
        n_stmts = scan["stmt_count"]
        if n_stmts > 45:
            return None
        rets = scan["rets"]
        calls = scan["calls"] | scan["globals"]
        methods = scan["methods"]
        lcalls = scan["local_calls"] | scan["local_refs"]
        strs = scan["strs"]
        props = scan["props"]
        has_args = bool(fn.get("args"))

        # 1. Pure datatype parser / converter functions (e.g. parseColor3, toUDim2, toVector2, toUDim)
        if rets:
            dts = {self._ctor_datatype(r) for r in rets}
            if len(dts) == 1 and None not in dts:
                dt = next(iter(dts))
                prefix = "parse" if n_stmts >= 6 and has_args else ("to" if has_args else "get")
                return prefix + dt

        # 2. Filesystem & JSON config helpers
        if "makefolder" in calls and "writefile" not in calls and n_stmts <= 12:
            return "ensureFolder"
        if "writefile" in calls and n_stmts <= 18:
            if any("Chat" in s for s in strs):
                return "saveSeenChat"
            return "saveFile"
        if "readfile" in calls and n_stmts <= 24:
            if any("Chat" in s for s in strs):
                return "loadSeenChat"
            if "JSONDecode" in methods or "HttpService.JSONDecode" in calls:
                return "readJsonFile"
            return "readCachedFile"
        if "delfile" in calls and n_stmts <= 10:
            return "deleteFile"

        # 3. RichText / compact number / rate / vararg formatters & math helpers
        if "table.concat" in calls and "select" in calls and "tostring" in calls and n_stmts <= 15:
            return "formatArgs"
        if "Disconnect" in methods and "table.clear" in calls and n_stmts <= 15:
            return "disconnectAll"
        if "loadstring" in calls and n_stmts <= 25:
            return "compileChunk"
        if "getfenv" in calls and "setmetatable" in calls and n_stmts <= 25:
            return "createSandboxEnv"
        if "math.log10" in calls and n_stmts <= 16:
            return "roundSigFigs"
        if ("math.clamp" in calls or ("math.max" in calls and "math.min" in calls)) and not methods and n_stmts <= 12:
            return "clampValue"
        if ("math.round" in calls or "tonumber" in calls) and not methods and len(rets) >= 1 and n_stmts <= 10:
            return "roundValue" if "math.round" in calls else "toNumberOrDefault"
        if has_args and any("<font color=" in s for s in strs) and n_stmts <= 15:
            return "colorizeText"
        if has_args and any(s in (" K/s", " M/s", " B/s") for s in strs) and n_stmts <= 20:
            return "formatRate"
        if has_args and any(s in ("k", "K", "M", "B", "T") or s.startswith("$%.") for s in strs) and n_stmts <= 18:
            return "formatCompact"
        if has_args and ("string.format" in calls or "format" in methods) \
                and any(s in ("%.2f", "%.1f", "%.0f") for s in strs) and "0+$" in strs and n_stmts <= 12:
            return "formatDecimal"

        # 4. Roblox Instance / Tween / Remote / HTTP / State helpers
        if "Cancel" in methods and ("Create" in methods or "tw" in lcalls or "TweenService" in (calls | lcalls)) and n_stmts <= 16:
            return "playTween"
        if "Destroy" in methods and not rets and n_stmts <= 15:
            return "destroyAll"
        if "Raycast" in methods and n_stmts <= 25:
            return "raycastGround"
        if "os.clock" in calls and not rets and has_args and n_stmts <= 18:
            return "runUntilTimeout"
        if "table.insert" in calls and not rets and has_args and n_stmts <= 6:
            return "registerItem"
        if "GetFullName" in (methods | props) and n_stmts <= 12:
            return "getInstancePath"
        if "Archivable" in props and "Clone" in (methods | props) and n_stmts <= 20:
            return "cloneInstance"
        if "closeDD" in (methods | props) and n_stmts <= 8:
            return "closeDropdown"
        if "UnbindFromRenderStep" in (methods | props) and n_stmts <= 18:
            return "cleanupRenderStep"
        if ("httpRequest" in lcalls or "request" in calls or "http_request" in calls or "syn.request" in calls) \
                and ("JSONEncode" in (methods | props) or "POST" in strs) and n_stmts <= 35:
            return "sendHeartbeat" if ("beatUrl" in lcalls or any("beat" in s.lower() for s in strs)) else "sendHttpPost"
        if "InvokeServer" in methods and len(body) <= 12:
            return "invokeRemote"
        if "FireServer" in methods and len(body) <= 12:
            return "fireRemote"
        if "Carried" in strs and "CarrierUserId" in props and len(body) <= 15:
            return "isCarried"
        if len(rets) == 1 and rets[0].get("type") == "AstExprBinary":
            rop = rets[0].get("op", "")
            if rop.startswith("Compare"):
                if "Health" in props and len(body) <= 12:
                    return "isAlive"
                r_right = rets[0].get("right", {})
                if r_right.get("type") == "AstExprLocal":
                    r_info = self.locals.get(r_right["local"]["location"])
                    r_nm = (r_info.get("new") or r_info.get("name") or "") if r_info else ""
                    if "bagMax" in r_nm and len(body) <= 10:
                        return "isBagFull"
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

        def _base_from_container(a):
            if not isinstance(a, dict):
                return None
            if a.get("type") == "AstExprLocal":
                return ("local", a["local"]["location"])
            if a.get("type") == "AstExprCall":
                cf = a.get("func", {})
                if cf.get("type") == "AstExprIndexName":
                    mn = METHOD_NAMES.get(cf["index"])
                    if not mn and cf["index"].startswith("Get") and len(cf["index"]) > 3:
                        mn = camel(cf["index"][3:])
                    return ("name", mn) if mn else None
                if cf.get("type") == "AstExprLocal":
                    f_src = self.locals.get(cf["local"]["location"])
                    f_nm = strip_num_suffix((f_src.get("new") or f_src.get("name") or "") if f_src else "")
                    for vp in ("get", "find", "list", "collect", "fetch"):
                        if f_nm.startswith(vp) and len(f_nm) > len(vp) and f_nm[len(vp)].isupper():
                            return ("name", camel(f_nm[len(vp):]))
            if a.get("type") == "AstExprIndexName":
                return ("name", camel(a["index"]))
            return None

        if first.get("type") == "AstExprCall" and first.get("args"):
            base = _base_from_container(first["args"][0])
        elif first.get("type") == "AstExprGlobal" and first.get("global") == "next" and len(vals) >= 2:
            base = _base_from_container(vals[1])
        elif len(vals) == 1:
            base = _base_from_container(first)
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
            if f.get("type") == "AstExprIndexName" and f.get("op") in (":", "."):
                m = f["index"]
                arg = const_str(e["args"][0]) if e["args"] else None
                if m == "GetService" and arg and re.match(r"^[A-Za-z]\w*$", arg):
                    return arg
                if m in ("FindFirstChild", "WaitForChild", "FindFirstChildOfClass", "FindFirstChildWhichIsA",
                         "FindFirstAncestor", "FindFirstAncestorOfClass", "FindFirstAncestorWhichIsA") and arg:
                    return camel(arg)
                if m == "IsA" and arg:
                    return camel("is " + arg)
                if m == "GetDefaultTab":
                    return "defaultTab"
                if m in ("CreateWindow", "Window"):
                    return "mainWindow"
                if m in ("CreateTab", "AddTab", "Tab", "CreateSection", "AddSection", "Section",
                         "CreateToggle", "AddToggle", "CreateDropdown", "AddDropdown",
                         "CreateSlider", "AddSlider", "CreateInput", "AddInput",
                         "CreateButton", "AddButton", "CreateParagraph", "AddParagraph",
                         "CreateColorpicker", "CreateKeybind"):
                    suffix = re.sub(r"^(Create|Add)", "", m)
                    lbl = None
                    if e.get("args") and e["args"][0].get("type") == "AstExprTable":
                        for ent in (e["args"][0].get("items") or e["args"][0].get("entries") or ()):
                            if isinstance(ent.get("key"), dict) and const_str(ent["key"]) in ("Name", "Title"):
                                lbl = const_str(ent.get("value"))
                                break
                    elif arg:
                        lbl = arg
                    if lbl and re.match(r"^[A-Za-z][A-Za-z0-9 _/-]{1,24}$", lbl):
                        c_nm = camel(lbl + " " + suffix)
                        if c_nm and c_nm not in KEYWORDS:
                            return c_nm
                    return camel(suffix)
                if m in METHOD_NAMES:
                    return METHOD_NAMES[m]
                if m.startswith("Get") and len(m) > 3:
                    return camel(m[3:])
                if f.get("op") == "." and e.get("args"):
                    a0_nm = self.infer(e["args"][0], 0, _seen)
                    if a0_nm and a0_nm not in WEAK_1CHAR:
                        return a0_nm
                return str_arg_name(e)
            if f.get("type") == "AstExprCall":
                inner = dotted(f.get("func", {}))
                if inner == "loadstring":
                    return "lib"
            if f.get("type") == "AstExprLocal":
                src = self.locals.get(f["local"]["location"])
                src_nm = strip_num_suffix((src.get("new") or src.get("name") or "") if src else "")
                if src_nm == "getService" and e.get("args"):
                    arg = const_str(e["args"][0])
                    if arg and re.match(r"^[A-Za-z]\w*$", arg):
                        return arg
                for vp in ("get", "find", "load", "read", "create", "build", "make", "parse", "clone", "resolve", "fetch"):
                    if src_nm.startswith(vp) and len(src_nm) > len(vp) and src_nm[len(vp)].isupper():
                        stem = camel(src_nm[len(vp):])
                        if stem and stem not in KEYWORDS and stem not in WEAK_1CHAR:
                            return stem
                if src_nm in ("formatArgs", "formatRate", "formatCompact", "formatDecimal", "colorizeText"):
                    return "formattedText"
                if src_nm in ("clampValue", "roundValue", "roundSigFigs", "toNumberOrDefault"):
                    return "numVal"
                if src_nm.startswith(("is", "has", "can", "should")) and len(src_nm) > 3 and src_nm[2:3].isupper():
                    return camel(src_nm)
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
            if s:
                return camel(s)
            obj_nm = self.infer(e.get("expr"), 0, _seen)
            if obj_nm and obj_nm not in WEAK_1CHAR:
                if obj_nm.endswith("Map") and len(obj_nm) > 3:
                    stem = obj_nm[:-3]
                    return "entry" if stem in ("id", "uid", "key", "value", "label") else camel(stem + " entry")
                sg = singular(obj_nm)
                if sg and sg not in KEYWORDS and sg not in WEAK_1CHAR and sg != obj_nm:
                    return sg
                if obj_nm in ("hdr", "headers"):
                    return "headerEntry"
            return None
        if t == "AstExprFunction":
            return self.function_name(e) or "fn"
        if t == "AstExprTable":
            return self.table_name(e, None, _seen)
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

    def table_name(self, e, info=None, _seen=()):
        """Infer a semantic name for a Luau table literal from its entries,
        keys, element types, string nouns, and downstream member/element uses."""
        entries = e.get("items") if e.get("items") is not None else e.get("entries", [])
        kv = {}
        arr = []
        for ent in entries:
            k = ent.get("key")
            v = ent.get("value")
            if isinstance(k, dict) and k.get("type") == "AstExprConstantString":
                kv[k["value"]] = v
            elif k is None and isinstance(v, dict):
                arr.append(v)

        members = set(kv) | (set(info["members"]) if info else set())

        # 1. Well-known structural shapes
        if members & {"tpOk", "inDim"} or ("cleanup" in members and len(members) >= 2):
            return "state"
        if members & {"Callback", "Title"} and len(members) >= 2:
            return "options"
        if "Url" in members and (members & {"Method", "Headers", "Body"}):
            return "requestData"
        if "Value" in members and "Set" in members:
            return "control"
        if {"Center", "Distance", "Zoom"} <= members:
            return "cameraOrbit"
        if {"Rows", "Header"} <= members:
            return "tableView"
        if {"Tabs", "Opts"} <= members:
            return "window"
        if {"Hud", "Eggs"} <= members:
            return "hudElements"
        if {"On", "Toggle"} <= members:
            return "toggleState"
        if {"live", "off"} <= members and (members & {"active", "ready", "wait"}):
            return "statusStyles"
        if {"Toggle", "Slider", "Dropdown"} <= members:
            return "widgetSpecs"
        if {"left", "center", "right"} <= members and len(members) <= 5:
            return "alignments"
        if {"links", "rig", "body"} <= members:
            return "rigState"
        if {"Icon", "Name", "Chip"} <= members:
            return "cardWidgets"
        if {"pn", "hd", "body"} <= members:
            return "sectionView"
        if {"sty", "root", "el"} <= members:
            return "richView"
        if ({"ok", "err"} <= members or {"ok", "data"} <= members) and len(members) <= 5:
            return "response"
        if "hdr" in members and len(members) <= 4:
            return "groupState"

        # 2. Named item / egg / entity record (`{..., Name = "Halloween egg", Uid = "carry"}`)
        if "Name" in kv and "Parent" not in members and "Size" not in members and "Position" not in members:
            nm_s = const_str(kv["Name"])
            if nm_s and re.match(r"^[A-Za-z][A-Za-z0-9 _-]{1,28}$", nm_s):
                c = camel(nm_s)
                if c and c not in KEYWORDS and c not in WEAK_1CHAR:
                    return c

        # 3. Unit multiplier / suffix tables
        if kv and set(kv) <= {"k", "m", "b", "t", "qa", "qi", "sx", "K", "M", "B", "T"} and len(kv) >= 3:
            return "unitMultipliers"
        arr_strs = [const_str(x) for x in arr if const_str(x) is not None]
        if len(arr_strs) >= 4 and len(arr_strs) == len(arr) \
                and set(arr_strs) <= {"", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "k", "m", "b", "t"}:
            return "unitSuffixes"

        # 4. Key-value maps (Enum maps, boolean property filters, function dispatchers, score maps)
        if len(kv) >= 2 and not arr:
            vals = list(kv.values())
            if all(dotted(v) and dotted(v).startswith("Enum.") for v in vals):
                return "enumProps"
            if all(v.get("type") == "AstExprConstantBool" for v in vals):
                kset = set(kv) | (set(info["members"]) if info else set())
                if all(k.endswith(("Color", "Color3")) for k in kset):
                    return "colorProps"
                if kset <= {"Position", "Size", "CanvasSize", "CanvasPosition"}:
                    return "udim2Props"
                if kset <= {"AnchorPoint", "CanvasPosition"}:
                    return "vector2Props"
                if "CornerRadius" in kset or any(k.startswith("Padding") for k in kset):
                    return "udimProps"
                if kset & {"Activated", "MouseButton1Click", "FocusLost", "InputBegan", "TouchTap"}:
                    return "eventNames"
                if len(kset & _GUI_PART_PROPS) >= max(4, len(kset) // 2):
                    return "allowedProps"
                dom = _dominant_string_noun(list(kset), "Flags")
                return dom or "enabledFlags"
            if sum(1 for v in vals if v.get("type") == "AstExprFunction") >= max(2, len(vals) - 1):
                klow = " ".join(kv).lower()
                if any(w in klow for w in ("rarity", "lowest", "highest", "copies")):
                    return "sortComparators"
                if any(w in klow for w in ("ping", "eval", "get_tree", "set_property", "click", "teleport")) \
                        or (info and info.get("dispatch")):
                    return "commandHandlers"
                return "handlers"
            if all(v.get("type") == "AstExprConstantNumber" for v in vals):
                dom = _dominant_string_noun(list(kv), "Values")
                return dom or "valueMap"
            if all(v.get("type") == "AstExprConstantString" for v in vals):
                dom = _dominant_string_noun(list(kv) + [const_str(v) for v in vals], "Map")
                return dom or "labelMap"
            if all(v.get("type") == "AstExprTable" for v in vals):
                dom = _dominant_string_noun(list(kv), "Configs")
                return dom or "configMap"
            if {"Default", "Labels"} <= set(kv):
                return "priorityConfig"

        # 5. Homogeneous array literals (`{Color3..., }`, `{Enum..., }`, string lists, nested presets)
        if arr and not kv:
            dts = [self._ctor_datatype(x) for x in arr]
            if all(d == "Color3" for d in dts):
                return "colorPalette"
            if all(d == "ColorSequenceKeypoint" for d in dts):
                return "keypoints"
            if all(x.get("type") == "AstExprTable" for x in arr):
                # Nested array of Color3 pairs or string presets or weight tiers
                sub_entries = [(x.get("items") if x.get("items") is not None else x.get("entries", [])) for x in arr]
                if sub_entries and all(
                    se and all(e0.get("key") is None and self._ctor_datatype(e0.get("value")) == "Color3" for e0 in se)
                    for se in sub_entries
                ):
                    return "colorPalettes"
                sub_keys = [
                    {e0["key"]["value"] for e0 in se if isinstance(e0.get("key"), dict) and const_str(e0["key"])}
                    for se in sub_entries
                ]
                if sub_keys and all({"min", "max", "weight"} <= sk for sk in sub_keys):
                    return "weightTiers"
                nested_strs = [
                    const_str(e0.get("value"))
                    for se in sub_entries for e0 in se
                    if e0.get("key") is None and const_str(e0.get("value"))
                ]
                dom = _dominant_string_noun(nested_strs, "Presets")
                if dom:
                    return dom
            enum_types = []
            for x in arr:
                dx = dotted(x)
                if dx and dx.startswith("Enum.") and dx.count(".") == 2:
                    enum_types.append(dx.split(".")[1])
            if len(enum_types) == len(arr) and len(set(enum_types)) == 1:
                return plural(camel(enum_types[0])) or "enumItems"
            if all(x.get("type") == "AstExprCall" and x["func"].get("type") == "AstExprIndexName"
                   and x["func"]["index"] in ("Connect", "Once") for x in arr):
                return "connections"
            if len(arr_strs) == len(arr) and len(arr_strs) >= 2:
                if sum(1 for s in arr_strs if s in _ROBLOX_CLASSES) >= max(2, len(arr_strs) // 2):
                    return "classNames"
                dom = _dominant_string_noun(arr_strs, "List")
                if dom:
                    return dom
                return "nameList"

        # 6. Downstream usage on initially-empty tables (`local tbl = {}`)
        if info is not None:
            if info.get("disconnect_map"):
                return "connections"
            if info.get("dispatch"):
                return "handlers"
            if info.get("concat_tbl"):
                return "parts"
            if info.get("elem_hints"):
                for eh in info["elem_hints"]:
                    el_nm = self.infer(eh, 0, _seen + (id(info),))
                    if el_nm and el_nm not in WEAK_1CHAR:
                        pl = plural(el_nm)
                        if pl and pl not in KEYWORDS:
                            return pl
                return "list"
            if len(members) >= 2 and all(m in _GUI_PART_PROPS for m in members):
                return "allowedProps"
            if info.get("index_keys"):
                for ik in info["index_keys"]:
                    ik_nm = self.infer(ik, 0, _seen + (id(info),))
                    if ik_nm and ik_nm not in WEAK_1CHAR and len(ik_nm) <= 18:
                        return camel(ik_nm + " map")

        return "tbl"

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
            nm = self.table_name(expr, info, _seen) if (idx == 0 and expr.get("type") == "AstExprTable") \
                else self.infer(expr, idx, _seen)
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
