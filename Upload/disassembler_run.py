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


def _is_luau_bytecode(data):
    if len(data) < 4:
        return False
    return data[:1] == b'\x06' or data[:1] == b'\x1b'


def _try_b64_decode(data):
    try:
        decoded = base64.b64decode(data)
        if decoded != data:
            return decoded
    except Exception:
        pass
    return None


def disassemble(bytecode, filename=None):
    return luna.disassemble_bytecode(bytecode, filename)


def try_disassemble(bytecode, filename=None):
    try:
        return disassemble(bytecode, filename)
    except luna.DeserializationError:
        decoded = _try_b64_decode(bytecode)
        if decoded:
            try:
                return disassemble(decoded, filename)
            except Exception as e:
                return f'-- Error: {e}'
        return f'-- Error: invalid Luau bytecode ({len(bytecode)} bytes)'
    except Exception as e:
        return f'-- Error: {e}'


if __name__ == '__main__':
    in_path, out_path = sys.argv[1], sys.argv[2]
    with open(in_path, 'rb') as f:
        bytecode = f.read()
    if not bytecode:
        result = '-- Error: empty bytecode'
    else:
        result = try_disassemble(bytecode, 'input.luau')
    with open(out_path, 'w', encoding='utf-8', errors='replace') as f:
        f.write(result)