module enseed.core.matrix;

import std.math;
import enseed.core.math;
import enseed.core.vector;

struct matrix4(T)
{	
	
	alias vector3!T vector;
	
	union
	{
		T e[4][4];
		T[16] ma;
		struct
		{
			T
				e00, e01, e02, e03,
				e10, e11, e12, e13,
				e20, e21, e22, e23,
				e30, e31, e32, e33;
		}
	}
	
	static matrix4 identity, zero;
	
	static this()
	{
		zero = matrix4(0);
		identity = matrix4(1, 0, 0, 0,
							0, 1, 0, 0,
							0, 0, 1, 0,
							0, 0, 0, 1);
	}
	
	static matrix4 opCall(T c00, T c01, T c02, T c03,
							T c10, T c11, T c12, T c13,
							T c20, T c21, T c22, T c23,
							T c30, T c31, T c32, T c33)
	{
		matrix4 m = void;
		m.e[0][0] = c00;	m.e[0][1] = c01;	m.e[0][2] = c02;	m.e[0][3] = c03;
		m.e[1][0] = c10;	m.e[1][1] = c11;	m.e[1][2] = c12;	m.e[1][3] = c13;
		m.e[2][0] = c20;	m.e[2][1] = c21;	m.e[2][2] = c22;	m.e[2][3] = c23;
		m.e[3][0] = c30;	m.e[3][1] = c31;	m.e[3][2] = c32;	m.e[3][3] = c33;
		return m;
	}
	
	
	static matrix4 opCall(T x)
	{
		return matrix4(x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x);
	}
		
	void identify()
	{
		e00 = 1, e01 = 0, e02 = 0, e03 = 0,
		e10 = 0, e11 = 1, e12 = 0, e13 = 0,
		e20 = 0, e21 = 0, e22 = 1, e23 = 0,
		e30 = 0, e31 = 0, e32 = 0, e33 = 1;
	}
	
	void transpose()
	{
	}
	
	matrix4 inverse()
	{
		matrix4 mat;
		return mat;
	}
	
	
	matrix4 rotateRadians( vector rotation )
	{
		double
			cx = cos( rotation.x ),
			sx = sin( rotation.x ),
			cy = cos( rotation.y ),
			sy = sin( rotation.y ),
			cz = cos( rotation.z ),
			sz = sin( rotation.z );

		e00 = cast(T)( cz * cy );
		e01 = cast(T)( sz * cy );
		e02 = cast(T)( -sy );
		
		e10 = cast(T)( cz * sy * sx - sz * cx );
		e11 = cast(T)( sz * sy * sx + cz * cx );
		e12 = cast(T)( cy * sx );
		
		e20 = cast(T)(cz * sy * cx + sz * sx);
		e21 = cast(T)(sz * sy * cx - cz * sx);
		e22 = cast(T)( cy * cx );

		return this;
	}
	
	matrix4 rotateDegrees(vector rotation)
	{
		return rotateRadians(rotation * DEGTORAD);
	}
	
	
	T opIndex(uint row, uint colum)
	{
		return 0;
	}
	
	
	void opBinary(string op)(matrix4 rhs)
		if (op != "*")
	{
		matrix4 mat;
		
		for (int i = 0; i < ma.length; ++i)
		{
			mixin("mat.ma[i] = ma[i] "~op~" rhs.ma[i];");
		}
		
		return mat;
	}
	
	
	matrix4 opBinary(string op)(T c)
	{
		matrix4 mat;
		
		for (int i = 0; i < ma.length; ++i)
		{
			mixin("mat.ma[i] = ma[i] "~op~" c;");
		}
		
		return mat;
	}

	
	void opOpAssign(string op)(T c)
	{
		for (int i = 0; i < ma.length; ++i)
		{
			mixin("ma[i] "~op~"= c;");
		}
	}
	
	matrix4 opNeg() { return this * cast(T)(-1); }
	
	matrix4 opMul(matrix4 m) 
	{
		matrix4 m3;
		
		m3.ma[0] = ma[0]*m.ma[0] + ma[4]*m.ma[1] + ma[8]*m.ma[2] + ma[12]*m.ma[3];
		m3.ma[1] = ma[1]*m.ma[0] + ma[5]*m.ma[1] + ma[9]*m.ma[2] + ma[13]*m.ma[3];
		m3.ma[2] = ma[2]*m.ma[0] + ma[6]*m.ma[1] + ma[10]*m.ma[2] + ma[14]*m.ma[3];
		m3.ma[3] = ma[3]*m.ma[0] + ma[7]*m.ma[1] + ma[11]*m.ma[2] + ma[15]*m.ma[3];

		m3.ma[4] = ma[0]*m.ma[4] + ma[4]*m.ma[5] + ma[8]*m.ma[6] + ma[12]*m.ma[7];
		m3.ma[5] = ma[1]*m.ma[4] + ma[5]*m.ma[5] + ma[9]*m.ma[6] + ma[13]*m.ma[7];
		m3.ma[6] = ma[2]*m.ma[4] + ma[6]*m.ma[5] + ma[10]*m.ma[6] + ma[14]*m.ma[7];
		m3.ma[7] = ma[3]*m.ma[4] + ma[7]*m.ma[5] + ma[11]*m.ma[6] + ma[15]*m.ma[7];

		m3.ma[8] = ma[0]*m.ma[8] + ma[4]*m.ma[9] + ma[8]*m.ma[10] + ma[12]*m.ma[11];
		m3.ma[9] = ma[1]*m.ma[8] + ma[5]*m.ma[9] + ma[9]*m.ma[10] + ma[13]*m.ma[11];
		m3.ma[10] = ma[2]*m.ma[8] + ma[6]*m.ma[9] + ma[10]*m.ma[10] + ma[14]*m.ma[11];
		m3.ma[11] = ma[3]*m.ma[8] + ma[7]*m.ma[9] + ma[11]*m.ma[10] + ma[15]*m.ma[11];

		m3.ma[12] = ma[0]*m.ma[12] + ma[4]*m.ma[13] + ma[8]*m.ma[14] + ma[12]*m.ma[15];
		m3.ma[13] = ma[1]*m.ma[12] + ma[5]*m.ma[13] + ma[9]*m.ma[14] + ma[13]*m.ma[15];
		m3.ma[14] = ma[2]*m.ma[12] + ma[6]*m.ma[13] + ma[10]*m.ma[14] + ma[14]*m.ma[15];
		m3.ma[15] = ma[3]*m.ma[12] + ma[7]*m.ma[13] + ma[11]*m.ma[14] + ma[15]*m.ma[15];
		
		return m3;
	}
	
	matrix4 opMul(T c)
	{
		matrix4 m;
		
		m.ma = this.ma.dup;

		foreach(ref i;m.ma)
			i *= c;
		
		return m;
	}
	
	vector opMul(in vector v)
	{
		auto temp = vector.zero;
		temp.x = v.x * e00 + v.y * e01 + v.z * e02;
		temp.y = v.x * e10 + v.y * e11 + v.z * e12;
		temp.z = v.x * e20 + v.y * e21 + v.z * e22;
		
		return temp;
	}

}

alias matrix4!float matrix4f;
alias matrix4!double matrix4d;

unittest
{
/*	auto mat = matrix4.IDENTITY;
	
	mat *= 4;

	assert(mat[0][0] == 4);	*/
}