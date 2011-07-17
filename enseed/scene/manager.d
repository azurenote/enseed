module enseed.scene.manager;

import dcollections.LinkList;
import enseed.lib;
import enseed.scene.node;

class SceneManager
{
	SceneNode _root;
	Driver _driver;
	
	
	@property
	{
		SceneNode root() { return _root; }
		void driver(Driver value) { _driver = value; }
		Driver driver() {return _driver;}
	}
	
	this(Device device)
	{
		_root = new SceneNode;
		_driver = device.videoDriver;
	}
	
	void render()
	{
		auto list = root.children;
		
		
		
		foreach (node; list)
		{
			auto matrix = node.transform;
			
			foreach(ref vertex; node.mesh.vertices)
			{
				vertex.point = matrix * vertex.point;
			}
			
			
			driver.drawMesh(node.mesh);
		}
	}
}