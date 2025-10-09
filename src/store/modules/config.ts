import { defineStore } from 'pinia';
import * as ConfigApi from '@/api/config'
import { useStorage } from '@vueuse/core'

export interface IConfig {
  payment_address: string
  payment_qr_code: string
  transfer_fee: number
  withdrawl_fee: number
  exchange_rate_alipay: number
  exchange_rate_wechat: number
  exchange_rate_bank: number
}

export default defineStore({
  id: 'config',
  state: () => ({
    config: useStorage<IConfig>('config', {} as IConfig),
  }),
  actions: {
    // get platform config
    async getConfig(loginToken) {
      try {
        const response = await ConfigApi.getConfigInfo(loginToken)
        if (response.data.code == 10000) {
          const { config } = response.data.data;

          this.config.value = {
            payment_address: config.payment_address,
            payment_qr_code: config.payment_qr_code,
            transfer_fee: config.transfer_fee,
            withdrawl_fee: config.withdrawl_fee,
            exchange_rate_alipay: config.exchange_rate_alipay,
            exchange_rate_wechat: config.exchange_rate_wechat,
            exchange_rate_bank: config.exchange_rate_bank,
          }
        }
        return response
      } catch (error) {
        throw error;
      }
    },
  }
});
