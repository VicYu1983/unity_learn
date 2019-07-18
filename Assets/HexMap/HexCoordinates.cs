﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class HexCoordinates
{
    [SerializeField]
    private int x, z;

    public int X { get
        {
            return x;
        }
    }
    public int Z { get
        {
            return z;
        }
    }
    public int Y { get
        {
            return -X - Z;
        }
    }
    public HexCoordinates(int x, int z)
    {
        this.x = x;
        this.z = z;
    }

    public static HexCoordinates FromOffsetCoordinates(int x, int z)
    {
        return new HexCoordinates(x-z/2, z);
    }

    public static HexCoordinates FromPosition(Vector3 position)
    {
        float x = position.x / (HexMetrics.innerRadius * 2f);
        float y = -x;
        float offset = position.z / (HexMetrics.outerRadius * 3f);
        x -= offset;
        y -= offset;

        int ix = Mathf.RoundToInt(x);
        int iy = Mathf.RoundToInt(y);
        int iz = Mathf.RoundToInt(-x-y);
        if(ix + iy + iz != 0)
        {
            float dx = Mathf.Abs(x - ix);
            float dy = Mathf.Abs(y - iy);
            float dz = Mathf.Abs(-x - y - iz);

            if(dx > dy && dx > dz)
            {
                ix = -iy - iz;
            }
            else if(dz > dy)
            {
                iz = -ix - iy;
            }
        }
        return new HexCoordinates(ix, iz);
    }

    public override string ToString()
    {
        return "(" + X.ToString() + ", " + Y.ToString() + ", " + Z.ToString() + ")";
    }

    public string ToStringOnSeparateLines()
    {
        return X.ToString() + "\n" + Y.ToString() + "\n" + Z.ToString();
    }
}
