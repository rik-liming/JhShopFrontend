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
        </div>
      </div>

      <!-- 标题 & 汇率 -->
      <div class="tw-relative">
          <h1 class="tw-text-left tw-text-2xl tw-mt-14 tw-mb-10">充值详情</h1>
      </div>

      <!-- 用户信息 -->
      <div class="tw-my-4" v-if="rechargeData">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">ID：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatIdDisplay(userStore.user?.value?.id) }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">总资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ userStore.account?.value?.totalBalance }} USDT</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">充值金额：</p>
          <p class="tw-font-semibold tw-text-right tw-text-red-600">{{ rechargeData.amount }} USDT</p>
        </div>
      </div>

      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 汇率 -->
      <div class="tw-my-6" v-if="rechargeData">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">USDT币价：</p>
          <p class="tw-font-semibold tw-text-right">{{ getExchangeRate() }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">USDT金额：</p>
          <p class="tw-font-semibold tw-text-right">{{ rechargeData.amount }} USDT</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">CNY金额：</p>
          <p class="tw-font-semibold tw-text-right">{{ getExchangeCNY(rechargeData.amount) }} CNY</p>
        </div>
      </div>

      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 订单信息 -->
      <div class="tw-my-6" v-if="rechargeData">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">充值时间：</p>
          <p class="tw-font-semibold tw-text-right">{{ rechargeData.created_at }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">订单编号：</p>
          <p class="tw-font-semibold tw-text-right">{{ rechargeData.transaction_id }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">订单状态：</p>
          <p class="tw-font-semibold tw-text-right tw-text-red-600">{{ rechargeStatusMap[rechargeData.status] }}</p>
        </div>
      </div>

      <!-- 按钮 -->
      <button
        class="tw-w-full tw-bg-rose-500 tw-text-white tw-font-semibold tw-rounded-full tw-py-2 tw-mt-14 hover:tw-bg-rose-600"
        @click="handleConfirm"
      >
        我已知晓
      </button>

      <!-- 底部版权 -->
      <p class="tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import * as RechargeApi from '@/api/recharge'
import store from '@/store'
import { formatIdDisplay } from '@/utils/tool'
import Decimal from 'decimal.js'

const router = useRouter();
const route = useRoute();
const userStore = store.user()
const configStore = store.config()

const recharge_id = route.query.reference_id

const rechargeStatusMap = {
  0: '待平台确认',
  1: '已通过',
  '-1': '已驳回',
}

// 声明数据变量
const rechargeData = ref(null);

const getExchangeCNY = (amount) => {
  const num1 = new Decimal(amount);  // 第一个数
  const num2 = new Decimal(getExchangeRate());    // 第二个数

  // 相乘并保留 2 位小数
  const result = num1.mul(num2).toFixed(2, Decimal.ROUND_UP);
  return result
}

// 获取充值详情数据
const fetchRechargeDetail = async () => {
  try {
    const response = await RechargeApi.getRechargeDetail(userStore.loginToken, recharge_id)
    if (response.data.code === 10000) {
      rechargeData.value = response.data.data.recharge;
    } else {
      console.error('获取数据失败');
    }
  } catch (error) {
    console.error('请求错误:', error);
  }
};

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

const handleClose = () => {
  router.push('/');
};

const handleConfirm = () => {
  router.push('/');
};

// 页面加载时获取充值数据
onMounted(() => {
  fetchRechargeDetail();
});
</script>

<style scoped lang="scss">
</style>
