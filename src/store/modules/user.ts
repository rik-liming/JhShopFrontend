import { defineStore } from 'pinia';
import { resetRouter } from '@/router';
import tagsViewStore from './tagsView';
import * as AuthApi from '@/api/auth';
import * as UserApi from '@/api/user';
import { useStorage } from '@vueuse/core';

// 每个浏览器 tab 都有独立的 ID
const tabId = sessionStorage.getItem('tabId') || crypto.randomUUID();
sessionStorage.setItem('tabId', tabId);

export interface IUser {
  id: string;
  userName: string;
  realName: string;
  avatar: string;
  email: string;
  role: string;
  inviteCode: string;
}

export interface IUserAccount {
  totalBalance: number;
  availableBalance: number;
}

export default defineStore({
  id: 'user',
  state: () => ({
    loginToken: useStorage(`loginToken_${tabId}`, ''),
    user: useStorage<IUser>(`user_${tabId}`, {} as IUser),
    account: useStorage<IUserAccount>(`account_${tabId}`, {} as IUserAccount),
  }),
  actions: {
    async verifyOtp(email: string, otp: string) {
      const response = await AuthApi.verifyOtp({ email, otp });
      if (response.data.code === 10000) {
        const { token, user } = response.data.data;
        this.loginToken = token;
        this.user.value = {
          id: user.id,
          userName: user.user_name,
          realName: user.real_name,
          avatar: user.avatar,
          email: user.email,
          role: user.role,
          inviteCode: user.invite_code,
        };
      }
      return response;
    },

    async getUserInfo() {
      const response = await UserApi.getUserInfo(this.loginToken);
      if (response.data.code === 10000) {
        const { account } = response.data.data;
        this.account.value = {
          totalBalance: account.total_balance,
          availableBalance: account.available_balance,
        };
      }
      return response;
    },

    async getAccountInfo() {
      const response = await UserApi.getAccountInfo(this.loginToken);
      if (response.data.code === 10000) {
        const { account } = response.data.data;
        this.account.value = {
          totalBalance: account.total_balance,
          availableBalance: account.available_balance,
        };
        console.log("update account... ", this.account.value)
      }
      return response;
    },

    async logout() {
      try {
        await AuthApi.logout(this.loginToken);
      } finally {
        this.loginToken = '';
        this.user.value = {} as IUser;
        this.account.value = {} as IUserAccount;
        resetRouter();
        tagsViewStore().delAllViews();
      }
    },
  },
});
