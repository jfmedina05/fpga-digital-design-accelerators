
#include <stdio.h>
#include <stdlib.h>

#include "ema.h"

static long y = 1000;

void ema_reset( void )
{
    y = 1000;
}

long ema_simple(long x)
{
    y = (x / 4) + (y / 4) + (y / 2);
    return y;
}

