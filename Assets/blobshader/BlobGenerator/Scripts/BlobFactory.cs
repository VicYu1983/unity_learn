using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

public class BlobFactory : MonoBehaviour
{
    public GameObject prefabBlob;
    public GameObject prefabCup;
    public RectTransform transformCup;
    public RectTransform transformInput;

    public float rate = .3f;
    public float blobSize = .5f;
    public float seperate = 4f;
    public Color waterColor = new Color(0.3f, 0.5f, 0.8f);

    private int maxCount = 30;
    private GameObject cup;
    private GameObject[] blobs;

    private BlobRigid blobRigidLayer;
    private BlobParams blobEffectLayer;

    private bool keepOut = true;

    public void Clear()
    {
        foreach(GameObject blob in blobs)
        {
            blob.GetComponent<RectTransform>().localPosition = new Vector3(int.MaxValue, 0, 0);
            blob.GetComponent<Rigidbody2D>().Sleep();
        }
    }

    public void ReStart()
    {
        Clear();
        TurnOn();
        StartCoroutine(StartToBlob());
    }

    public void TurnOff()
    {
        keepOut = false;
    }

    public void TurnOn()
    {
        keepOut = true;
    }

    void Awake()
    {
        if( prefabCup == null )
        {
            throw new Exception("請輸入prefabCup參數!");
        }
        if( prefabBlob == null )
        {
            throw new Exception("請輸入prefabBlob參數!");
        }
        if (transformCup == null )
        {
            throw new Exception("請輸入transformCup參數!");
        }
        if(transformInput == null)
        {
            throw new Exception("請輸入transformInput參數!");
        }
        blobRigidLayer = GetComponentInChildren<BlobRigid>();
        blobEffectLayer = GetComponentInChildren<BlobParams>();
    }

    void Start()
    {
        blobs = new GameObject[maxCount];
        for (var i = 0; i < maxCount; ++i)
        {
            blobs[i] = Instantiate(prefabBlob, blobRigidLayer.transform);
            blobs[i].GetComponent<RectTransform>().localPosition = new Vector3(int.MaxValue, 0, 0);
            blobs[i].GetComponent<RectTransform>().localScale = new Vector3(blobSize, blobSize, 1);
            blobEffectLayer.points[i] = blobs[i].GetComponent<RectTransform>();
        }
        cup = Instantiate(prefabCup, blobRigidLayer.transform);
        blobEffectLayer.blobSize = blobSize;
        StartCoroutine(StartToBlob());

        blobEffectLayer.blobmat.SetVector("_waterColor", new Vector4(waterColor.r, waterColor.g, waterColor.b, 1));
    }
    
    void Update()
    {
        cup.GetComponent<RectTransform>().localPosition = transformCup.localPosition;
    }
    
    IEnumerator StartToBlob()
    {
        for (var i = 0; i < blobs.Length; ++i)
        {
            if (keepOut)
            {
                Vector3 offsetPosition = transformInput.localPosition + new Vector3(UnityEngine.Random.Range(-seperate, seperate), UnityEngine.Random.Range(-seperate, seperate), 0);
                blobs[i].GetComponent<RectTransform>().localPosition = offsetPosition;
            }
            yield return new WaitForSeconds(rate);
        }
    }
}
