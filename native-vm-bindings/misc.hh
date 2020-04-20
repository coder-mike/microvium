#pragma once

#include <napi.h>

#include "../native-vm/microvium.h"

void throwVMError(const Napi::Env& env, vm_TeError err);

