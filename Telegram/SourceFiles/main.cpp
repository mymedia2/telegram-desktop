/*
This file is part of Telegram Desktop,
the official desktop application for the Telegram messaging service.

For license and copyright information please follow this link:
https://github.com/telegramdesktop/tdesktop/blob/master/LEGAL
*/
#include "core/launcher.h"

int main(int argc, char *argv[]) {
	// Telegram doesn't start when extraordinary theme is set, see launchpad.net/bugs/1680943
	unsetenv("QT_QPA_PLATFORMTHEME");

	const auto launcher = Core::Launcher::Create(argc, argv);
	return launcher ? launcher->exec() : 1;
}
