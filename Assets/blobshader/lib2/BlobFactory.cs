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

    private int maxCount = 30;
    private GameObject wall;
    private GameObject[] blobs;

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
    }
    
    void Update()
    {
        wall.GetComponent<RectTransform>().localPosition = transformWall.localPosition;
    }

    IEnumerator StartToBlob()
    {
        for (var i = 0; i < blobs.Length; ++i)
        {
            blobs[i].GetComponent<RectTransform>().localPosition = transformInput.localPosition;
            yield return new WaitForSeconds(rate);
        }
    }
}
