import { defineStore } from 'pinia';
import { login as apiLogin, logout as apiLogout, getInfo as apiGetInfo } from '@/api/user.jsb';
import router, { resetRouter } from '@/router';
import tagsViewStore from './tagsView';
import permissionStore from './permission';
import * as AuthApi from '@/api/auth'
import { useStorage } from '@vueuse/core'

export interface IUser {
  id: string
  userName: string
  realName: string
  avatar: string
  email: string
  role: string
}

export default defineStore({
  id: 'user',
  state: () => ({
    // 分开存储
    loginToken: useStorage('loginToken', ''),
    user: useStorage<IUser>('user', {} as IUser),
  }),
  actions: {
    // user verify otp and login
    async verifyOtp(email: string, otp: string) {
      try {
        const response = await AuthApi.verifyOtp({email, otp})
        if (response.data.code == 10000) {
          const { token, user } = response.data.data;

          this.loginToken = token
          this.user.value = {
            id: user.id,
            userName: user.user_name,
            realName: user.real_name,
            avatar: user.avatar,
            email: user.email,
            role: user.role,
          }
        }
        return response
      } catch (error) {
        throw error;
      }
    },

    // get user info
    async getInfo() {
      try {
        const response = await apiGetInfo(this.token);
        const { data } = response;

        if (!data) {
          throw new Error('Verification failed, please Login again.');
        }

        const { roles, name, avatar, introduction } = data;

        if (!roles || roles.length <= 0) {
          throw new Error('getInfo: roles must be a non-null array!');
        }

        this.roles = roles;
        this.name = name;
        this.avatar = avatar;
        this.introduction = introduction;

        return data;
      } catch (error) {
        throw error;
      }
    },

    // user logout
    async logout() {
      try {
        // 登出是前端登出即可，后端处理失败也同样退出
        const response = await AuthApi.logout(this.loginToken)
        this.loginToken = '';
        this.user = null;
        resetRouter();
        tagsViewStore().delAllViews();

        // if (response.data.code == 10000) {
          
        // }
      } catch (error) {
        throw error;
      }
    },

    // remove token
    resetToken() {
      this.token = '';
      this.role = '';
    },

    // dynamically modify permissions
    async changeRoles(role: string) {
      const token = role + '-token';
      this.token = token;
      // setToken(token);

      const infoRes = await this.getInfo();
      const roles = infoRes.roles || [];

      resetRouter();

      // generate accessible routes map based on roles
      const accessRoutes = await permissionStore().generateRoutes(roles);

      // dynamically add accessible routes
      accessRoutes.forEach(item => {
        router.addRoute(item);
      });

      tagsViewStore().delAllViews();
    }
  }
});
