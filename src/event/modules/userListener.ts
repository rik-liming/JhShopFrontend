import pusher from '../pusher';
import emitter from '../eventBus';

export function initUserListener() {
  const channel = pusher.subscribe('jh-shop');

  channel.bind('UserRoleChanged', async (data: any) => {
	  emitter.emit('user:roleChanged', data);
  });
}
