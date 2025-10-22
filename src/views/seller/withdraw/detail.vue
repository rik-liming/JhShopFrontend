<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-flex tw-justify-center">
    <div class="tw-w-[90%] tw-p-1 tw-text-center tw-flex tw-flex-col tw-justify-start tw-items-center">
      <!-- 顶部图标 -->
      <div class="tw-w-full tw-flex tw-items-center tw-justify-between tw-mt-14 tw-mb-2 tw-relative">
        <div class="tw-flex tw-items-center tw-w-full">
          <img src="@/assets/logo.png" alt="logo" class="tw-w-[104px] tw-h-[100px] tw-mx-auto" />
        </div>
        <div class="tw-absolute tw-left-0 tw-flex tw-flex-col tw-items-end">
          <hamburger 
            id="hamburger-container" 
            :is-active="appStore.sidebar.opened" 
            class="hamburger-container"
            :iconStyle="2"
            @toggleClick="toggleSidebar" 
          />
        </div>
        <div class="tw-absolute tw-right-0 tw-flex tw-flex-col tw-items-end">
          <button class="tw-text-[#D9001B] tw-font-pingfang tw-text-[17px] tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-rounded-lg tw-px-2 tw-py-1 tw-mb-16" @click="handleClose">关闭</button>
        </div>
      </div>

      <div class="tw-w-[86%] tw-text-[#333333]">
        <div class="tw-w-full tw-flex tw-flex-col tw-justify-start">
          <h1 class="tw-text-left tw-text-[23px] tw-font-pingfangsb tw-mt-10 tw-mb-4">提现详情</h1>
        </div>

        <!-- 商户号 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-6 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">商户号：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatIdDisplay(userStore?.user?.value?.id) }}</p>
        </div>

        <!-- 总资产 -->
        <div v-if="withdrawData?.status == 1" class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">总资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ withdrawData?.balance_before }} USDT</p>
        </div>

        <!-- 充值金额 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">提现金额：</p>
          <p class="tw-font-semibold tw-text-right tw-text-[#D9001B]">{{ withdrawData?.amount }} USDT</p>
        </div>
      </div>

      <hr class="tw-w-full tw-my-3 tw-border-black tw-border-opacity-30" />

      <div class="tw-w-[86%] tw-text-[#333333]">
        <!-- USDT币价 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-6 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">USDT币价：</p>
          <p class="tw-font-semibold tw-text-right">{{ withdrawData?.exchange_rate }} 元</p>
        </div>

        <!-- USDT金额 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">USDT金额：</p>
          <p class="tw-font-semibold tw-text-right">$ {{ withdrawData?.amount }}</p>
        </div>

        <!-- CNY金额 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">CNY金额：</p>
          <p class="tw-font-semibold tw-text-right">{{ withdrawData?.cny_amount }} 元</p>
        </div>
      </div>

      <hr class="tw-w-full tw-my-3 tw-border-black tw-border-opacity-30" />

      <div class="tw-w-[86%] tw-text-[#333333]">
        <!-- 商户号 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-6 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">充值时间：</p>
          <p class="tw-font-semibold tw-text-right">{{ withdrawData?.created_at }}</p>
        </div>

        <!-- 总资产 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">订单编号：</p>
          <p class="tw-font-semibold tw-text-right">{{ withdrawData?.display_withdraw_id }}</p>
        </div>

        <!-- 可用资产 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">订单状态：</p>
          <p class="tw-font-semibold tw-text-right" :class="getStatusStyle(withdrawData?.status).style">{{ getStatusStyle(withdrawData?.status).text }}</p>
        </div>

        <button
          type="submit"
          class="tw-w-[80%] !tw-bg-[rgba(217,0,27,0.67843137254902)] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[20px] tw-rounded-3xl tw-py-3 tw-mt-20 hover:tw-bg-rose-600"
          style="letter-spacing: 4px;"
          @click="handleConfirm"
        >
          我已知晓
        </button>
      </div>

      <!-- 底部版权 -->
      <p 
        class="tw-text-xs tw-text-gray-400"
        :class="(withdrawData?.status == 1 || withdrawData?.status == -1) ? `tw-mt-24` : `tw-mt-32`"
      >
        Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import * as WithdrawApi from '@/api/withdraw'
import store from '@/store'
import { formatIdDisplay } from '@/utils/tool'
import Decimal from 'decimal.js'

const router = useRouter();
const route = useRoute();
const userStore = store.user()
const configStore = store.config()
const appStore = store.app()

const withdraw_id = route.query.reference_id

const getStatusStyle = (status) => {
  switch (status) {
    case 0:
      return { style: 'tw-text-yellow-500', text: '等待平台确认' };
    case 1:
      return { style: 'tw-text-green-500', text: '已通过'};
    case -1:
      return { style: 'tw-text-red-500', text: '已驳回'};
    default:
      return { style: 'tw-text-gray-500', text: '-'};
  }
}

// 声明数据变量
const withdrawData = ref(null);

// 获取详情数据
const fetchWithdrawDetail = async () => {
  try {
    const response = await WithdrawApi.getWithdrawDetail(userStore.loginToken, withdraw_id)
    if (response.data.code === 10000) {
      withdrawData.value = response.data.data.withdraw;
    } else {
      console.error('获取数据失败');
    }
  } catch (error) {
    console.error('请求错误:', error);
  }
};

const handleClose = () => {
  router.push('/');
};

const handleConfirm = () => {
  router.push('/');
};

// 页面加载时获取充值数据
onMounted(() => {
  fetchWithdrawDetail();
});

const toggleSidebar = () => {
  appStore.toggleSidebar();
}

</script>

<style scoped lang="scss">
/* 保持样式不变 */
</style>
