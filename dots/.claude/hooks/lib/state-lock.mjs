import { lstatSync, readFileSync, realpathSync } from 'node:fs';
import { relative, isAbsolute, sep } from 'node:path';
import { pathToFileURL } from 'node:url';
const PACKAGE_ROOT = "/home/boris/.local/share/mise/installs/npm-oh-my-claude-sisyphus/5.5.0/node_modules/.mise/oh-my-claude-sisyphus@5.5.0/node_modules/oh-my-claude-sisyphus";
const EXPECTED_PACKAGE_NAME = "oh-my-claude-sisyphus";
const EXPECTED_PACKAGE_VERSION = "5.5.0";
const PACKAGE_JSON = PACKAGE_ROOT + '/package.json';
const HELPER_PATH = PACKAGE_ROOT + '/scripts/lib/state-lock.mjs';
function validatePackageOwnedHelper() {
  if (!lstatSync(PACKAGE_ROOT).isDirectory() || realpathSync(PACKAGE_ROOT) !== PACKAGE_ROOT || !lstatSync(PACKAGE_JSON).isFile() || !lstatSync(HELPER_PATH).isFile()) throw new Error('OMC state-lock bridge package root is unavailable');
  if (realpathSync(PACKAGE_JSON) !== PACKAGE_JSON) throw new Error('OMC state-lock bridge manifest identity changed');
  const helperReal = realpathSync(HELPER_PATH);
  const helperRelative = relative(PACKAGE_ROOT, helperReal);
  if (isAbsolute(helperRelative) || helperRelative === '..' || helperRelative.startsWith('..' + sep)) throw new Error('OMC state-lock bridge helper escapes package root');
  let manifest;
  try { manifest = JSON.parse(readFileSync(PACKAGE_JSON, 'utf8')); } catch { throw new Error('OMC state-lock bridge package manifest is invalid'); }
  if (!manifest || manifest.name !== EXPECTED_PACKAGE_NAME || manifest.version !== EXPECTED_PACKAGE_VERSION) throw new Error('OMC state-lock bridge package identity mismatch');
}
validatePackageOwnedHelper();
const canonical = await import(pathToFileURL(HELPER_PATH).href);
export const processStartIdentity = canonical.processStartIdentity;
export const isStateFileLockingSupported = canonical.isStateFileLockingSupported;
export const isExclusiveStateLockingAvailable = canonical.isExclusiveStateLockingAvailable;
export const getStateFileLockDiagnostic = canonical.getStateFileLockDiagnostic;
export const getStateFileLockFailureMessage = canonical.getStateFileLockFailureMessage;
export const acquireStateFileLockSync = canonical.acquireStateFileLockSync;
export const releaseStateFileLockSync = canonical.releaseStateFileLockSync;
export const withStateFileLockSync = canonical.withStateFileLockSync;
export const acquireRecoveryClaim = canonical.acquireRecoveryClaim;
export const readRecoveryClaim = canonical.readRecoveryClaim;
export const releaseRecoveryClaim = canonical.releaseRecoveryClaim;
export const sameRecoveryClaim = canonical.sameRecoveryClaim;
export const isEmergencyOwnerLive = canonical.isEmergencyOwnerLive;
