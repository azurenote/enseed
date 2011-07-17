module enseed.core.vector;

import std.math : sqrt;
import std.conv;
import std.string : format;
import std.numeric : dotProduct;
import enseed.core.math;

template VectorOperation(T, alias V)
{
	alias typeof(this) vector_t;
	alias typeof(V) array_t;

final:

	T opIndex(size_t index) { return V[index]; }

	T opIndexAssign(T value, size_t index) { return V[index] = value; }
	
	ref vector_t opAssign(array_t arr)
	{
		for (int i = 0; i < V.length; ++i)
			V[i] = arr[i];

		return this;
	}
	
	ref vector_t opAssign(vector_t rhs)
	{
		for (int i = 0; i < V.length; ++i)
			V[i] = rhs[i];
		
		return this;
	}
	
	@property T squaredLength() 
	{
		T res = 0;

		for (int i = 0; i < V.length; i++)
			res += ( V[i] * V[i] );

		return res;
	}
		
	T squaredDistanceTo(vector_t rhs) { return (rhs - this).squaredLength; }
	
	T dot(vector_t rhs) { return dotProduct(V, rhs.array); }


	
	static if (is(T : float) || is(T : double)  || is(T : real))
	{
		@property
		{
			T length() { return cast(T) sqrt( squaredLength ); }

			vector_t normalized() 
			{	
				vector_t v = this;
				v.normalize();
				return v;
			}
		}

		void normalize() { this *= (1 / length); }		
			
		T distanceTo(vector_t v) { return cast(T) sqrt( squaredDistanceTo(v) ); }
	}
}



struct vector3(T)
{
	union
	{
		struct
		{
			T x, y, z;
		}
		T[3] array;
	}
	
	this(T x, T y, T z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	static vector3 opCall(T x, T y, T z)
	{
		vector3 v = void;
		v.x = x;
		v.y = y;
		v.z = z;
		
		return v;
	}
	
	static vector3 opCall(T[3] a, T[3] b)
	{
		return vector3(b[0] - a[0], b[1] - a[1], b[2] - a[2]);
	}
	
	static vector3 zero;

	
	mixin VectorOperation!(T, array);
	

	vector3 opBinary(string op)(vector3 rhs)
	{
		mixin("return vector3(x "~op~" rhs.x, y "~op~" rhs.y, z "~op~" rhs.z);");
	}
	
	vector3 opBinary(string op)(T c)
	{
		mixin("return vector3(x "~op~" c, y "~op~" c, z "~op~" c);");
	}
	
	vector3 opBinaryRight(string op)(T c)
	{
		mixin("return vector3(x "~op~" c, y "~op~" c, z "~op~" c);");
	}
	
	void opOpAssign(string op)(vector3 rhs)
	{
		mixin("x "~op~"= rhs.x; y "~op~"= rhs.y; z "~op~"= rhs.y;");
	}
	
	void opOpAssign(string op)(T c)
	{
		mixin("x "~op~"= c; y "~op~"= c; z "~op~"= c;");
	}
	
	vector3 opNeg() { return vector3(-x, -y, -z); }
	
	vector3 cross(vector3 rhs)
	{
		return  vector3(y * rhs.z - z * rhs.y,
						z * rhs.x - x * rhs.z,
						x * rhs.y - y * rhs.x);
	}
	
	string toString() { return format("vector(%f, %f, %f)", x, y, z); }
}

alias vector3!int vector3i;
alias vector3!float vector3f;


@property bool isZero(float value)
//	if (is(T : float) || is(T : double))
{
	return value < float.epsilon;
}

unittest
{
	vector3f v, v2;

	v[0] = 123;
	assert(v.x == 123, "opindexassign");
	
	assert((-v).x == -123, "opneg");

	v2 = v = [1,2,3];
	assert(v.y == 2, "opbin(arr)");
	
	assert((v + v2).x == 2, "opbin(vector)");
	
	assert((v - 3).z == 0, "opbin(T)");
	

	v *= 2;
	assert(v.z == 6, "opassign");
		
	v = vector3f(1,1,0);
	v2 = vector3f(-1,1,0);
	
	assert(v.distanceTo(v2) == 2, "distance2");
	
	assert(v.dot(v2) < float.epsilon, "dot product");

	v.normalize();
	v2.normalize();
	
	assert((v.cross(v2).z - 1).isZero, "cross product");
}




struct vector2(T)
{
	union
	{
		struct { T x, y; }
		T[2] array;
	}
	
	this(T x, T y)
	{
		this.x = x;
		this.y = y;
	}
	
	static vector2 opCall(T x, T y)
	{
		vector2 v = void;
		v.x = x;
		v.y = y;
		
		return v;
	}

	
	mixin VectorOperation!(T, array);
	
	vector2 opBinary(string op)(vector2 rhs)
	{
		mixin("return vector2(x "~op~" rhs.x, y "~op~" rhs.y);");
	}
	
	vector2 opBinary(string op)(T c)
	{
		mixin("return vector2(x "~op~" c, y "~op~" c);");
	}
	
	vector2 opBinaryRight(string op)(T c)
	{
		mixin("return vector2(x "~op~" c, y "~op~" c);");
	}
	
	void opOpAssign(string op)(vector2 rhs)
	{
		mixin("x "~op~"= rhs.x; y "~op~"= rhs.y;");
	}
	
	void opOpAssign(string op)(T c)
	{
		mixin("x "~op~"= c; y "~op~"= c;");
	}
	
	vector2 opNeg() { return vector2(-x, -y); }

	string toString() { return format("vector(%f, %f)", x, y); }
}


alias vector2!int vector2i;
alias vector2!float vector2f;
alias vector2i size2i;




vector3!T getNormalVector(T)(T[3][3] array)
	if (is(T : float) || is(T : double))
{
	alias vector3!T vector;
	
	auto a = vector3(array[1][0] - array[0][0],
					 array[1][1] - array[0][1],
					 array[1][2] - array[0][2]);
	auto b = vector3(array[2][0] - array[0][0],
					 array[2][1] - array[0][1],
					 array[2][2] - array[0][2]);
	
	auto c = a.cross(b);
	
	c.normalize();
	
	return c;
}

import std.stdio;

unittest
{
	float[3][3] array = [[0,0,0], [1,0,0], [0,2,0]];

	auto v = getNormalVector!(float)(array);
	
	writeln(typeid(v));
	
	writeln(v);
}