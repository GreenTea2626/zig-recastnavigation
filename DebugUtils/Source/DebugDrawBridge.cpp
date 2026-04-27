#include "DebugDrawBridge.h"
#include "DetourDebugDraw.h"

struct DebugDrawAdapter : duDebugDraw
{
    DebugDrawC *cb;

    DebugDrawAdapter(DebugDrawC *c) : cb(c) {}

    void depthMask(bool state) override
    {
        if (cb->depthMask)
            cb->depthMask(cb->user, state);
    }

    void texture(bool state) override
    {
        if (cb->texture)
            cb->texture(cb->user, state);
    }

    void begin(duDebugDrawPrimitives prim, float size) override
    {
        if (cb->begin)
            cb->begin(cb->user, prim, size);
    }

    void vertex(const float *pos, unsigned int color) override
    {
        if (cb->vertex)
            cb->vertex(cb->user, pos, color);
    }

    void vertex(float x, float y, float z, unsigned int color) override
    {
        float p[3] = {x, y, z};
        if (cb->vertex)
            cb->vertex(cb->user, p, color);
    }

    void vertex(const float *pos, unsigned int color, const float *uv) override
    {
        (void)uv;
        if (cb->vertex)
            cb->vertex(cb->user, pos, color);
    }

    void vertex(float x, float y, float z, unsigned int color, float u, float v) override
    {
        (void)u;
        (void)v;

        float p[3] = {x, y, z};
        if (cb->vertex)
            cb->vertex(cb->user, p, color);
    }

    void end() override
    {
        if (cb->end)
            cb->end(cb->user);
    }

    unsigned int areaToCol(unsigned int area) override
    {
        if (cb->areaToCol)
            return cb->areaToCol(cb->user, area);
        return duIntToCol(area, 255);
    }
};

extern "C" void duDebugDrawNavMeshC(DebugDrawC *dd, const dtNavMesh *mesh, unsigned char flags)
{
    DebugDrawAdapter adapter(dd);
    duDebugDrawNavMesh(&adapter, *mesh, flags);
}