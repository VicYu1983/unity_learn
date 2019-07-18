using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class S : MonoBehaviour
{
    public GameObject prefab;
    public int instances = 1000;

    private List<GameObject> objs = new List<GameObject>();
    private List<Vector3> locs = new List<Vector3>();

    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < instances; ++i)
        {
            GameObject go = Instantiate(prefab, transform);
            go.transform.parent = transform;
            go.transform.position = new Vector3(Random.Range(-10f, 10f), Random.Range(-10f, 10f), Random.Range(-10f, 10f));

            ObjectTextureHandler oph = go.AddComponent<ObjectTextureHandler>();
            oph.m_TextureCellAndDimension = new Vector4(Mathf.Round(Random.Range(0.0f, 1.0f)),
                                                    Mathf.Round(Random.Range(0.0f, 1.0f)), 2, 2);
            float tiling = Random.Range(1.0f, 3.0f);
            oph.m_TextureTilingAndOffset = new Vector4(tiling,
                                                       tiling,
                                                       Random.Range(0f, 1f),
                                                       Random.Range(0f, 1f));

            objs.Add(go);
            locs.Add(go.transform.position);
        }
    }

    // Update is called once per frame
    void Update()
    {
        for (var i = 0; i < locs.Count; ++i)
        {
            Vector3 loc = locs[i];
            loc.x += 1;
            locs[i] = loc;
        }
        for(var i = 0; i < objs.Count; ++i)
        {
            objs[i].transform.position = locs[i];
        }
        //foreach( var go in objs)
        //{
        //    Vector3 pos = go.transform.position;
        //    go.transform.position = pos + new Vector3(1, 0, 0);
        //}
    }
}
