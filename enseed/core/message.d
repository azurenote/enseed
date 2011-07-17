module enseed.core.message;

import std.array;

interface IMessage
{
	@property
	{
		int type();
		long senderID();
		long targetID();
	}
}

class Message(T) : IMessage
{
	int _type;
	long _senderID;
	long _targetID;

	@property
	{
		int type() {return _type;}
		long senderID() {return _senderID;}
		long targetID() {return _targetID;}
	}
}

interface IMessageReceiver
{
	@property
	{
		long receiverID();
	}

	void receive(IMessage);
}

interface IMessageRouter
{
	void addReceiver(IMessageReceiver);

	void removeReceiver(IMessageReceiver);

	//remove by id
	void removeReceiver(long);
}

class MessageRouter : IMessageRouter
{
	IMessageReceiver[long] receivers;
	IMessage[] queue;

	void send(IMessage message)
	{
		queue ~= message;
	}

	void addReceiver(IMessageReceiver receiver)
	{
		receivers[receiver.receiverID] = receiver;
	}

	void removeReceiver(IMessageReceiver receiver)
	{
		receivers.remove(receiver.receiverID);
	}
	

	//remove by id
	void removeReceiver(long id)
	{
		receivers.remove(id);
	}

	void progress()
	{
		while (queue.length > 0)
		{
			auto message = queue.front();
			
			auto target = receivers[message.targetID];
			
			target.receive(message);
			
			queue.popFront();
		}
	}
}