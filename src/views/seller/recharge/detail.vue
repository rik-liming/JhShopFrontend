<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-flex tw-justify-center">
    <div class="tw-w-[90%] tw-p-1 tw-text-center tw-flex tw-flex-col tw-justify-start tw-items-center">
      <!-- 顶部图标 -->
      <div class="tw-w-full tw-flex tw-items-center tw-justify-between tw-mt-14 tw-mb-2 tw-relative">
        <div class="tw-flex tw-items-center tw-w-full">
          <img src="@/assets/logo.png" alt="logo" class="tw-w-[104px] tw-h-[100px] tw-mx-auto" />
        </div>
        <div class="tw-absolute tw-left-0 tw-flex tw-flex-col tw-items-end">
          <!-- <hamburger 
            id="hamburger-container" 
            :is-active="appStore.sidebar.opened" 
            class="hamburger-container"
            :iconStyle="2"
            @toggleClick="toggleSidebar" 
          /> -->
        </div>
        <div class="tw-absolute tw-right-0 tw-top-0 tw-flex tw-flex-col tw-items-end">
          <!-- <button class="tw-text-[#D9001B] tw-font-pingfang tw-text-[17px] tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-rounded-lg tw-px-2 tw-py-1 tw-mb-16" @click="handleClose">关闭</button> -->
          <img 
            src="@/assets/close_icon.png" 
            alt="close" 
            class="cursor-pointer tw-w-8 tw-h-8" 
            @click="handleClose"
          />
        </div>
        <div class="tw-absolute tw-top-[-44px] tw-right-[-10px] tw-flex tw-flex-col tw-items-end tw-mt-36">
          <p class="tw-text-sm tw-mb-2 tw-mr-4 tw-font-songti tw-font-bold tw-text-[#333333]">市场汇率：<span class="tw-text-red-500 tw-font-pingfang tw-font-normal" style="color: rgba(rgba(217, 0, 27, 0.854901960784314))">{{ configStore.config?.value?.exchange_rate_platform }}</span></p>
        </div>
      </div>

      <hr class="tw-w-[90%] tw-mt-4 tw-border-black tw-border-opacity-20" />

      <div class="tw-w-[86%] tw-text-[#333333]">
        <div class="tw-w-full tw-flex tw-flex-col tw-justify-start">
          <h1 class="tw-text-left tw-text-[23px] tw-font-pingfangsb tw-mt-6 tw-mb-4">充值详情</h1>
        </div>

        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-6 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">ID：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatIdDisplay(rechargeData?.user_id) }}</p>
        </div>

        <!-- 总资产 -->
        <div v-if="rechargeData?.status == 1 || rechargeData?.status == -1" class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">总资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ rechargeData?.balance_before }} USDT</p>
        </div>

        <!-- 充值金额 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">充值金额：</p>
          <p class="tw-font-semibold tw-text-right tw-text-[#D9001B]">{{ rechargeData?.amount }} USDT</p>
        </div>
      </div>

      <hr class="tw-w-full tw-my-3 tw-border-black tw-border-opacity-30" />

      <div class="tw-w-[86%] tw-text-[#333333]">
        <!-- USDT币价 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-6 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">USDT币价：</p>
          <p class="tw-font-semibold tw-text-right">{{ rechargeData?.exchange_rate }} 元</p>
        </div>

        <!-- USDT金额 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">USDT金额：</p>
          <p class="tw-font-semibold tw-text-right">$ {{ rechargeData?.amount }}</p>
        </div>

        <!-- CNY金额 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">CNY金额：</p>
          <p class="tw-font-semibold tw-text-right">{{ rechargeData?.cny_amount }} 元</p>
        </div>
      </div>

      <hr class="tw-w-full tw-my-3 tw-border-black tw-border-opacity-30" />

      <div class="tw-w-[86%] tw-text-[#333333]">
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-6 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">充值时间：</p>
          <p class="tw-font-semibold tw-text-right">{{ rechargeData?.created_at }}</p>
        </div>

        <!-- 总资产 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">订单编号：</p>
          <p class="tw-font-semibold tw-text-right">{{ rechargeData?.display_recharge_id }}</p>
        </div>

        <!-- 可用资产 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">订单状态：</p>
          <p class="tw-font-semibold tw-text-right" :class="getStatusStyle(rechargeData?.status).style">{{ getStatusStyle(rechargeData?.status).text }}</p>
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
        :class="(rechargeData?.status == 1 || rechargeData?.status == -1) ? `tw-mt-24` : `tw-mt-32`"
      >
        Copy@ JH嘉禾商城</p>
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
const appStore = store.app()

const recharge_id = route.query.reference_id
const goback = route.query.goback
const myTableType = route.query.myTableType

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
const rechargeData = ref(null);

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
const handleClose = () => {
  if (goback) {
    router.push(`${goback}?myTableType=${myTableType}`);
  } else {
    router.push('/');
  }
};

const handleConfirm = () => {
  if (goback) {
    router.push(`${goback}?myTableType=${myTableType}`);
  } else {
    router.push('/');
  }
};

// 页面加载时获取充值数据
onMounted(() => {
  fetchRechargeDetail();
});

const toggleSidebar = () => {
  appStore.toggleSidebar();
}

</script>

<style scoped lang="scss">
/* 保持样式不变 */
</style>
