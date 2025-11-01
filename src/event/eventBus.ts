import mitt from 'mitt';

type Events = {
	'user:roleChanged': { user_id: number; new_role: string };
//   'order:update': { order_id: number; status: number };
//   'asset:changed': { user_id: number; delta: number };
  // ...其他类型
};

const emitter = mitt<Events>();
export default emitter;
