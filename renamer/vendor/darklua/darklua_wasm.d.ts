/* tslint:disable */
/* eslint-disable */
/**
* @param {string} code
* @param {any} opt_config
* @returns {string}
*/
export function process_code(code: string, opt_config: any): string;
/**
* @returns {any[]}
*/
export function get_all_rule_names(): any[];
/**
* @returns {string}
*/
export function get_serialized_default_rules(): string;
/**
*/
export class AgentConstructorOptions {
  free(): void;
/**
*/
  keep_alive: boolean;
/**
*/
  keep_alive_msecs: number;
/**
*/
  max_free_sockets: number;
/**
*/
  max_sockets: number;
/**
*/
  timeout: number;
}
/**
*/
export class AppendFileOptions {
  free(): void;
/**
* @param {string | undefined} [encoding]
* @param {number | undefined} [mode]
* @param {string | undefined} [flag]
*/
  constructor(encoding?: string, mode?: number, flag?: string);
/**
* @returns {AppendFileOptions}
*/
  static new(): AppendFileOptions;
/**
*/
  encoding?: string;
/**
*/
  flag?: string;
/**
*/
  mode?: number;
}
/**
*/
export class AssertionErrorOptions {
  free(): void;
/**
* @param {string | undefined} message
* @param {any} actual
* @param {any} expected
* @param {string} operator
*/
  constructor(message: string | undefined, actual: any, expected: any, operator: string);
/**
* The actual property on the error instance.
*/
  actual: any;
/**
* The expected property on the error instance.
*/
  expected: any;
/**
* If provided, the error message is set to this value.
*/
  message?: string;
/**
* The operator property on the error instance.
*/
  operator: string;
}
/**
*/
export class Configuration {
  free(): void;
/**
*/
  constructor();
/**
*/
  column_width: number;
/**
*/
  indentation_type: string;
/**
*/
  indentation_width: number;
/**
*/
  line_endings: string;
/**
*/
  quote_style: string;
}
/**
*/
export class ConsoleConstructorOptions {
  free(): void;
/**
* @param {any} stdout
* @param {any} stderr
* @param {boolean | undefined} ignore_errors
* @param {any} color_mod
* @param {object | undefined} [inspect_options]
*/
  constructor(stdout: any, stderr: any, ignore_errors: boolean | undefined, color_mod: any, inspect_options?: object);
/**
* @param {any} stdout
* @param {any} stderr
* @returns {ConsoleConstructorOptions}
*/
  static new(stdout: any, stderr: any): ConsoleConstructorOptions;
/**
*/
  color_mod: any;
/**
*/
  ignore_errors?: boolean;
/**
*/
  inspect_options?: object;
/**
*/
  stderr: any;
/**
*/
  stdout: any;
}
/**
*/
export class CreateHookCallbacks {
  free(): void;
/**
* @param {Function} init
* @param {Function} before
* @param {Function} after
* @param {Function} destroy
* @param {Function} promise_resolve
*/
  constructor(init: Function, before: Function, after: Function, destroy: Function, promise_resolve: Function);
/**
*/
  after: Function;
/**
*/
  before: Function;
/**
*/
  destroy: Function;
/**
*/
  init: Function;
/**
*/
  promise_resolve: Function;
}
/**
*/
export class CreateReadStreamOptions {
  free(): void;
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
  constructor(auto_close?: boolean, emit_close?: boolean, encoding?: string, end?: number, fd?: number, flags?: string, high_water_mark?: number, mode?: number, start?: number);
/**
*/
  auto_close?: boolean;
/**
*/
  emit_close?: boolean;
/**
*/
  encoding?: string;
/**
*/
  end?: number;
/**
*/
  fd?: number;
/**
*/
  flags?: string;
/**
*/
  high_water_mark?: number;
/**
*/
  mode?: number;
/**
*/
  start?: number;
}
/**
*/
export class CreateWriteStreamOptions {
  free(): void;
/**
* @param {boolean | undefined} [auto_close]
* @param {boolean | undefined} [emit_close]
* @param {string | undefined} [encoding]
* @param {number | undefined} [fd]
* @param {string | undefined} [flags]
* @param {number | undefined} [mode]
* @param {number | undefined} [start]
*/
  constructor(auto_close?: boolean, emit_close?: boolean, encoding?: string, fd?: number, flags?: string, mode?: number, start?: number);
/**
*/
  auto_close?: boolean;
/**
*/
  emit_close?: boolean;
/**
*/
  encoding?: string;
/**
*/
  fd?: number;
/**
*/
  flags?: string;
/**
*/
  mode?: number;
/**
*/
  start?: number;
}
/**
*/
export class FormatInputPathObject {
  free(): void;
/**
* @param {string | undefined} [base]
* @param {string | undefined} [dir]
* @param {string | undefined} [ext]
* @param {string | undefined} [name]
* @param {string | undefined} [root]
*/
  constructor(base?: string, dir?: string, ext?: string, name?: string, root?: string);
/**
* @returns {FormatInputPathObject}
*/
  static new(): FormatInputPathObject;
/**
*/
  base?: string;
/**
*/
  dir?: string;
/**
*/
  ext?: string;
/**
*/
  name?: string;
/**
*/
  root?: string;
}
/**
*/
export class GetNameOptions {
  free(): void;
/**
* @param {number | undefined} family
* @param {string} host
* @param {string} local_address
* @param {number} port
* @returns {GetNameOptions}
*/
  static new(family: number | undefined, host: string, local_address: string, port: number): GetNameOptions;
/**
*/
  family?: number;
/**
*/
  host: string;
/**
*/
  local_address: string;
/**
*/
  port: number;
}
/**
*/
export class MkdtempSyncOptions {
  free(): void;
/**
* @param {string | undefined} [encoding]
*/
  constructor(encoding?: string);
/**
* @returns {MkdtempSyncOptions}
*/
  static new(): MkdtempSyncOptions;
/**
*/
  encoding?: string;
}
/**
*/
export class NetServerOptions {
  free(): void;
/**
*/
  allow_half_open?: boolean;
/**
*/
  pause_on_connect?: boolean;
}
/**
*/
export class PipeOptions {
  free(): void;
/**
* @param {boolean | undefined} [end]
*/
  constructor(end?: boolean);
/**
*/
  end?: boolean;
}
/**
*/
export class ProcessSendOptions {
  free(): void;
/**
* @param {boolean | undefined} [swallow_errors]
*/
  constructor(swallow_errors?: boolean);
/**
*/
  swallow_errors?: boolean;
}
/**
*/
export class SetAadOptions {
  free(): void;
/**
* @param {Function} flush
* @param {number} plaintext_length
* @param {Function} transform
*/
  constructor(flush: Function, plaintext_length: number, transform: Function);
/**
*/
  flush: Function;
/**
*/
  readonly plaintextLength: number;
/**
*/
  plaintext_length: number;
/**
*/
  transform: Function;
}
/**
*/
export class StreamTransformOptions {
  free(): void;
/**
* @param {Function} flush
* @param {Function} transform
*/
  constructor(flush: Function, transform: Function);
/**
*/
  flush: Function;
/**
*/
  transform: Function;
}
/**
*/
export class UserInfoOptions {
  free(): void;
/**
* @param {string | undefined} [encoding]
*/
  constructor(encoding?: string);
/**
* @returns {UserInfoOptions}
*/
  static new(): UserInfoOptions;
/**
*/
  encoding?: string;
}
/**
*/
export class WasiOptions {
  free(): void;
/**
* @param {any[] | undefined} args
* @param {object | undefined} env
* @param {object} preopens
*/
  constructor(args: any[] | undefined, env: object | undefined, preopens: object);
/**
* @param {object} preopens
* @returns {WasiOptions}
*/
  static new(preopens: object): WasiOptions;
/**
*/
  args?: any[];
/**
*/
  env?: object;
/**
*/
  preopens: object;
}
/**
*/
export class WriteFileSyncOptions {
  free(): void;
/**
* @param {string | undefined} [encoding]
* @param {string | undefined} [flag]
* @param {number | undefined} [mode]
*/
  constructor(encoding?: string, flag?: string, mode?: number);
/**
*/
  encoding?: string;
/**
*/
  flag?: string;
/**
*/
  mode?: number;
}
