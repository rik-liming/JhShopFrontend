import { initUserListener } from './userListener';
import { initConfigListener } from './configListener';
import { initTransactionListener } from './transactionListener';

export function initEventListeners() {
	initUserListener();
  	initConfigListener();
  	initTransactionListener();
}
