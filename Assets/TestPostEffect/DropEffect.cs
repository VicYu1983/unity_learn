using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DropEffect : MonoBehaviour
{
    public float totalAge = 1;
    public Material mat;

    float currentAge;
    Vector3 dropScreenPos;

    void Awake()
    {
        currentAge = totalAge;
    }

    public void Trigger(Transform dropPos)
    {
        Vector3 screenPos = Camera.main.WorldToScreenPoint(dropPos.position);
        Trigger(new Vector3(screenPos.x / Screen.width, screenPos.y / Screen.height, 0));
    }

    public void Trigger(Vector3 dropPos)
    {
        dropScreenPos = dropPos;
        currentAge = 0;
    }

    void Update()
    {
        currentAge += Time.deltaTime;
        if(currentAge > totalAge)
        {
            currentAge = totalAge;
        }
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, mat);
        if (dropScreenPos != null)
        {
            mat.SetVector("_dropPos", dropScreenPos);
            mat.SetFloat("_effect", 1 - (currentAge / totalAge));
        }
    }
}
