<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-items-center tw-justify-center">
    <div class="tw-w-[360px] tw-p-2 tw-text-center">
      <!-- 顶部图标 -->
      <div class="tw-flex tw-items-center tw-justify-between tw-mb-2 tw-relative">
        <div class="tw-flex tw-items-center tw-w-full">
          <img src="@/assets/logo.png" alt="logo" class="tw-w-32 tw-h-32 tw-mx-auto" />
        </div>
        <div class="tw-absolute tw-right-0 tw-flex tw-flex-col tw-items-end">
          <button class="tw-text-red-500 tw-text-sm tw-border tw-border-solid tw-border-black tw-rounded tw-px-4 tw-py-2 tw-mb-4" @click="handleClose">关闭</button>
          <p class="tw-text-sm tw-text-gray-600 tw-mb-2">市场汇率：<span class="tw-text-red-500">{{ getExchangeRate() }}</span></p>
        </div>
      </div>
      

      <!-- 标题 & 汇率 -->
      <h2 class="tw-text-lg tw-font-semibold">提现</h2>
      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 用户信息 -->
      <div class="tw-mt-8 tw-mb-8">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">商户号：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatIdDisplay(userStore.user?.value?.id)}}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">总资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ userStore.account?.value?.totalBalance }} USDT</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">可用资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ userStore.account?.value?.availableBalance }} USDT</p>
        </div>
      </div>


      <div class="tw-mt-4 tw-text-left">
        <div class="tw-text-lg tw-font-bold">提现</div>
        <div class="tw-text-lg tw-text-red-500 tw-mt-2 tw-mb-10 withdraw-fee-text">
          每笔提现收取手续费 {{ configStore?.config?.value?.withdraw_fee }} USDT
        </div>
      </div>

      <!-- 表单 -->
      <form @submit.prevent="handleTransfer">
        <!-- 输入金额 -->
        <div class="tw-flex tw-flex-col tw-gap-4">
          <div class="tw-text-left">
            <label class="tw-font-normal">提现地址: USTD-TRC20</label>
            <input
              type="text"
              placeholder="提现地址"
              v-model="form.withdrawAddress"
              class="tw-w-full tw-border tw-border-solid tw-border-gray tw-rounded-md tw-px-3 tw-py-2 tw-text-sm tw-placeholder-gray-400 tw-mb-4"
            />
          </div>

          <input
            type="number"
            placeholder="提现金额"
            v-model="form.amount"
            class="tw-w-full tw-border tw-border-solid tw-border-gray tw-rounded-md tw-px-3 tw-py-2 tw-text-sm tw-placeholder-gray-400 tw-mb-4"
          />

          <input
            type="text"
            placeholder="支付密码"
            v-model="form.paymentPassword"
            class="tw-w-full tw-border tw-border-solid tw-border-gray tw-rounded-md tw-px-3 tw-py-2 tw-text-sm tw-placeholder-gray-400 tw-mb-4"
          />
        </div>

        <!-- 按钮 -->
        <button
          type="submit"
          class="tw-w-full tw-bg-rose-500 tw-text-white tw-font-semibold tw-rounded-full tw-py-2 tw-mt-4 hover:tw-bg-rose-600"
        >
          立即提现
        </button>
      </form>

      <button 
        class="tw-w-full tw-text-red-500 tw-font-medium tw-py-2 tw-mt-2"
        @click="handleClose"
      >
        取消
      </button>

      <!-- 底部版权 -->
      <p class="tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>

import { useRouter } from 'vue-router';
import { ref } from 'vue'
import store from '@/store'
import { formatIdDisplay, exactIdFromDisplay } from '@/utils/tool'
import * as WithdrawApi from '@/api/withdraw'

const userStore = store.user()
const configStore = store.config()

const router = useRouter()

function getExchangeRate() {
  const configStore = store.config();
  if (!configStore || !configStore.config) {
    return 0.00;
  }
  let exchangeRate = 0.00;
  // switch (listQuery.channel) {
  //   case 'alipay':
  //     exchangeRate = configStore.config.value.exchange_rate_alipay;
  //     break;
  //   case 'wechat':
  //     exchangeRate = configStore.config.value.exchange_rate_wechat;
  //     break;
  //   case 'bank':
  //     exchangeRate = configStore.config.value.exchange_rate_bank;
  //     break;
  // }
  exchangeRate = configStore.config.value.exchange_rate_alipay;
  return exchangeRate;
}

const form = ref({
  withdrawAddress: '',
  amount: 0,
  paymentPassword: ''
});

const handleClose = () => {
  router.push('/')
}

const handleTransfer = async() => {
  console.log(form.value)

  if (!form.value.withdrawAddress || !form.value.amount || !form.value.paymentPassword) {
    alert('请填写提现的各项内容');
    return;
  }

  try {
    const resp = await WithdrawApi.createWithdraw(userStore.loginToken, {
      withdrawAddress: form.value.withdrawAddress,
      amount: form.value.amount,
      paymentPassword: form.value.paymentPassword,
    })

    if (resp.data.code === 10000) {
      ElMessage.success('提交转账成功');
      const transactionId = resp.data.data.withdraw.transaction_id
      router.push(`/withdraw/detail?transactionId=${transactionId}`);
    } else {
      ElMessage.error(resp.data.msg);
    }  
  } catch (error) {
    console.log(error)
  }
  
}
</script>

<style scoped lang="scss">
.withdraw-fee-text {
    text-decoration: underline rgb(215, 215, 215);
    text-decoration-thickness: 3px; /* 增加下划线的粗细 */
    text-underline-offset: 5px; /* 增加下划线与文字的距离 */
}
</style>