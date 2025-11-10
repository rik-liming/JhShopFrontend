import mitt from 'mitt';

type Events = {
	'user:roleChanged': { user_id: number; new_role: string };
	'user:statusChanged': { user_id: number };
	'user:passwordChanged': { user_id: number };
	'config:changed': {};
	'orderListing:updated': {};
  	'transaction:updated': { 
		user_id: number;
		transaction_id: string; 
		transaction_type: string; 
		reference_id: number;
	};
	'message:read': { user_id: number };
//   'asset:changed': { user_id: number; delta: number };
  // ...其他类型
};

const emitter = mitt<Events>();
export default emitter;
