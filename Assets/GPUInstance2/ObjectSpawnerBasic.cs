using System.Collections;
using UnityEngine;

public class ObjectSpawnerBasic : MonoBehaviour
{
    public GameObject m_ObjectPrefab;
    public float m_SpawningInterval = .01f;

    void Start()
    {
        StartCoroutine(SpawnObjects());
    }

    IEnumerator SpawnObjects()
    {
        WaitForSeconds waitForInterval = new WaitForSeconds(m_SpawningInterval);
        while (true)
        {
            GameObject go = Instantiate(m_ObjectPrefab, transform);
            go.transform.parent = transform;
            go.transform.position = new Vector3(Random.Range(-10f, 10f), Random.Range(-10f, 10f), Random.Range(-10f, 10f));
            //go.GetComponent<Rigidbody>().AddForce(new Vector3(Random.Range(-10f, 10f),
            //                                                  Random.Range(-10f, 10f),
            //                                                  Random.Range(-10f, 10f)));


            //ObjectPropertyHandler oph = go.AddComponent<ObjectPropertyHandler>();
            //oph.m_Color = new Color(Random.Range(0f, 1f), Random.Range(0f, 1f), Random.Range(0f, 1f), 1f);

            ObjectTextureHandler oph = go.AddComponent<ObjectTextureHandler>();
            oph.m_TextureCellAndDimension = new Vector4(Mathf.Round(Random.Range(0.0f, 1.0f)),
                                                    Mathf.Round(Random.Range(0.0f, 1.0f)), 2, 2);
            float tiling = Random.Range(1.0f, 3.0f);
            oph.m_TextureTilingAndOffset = new Vector4(tiling,
                                                       tiling,
                                                       Random.Range(0f, 1f),
                                                       Random.Range(0f, 1f));
            yield return waitForInterval;
        }
    }
}