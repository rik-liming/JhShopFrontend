import { initUserListener } from './userListener';
import { initConfigListener } from './configListener';
// import { initAssetListener } from './assetListener';

export function initEventListeners() {
	initUserListener();
  	initConfigListener();
//   initAssetListener();
}
