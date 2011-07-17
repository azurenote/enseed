module enseed.scene.camera;

import enseed.core.vector;

class Camera
{
	vector3f _position;
	
	@property
	{
		vector3f position() {return _position;}
		void position(vector3f pos) {_position = pos;}
	}
}