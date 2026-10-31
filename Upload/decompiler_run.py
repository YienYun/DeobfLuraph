import sys
import base64

def _ensure_luna():
    try:
        import luna
        return luna
    except ImportError:
        pass
    import pathlib
    here = str(pathlib.Path(__file__).resolve().parent)
    if here not in sys.path:
        sys.path.insert(0, here)
    import luna
    return luna

luna = _ensure_luna()


def decompile(bytecode):
    return luna.decompile_bytecode(bytecode, {}, '')


def try_decompile(bytecode):
    try:
        return decompile(bytecode)
    except luna.DeserializationError:
        decoded = _try_b64_decode(bytecode)
        if decoded:
            try:
                return decompile(decoded)
            except Exception as e:
                return f'-- Error: {e}'
        return f'-- Error: invalid Luau bytecode ({len(bytecode)} bytes)'
    except Exception as e:
        return f'-- Error: {e}'


def _try_b64_decode(data):
    try:
        decoded = base64.b64decode(data)
        if decoded != data:
            return decoded
    except Exception:
        pass
    return None


if __name__ == '__main__':
    in_path, out_path = sys.argv[1], sys.argv[2]
    with open(in_path, 'rb') as f:
        bytecode = f.read()
    if not bytecode:
        result = '-- Error: empty bytecode'
    else:
        result = try_decompile(bytecode)
    with open(out_path, 'w', encoding='utf-8', errors='replace') as f:
        f.write(result)