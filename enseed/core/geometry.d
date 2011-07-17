module enseed.core.geometry;

import enseed.core.vector;

struct vertex
{
	vector3f point;
	vector3f color;
	
	static vertex opCall(float x, float y, float z,
						 float r, float g, float b)
	{
		vertex v;
		v.point = [x,y,z];
		v.color = [r,g,b];
		
		return v;
	}
	
	static vertex opCall(float x, float y, float z)
	{
		vertex v;
		v.point = [x,y,z];
		v.color = [0.5,0.5,0.5];
		return v;
	}
}