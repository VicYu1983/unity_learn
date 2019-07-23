using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DrawFlowMap : MonoBehaviour
{
    public int mapSize = 512;
    public int drawSize = 10;

    Texture2D map;
    Vector3 lastMousePos = new Vector3();

    void Start()
    {
        map = new Texture2D(mapSize, mapSize);
        FillColor(new Color(.5f, .5f, 0));
        GetComponent<Image>().material.mainTexture = map;
    }
    
    public void DrawLine(int startX = 0, int startY = 0, int endX = 0, int endY = 0, int radius = 1)
    {
        Vector2 startPoint = new Vector2(startX, startY);
        Vector2 endPoint = new Vector2(endX, endY);

        Vector2 dir = endPoint - startPoint;
        Vector2 dirIdentity = dir.normalized;
        float distance = dir.magnitude;

        for( int i = 0; i < (int)distance; ++i)
        {
            Vector2 drawLocation = dirIdentity * i + startPoint;
            DrawPoint(new Color((dirIdentity.x+1)*.5f, (dirIdentity.y+1)*.5f, 0), (int)drawLocation.x, (int)drawLocation.y, radius);
        }
        
        map.Apply();
    }

    void FillColor(Color color)
    {
        var fillColorArray = map.GetPixels();
        for (var i = 0; i < fillColorArray.Length; ++i)
        {
            fillColorArray[i] = color;
        }
        map.SetPixels(fillColorArray);
        map.Apply();
    }
    
    void DrawPoint(Color color, int x = 0, int y = 0, int radius = 1)
    {
        int minX = Mathf.Max(x - radius, 0);
        int minY = Mathf.Max(y - radius, 0);
        int maxX = Mathf.Min(x + radius, mapSize);
        int maxY = Mathf.Min(y + radius, mapSize);
        Vector2 target = new Vector2(x, y);
        Vector2 drawPoint = new Vector2();
        for (int dx = minX; dx < maxX; ++dx)
        {
            for(int dy = minY; dy < maxY; ++dy)
            {
                drawPoint.x = dx;
                drawPoint.y = dy;
                float dist = (drawPoint - target).magnitude;

                if ( dist < radius)
                {
                    Color mapColor = map.GetPixel(dx, dy);
                    float factor = 1.0f - dist / (float)radius;
                    
                    map.SetPixel(dx, dy, (color * factor * .01f + mapColor));
                }
            }
        }
    }

    bool isMouseDown = false;

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            isMouseDown = true;
            lastMousePos = Input.mousePosition;
        }

        if (Input.GetMouseButtonUp(0))
        {
            isMouseDown = false;
        }

        if (isMouseDown)
        {
            Vector3 clickPos = Input.mousePosition;
            DrawLine((int)lastMousePos.x, (int)lastMousePos.y, (int)clickPos.x, (int)clickPos.y, drawSize);
            lastMousePos = clickPos;
        }
    }
}
