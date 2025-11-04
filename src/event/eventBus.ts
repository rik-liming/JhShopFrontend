import mitt from 'mitt';

type Events = {
	'user:roleChanged': { user_id: number; new_role: string };
	'config:changed': {};
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
