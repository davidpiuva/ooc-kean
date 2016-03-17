/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

import ../Process
import PipeWin32

version(windows) {
ProcessWin32: class extends Process {
	si: StartupInfo
	pi: ProcessInformation
	cmdLine: String

	init: func ~win32 (=args) {
		sb := CharBuffer new()
		for (arg in args)
			sb append(arg). append(' ')
		cmdLine = sb toString()
		ZeroMemory(si&, StartupInfo size)
		si structSize = StartupInfo size
		ZeroMemory(pi&, ProcessInformation size)
	}
	_wait: func (duration: Long) -> Int {
		// Wait until child process exits.
		status := WaitForSingleObject(pi process, duration)
		exitCode := -1
		if (status == WAIT_OBJECT_0) {
			GetExitCodeProcess(pi process, exitCode&)
			CloseHandle(pi thread)
			CloseHandle(pi process)
		}
		exitCode
	}
	wait: override func -> Int { this _wait(INFINITE) }
	waitNoHang: override func -> Int { this _wait(0) }
	executeNoWait: override func -> Long {
		if (stdIn != null || stdOut != null || stdErr != null) {
			if (stdIn != null) {
				si stdInput = stdIn as PipeWin32 readFD
				SetHandleInformation(stdOut as PipeWin32 writeFD, HANDLE_FLAG_INHERIT, 0)
			}
			if (stdOut != null) {
				si stdOutput = stdOut as PipeWin32 writeFD
				SetHandleInformation(stdOut as PipeWin32 readFD, HANDLE_FLAG_INHERIT, 0)
			}
			if (stdErr != null) {
				si stdError = stdErr as PipeWin32 writeFD
				SetHandleInformation(stdErr as PipeWin32 readFD, HANDLE_FLAG_INHERIT, 0)
			}
			si flags |= StartFlags UseStdHandles
		}

		envString := buildEnvironment()

		// Reference: http://msdn.microsoft.com/en-us/library/ms682512%28VS.85%29.aspx
		// Start the child process.
		if (!CreateProcess(
			null, // No module name (use command line)
			cmdLine toCString(), // Command line
			null, // Process handle not inheritable
			null, // Thread handle not inheritable
			true, // Set handle inheritance to true
			0, // No creation flags
			envString, // Use parent's environment block
			cwd ? cwd toCString() : null, // Use custom cwd if we have one
			si&, // Pointer to STARTUPINFO structure
			pi& // Pointer to PROCESS_INFORMATION structure
		)) {
			err := GetLastError()
			raise("CreateProcess failed (error %d: %s).\n Command Line:\n %s" format(err, GetWindowsErrorMessage(err), cmdLine))
			return -1
		}

		if (stdIn != null)
			stdIn close('r')
		if (stdOut != null)
			stdOut close('w')
		if (stdErr != null)
			stdErr close('w')

		this pid = pi pid
		pi pid
	}
	buildEnvironment: func -> Char* {
		if (env == null)
			return null

		envLength := 1
		env each(|k, v|
			envLength += k size
			envLength += v size
			envLength += 2 // one for the =, one for the \0
		)

		envString := CString new(envLength)
		index := 0
		for (k in env keys) {
			v := env get(k)

			memcpy(envString + index, k toCString(), k size)
			index += k size

			envString[index] = '='
			index += 1

			memcpy(envString + index, v toCString(), v size)
			index += v size

			envString[index] = '\0'
			index += 1
		}

		envString[index] = '\0'
		envString
	}
	terminate: override func { "please implement me! ProcessWin32 terminate" println() }
	kill: override func { "please implement me! ProcessWin32 kill" println() }
}
}
