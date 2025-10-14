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
      <h2 class="tw-text-lg tw-font-semibold">充值</h2>
      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 表单 -->
      <form @submit.prevent="handleRecharge" class="tw-mb-4">

        <!-- 商户号 -->
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">商户号：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatIdDisplay(userStore?.user?.value?.id) }}</p>
        </div>

        <!-- 总资产 -->
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">总资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ userStore?.account?.value?.totalBalance }} USDT</p>
        </div>

        <!-- 可用资产 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2">
          <p class="tw-text-left">可用资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ userStore?.account?.value?.availableBalance }} USDT</p>
        </div>

        <!-- 地址展示 -->
        <div class="tw-text-left tw-mb-3">
          <p class="tw-font-medium">接收地址（平台）：USDT-TRC20</p>
          <div
            class="tw-w-full tw-bg-gray-100 tw-rounded-md tw-border tw-border-gray-300 tw-px-2 tw-py-1 tw-break-all tw-text-sm tw-mt-1"
          >
            TAqVNKoVVfVKLU31s3tPBdhRZFKgJVeRH5
          </div>
        </div>

        <!-- 输入金额 -->
        <input
          type="text"
          placeholder="请输入充值金额（此处字体透明度35%）"
          v-model="form.amount"
          class="tw-w-full tw-border tw-border-solid tw-border-gray tw-rounded-md tw-px-3 tw-py-2 tw-text-sm tw-placeholder-gray-400 tw-mb-4"
        />

        <!-- 上传截图 -->
        <div class="tw-text-left tw-mb-3">
          <p class="tw-font-medium tw-mb-3">上传充值截图（必选）</p>

          <CustomFileUpload v-model:file="imageFile" />
        </div>

        <!-- 按钮 -->
        <button
          type="submit"
          class="tw-w-full tw-bg-rose-500 tw-text-white tw-font-semibold tw-rounded-full tw-py-2 tw-mt-4 hover:tw-bg-rose-600"
        >
          立即充值
        </button>
        <button 
          type="button"
          class="tw-w-full tw-text-red-500 tw-font-medium tw-py-2 tw-mt-2"
          @click="handleClose"
        >
          取消
        </button>
      </form>

      <!-- 底部版权 -->
      <p class="tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import CustomFileUpload from '@/components/CustomFileUpload';
import store from '@/store'
import { formatIdDisplay } from '@/utils/tool'
import * as RechargeApi from '@/api/recharge'

const configStore = store.config()
const userStore = store.user()

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

const imageFile = ref(null);
const form = ref({
  amount: '',
  imageFile: null,
});

const router = useRouter();

const handleClose = () => {
  router.push('/');
};

const handleRecharge = async() => {
  // 你可以在这里添加验证逻辑（比如检查金额和文件上传）
  if (!form.value.amount || !imageFile.value) {
    alert('请填写充值金额并上传截图');
    return;
  }

  const resp = await RechargeApi.createRecharge(userStore.loginToken, {
    amount: form.value.amount
  })

  if (resp.data.code === 10000) {
    ElMessage.success('提交充值成功');
    const transactionId = resp.data.data.recharge.transaction_id
    router.push(`/recharge/detail?transactionId=${transactionId}`);
  }
};
</script>

<style scoped lang="scss">
/* 保持样式不变 */
</style>
