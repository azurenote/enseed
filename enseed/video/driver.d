module enseed.video.driver;

import
	derelict.sdl.sdl,
	derelict.opengl.gl,
	derelict.opengl.glu;

import enseed.core.geometry;
import enseed.scene.camera;
import enseed.video.mesh;

class Driver
{
private:
	Camera _activeCam;
	
public:
	
	@property
	{
		Camera activeCamera() {return _activeCam;}
		void activeCamera(Camera value) {_activeCam = value;}
	}
	

	bool begin()
	{
		// clear the screen. by default it clears to black
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);		
		glShadeModel(GL_SMOOTH);

		return true;
	}
	
	void end()
	{
		glFlush();
		// swap the buffers, making our backbuffer the visible one
		SDL_GL_SwapBuffers();
	}
		
	void drawPoints(vertex[] list)
	{
		glBegin(GL_TRIANGLE_STRIP);
		foreach(v; list)
		{
			glColor3fv(v.color.array.ptr);
			glVertex3fv(v.point.array.ptr);
		}
		glEnd();
	}
	
	void drawMesh(Mesh mesh)
	{
		glBegin(GL_TRIANGLE_STRIP);
		foreach(v; mesh.vertices)
		{
			glColor3fv(v.color.array.ptr);
			glVertex3fv(v.point.array.ptr);
		}
		glEnd();
	}
}