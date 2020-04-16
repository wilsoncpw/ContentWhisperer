//
//  cOpen.c
//  ContentWhisperer
//
//  Created by Colin Wilson on 16/04/2020.
//  Copyright © 2020 Colin Wilson. All rights reserved.
//

#include "cOpen.h"
#include <fcntl.h>

int cOpen (const char *path, int flags) {
    return open (path, flags);
}
