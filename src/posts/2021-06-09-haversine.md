---
image: /assets/images/2021-06-09-haversine/law-of-haversines.svg
category: Distance Metric
code: https://github.com/laegsgaardTroels/haversine
---
The haversine distance can be used to calculate the distance between two points on a sphere. Here is my derivation of it.<!--more--> Assume you have two points $p_1 = (r, \theta_1, \varphi_1)$ and $p_2=(r, \theta_2, \varphi_2)$ in spherical coordinates. 

$r$ is the radius of the sphere. $\theta_1, \theta_2\in(-\frac{\pi}{2}, \frac{\pi}{2}]$ is the latitude. $\varphi_1, \varphi_2\in(-\pi, \pi]$ is the longitude.

You can convert spherical coordinates to cartesian coordinates (vectors) using:

$$
\begin{aligned}
x &= r \cdot \cos(\theta)\cos(\varphi) \\
y &= r \cdot \cos(\theta)\sin(\varphi) \\
z &= r \cdot \sin(\theta)
\end{aligned}
$$

$z = r \cdot \sin(\theta)$ is north/south, $x = r \cdot \cos(\theta)\cos(\varphi)$ and $y = r \cdot \cos(\theta)\sin(\varphi)$ defines a plane orthogonal to north/south.

Remember the dot product between two points is:

$$
\begin{aligned}
    v_1 \cdot v_2 = \lVert v_1 \rVert \lVert v_2 \rVert \cos(\angle(v_1, v_2))
\end{aligned}
$$

Where $\angle(v_1, v_2)$ is the angle between the two vectors. Let $v_1 = (x_1, y_1, z_1)^T$ and $v_2 = (x_2, y_2, z_2)^T$ where $\lVert v_1 \rVert = \lVert v_2 \rVert = r$. You can now calculate this angle by:

$$
\begin{aligned}
\angle(v_1, v_2) 
&= \arccos[\frac{v_1}{\lVert v_1 \rVert} \frac{v_2}{\lVert v_2 \rVert}] \\
&= \arccos[\cos(\theta_1)\cos(\varphi_1) \cos(\theta_2)\cos(\varphi_2) + \cos(\theta_1)\sin(\varphi_1)\cos(\theta_2)\sin(\varphi_2) + \sin(\theta_1) \sin(\theta_2)]
\end{aligned}
$$

You can calculate the distance between two points with angle $\angle(v_1, v_2)$ on a circle with radius $r$ as:

$$
d = r \cdot \angle(v_1, v_2)
$$

To show that this is the haversine:

$$
\begin{aligned}
d &= r \cdot \arccos[\cos(\theta_1)\cos(\varphi_1) \cos(\theta_2)\cos(\varphi_2) + \cos(\theta_1)\sin(\varphi_1)\cos(\theta_2)\sin(\varphi_2) + \sin(\theta_1) \sin(\theta_2)] \\
& = r \cdot \arccos[\cos(\theta_1)\cos(\theta_2) [\cos(\varphi_1) \cos(\varphi_2) + \sin(\varphi_1)\sin(\varphi_2)] + \sin(\theta_1) \sin(\theta_2)] \\
& = r \cdot \arccos[\cos(\theta_1)\cos(\theta_2) \cos(\varphi_2 - \varphi_1) + \sin(\theta_1) \sin(\theta_2)] \\
& = 2r \cdot \arcsin[(\frac{1 -[\cos(\theta_1)\cos(\theta_2) \cos(\varphi_2 - \varphi_1) + \sin(\theta_1) \sin(\theta_2)]}{2})^{0.5}] \\
& = 2r \cdot \arcsin[(\frac{1 -\cos(\theta_1)\cos(\theta_2) \cos(\varphi_2 - \varphi_1) - \sin(\theta_1) \sin(\theta_2)]}{2})^{0.5}] \\
& = 2r \cdot \arcsin[(\frac{1 -\cos(\theta_1)\cos(\theta_2) \cos(\varphi_2 - \varphi_1) - (\cos(\theta_2 - \theta_1) - \cos(\theta_1) \cos(\theta_2))}{2})^{0.5}] \\
& = 2r \cdot \arcsin[(\frac{1 -\cos(\theta_1)\cos(\theta_2) \cos(\varphi_2 - \varphi_1) - \cos(\theta_2 - \theta_1) + \cos(\theta_1) \cos(\theta_2)}{2})^{0.5}] \\
& = 2r \cdot \arcsin[(\frac{1 - \cos(\theta_2 - \theta_1) + \cos(\theta_1)\cos(\theta_2) (1 - \cos(\varphi_2 - \varphi_1))}{2})^{0.5}] \\
& = 2r \cdot \arcsin[(\sin^2(\frac{\theta_2 - \theta_2}{2}) + \cos(\theta_1)\cos(\theta_2)\sin^2(\frac{\varphi_2 - \varphi_1}{2}))^{0.5}] \\
\end{aligned}
$$

