import { defineStore } from 'pinia';
import * as ConfigApi from '@/api/config'
import { useStorage } from '@vueuse/core'

export interface IRemoteOrderConfig {
  openMarkets: string[]
  amountOptions: number[]
}

export interface IConfig {
  payment_address: string
  payment_qr_code: string
  transfer_fee: number
  withdrawl_fee: number
  exchange_rate_platform: number
  exchange_rate_alipay: number
  exchange_rate_wechat: number
  exchange_rate_bank: number
  advertisement_text: string
  remote_order_config: IRemoteOrderConfig
}

export default defineStore({
  id: 'config',
  state: () => ({
    config: useStorage<IConfig>('config', {} as IConfig),
  }),
  actions: {
    // get platform config
    async getConfig() {
      try {
        const response = await ConfigApi.getConfigInfo()
        if (response.data.code == 10000) {
          const { config } = response.data.data;

          this.config.value = {
            payment_address: config.payment_address,
            payment_qr_code: config.payment_qr_code,
            transfer_fee: config.transfer_fee,
            withdrawl_fee: config.withdrawl_fee,
            exchange_rate_platform: config.exchange_rate_platform,
            exchange_rate_alipay: config.exchange_rate_alipay,
            exchange_rate_wechat: config.exchange_rate_wechat,
            exchange_rate_bank: config.exchange_rate_bank,
            advertisement_text: config.advertisement_text,
            remote_order_config: config.remote_order_config
          }
        }
        return response
      } catch (error) {
        throw error;
      }
    },
  }
});
