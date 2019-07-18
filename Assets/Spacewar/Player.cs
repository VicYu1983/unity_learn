using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    public Rigidbody shield;
    public Rigidbody armor;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
        {
            shield.AddTorque(0, 50000, 0);
        }
        if (Input.GetKeyDown(KeyCode.R))
        {
            shield.AddTorque(0, -50000, 0);
        }
        if (Input.GetKeyDown(KeyCode.W))
        {
            shield.AddTorque(0, -50000, 0);
        }
        if (Input.GetKeyDown(KeyCode.S))
        {
            shield.AddTorque(0, -50000, 0);
        }
        if (Input.GetKeyDown(KeyCode.A))
        {
            shield.AddTorque(0, -50000, 0);
        }
        if (Input.GetKeyDown(KeyCode.D))
        {
            shield.AddTorque(0, -50000, 0);
        }
    }
}
