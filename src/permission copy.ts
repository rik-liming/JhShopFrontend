import router from './router';
import store from '@/store';
import permissionStore from './store/modules/permission';
import NProgress from 'nprogress'; // progress bar
import 'nprogress/nprogress.css'; // progress bar style
import getPageTitle from '@/utils/get-page-title';

NProgress.configure({ showSpinner: false }); // NProgress Configuration

const whiteList = ['/login', '/register', '/register/success', '/auth-redirect']; // no redirect whitelist

router.beforeEach(async (to, from, next) => {
  // console.log('router.beforeEach', to.path, from.path);
  // start progress bar
  NProgress.start();

  // set page title
  document.title = getPageTitle(to.meta.title);

  // determine whether the user has logged in
  const userStore = store.user()

  const hasToken = !!userStore.loginToken

  if (hasToken) {

    if (to.path === '/login' || to.path === '/register') {
      // if is logged in, redirect to the home page
      NProgress.done();
      next({ path: '/' });
    } else {
      const hasRoles = !!userStore.user?.value?.role

      // determine whether the user has obtained his permission roles through getInfo
      // console.log('hasRoles=', hasRoles);
      if (hasRoles) {
        let roles = [userStore.user?.value?.role]
        const accessRoutes = await permissionStore().generateRoutes(roles);

        // 重新添加新的路由
        accessRoutes.forEach(route => {
          router.addRoute(route);  // 添加新的路由
        });

        next();
      } else {
        try {
          ElMessage.error('无权访问!');
          NProgress.done();
          next(`/login?redirect=${to.path}`);
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        } catch (error: any) {
          // remove token and go to login page to re-login
          // await userStore().resetToken();
          ElMessage.error(error.message || 'Has Error');
          NProgress.done();
          next(`/login?redirect=${to.path}`);
        }
      }
    }
  } else {
    /* has no token*/
    if (whiteList.indexOf(to.path) !== -1) {
      // in the free login whitelist, go directly
      next();
    } else {
      // other pages that do not have permission to access are redirected to the login page.
      NProgress.done();
      next(`/login?redirect=${to.path}`);
    }
  }
});

router.afterEach(() => {
  // finish progress bar
  NProgress.done();
});