For the first equality we expand on the equality above. For the second we refactor $\cos(\theta_1)\cos(\theta_2)$. For the third equality it is used that: $\cos(\varphi_2 - \varphi_1) = \cos(\varphi_1) \cos(\varphi_2) + \sin(\varphi_1)\sin(\varphi_2)$. For the fourth we ues that $\arccos(x)=2\arcsin[(\frac{1-x}{2})^{0.5})$. For the fifth we multiply $-1$ into the parenthesis. For the sixth we use $\sin(\theta_1)\sin(\theta_2) = \cos(\theta_2 - \theta_1) - \cos(\theta_1) \cos(\theta_2)$. For the seventh we multiply $-1$ into the parenthesis. For the ninth we rearrange. For the eigth we use $\sin^2(\frac{x}{2}) = \frac{1-\cos(x)}{2}$

The righthand side is now the haversine, see [1]. And voila done.

## Example: AIS Data

Here is a small example in Python with AIS data for one vessel. I calculate the distance between each point and compare two of above calculations.


```python
import numpy as np

# Radius of the earth in meters.
EARTH_RADIUS_METERS = 6378137.00

ais = np.genfromtxt('ais.csv', delimiter=',', names=True) 

def haversine(lat1, lon1, lat2, lon2):
    lat1, lon1, lat2, lon2 = map(np.radians, [lat1, lon1, lat2, lon2])
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = (
        np.sin(dlat / 2.0) ** 2
        + np.cos(lat1) * np.cos(lat2) * np.sin(dlon / 2.0) ** 2
    )
    return 2 * EARTH_RADIUS_METERS * np.arcsin(np.sqrt(a))


def other_haversine(lat1, lon1, lat2, lon2):
    lat1, lon1, lat2, lon2 = map(np.radians, [lat1, lon1, lat2, lon2])
    x1, y1, z1 = xyz(lat1, lon1)
    x2, y2, z2 = xyz(lat2, lon2)
    theta = np.arccos(x1 * x2 + y1 * y2 + z1 * z2)
    return theta * EARTH_RADIUS_METERS


def xyz(lat, lon):
    x = np.cos(lat) * np.cos(lon)
    y = np.cos(lat) * np.sin(lon)
    z = np.sin(lat)
    return x, y, z 
```

They're equal up to 1 cm e.g. 0.01 meter.


```python
lat1 = ais['latitude'][1:]
lon1 = ais['longitude'][1:]
lat2 = ais['latitude'][:-1]
lon2 = ais['longitude'][:-1]

np.all(np.abs(other_haversine(lat1, lon1, lat2, lon2) - haversine(lat1, lon1, lat2, lon2)) < 0.01)
```




    True



# References

[1] https://en.wikipedia.org/wiki/Haversine_formula

[2] https://en.wikipedia.org/wiki/Circular_arc
