using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TouchCanvas : MonoBehaviour
{
    public DropEffect postEffect;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (postEffect != null && Input.GetMouseButtonUp(0))
        {
            Vector3 dropPos = Input.mousePosition;
            dropPos.x /= Screen.width;
            dropPos.y /= Screen.height;
            postEffect.Trigger(dropPos);
        }
    }
}
