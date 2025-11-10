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
          <h1 class="tw-text-left tw-text-2xl tw-mt-14 tw-mb-10">转账详情</h1>
      </div>

      <!-- 用户信息 -->
      <div class="tw-my-4">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">ID：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatIdDisplay(transferData?.sender_user_id) }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">总资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ transferData?.transaction?.balance_before }} USDT</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">转账金额：</p>
          <p class="tw-font-semibold tw-text-right tw-text-red-600">- {{ transferData?.amount }} USDT</p>
        </div>
      </div>

      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 用户信息 -->
      <div class="tw-my-6">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">USDT币价：</p>
          <p class="tw-font-semibold tw-text-right">{{ transferData?.exchange_rate }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">USDT金额：</p>
          <p class="tw-font-semibold tw-text-right">{{ transferData?.amount }} USDT</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">CNY金额：</p>
          <p class="tw-font-semibold tw-text-right">{{ transferData?.cny_amount }} 元</p>
        </div>
      </div>

      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 用户信息 -->
      <div class="tw-my-6">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">对方ID：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatIdDisplay(transferData?.receiver_user_id) }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">转账时间：</p>
          <p class="tw-font-semibold tw-text-right">{{ transferData?.created_at }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">订单编号：</p>
          <p class="tw-font-semibold tw-text-right">{{ transferData?.transaction_id }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">订单状态：</p>
          <p class="tw-font-semibold tw-text-right tw-text-red-600">{{ transferStatusMap[transferData?.status] }}</p>
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
import { useRouter, useRoute } from 'vue-router';
import { ref, onMounted } from 'vue';
import { formatIdDisplay } from '@/utils/tool'
import * as TransferApi from '@/api/transfer'
import store from '@/store'

const transferStatusMap = {
  0: '待平台确认',
  1: '已通过',
  '-1': '已驳回',
}

const router = useRouter()
const route = useRoute()

const userStore = store.user()
const configStore = store.config()

const transactionId = route.query.transactionId
const transferData = ref(null);

const handleClose = () => {
  router.push('/')
}

const handleConfirm = () => {
  router.push('/')
}
// 页面加载时获取充值数据
onMounted(() => {
  fetchTransferDetail();
});

// 获取充值详情数据
const fetchTransferDetail = async () => {
  try {
    const response = await TransferApi.getTransferDetail(userStore.loginToken, transactionId)
    if (response.data.code === 10000) {
      transferData.value = response.data.data.transfer;
    } else {
      console.error('获取数据失败');
    }
  } catch (error) {
    console.error('请求错误:', error);
  }
};

</script>

<style scoped lang="scss">
</style>
