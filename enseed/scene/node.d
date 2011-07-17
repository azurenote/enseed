module enseed.scene.node;

import
	std.algorithm,
	dcollections.LinkList,
	enseed.core.vector,
	enseed.core.matrix,
	enseed.video.mesh;

class SceneNode
{
private:
	vector3f _position;
	matrix4f _transform;
	bool _isVisible;
	LinkList!SceneNode _children;

	Mesh _mesh;
	
public:
	
	this()
	{
		_children = new LinkList!SceneNode;
		_isVisible = true;
		_position = vector3f.zero;
		
		_transform.identify();
	}
	
	@property
	{
		ref vector3f position() { return _position; }
		ref matrix4f transform() {return _transform;}
		void transform(matrix4f value) {_transform = value;}
		
		void mesh(Mesh value) { _mesh = value; }
		Mesh mesh() {return _mesh;}
		auto children() { return _children[]; }
		
		bool isVisible() {return _isVisible;}
		void isVisible(bool value) {_isVisible = value;}
	}
	
	void addChild(SceneNode child)
	{
		_children.add(child);
	}
	
	void removeChild(SceneNode child)
	{
		auto cursor = find(_children[], child).begin;
		
		_children.remove(cursor);
	}
	
	Mesh getTransformedMesh()
	{
		return null;
	}
}