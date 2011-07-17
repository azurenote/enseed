module enseed.utility.singleton;

template StaticSingleton()
{
	public
	{
		static this()
		{
			_instance = new typeof(this)();
		}
	
		static typeof(this) instance()
		{
			return _instance;
		}
		
		static void release()
		{
			delete _instance;
		}
	}
	
	protected this()
	{
	}
	
	private
	{
		static typeof(this) _instance = null;
	}
}