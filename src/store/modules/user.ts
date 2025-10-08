import { defineStore } from 'pinia';
import router, { resetRouter } from '@/router';
import tagsViewStore from './tagsView';
import permissionStore from './permission';
import * as AuthApi from '@/api/auth'
import * as UserApi from '@/api/user'
import { useStorage } from '@vueuse/core'

export interface IUser {
  id: string
  userName: string
  realName: string
  avatar: string
  email: string
  role: string
}

export interface IUserAccount {
  totalBalance: number
  availableBalance: number
}

export default defineStore({
  id: 'user',
  state: () => ({
    // 分开存储
    loginToken: useStorage('loginToken', ''),
    user: useStorage<IUser>('user', {} as IUser),
    account: useStorage<IUserAccount>('account', {} as IUserAccount),
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
    async getUserInfo() {
      try {
        const response = await UserApi.getUserInfo(this.loginToken)
        if (response.data.code == 10000) {
          const { account, user } = response.data.data;

          this.account.value = {
            totalBalance: account.total_balance,
            availableBalance: account.available_balance
          }
        }
        return response
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
  }
});
