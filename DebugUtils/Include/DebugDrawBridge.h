#pragma once

#include "DetourNavMesh.h"
#include "DebugDraw.h" // for duDebugDraw + enums

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct DebugDrawC
    {
        void *user;

        void (*depthMask)(void *user, bool state);
        void (*texture)(void *user, bool state);
        void (*begin)(void *user, int prim, float size);
        void (*vertex)(void *user, const float *pos, unsigned int color);
        void (*end)(void *user);
        unsigned int (*areaToCol)(void *user, unsigned int area);
    } DebugDrawC;

    // C-callable entry point
    void duDebugDrawNavMeshC(DebugDrawC *dd, const dtNavMesh *mesh, unsigned char flags);

#ifdef __cplusplus
}
#endif