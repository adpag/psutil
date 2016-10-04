/*
 * Copyright (c) 2009, Giampaolo Rodola'. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include <Python.h>

PyObject* AccessDenied(void);
PyObject* NoSuchProcess(void);

#ifdef PSUTIL_POSIX
int psutil_pid_exists(long pid);
int psutil_raise_ad_or_nsp(long pid);
#endif
