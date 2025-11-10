import pusher from '../pusher';
import emitter from '../eventBus';

export function initTransactionListener() {
  const channel = pusher.subscribe('jh-shop');

  channel.bind('TransactionUpdated', async (data: any) => {
	  emitter.emit('transaction:updated', data);
  });

  channel.bind('OrderListingUpdated', async (data: any) => {
	  emitter.emit('orderListing:updated', data);
  });
}
