using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlobFactory : MonoBehaviour
{
    public BlobRigid blobRigidLayer;
    public BlobParams blobEffectLayer;

    public GameObject prefabBlob;
    public GameObject prefabWall;
    public RectTransform transformWall;
    public RectTransform transformInput;

    public float rate = .3f;
    public float blobSize = .5f;
    public float seperate = 4f;
    public Color waterColor = new Color(0.3f, 0.5f, 0.8f);

    private int maxCount = 30;
    private GameObject wall;
    private GameObject[] blobs;

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
        StartCoroutine(StartToBlob());
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
        wall = Instantiate(prefabWall, blobRigidLayer.transform);
        blobEffectLayer.blobSize = blobSize;
        StartCoroutine(StartToBlob());

        blobEffectLayer.blobmat.SetVector("_waterColor", new Vector4(waterColor.r, waterColor.g, waterColor.b, 1));
    }
    
    void Update()
    {
        wall.GetComponent<RectTransform>().localPosition = transformWall.localPosition;
    }

    IEnumerator StartToBlob()
    {
        for (var i = 0; i < blobs.Length; ++i)
        {
            Vector3 offsetPosition = transformInput.localPosition + new Vector3(Random.Range(-seperate, seperate), Random.Range(-seperate, seperate), 0);
            blobs[i].GetComponent<RectTransform>().localPosition = offsetPosition;
            yield return new WaitForSeconds(rate);
        }
    }
}
