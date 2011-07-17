module enseed.lib;

import derelict.sdl.sdl;
import derelict.sdl.image;
import derelict.opengl.gl;
import derelict.opengl.glu;

import
	enseed.utility.singleton,
	enseed.core.vector;

public
{
	import enseed.video.driver;
}

// horizontal and vertical screen resolution
const int   xResolution     = 800;
const int   yResolution     = 600;

// number of bits per pixel used for display. 24 => true color
const int   bitsPerPixel    = 24;

// field of view => the angle our camera will see vertically
const float fov             = 45.f;

// distance of the near clipping plane
const float nearPlane       = .1f;

// distance of the far clipping plane
const float farPlane        = 100.f;

class Device
{
	mixin StaticSingleton;
	
	private
	{
		bool inited;
		Driver _driver;
	}
	
	struct Initializer
	{
		string windowCaption;
		size2i windowSize;
		uint pixelSize;
	}
	

	private this()
	{
	}
	
	~this()
	{
		try
		{
		// tell SDL to quit
		SDL_Quit();
		}
		catch(Exception o)
		{
		}

	}
	
	@property
	{
		Driver videoDriver() { return _driver; }
		
		void windowCaption(string caption)
		{
			SDL_WM_SetCaption(caption.ptr, null);
		}
	}

	bool run()
	{
		SDL_Event event;
		
		SDL_PollEvent(&event);
		
		switch(event.type)
		{
			case SDL_QUIT:
				return false;
			default:
		}
		
		return true;
	}
	
	bool initialize(Initializer data)
	{
		DerelictGLU.load();
		DerelictGL.load();
		DerelictSDL.load();
		DerelictSDLImage.load();
		
		SDL_Init(SDL_INIT_VIDEO);

		// enable double-buffering
		SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

		// create our OpenGL window
		SDL_SetVideoMode(data.windowSize.x, data.windowSize.y, data.pixelSize, SDL_OPENGL);
		SDL_WM_SetCaption(data.windowCaption.ptr, null);
		
		
		// switch to the projection mode matrix
		glMatrixMode(GL_PROJECTION);

		// load the identity matrix for projection
		glLoadIdentity();


		// setup a perspective projection matrix
		gluPerspective(fov, cast(float)xResolution / yResolution, nearPlane, farPlane);


		// switch back to the modelview transformation matrix
		glMatrixMode(GL_MODELVIEW);

		// load the identity matrix for modelview
		glLoadIdentity();
		
		_driver = new Driver;
		
		inited = true;
		return true;
	}
	
}