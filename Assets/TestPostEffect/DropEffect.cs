using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DropEffect : MonoBehaviour
{
    public float totalAge = 1.0f;
    public Material mat;

    List<float> currentAge;
    List<float> currentEffect;
    List<Vector4> dropScreenPos;

    void Awake()
    {
        currentAge = new List<float>();
        currentEffect = new List<float>();
        dropScreenPos = new List<Vector4>();

        for(int i = 0; i < 5; ++i)
        {
            currentAge.Add(totalAge);
            currentEffect.Add(0);
            dropScreenPos.Add(new Vector4());
        }
    }

    public void Trigger(Transform dropPos)
    {
        Vector3 screenPos = Camera.main.WorldToScreenPoint(dropPos.position);
        Trigger(new Vector3(screenPos.x / Screen.width, screenPos.y / Screen.height, 0));
    }

    public void Trigger(Vector3 dropPos)
    {
        dropScreenPos.RemoveAt(0);
        dropScreenPos.Add(dropPos);

        currentAge.RemoveAt(0);
        currentAge.Add(0);
    }

    void Update()
    {
        for( var i = 0; i < currentAge.Count; ++i)
        {
            currentAge[i] += Time.deltaTime;
            if (currentAge[i] > totalAge)
            {
                currentAge[i] = totalAge;
            }
            currentEffect[i] = 1.0f - (currentAge[i] / totalAge);
        }
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, mat);
        if (dropScreenPos != null)
        {
            mat.SetVectorArray("_dropPos", dropScreenPos);
            mat.SetFloatArray("_effect", currentEffect);
        }
    }
}
