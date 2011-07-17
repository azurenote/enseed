module enseed.core.math;

private import std.math : PI;

//Constant for PI.
//enum PI	= 3.14159265359f;

//Constant for reciprocal of PI.
enum RECIPROCAL_PI = 1.0f / PI;

//Constant for half of PI.
enum HALF_PI = PI / 2.0f;

//! 32bit Constant for converting from degrees to radians
enum DEGTORAD = PI / 180.0f;

//! 32bit constant for converting from radians to degrees (formally known as GRAD_PI)
enum RADTODEG = 180.0f / PI;
