using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class BlobParams : MonoBehaviour {

    public RectTransform[] points;
    public float blobSize = 1;
	Material blobmat;

	void Start () {
		blobmat = GetComponent<Image> ().material;
	}

	Vector4[] getShaderVectorAry(){
		Vector4[] retary = new Vector4[points.Length];
		for (int i = 0; i < points.Length; ++i) {
			RectTransform p = points [i];
            if (p != null)
            {
                float sx = (p.anchoredPosition.x + Screen.width / 2) / Screen.width;
                float sy = (p.anchoredPosition.y + Screen.height / 2) / Screen.height;
                retary[i] = new Vector4(sx, sy, 0, 1);
            }
		}
		return retary;
	}

    float getShapeValue()
    {
        return 5 - blobSize + 1;
    }

	void Update () {
        
        Vector4[] blobs = getShaderVectorAry();
        blobmat.SetVectorArray ("_point_pos", blobs);
        blobmat.SetInt("_count", blobs.Length);
        //blobmat.SetFloat("_shape", getShapeValue());
    }
}
