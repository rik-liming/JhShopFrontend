import pusher from '../pusher';
import emitter from '../eventBus';

export function initConfigListener() {
  const channel = pusher.subscribe('jh-shop');

  channel.bind('ConfigChanged', async (data: any) => {
	  emitter.emit('config:changed', data);
  });
}
