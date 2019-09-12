'use strict';
const path = require('path');
const execa = require('execa');
const electronUtil = require('electron-util/node');
const macosVersion = require('macos-version');

const binary = path.join(electronUtil.fixPathForAsarUnpack(__dirname), 'open-with');

const isAlreadySorted = macosVersion.isGreaterThanOrEqualTo('10.15');
const isSupported = macosVersion.isGreaterThanOrEqualTo('10.14.4');

const formatApps = appList => appList.filter(app => Boolean(app.url)).sort((a, b) => {
	if (a.isDefault !== b.isDefault) {
		return b.isDefault - a.isDefault;
	}

	if (isAlreadySorted) {
		return 0;
	}

	if (a.url.includes('Applications') !== b.url.includes('Applications')) {
		return b.url.includes('Applications') - a.url.includes('Applications');
	}

	return path.parse(a.url).name.localeCompare(path.parse(b.url).name);
});

const callBinary = async (subCommand, argument) => {
	if (!isSupported) {
		return [];
	}

	try {
		const {stdout} = await execa(binary, [subCommand, argument]);
		return formatApps(JSON.parse(stdout));
	} catch {
		return [];
	}
};

const callBinarySync = (subCommand, argument) => {
	if (!isSupported) {
		return [];
	}

	try {
		const {stdout} = execa.sync(binary, [subCommand, argument]);
		return formatApps(JSON.parse(stdout));
	} catch {
		return [];
	}
};

exports.getAppsThatOpenFile = filePath => callBinary('apps-for-file', path.resolve(filePath));
exports.getAppsThatOpenFile.sync = filePath => callBinarySync('apps-for-file', path.resolve(filePath));

exports.getAppsThatOpenType = fileType => callBinary('apps-for-type', fileType);
exports.getAppsThatOpenType.sync = fileType => callBinarySync('apps-for-type', fileType);

exports.getAppsThatOpenExtension = fileExtension => callBinary('apps-for-extension', fileExtension);
exports.getAppsThatOpenExtension.sync = fileExtension => callBinarySync('apps-for-extension', fileExtension);

exports.openFileWithApp = (filePath, appUrl) => {
	if (!isSupported) {
		return false;
	}

	try {
		execa.sync(binary, ['open', filePath, appUrl]);
		return true;
	} catch {
		return false;
	}
};

