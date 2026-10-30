let imports = {};
imports['__wbindgen_placeholder__'] = module.exports;
let wasm;
const { TextDecoder, TextEncoder } = require(`util`);

let cachedTextDecoder = new TextDecoder('utf-8', { ignoreBOM: true, fatal: true });

cachedTextDecoder.decode();

let cachedUint8Memory0 = null;

function getUint8Memory0() {
    if (cachedUint8Memory0 === null || cachedUint8Memory0.byteLength === 0) {
        cachedUint8Memory0 = new Uint8Array(wasm.memory.buffer);
    }
    return cachedUint8Memory0;
}

function getStringFromWasm0(ptr, len) {
    ptr = ptr >>> 0;
    return cachedTextDecoder.decode(getUint8Memory0().subarray(ptr, ptr + len));
}

const heap = new Array(128).fill(undefined);

heap.push(undefined, null, true, false);

let heap_next = heap.length;

function addHeapObject(obj) {
    if (heap_next === heap.length) heap.push(heap.length + 1);
    const idx = heap_next;
    heap_next = heap[idx];

    heap[idx] = obj;
    return idx;
}

function getObject(idx) { return heap[idx]; }

let WASM_VECTOR_LEN = 0;

let cachedTextEncoder = new TextEncoder('utf-8');

const encodeString = (typeof cachedTextEncoder.encodeInto === 'function'
    ? function (arg, view) {
    return cachedTextEncoder.encodeInto(arg, view);
}
    : function (arg, view) {
    const buf = cachedTextEncoder.encode(arg);
    view.set(buf);
    return {
        read: arg.length,
        written: buf.length
    };
});

function passStringToWasm0(arg, malloc, realloc) {

    if (realloc === undefined) {
        const buf = cachedTextEncoder.encode(arg);
        const ptr = malloc(buf.length, 1) >>> 0;
        getUint8Memory0().subarray(ptr, ptr + buf.length).set(buf);
        WASM_VECTOR_LEN = buf.length;
        return ptr;
    }

    let len = arg.length;
    let ptr = malloc(len, 1) >>> 0;

    const mem = getUint8Memory0();

    let offset = 0;

    for (; offset < len; offset++) {
        const code = arg.charCodeAt(offset);
        if (code > 0x7F) break;
        mem[ptr + offset] = code;
    }

    if (offset !== len) {
        if (offset !== 0) {
            arg = arg.slice(offset);
        }
        ptr = realloc(ptr, len, len = offset + arg.length * 3, 1) >>> 0;
        const view = getUint8Memory0().subarray(ptr + offset, ptr + len);
        const ret = encodeString(arg, view);

        offset += ret.written;
        ptr = realloc(ptr, len, offset, 1) >>> 0;
    }

    WASM_VECTOR_LEN = offset;
    return ptr;
}

function isLikeNone(x) {
    return x === undefined || x === null;
}

let cachedInt32Memory0 = null;

function getInt32Memory0() {
    if (cachedInt32Memory0 === null || cachedInt32Memory0.byteLength === 0) {
        cachedInt32Memory0 = new Int32Array(wasm.memory.buffer);
    }
    return cachedInt32Memory0;
}

function dropObject(idx) {
    if (idx < 132) return;
    heap[idx] = heap_next;
    heap_next = idx;
}

function takeObject(idx) {
    const ret = getObject(idx);
    dropObject(idx);
    return ret;
}
/**
* @param {string} code
* @param {any} opt_config
* @returns {string}
*/
module.exports.process_code = function(code, opt_config) {
    let deferred3_0;
    let deferred3_1;
    try {
        const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
        const ptr0 = passStringToWasm0(code, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        wasm.process_code(retptr, ptr0, len0, addHeapObject(opt_config));
        var r0 = getInt32Memory0()[retptr / 4 + 0];
        var r1 = getInt32Memory0()[retptr / 4 + 1];
        var r2 = getInt32Memory0()[retptr / 4 + 2];
        var r3 = getInt32Memory0()[retptr / 4 + 3];
        var ptr2 = r0;
        var len2 = r1;
        if (r3) {
            ptr2 = 0; len2 = 0;
            throw takeObject(r2);
        }
        deferred3_0 = ptr2;
        deferred3_1 = len2;
        return getStringFromWasm0(ptr2, len2);
    } finally {
        wasm.__wbindgen_add_to_stack_pointer(16);
        wasm.__wbindgen_free(deferred3_0, deferred3_1, 1);
    }
};

let cachedUint32Memory0 = null;

function getUint32Memory0() {
    if (cachedUint32Memory0 === null || cachedUint32Memory0.byteLength === 0) {
        cachedUint32Memory0 = new Uint32Array(wasm.memory.buffer);
    }
    return cachedUint32Memory0;
}

function getArrayJsValueFromWasm0(ptr, len) {
    ptr = ptr >>> 0;
    const mem = getUint32Memory0();
    const slice = mem.subarray(ptr / 4, ptr / 4 + len);
    const result = [];
    for (let i = 0; i < slice.length; i++) {
        result.push(takeObject(slice[i]));
    }
    return result;
}
/**
* @returns {any[]}
*/
module.exports.get_all_rule_names = function() {
    try {
        const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
        wasm.get_all_rule_names(retptr);
        var r0 = getInt32Memory0()[retptr / 4 + 0];
        var r1 = getInt32Memory0()[retptr / 4 + 1];
        var v1 = getArrayJsValueFromWasm0(r0, r1).slice();
        wasm.__wbindgen_free(r0, r1 * 4, 4);
        return v1;
    } finally {
        wasm.__wbindgen_add_to_stack_pointer(16);
    }
};

/**
* @returns {string}
*/
module.exports.get_serialized_default_rules = function() {
    let deferred1_0;
    let deferred1_1;
    try {
        const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
        wasm.get_serialized_default_rules(retptr);
        var r0 = getInt32Memory0()[retptr / 4 + 0];
        var r1 = getInt32Memory0()[retptr / 4 + 1];
        deferred1_0 = r0;
        deferred1_1 = r1;
        return getStringFromWasm0(r0, r1);
    } finally {
        wasm.__wbindgen_add_to_stack_pointer(16);
        wasm.__wbindgen_free(deferred1_0, deferred1_1, 1);
    }
};

let stack_pointer = 128;

function addBorrowedObject(obj) {
    if (stack_pointer == 1) throw new Error('out of js stack');
    heap[--stack_pointer] = obj;
    return stack_pointer;
}

let cachedFloat64Memory0 = null;

function getFloat64Memory0() {
    if (cachedFloat64Memory0 === null || cachedFloat64Memory0.byteLength === 0) {
        cachedFloat64Memory0 = new Float64Array(wasm.memory.buffer);
    }
    return cachedFloat64Memory0;
}

function passArrayJsValueToWasm0(array, malloc) {
    const ptr = malloc(array.length * 4, 4) >>> 0;
    const mem = getUint32Memory0();
    for (let i = 0; i < array.length; i++) {
        mem[ptr / 4 + i] = addHeapObject(array[i]);
    }
    WASM_VECTOR_LEN = array.length;
    return ptr;
}

function handleError(f, args) {
    try {
        return f.apply(this, args);
    } catch (e) {
        wasm.__wbindgen_exn_store(addHeapObject(e));
    }
}

const AgentConstructorOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_agentconstructoroptions_free(ptr >>> 0));
/**
*/
class AgentConstructorOptions {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        AgentConstructorOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_agentconstructoroptions_free(ptr);
    }
    /**
    * @returns {number}
    */
    get keep_alive_msecs() {
        const ret = wasm.agentconstructoroptions_keep_alive_msecs(this.__wbg_ptr);
        return ret;
    }
    /**
    * @param {number} value
    */
    set keep_alive_msecs(value) {
        wasm.agentconstructoroptions_set_keep_alive_msecs(this.__wbg_ptr, value);
    }
    /**
    * @returns {boolean}
    */
    get keep_alive() {
        const ret = wasm.agentconstructoroptions_keep_alive(this.__wbg_ptr);
        return ret !== 0;
    }
    /**
    * @param {boolean} value
    */
    set keep_alive(value) {
        wasm.agentconstructoroptions_set_keep_alive(this.__wbg_ptr, value);
    }
    /**
    * @returns {number}
    */
    get max_free_sockets() {
        const ret = wasm.agentconstructoroptions_max_free_sockets(this.__wbg_ptr);
        return ret;
    }
    /**
    * @param {number} value
    */
    set max_free_sockets(value) {
        wasm.agentconstructoroptions_set_max_free_sockets(this.__wbg_ptr, value);
    }
    /**
    * @returns {number}
    */
    get max_sockets() {
        const ret = wasm.agentconstructoroptions_max_sockets(this.__wbg_ptr);
        return ret;
    }
    /**
    * @param {number} value
    */
    set max_sockets(value) {
        wasm.agentconstructoroptions_set_max_sockets(this.__wbg_ptr, value);
    }
    /**
    * @returns {number}
    */
    get timeout() {
        const ret = wasm.agentconstructoroptions_timeout(this.__wbg_ptr);
        return ret;
    }
    /**
    * @param {number} value
    */
    set timeout(value) {
        wasm.agentconstructoroptions_set_timeout(this.__wbg_ptr, value);
    }
}
module.exports.AgentConstructorOptions = AgentConstructorOptions;

const AppendFileOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_appendfileoptions_free(ptr >>> 0));
/**
*/
class AppendFileOptions {

    static __wrap(ptr) {
        ptr = ptr >>> 0;
        const obj = Object.create(AppendFileOptions.prototype);
        obj.__wbg_ptr = ptr;
        AppendFileOptionsFinalization.register(obj, obj.__wbg_ptr, obj);
        return obj;
    }

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        AppendFileOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_appendfileoptions_free(ptr);
    }
    /**
    * @param {string | undefined} [encoding]
    * @param {number | undefined} [mode]
    * @param {string | undefined} [flag]
    */
    constructor(encoding, mode, flag) {
        const ret = wasm.appendfileoptions_new_with_values(isLikeNone(encoding) ? 0 : addHeapObject(encoding), !isLikeNone(mode), isLikeNone(mode) ? 0 : mode, isLikeNone(flag) ? 0 : addHeapObject(flag));
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {AppendFileOptions}
    */
    static new() {
        const ret = wasm.appendfileoptions_new();
        return AppendFileOptions.__wrap(ret);
    }
    /**
    * @returns {string | undefined}
    */
    get encoding() {
        const ret = wasm.appendfileoptions_encoding(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set encoding(value) {
        wasm.appendfileoptions_set_encoding(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {number | undefined}
    */
    get mode() {
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.appendfileoptions_mode(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r1 = getInt32Memory0()[retptr / 4 + 1];
            return r0 === 0 ? undefined : r1 >>> 0;
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
        }
    }
    /**
    * @param {number | undefined} [value]
    */
    set mode(value) {
        wasm.appendfileoptions_set_mode(this.__wbg_ptr, !isLikeNone(value), isLikeNone(value) ? 0 : value);
    }
    /**
    * @returns {string | undefined}
    */
    get flag() {
        const ret = wasm.appendfileoptions_flag(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set flag(value) {
        wasm.appendfileoptions_set_flag(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
}
module.exports.AppendFileOptions = AppendFileOptions;

const AssertionErrorOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_assertionerroroptions_free(ptr >>> 0));
/**
*/
class AssertionErrorOptions {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        AssertionErrorOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_assertionerroroptions_free(ptr);
    }
    /**
    * @param {string | undefined} message
    * @param {any} actual
    * @param {any} expected
    * @param {string} operator
    */
    constructor(message, actual, expected, operator) {
        const ret = wasm.assertionerroroptions_new(isLikeNone(message) ? 0 : addHeapObject(message), addHeapObject(actual), addHeapObject(expected), addHeapObject(operator));
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * If provided, the error message is set to this value.
    * @returns {string | undefined}
    */
    get message() {
        const ret = wasm.assertionerroroptions_message(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set message(value) {
        wasm.assertionerroroptions_set_message(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * The actual property on the error instance.
    * @returns {any}
    */
    get actual() {
        const ret = wasm.assertionerroroptions_actual(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {any} value
    */
    set actual(value) {
        wasm.assertionerroroptions_set_actual(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * The expected property on the error instance.
    * @returns {any}
    */
    get expected() {
        const ret = wasm.assertionerroroptions_expected(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {any} value
    */
    set expected(value) {
        wasm.assertionerroroptions_set_expected(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * The operator property on the error instance.
    * @returns {string}
    */
    get operator() {
        const ret = wasm.assertionerroroptions_operator(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string} value
    */
    set operator(value) {
        wasm.assertionerroroptions_set_operator(this.__wbg_ptr, addHeapObject(value));
    }
}
module.exports.AssertionErrorOptions = AssertionErrorOptions;

const ConfigurationFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_configuration_free(ptr >>> 0));
/**
*/
class Configuration {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        ConfigurationFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_configuration_free(ptr);
    }
    /**
    */
    constructor() {
        const ret = wasm.configuration_new();
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {number}
    */
    get column_width() {
        const ret = wasm.configuration_column_width(this.__wbg_ptr);
        return ret >>> 0;
    }
    /**
    * @returns {string}
    */
    get line_endings() {
        let deferred1_0;
        let deferred1_1;
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.configuration_line_endings(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r1 = getInt32Memory0()[retptr / 4 + 1];
            deferred1_0 = r0;
            deferred1_1 = r1;
            return getStringFromWasm0(r0, r1);
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
            wasm.__wbindgen_free(deferred1_0, deferred1_1, 1);
        }
    }
    /**
    * @returns {string}
    */
    get indentation_type() {
        let deferred1_0;
        let deferred1_1;
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.configuration_indentation_type(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r1 = getInt32Memory0()[retptr / 4 + 1];
            deferred1_0 = r0;
            deferred1_1 = r1;
            return getStringFromWasm0(r0, r1);
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
            wasm.__wbindgen_free(deferred1_0, deferred1_1, 1);
        }
    }
    /**
    * @returns {number}
    */
    get indentation_width() {
        const ret = wasm.configuration_indentation_width(this.__wbg_ptr);
        return ret >>> 0;
    }
    /**
    * @returns {string}
    */
    get quote_style() {
        let deferred1_0;
        let deferred1_1;
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.configuration_quote_style(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r1 = getInt32Memory0()[retptr / 4 + 1];
            deferred1_0 = r0;
            deferred1_1 = r1;
            return getStringFromWasm0(r0, r1);
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
            wasm.__wbindgen_free(deferred1_0, deferred1_1, 1);
        }
    }
    /**
    * @param {number} column_width
    */
    set column_width(column_width) {
        wasm.configuration_set_column_width(this.__wbg_ptr, column_width);
    }
    /**
    * @param {string} line_endings
    */
    set line_endings(line_endings) {
        const ptr0 = passStringToWasm0(line_endings, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        wasm.configuration_set_line_endings(this.__wbg_ptr, ptr0, len0);
    }
    /**
    * @param {string} indentation_type
    */
    set indentation_type(indentation_type) {
        const ptr0 = passStringToWasm0(indentation_type, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        wasm.configuration_set_indentation_type(this.__wbg_ptr, ptr0, len0);
    }
    /**
    * @param {number} indentation_width
    */
    set indentation_width(indentation_width) {
        wasm.configuration_set_indentation_width(this.__wbg_ptr, indentation_width);
    }
    /**
    * @param {string} quote_style
    */
    set quote_style(quote_style) {
        const ptr0 = passStringToWasm0(quote_style, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
        const len0 = WASM_VECTOR_LEN;
        wasm.configuration_set_quote_style(this.__wbg_ptr, ptr0, len0);
    }
}
module.exports.Configuration = Configuration;

const ConsoleConstructorOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_consoleconstructoroptions_free(ptr >>> 0));
/**
*/
class ConsoleConstructorOptions {

    static __wrap(ptr) {
        ptr = ptr >>> 0;
        const obj = Object.create(ConsoleConstructorOptions.prototype);
        obj.__wbg_ptr = ptr;
        ConsoleConstructorOptionsFinalization.register(obj, obj.__wbg_ptr, obj);
        return obj;
    }

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        ConsoleConstructorOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_consoleconstructoroptions_free(ptr);
    }
    /**
    * @param {any} stdout
    * @param {any} stderr
    * @param {boolean | undefined} ignore_errors
    * @param {any} color_mod
    * @param {object | undefined} [inspect_options]
    */
    constructor(stdout, stderr, ignore_errors, color_mod, inspect_options) {
        const ret = wasm.consoleconstructoroptions_new_with_values(addHeapObject(stdout), addHeapObject(stderr), isLikeNone(ignore_errors) ? 0xFFFFFF : ignore_errors ? 1 : 0, addHeapObject(color_mod), isLikeNone(inspect_options) ? 0 : addHeapObject(inspect_options));
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @param {any} stdout
    * @param {any} stderr
    * @returns {ConsoleConstructorOptions}
    */
    static new(stdout, stderr) {
        const ret = wasm.consoleconstructoroptions_new(addHeapObject(stdout), addHeapObject(stderr));
        return ConsoleConstructorOptions.__wrap(ret);
    }
    /**
    * @returns {any}
    */
    get stdout() {
        const ret = wasm.consoleconstructoroptions_stdout(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {any} value
    */
    set stdout(value) {
        wasm.consoleconstructoroptions_set_stdout(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * @returns {any}
    */
    get stderr() {
        const ret = wasm.consoleconstructoroptions_stderr(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {any} value
    */
    set stderr(value) {
        wasm.consoleconstructoroptions_set_stderr(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * @returns {boolean | undefined}
    */
    get ignore_errors() {
        const ret = wasm.consoleconstructoroptions_ignore_errors(this.__wbg_ptr);
        return ret === 0xFFFFFF ? undefined : ret !== 0;
    }
    /**
    * @param {boolean | undefined} [value]
    */
    set ignore_errors(value) {
        wasm.consoleconstructoroptions_set_ignore_errors(this.__wbg_ptr, isLikeNone(value) ? 0xFFFFFF : value ? 1 : 0);
    }
    /**
    * @returns {any}
    */
    get color_mod() {
        const ret = wasm.consoleconstructoroptions_color_mod(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {any} value
    */
    set color_mod(value) {
        wasm.consoleconstructoroptions_set_color_mod(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * @returns {object | undefined}
    */
    get inspect_options() {
        const ret = wasm.consoleconstructoroptions_inspect_options(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {object | undefined} [value]
    */
    set inspect_options(value) {
        wasm.consoleconstructoroptions_set_inspect_options(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
}
module.exports.ConsoleConstructorOptions = ConsoleConstructorOptions;

const CreateHookCallbacksFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_createhookcallbacks_free(ptr >>> 0));
/**
*/
class CreateHookCallbacks {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        CreateHookCallbacksFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_createhookcallbacks_free(ptr);
    }
    /**
    * @param {Function} init
    * @param {Function} before
    * @param {Function} after
    * @param {Function} destroy
    * @param {Function} promise_resolve
    */
    constructor(init, before, after, destroy, promise_resolve) {
        try {
            const ret = wasm.createhookcallbacks_new(addBorrowedObject(init), addBorrowedObject(before), addBorrowedObject(after), addBorrowedObject(destroy), addBorrowedObject(promise_resolve));
            this.__wbg_ptr = ret >>> 0;
            return this;
        } finally {
            heap[stack_pointer++] = undefined;
            heap[stack_pointer++] = undefined;
            heap[stack_pointer++] = undefined;
            heap[stack_pointer++] = undefined;
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @returns {Function}
    */
    get init() {
        const ret = wasm.createhookcallbacks_init(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {Function} value
    */
    set init(value) {
        wasm.createhookcallbacks_set_init(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * @returns {Function}
    */
    get before() {
        const ret = wasm.createhookcallbacks_before(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {Function} value
    */
    set before(value) {
        wasm.createhookcallbacks_set_before(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * @returns {Function}
    */
    get after() {
        const ret = wasm.createhookcallbacks_after(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {Function} value
    */
    set after(value) {
        wasm.createhookcallbacks_set_after(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * @returns {Function}
    */
    get destroy() {
        const ret = wasm.createhookcallbacks_destroy(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {Function} value
    */
    set destroy(value) {
        wasm.createhookcallbacks_set_destroy(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * @returns {Function}
    */
    get promise_resolve() {
        const ret = wasm.createhookcallbacks_promise_resolve(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {Function} value
    */
    set promise_resolve(value) {
        wasm.createhookcallbacks_set_promise_resolve(this.__wbg_ptr, addHeapObject(value));
    }
}
module.exports.CreateHookCallbacks = CreateHookCallbacks;

const CreateReadStreamOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_createreadstreamoptions_free(ptr >>> 0));
/**
*/
class CreateReadStreamOptions {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        CreateReadStreamOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_createreadstreamoptions_free(ptr);
    }
    /**
    * @param {boolean | undefined} [auto_close]
    * @param {boolean | undefined} [emit_close]
    * @param {string | undefined} [encoding]
    * @param {number | undefined} [end]
    * @param {number | undefined} [fd]
    * @param {string | undefined} [flags]
    * @param {number | undefined} [high_water_mark]
    * @param {number | undefined} [mode]
    * @param {number | undefined} [start]
    */
    constructor(auto_close, emit_close, encoding, end, fd, flags, high_water_mark, mode, start) {
        const ret = wasm.createreadstreamoptions_new_with_values(isLikeNone(auto_close) ? 0xFFFFFF : auto_close ? 1 : 0, isLikeNone(emit_close) ? 0xFFFFFF : emit_close ? 1 : 0, isLikeNone(encoding) ? 0 : addHeapObject(encoding), !isLikeNone(end), isLikeNone(end) ? 0 : end, !isLikeNone(fd), isLikeNone(fd) ? 0 : fd, isLikeNone(flags) ? 0 : addHeapObject(flags), !isLikeNone(high_water_mark), isLikeNone(high_water_mark) ? 0 : high_water_mark, !isLikeNone(mode), isLikeNone(mode) ? 0 : mode, !isLikeNone(start), isLikeNone(start) ? 0 : start);
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {boolean | undefined}
    */
    get auto_close() {
        const ret = wasm.createreadstreamoptions_auto_close(this.__wbg_ptr);
        return ret === 0xFFFFFF ? undefined : ret !== 0;
    }
    /**
    * @param {boolean | undefined} [value]
    */
    set auto_close(value) {
        wasm.createreadstreamoptions_set_auto_close(this.__wbg_ptr, isLikeNone(value) ? 0xFFFFFF : value ? 1 : 0);
    }
    /**
    * @returns {boolean | undefined}
    */
    get emit_close() {
        const ret = wasm.createreadstreamoptions_emit_close(this.__wbg_ptr);
        return ret === 0xFFFFFF ? undefined : ret !== 0;
    }
    /**
    * @param {boolean | undefined} [value]
    */
    set emit_close(value) {
        wasm.createreadstreamoptions_set_emit_close(this.__wbg_ptr, isLikeNone(value) ? 0xFFFFFF : value ? 1 : 0);
    }
    /**
    * @returns {string | undefined}
    */
    get encoding() {
        const ret = wasm.createreadstreamoptions_encoding(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set encoding(value) {
        wasm.createreadstreamoptions_set_encoding(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {number | undefined}
    */
    get end() {
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.createreadstreamoptions_end(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r2 = getFloat64Memory0()[retptr / 8 + 1];
            return r0 === 0 ? undefined : r2;
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
        }
    }
    /**
    * @param {number | undefined} [value]
    */
    set end(value) {
        wasm.createreadstreamoptions_set_end(this.__wbg_ptr, !isLikeNone(value), isLikeNone(value) ? 0 : value);
    }
    /**
    * @returns {number | undefined}
    */
    get fd() {
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.createreadstreamoptions_fd(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r1 = getInt32Memory0()[retptr / 4 + 1];
            return r0 === 0 ? undefined : r1 >>> 0;
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
        }
    }
    /**
    * @param {number | undefined} [value]
    */
    set fd(value) {
        wasm.createreadstreamoptions_set_fd(this.__wbg_ptr, !isLikeNone(value), isLikeNone(value) ? 0 : value);
    }
    /**
    * @returns {string | undefined}
    */
    get flags() {
        const ret = wasm.createreadstreamoptions_flags(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set flags(value) {
        wasm.createreadstreamoptions_set_flags(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {number | undefined}
    */
    get high_water_mark() {
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.createreadstreamoptions_high_water_mark(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r2 = getFloat64Memory0()[retptr / 8 + 1];
            return r0 === 0 ? undefined : r2;
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
        }
    }
    /**
    * @param {number | undefined} [value]
    */
    set high_water_mark(value) {
        wasm.createreadstreamoptions_set_high_water_mark(this.__wbg_ptr, !isLikeNone(value), isLikeNone(value) ? 0 : value);
    }
    /**
    * @returns {number | undefined}
    */
    get mode() {
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.createreadstreamoptions_mode(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r1 = getInt32Memory0()[retptr / 4 + 1];
            return r0 === 0 ? undefined : r1 >>> 0;
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
        }
    }
    /**
    * @param {number | undefined} [value]
    */
    set mode(value) {
        wasm.createreadstreamoptions_set_mode(this.__wbg_ptr, !isLikeNone(value), isLikeNone(value) ? 0 : value);
    }
    /**
    * @returns {number | undefined}
    */
    get start() {
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.createreadstreamoptions_start(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r2 = getFloat64Memory0()[retptr / 8 + 1];
            return r0 === 0 ? undefined : r2;
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
        }
    }
    /**
    * @param {number | undefined} [value]
    */
    set start(value) {
        wasm.createreadstreamoptions_set_start(this.__wbg_ptr, !isLikeNone(value), isLikeNone(value) ? 0 : value);
    }
}
module.exports.CreateReadStreamOptions = CreateReadStreamOptions;

const CreateWriteStreamOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_createwritestreamoptions_free(ptr >>> 0));
/**
*/
class CreateWriteStreamOptions {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        CreateWriteStreamOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_createwritestreamoptions_free(ptr);
    }
    /**
    * @param {boolean | undefined} [auto_close]
    * @param {boolean | undefined} [emit_close]
    * @param {string | undefined} [encoding]
    * @param {number | undefined} [fd]
    * @param {string | undefined} [flags]
    * @param {number | undefined} [mode]
    * @param {number | undefined} [start]
    */
    constructor(auto_close, emit_close, encoding, fd, flags, mode, start) {
        const ret = wasm.createwritestreamoptions_new_with_values(isLikeNone(auto_close) ? 0xFFFFFF : auto_close ? 1 : 0, isLikeNone(emit_close) ? 0xFFFFFF : emit_close ? 1 : 0, isLikeNone(encoding) ? 0 : addHeapObject(encoding), !isLikeNone(fd), isLikeNone(fd) ? 0 : fd, isLikeNone(flags) ? 0 : addHeapObject(flags), !isLikeNone(mode), isLikeNone(mode) ? 0 : mode, !isLikeNone(start), isLikeNone(start) ? 0 : start);
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {boolean | undefined}
    */
    get auto_close() {
        const ret = wasm.createwritestreamoptions_auto_close(this.__wbg_ptr);
        return ret === 0xFFFFFF ? undefined : ret !== 0;
    }
    /**
    * @param {boolean | undefined} [value]
    */
    set auto_close(value) {
        wasm.createwritestreamoptions_set_auto_close(this.__wbg_ptr, isLikeNone(value) ? 0xFFFFFF : value ? 1 : 0);
    }
    /**
    * @returns {boolean | undefined}
    */
    get emit_close() {
        const ret = wasm.createwritestreamoptions_emit_close(this.__wbg_ptr);
        return ret === 0xFFFFFF ? undefined : ret !== 0;
    }
    /**
    * @param {boolean | undefined} [value]
    */
    set emit_close(value) {
        wasm.createwritestreamoptions_set_emit_close(this.__wbg_ptr, isLikeNone(value) ? 0xFFFFFF : value ? 1 : 0);
    }
    /**
    * @returns {string | undefined}
    */
    get encoding() {
        const ret = wasm.createwritestreamoptions_encoding(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set encoding(value) {
        wasm.createwritestreamoptions_set_encoding(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {number | undefined}
    */
    get fd() {
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.createwritestreamoptions_fd(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r1 = getInt32Memory0()[retptr / 4 + 1];
            return r0 === 0 ? undefined : r1 >>> 0;
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
        }
    }
    /**
    * @param {number | undefined} [value]
    */
    set fd(value) {
        wasm.createwritestreamoptions_set_fd(this.__wbg_ptr, !isLikeNone(value), isLikeNone(value) ? 0 : value);
    }
    /**
    * @returns {string | undefined}
    */
    get flags() {
        const ret = wasm.createwritestreamoptions_flags(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set flags(value) {
        wasm.createwritestreamoptions_set_flags(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {number | undefined}
    */
    get mode() {
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.createwritestreamoptions_mode(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r1 = getInt32Memory0()[retptr / 4 + 1];
            return r0 === 0 ? undefined : r1 >>> 0;
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
        }
    }
    /**
    * @param {number | undefined} [value]
    */
    set mode(value) {
        wasm.createwritestreamoptions_set_mode(this.__wbg_ptr, !isLikeNone(value), isLikeNone(value) ? 0 : value);
    }
    /**
    * @returns {number | undefined}
    */
    get start() {
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.createwritestreamoptions_start(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r2 = getFloat64Memory0()[retptr / 8 + 1];
            return r0 === 0 ? undefined : r2;
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
        }
    }
    /**
    * @param {number | undefined} [value]
    */
    set start(value) {
        wasm.createwritestreamoptions_set_start(this.__wbg_ptr, !isLikeNone(value), isLikeNone(value) ? 0 : value);
    }
}
module.exports.CreateWriteStreamOptions = CreateWriteStreamOptions;

const FormatInputPathObjectFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_formatinputpathobject_free(ptr >>> 0));
/**
*/
class FormatInputPathObject {

    static __wrap(ptr) {
        ptr = ptr >>> 0;
        const obj = Object.create(FormatInputPathObject.prototype);
        obj.__wbg_ptr = ptr;
        FormatInputPathObjectFinalization.register(obj, obj.__wbg_ptr, obj);
        return obj;
    }

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        FormatInputPathObjectFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_formatinputpathobject_free(ptr);
    }
    /**
    * @param {string | undefined} [base]
    * @param {string | undefined} [dir]
    * @param {string | undefined} [ext]
    * @param {string | undefined} [name]
    * @param {string | undefined} [root]
    */
    constructor(base, dir, ext, name, root) {
        const ret = wasm.formatinputpathobject_new_with_values(isLikeNone(base) ? 0 : addHeapObject(base), isLikeNone(dir) ? 0 : addHeapObject(dir), isLikeNone(ext) ? 0 : addHeapObject(ext), isLikeNone(name) ? 0 : addHeapObject(name), isLikeNone(root) ? 0 : addHeapObject(root));
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {FormatInputPathObject}
    */
    static new() {
        const ret = wasm.formatinputpathobject_new();
        return FormatInputPathObject.__wrap(ret);
    }
    /**
    * @returns {string | undefined}
    */
    get base() {
        const ret = wasm.formatinputpathobject_base(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set base(value) {
        wasm.formatinputpathobject_set_base(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {string | undefined}
    */
    get dir() {
        const ret = wasm.formatinputpathobject_dir(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set dir(value) {
        wasm.formatinputpathobject_set_dir(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {string | undefined}
    */
    get ext() {
        const ret = wasm.formatinputpathobject_ext(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set ext(value) {
        wasm.formatinputpathobject_set_ext(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {string | undefined}
    */
    get name() {
        const ret = wasm.formatinputpathobject_name(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set name(value) {
        wasm.formatinputpathobject_set_name(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {string | undefined}
    */
    get root() {
        const ret = wasm.formatinputpathobject_root(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set root(value) {
        wasm.formatinputpathobject_set_root(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
}
module.exports.FormatInputPathObject = FormatInputPathObject;

const GetNameOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_getnameoptions_free(ptr >>> 0));
/**
*/
class GetNameOptions {

    static __wrap(ptr) {
        ptr = ptr >>> 0;
        const obj = Object.create(GetNameOptions.prototype);
        obj.__wbg_ptr = ptr;
        GetNameOptionsFinalization.register(obj, obj.__wbg_ptr, obj);
        return obj;
    }

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        GetNameOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_getnameoptions_free(ptr);
    }
    /**
    * @param {number | undefined} family
    * @param {string} host
    * @param {string} local_address
    * @param {number} port
    * @returns {GetNameOptions}
    */
    static new(family, host, local_address, port) {
        const ret = wasm.getnameoptions_new(isLikeNone(family) ? 0xFFFFFF : family, addHeapObject(host), addHeapObject(local_address), port);
        return GetNameOptions.__wrap(ret);
    }
    /**
    * @returns {number | undefined}
    */
    get family() {
        const ret = wasm.getnameoptions_family(this.__wbg_ptr);
        return ret === 0xFFFFFF ? undefined : ret;
    }
    /**
    * @param {number | undefined} [value]
    */
    set family(value) {
        wasm.getnameoptions_set_family(this.__wbg_ptr, isLikeNone(value) ? 0xFFFFFF : value);
    }
    /**
    * @returns {string}
    */
    get host() {
        const ret = wasm.getnameoptions_host(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string} value
    */
    set host(value) {
        wasm.getnameoptions_set_host(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * @returns {string}
    */
    get local_address() {
        const ret = wasm.getnameoptions_local_address(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string} value
    */
    set local_address(value) {
        wasm.getnameoptions_set_local_address(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * @returns {number}
    */
    get port() {
        const ret = wasm.getnameoptions_port(this.__wbg_ptr);
        return ret >>> 0;
    }
    /**
    * @param {number} value
    */
    set port(value) {
        wasm.getnameoptions_set_port(this.__wbg_ptr, value);
    }
}
module.exports.GetNameOptions = GetNameOptions;

const MkdtempSyncOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_mkdtempsyncoptions_free(ptr >>> 0));
/**
*/
class MkdtempSyncOptions {

    static __wrap(ptr) {
        ptr = ptr >>> 0;
        const obj = Object.create(MkdtempSyncOptions.prototype);
        obj.__wbg_ptr = ptr;
        MkdtempSyncOptionsFinalization.register(obj, obj.__wbg_ptr, obj);
        return obj;
    }

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        MkdtempSyncOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_mkdtempsyncoptions_free(ptr);
    }
    /**
    * @param {string | undefined} [encoding]
    */
    constructor(encoding) {
        const ret = wasm.mkdtempsyncoptions_new_with_values(isLikeNone(encoding) ? 0 : addHeapObject(encoding));
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {MkdtempSyncOptions}
    */
    static new() {
        const ret = wasm.mkdtempsyncoptions_new();
        return MkdtempSyncOptions.__wrap(ret);
    }
    /**
    * @returns {string | undefined}
    */
    get encoding() {
        const ret = wasm.appendfileoptions_encoding(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set encoding(value) {
        wasm.appendfileoptions_set_encoding(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
}
module.exports.MkdtempSyncOptions = MkdtempSyncOptions;

const NetServerOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_netserveroptions_free(ptr >>> 0));
/**
*/
class NetServerOptions {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        NetServerOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_netserveroptions_free(ptr);
    }
    /**
    * @returns {boolean | undefined}
    */
    get allow_half_open() {
        const ptr = this.__destroy_into_raw();
        const ret = wasm.netserveroptions_allow_half_open(ptr);
        return ret === 0xFFFFFF ? undefined : ret !== 0;
    }
    /**
    * @param {boolean | undefined} [value]
    */
    set allow_half_open(value) {
        const ptr = this.__destroy_into_raw();
        wasm.netserveroptions_set_allow_half_open(ptr, isLikeNone(value) ? 0xFFFFFF : value ? 1 : 0);
    }
    /**
    * @returns {boolean | undefined}
    */
    get pause_on_connect() {
        const ptr = this.__destroy_into_raw();
        const ret = wasm.netserveroptions_pause_on_connect(ptr);
        return ret === 0xFFFFFF ? undefined : ret !== 0;
    }
    /**
    * @param {boolean | undefined} [value]
    */
    set pause_on_connect(value) {
        const ptr = this.__destroy_into_raw();
        wasm.netserveroptions_set_allow_half_open(ptr, isLikeNone(value) ? 0xFFFFFF : value ? 1 : 0);
    }
}
module.exports.NetServerOptions = NetServerOptions;

const PipeOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_pipeoptions_free(ptr >>> 0));
/**
*/
class PipeOptions {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        PipeOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_pipeoptions_free(ptr);
    }
    /**
    * @param {boolean | undefined} [end]
    */
    constructor(end) {
        const ret = wasm.pipeoptions_new(isLikeNone(end) ? 0xFFFFFF : end ? 1 : 0);
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {boolean | undefined}
    */
    get end() {
        const ptr = this.__destroy_into_raw();
        const ret = wasm.pipeoptions_end(ptr);
        return ret === 0xFFFFFF ? undefined : ret !== 0;
    }
    /**
    * @param {boolean | undefined} [value]
    */
    set end(value) {
        const ptr = this.__destroy_into_raw();
        wasm.pipeoptions_set_end(ptr, isLikeNone(value) ? 0xFFFFFF : value ? 1 : 0);
    }
}
module.exports.PipeOptions = PipeOptions;

const ProcessSendOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_processsendoptions_free(ptr >>> 0));
/**
*/
class ProcessSendOptions {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        ProcessSendOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_processsendoptions_free(ptr);
    }
    /**
    * @param {boolean | undefined} [swallow_errors]
    */
    constructor(swallow_errors) {
        const ret = wasm.processsendoptions_new(isLikeNone(swallow_errors) ? 0xFFFFFF : swallow_errors ? 1 : 0);
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {boolean | undefined}
    */
    get swallow_errors() {
        const ret = wasm.processsendoptions_swallow_errors(this.__wbg_ptr);
        return ret === 0xFFFFFF ? undefined : ret !== 0;
    }
    /**
    * @param {boolean | undefined} [value]
    */
    set swallow_errors(value) {
        wasm.processsendoptions_set_swallow_errors(this.__wbg_ptr, isLikeNone(value) ? 0xFFFFFF : value ? 1 : 0);
    }
}
module.exports.ProcessSendOptions = ProcessSendOptions;

const ReadStreamFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_readstream_free(ptr >>> 0));

class ReadStream {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        ReadStreamFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_readstream_free(ptr);
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    add_listener_with_open(listener) {
        try {
            const ret = wasm.readstream_add_listener_with_open(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    add_listener_with_close(listener) {
        try {
            const ret = wasm.readstream_add_listener_with_close(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    on_with_open(listener) {
        try {
            const ret = wasm.readstream_on_with_open(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    on_with_close(listener) {
        try {
            const ret = wasm.readstream_on_with_close(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    once_with_open(listener) {
        try {
            const ret = wasm.readstream_once_with_open(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    once_with_close(listener) {
        try {
            const ret = wasm.readstream_once_with_close(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    prepend_listener_with_open(listener) {
        try {
            const ret = wasm.readstream_prepend_listener_with_open(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    prepend_listener_with_close(listener) {
        try {
            const ret = wasm.readstream_prepend_listener_with_close(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    prepend_once_listener_with_open(listener) {
        try {
            const ret = wasm.readstream_prepend_once_listener_with_open(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    prepend_once_listener_with_close(listener) {
        try {
            const ret = wasm.readstream_prepend_once_listener_with_close(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
}
module.exports.ReadStream = ReadStream;

const SetAadOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_setaadoptions_free(ptr >>> 0));
/**
*/
class SetAadOptions {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        SetAadOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_setaadoptions_free(ptr);
    }
    /**
    * @param {Function} flush
    * @param {number} plaintext_length
    * @param {Function} transform
    */
    constructor(flush, plaintext_length, transform) {
        const ret = wasm.setaadoptions_new(addHeapObject(flush), plaintext_length, addHeapObject(transform));
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {Function}
    */
    get flush() {
        const ret = wasm.setaadoptions_flush(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {Function} value
    */
    set flush(value) {
        wasm.setaadoptions_set_flush(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * @returns {number}
    */
    get plaintextLength() {
        const ret = wasm.setaadoptions_plaintextLength(this.__wbg_ptr);
        return ret;
    }
    /**
    * @param {number} value
    */
    set plaintext_length(value) {
        wasm.setaadoptions_set_plaintext_length(this.__wbg_ptr, value);
    }
    /**
    * @returns {Function}
    */
    get transform() {
        const ret = wasm.setaadoptions_transform(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {Function} value
    */
    set transform(value) {
        wasm.setaadoptions_set_transform(this.__wbg_ptr, addHeapObject(value));
    }
}
module.exports.SetAadOptions = SetAadOptions;

const StreamTransformOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_streamtransformoptions_free(ptr >>> 0));
/**
*/
class StreamTransformOptions {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        StreamTransformOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_streamtransformoptions_free(ptr);
    }
    /**
    * @param {Function} flush
    * @param {Function} transform
    */
    constructor(flush, transform) {
        const ret = wasm.streamtransformoptions_new(addHeapObject(flush), addHeapObject(transform));
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {Function}
    */
    get flush() {
        const ret = wasm.streamtransformoptions_flush(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {Function} value
    */
    set flush(value) {
        wasm.streamtransformoptions_set_flush(this.__wbg_ptr, addHeapObject(value));
    }
    /**
    * @returns {Function}
    */
    get transform() {
        const ret = wasm.streamtransformoptions_transform(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {Function} value
    */
    set transform(value) {
        wasm.streamtransformoptions_set_transform(this.__wbg_ptr, addHeapObject(value));
    }
}
module.exports.StreamTransformOptions = StreamTransformOptions;

const UserInfoOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_userinfooptions_free(ptr >>> 0));
/**
*/
class UserInfoOptions {

    static __wrap(ptr) {
        ptr = ptr >>> 0;
        const obj = Object.create(UserInfoOptions.prototype);
        obj.__wbg_ptr = ptr;
        UserInfoOptionsFinalization.register(obj, obj.__wbg_ptr, obj);
        return obj;
    }

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        UserInfoOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_userinfooptions_free(ptr);
    }
    /**
    * @param {string | undefined} [encoding]
    */
    constructor(encoding) {
        const ret = wasm.userinfooptions_new_with_values(isLikeNone(encoding) ? 0 : addHeapObject(encoding));
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {UserInfoOptions}
    */
    static new() {
        const ret = wasm.userinfooptions_new();
        return UserInfoOptions.__wrap(ret);
    }
    /**
    * @returns {string | undefined}
    */
    get encoding() {
        const ret = wasm.userinfooptions_encoding(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set encoding(value) {
        wasm.userinfooptions_set_encoding(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
}
module.exports.UserInfoOptions = UserInfoOptions;

const WasiOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasioptions_free(ptr >>> 0));
/**
*/
class WasiOptions {

    static __wrap(ptr) {
        ptr = ptr >>> 0;
        const obj = Object.create(WasiOptions.prototype);
        obj.__wbg_ptr = ptr;
        WasiOptionsFinalization.register(obj, obj.__wbg_ptr, obj);
        return obj;
    }

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasiOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasioptions_free(ptr);
    }
    /**
    * @param {any[] | undefined} args
    * @param {object | undefined} env
    * @param {object} preopens
    */
    constructor(args, env, preopens) {
        var ptr0 = isLikeNone(args) ? 0 : passArrayJsValueToWasm0(args, wasm.__wbindgen_malloc);
        var len0 = WASM_VECTOR_LEN;
        const ret = wasm.wasioptions_new_with_values(ptr0, len0, isLikeNone(env) ? 0 : addHeapObject(env), addHeapObject(preopens));
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @param {object} preopens
    * @returns {WasiOptions}
    */
    static new(preopens) {
        const ret = wasm.wasioptions_new(addHeapObject(preopens));
        return WasiOptions.__wrap(ret);
    }
    /**
    * @returns {any[] | undefined}
    */
    get args() {
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.wasioptions_args(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r1 = getInt32Memory0()[retptr / 4 + 1];
            let v1;
            if (r0 !== 0) {
                v1 = getArrayJsValueFromWasm0(r0, r1).slice();
                wasm.__wbindgen_free(r0, r1 * 4, 4);
            }
            return v1;
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
        }
    }
    /**
    * @param {any[] | undefined} [value]
    */
    set args(value) {
        var ptr0 = isLikeNone(value) ? 0 : passArrayJsValueToWasm0(value, wasm.__wbindgen_malloc);
        var len0 = WASM_VECTOR_LEN;
        wasm.wasioptions_set_args(this.__wbg_ptr, ptr0, len0);
    }
    /**
    * @returns {object | undefined}
    */
    get env() {
        const ret = wasm.consoleconstructoroptions_inspect_options(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {object | undefined} [value]
    */
    set env(value) {
        wasm.consoleconstructoroptions_set_inspect_options(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {object}
    */
    get preopens() {
        const ret = wasm.wasioptions_preopens(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {object} value
    */
    set preopens(value) {
        wasm.wasioptions_set_preopens(this.__wbg_ptr, addHeapObject(value));
    }
}
module.exports.WasiOptions = WasiOptions;

const WriteFileSyncOptionsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_writefilesyncoptions_free(ptr >>> 0));
/**
*/
class WriteFileSyncOptions {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WriteFileSyncOptionsFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_writefilesyncoptions_free(ptr);
    }
    /**
    * @param {string | undefined} [encoding]
    * @param {string | undefined} [flag]
    * @param {number | undefined} [mode]
    */
    constructor(encoding, flag, mode) {
        const ret = wasm.writefilesyncoptions_new(isLikeNone(encoding) ? 0 : addHeapObject(encoding), isLikeNone(flag) ? 0 : addHeapObject(flag), !isLikeNone(mode), isLikeNone(mode) ? 0 : mode);
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
    /**
    * @returns {string | undefined}
    */
    get encoding() {
        const ret = wasm.userinfooptions_encoding(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set encoding(value) {
        wasm.userinfooptions_set_encoding(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {string | undefined}
    */
    get flag() {
        const ret = wasm.writefilesyncoptions_flag(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * @param {string | undefined} [value]
    */
    set flag(value) {
        wasm.writefilesyncoptions_set_flag(this.__wbg_ptr, isLikeNone(value) ? 0 : addHeapObject(value));
    }
    /**
    * @returns {number | undefined}
    */
    get mode() {
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.writefilesyncoptions_mode(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r1 = getInt32Memory0()[retptr / 4 + 1];
            return r0 === 0 ? undefined : r1 >>> 0;
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
        }
    }
    /**
    * @param {number | undefined} [value]
    */
    set mode(value) {
        wasm.writefilesyncoptions_set_mode(this.__wbg_ptr, !isLikeNone(value), isLikeNone(value) ? 0 : value);
    }
}
module.exports.WriteFileSyncOptions = WriteFileSyncOptions;

const WriteStreamFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_writestream_free(ptr >>> 0));

class WriteStream {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WriteStreamFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_writestream_free(ptr);
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    add_listener_with_open(listener) {
        try {
            const ret = wasm.writestream_add_listener_with_open(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    add_listener_with_close(listener) {
        try {
            const ret = wasm.writestream_add_listener_with_close(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    on_with_open(listener) {
        try {
            const ret = wasm.writestream_on_with_open(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    on_with_close(listener) {
        try {
            const ret = wasm.writestream_on_with_close(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    once_with_open(listener) {
        try {
            const ret = wasm.writestream_once_with_open(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    once_with_close(listener) {
        try {
            const ret = wasm.writestream_once_with_close(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    prepend_listener_with_open(listener) {
        try {
            const ret = wasm.writestream_prepend_listener_with_open(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    prepend_listener_with_close(listener) {
        try {
            const ret = wasm.writestream_prepend_listener_with_close(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    prepend_once_listener_with_open(listener) {
        try {
            const ret = wasm.writestream_prepend_once_listener_with_open(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
    /**
    * @param {Function} listener
    * @returns {any}
    */
    prepend_once_listener_with_close(listener) {
        try {
            const ret = wasm.writestream_prepend_once_listener_with_close(this.__wbg_ptr, addBorrowedObject(listener));
            return takeObject(ret);
        } finally {
            heap[stack_pointer++] = undefined;
        }
    }
}
module.exports.WriteStream = WriteStream;

module.exports.__wbindgen_string_new = function(arg0, arg1) {
    const ret = getStringFromWasm0(arg0, arg1);
    return addHeapObject(ret);
};

module.exports.__wbindgen_is_undefined = function(arg0) {
    const ret = getObject(arg0) === undefined;
    return ret;
};

module.exports.__wbindgen_is_object = function(arg0) {
    const val = getObject(arg0);
    const ret = typeof(val) === 'object' && val !== null;
    return ret;
};

module.exports.__wbindgen_string_get = function(arg0, arg1) {
    const obj = getObject(arg1);
    const ret = typeof(obj) === 'string' ? obj : undefined;
    var ptr1 = isLikeNone(ret) ? 0 : passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
    var len1 = WASM_VECTOR_LEN;
    getInt32Memory0()[arg0 / 4 + 1] = len1;
    getInt32Memory0()[arg0 / 4 + 0] = ptr1;
};

module.exports.__wbindgen_object_drop_ref = function(arg0) {
    takeObject(arg0);
};

module.exports.__wbg_new_abda76e883ba8a5f = function() {
    const ret = new Error();
    return addHeapObject(ret);
};

module.exports.__wbg_stack_658279fe44541cf6 = function(arg0, arg1) {
    const ret = getObject(arg1).stack;
    const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_malloc, wasm.__wbindgen_realloc);
    const len1 = WASM_VECTOR_LEN;
    getInt32Memory0()[arg0 / 4 + 1] = len1;
    getInt32Memory0()[arg0 / 4 + 0] = ptr1;
};

module.exports.__wbg_error_f851667af71bcfc6 = function(arg0, arg1) {
    let deferred0_0;
    let deferred0_1;
    try {
        deferred0_0 = arg0;
        deferred0_1 = arg1;
        console.error(getStringFromWasm0(arg0, arg1));
    } finally {
        wasm.__wbindgen_free(deferred0_0, deferred0_1, 1);
    }
};

module.exports.__wbindgen_object_clone_ref = function(arg0) {
    const ret = getObject(arg0);
    return addHeapObject(ret);
};

module.exports.__wbg_static_accessor_process_c44319a4493dffaa = function() {
    const ret = process;
    return addHeapObject(ret);
};

module.exports.__wbg_uptime_29fe439e5ec66c29 = function(arg0) {
    const ret = getObject(arg0).uptime();
    return ret;
};

module.exports.__wbg_instanceof_Window_f401953a2cf86220 = function(arg0) {
    let result;
    try {
        result = getObject(arg0) instanceof Window;
    } catch (_) {
        result = false;
    }
    const ret = result;
    return ret;
};

module.exports.__wbg_performance_3298a9628a5c8aa4 = function(arg0) {
    const ret = getObject(arg0).performance;
    return isLikeNone(ret) ? 0 : addHeapObject(ret);
};

module.exports.__wbg_now_4e659b3d15f470d9 = function(arg0) {
    const ret = getObject(arg0).now();
    return ret;
};

module.exports.__wbg_newnoargs_e258087cd0daa0ea = function(arg0, arg1) {
    const ret = new Function(getStringFromWasm0(arg0, arg1));
    return addHeapObject(ret);
};

module.exports.__wbg_call_27c0f87801dedf93 = function() { return handleError(function (arg0, arg1) {
    const ret = getObject(arg0).call(getObject(arg1));
    return addHeapObject(ret);
}, arguments) };

module.exports.__wbg_self_ce0dbfc45cf2f5be = function() { return handleError(function () {
    const ret = self.self;
    return addHeapObject(ret);
}, arguments) };

module.exports.__wbg_window_c6fb939a7f436783 = function() { return handleError(function () {
    const ret = window.window;
    return addHeapObject(ret);
}, arguments) };

module.exports.__wbg_globalThis_d1e6af4856ba331b = function() { return handleError(function () {
    const ret = globalThis.globalThis;
    return addHeapObject(ret);
}, arguments) };

module.exports.__wbg_global_207b558942527489 = function() { return handleError(function () {
    const ret = global.global;
    return addHeapObject(ret);
}, arguments) };

module.exports.__wbg_stringify_8887fe74e1c50d81 = function() { return handleError(function (arg0) {
    const ret = JSON.stringify(getObject(arg0));
    return addHeapObject(ret);
}, arguments) };

module.exports.__wbindgen_throw = function(arg0, arg1) {
    throw new Error(getStringFromWasm0(arg0, arg1));
};

module.exports.__wbg_addListener_ef6c129bb87219d9 = function(arg0, arg1, arg2, arg3) {
    const ret = getObject(arg0).addListener(getStringFromWasm0(arg1, arg2), getObject(arg3));
    return addHeapObject(ret);
};

module.exports.__wbg_on_5d61447a91633f13 = function(arg0, arg1, arg2, arg3) {
    const ret = getObject(arg0).on(getStringFromWasm0(arg1, arg2), getObject(arg3));
    return addHeapObject(ret);
};

module.exports.__wbg_once_73046d9a6e68af07 = function(arg0, arg1, arg2, arg3) {
    const ret = getObject(arg0).once(getStringFromWasm0(arg1, arg2), getObject(arg3));
    return addHeapObject(ret);
};

module.exports.__wbg_prependListener_c57792e09c18b9ac = function(arg0, arg1, arg2, arg3) {
    const ret = getObject(arg0).prependListener(getStringFromWasm0(arg1, arg2), getObject(arg3));
    return addHeapObject(ret);
};

module.exports.__wbg_prependOnceListener_56fb1130dde3be9d = function(arg0, arg1, arg2, arg3) {
    const ret = getObject(arg0).prependOnceListener(getStringFromWasm0(arg1, arg2), getObject(arg3));
    return addHeapObject(ret);
};

const path = require('path').join(__dirname, 'darklua_wasm_bg.wasm');
const bytes = require('fs').readFileSync(path);

const wasmModule = new WebAssembly.Module(bytes);
const wasmInstance = new WebAssembly.Instance(wasmModule, imports);
wasm = wasmInstance.exports;
module.exports.__wasm = wasm;

