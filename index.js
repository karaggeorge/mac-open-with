'use strict';
const path = require('path');
const execa = require('execa');
const electronUtil = require('electron-util/node');

const binary = path.join(electronUtil.fixPathForAsarUnpack(__dirname), 'open-with');

const formatApps = appList => appList.filter(app => Boolean(app.url)).sort((a, b) => {
	if (a.isDefault !== b.isDefault) {
		return b.isDefault - a.isDefault;
	}

	if (a.url.includes('Applications') !== b.url.includes('Applications')) {
		return b.url.includes('Applications') - a.url.includes('Applications');
	}

	return path.parse(a.url).name.localeCompare(path.parse(b.url).name);
});

exports.getAppsThatOpenFile = async filePath => {
	try {
		const {stdout} = await execa(binary, ['apps-for-file', path.resolve(filePath)]);
		return formatApps(JSON.parse(stdout));
	} catch {
		return [];
	}
};

exports.getAppsThatOpenType = async fileType => {
	try {
		const {stdout} = await execa(binary, ['apps-for-type', fileType]);
		return formatApps(JSON.parse(stdout));
	} catch {
		return [];
	}
};

exports.getAppsThatOpenExtension = async ext => {
	try {
		const {stdout} = await execa(binary, ['apps-for-extension', ext]);
		return formatApps(JSON.parse(stdout));
	} catch {
		return [];
	}
};

exports.openFileWithApp = (filePath, appUrl) => {
	try {
		execa.sync(binary, ['open', filePath, appUrl]);
		return true;
	} catch {
		return false;
	}
};

