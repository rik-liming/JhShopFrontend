<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-items-center tw-justify-center">
    <div class="tw-w-[360px] tw-p-2 tw-text-center">
      <!-- 顶部图标 -->
      <div class="tw-flex tw-items-center tw-justify-between tw-mb-10 tw-relative">
        <h1 class="tw-text-left tw-text-2xl">订单详情</h1>
        <div class="tw-absolute tw-right-0 tw-flex tw-flex-col tw-items-end">
          <button class="tw-text-red-500 tw-text-sm tw-border tw-border-solid tw-border-black tw-rounded tw-px-4 tw-py-2 tw-mb-4" @click="handleClose">关闭</button>
        </div>
      </div>

      <!-- 用户信息 -->
      <div class="tw-my-4">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">商户姓名：</p>
          <p class="tw-font-semibold tw-text-right">{{ order.sell_account_name }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">收款方式：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatPaymentMethod(order.payment_method) }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">收款账号：</p>
          <p class="tw-font-semibold tw-text-right">{{ order.sell_account_number }}</p>
        </div>
      </div>

      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 用户信息 -->
      <div class="tw-my-4">
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-items-center">
          <p class="tw-text-left">收款码：</p>
          <!-- <img :src="order.payment_code" alt="payment" class="tw-w-32 tw-h-40 tw-mx-auto" /> -->
          <img src="@/assets/sample_payment.png" alt="payment" class="tw-w-32 tw-h-40 tw-mx-auto" />
        </div>
      </div>

      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 用户信息 -->
      <div class="tw-my-4">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">买家姓名：</p>
          <p class="tw-font-semibold tw-text-right">{{ order.buy_account_name }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">付款方式</p>
          <p class="tw-font-semibold tw-text-right">{{ formatPaymentMethod(order.payment_method) }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">付款账户：</p>
          <p class="tw-font-semibold tw-text-right">{{ order.buy_account_number }}</p>
        </div>
      </div>

      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 用户信息 -->
      <div class="tw-my-4">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">USDT币价：</p>
          <p class="tw-font-semibold tw-text-right">{{ order.exchange_rate }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">USDT金额：</p>
          <p class="tw-font-semibold tw-text-right">$ {{ order.total_price }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">CNY金额：</p>
          <p class="tw-font-semibold tw-text-right">{{ order.total_cny_price }} 元</p>
        </div>
      </div>

      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 用户信息 -->
      <div class="tw-my-4">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">充值时间：</p>
          <p class="tw-font-semibold tw-text-right">{{ order.created_at }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">订单编号：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatOrderIdDisplay(order.id, order.created_at) }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">订单状态：</p>
          <p class="tw-font-semibold tw-text-right" :class="{'tw-text-red-600': order.status === 1, 'tw-text-green-600': order.status === 2}">
            {{ payStatusMap[order.status] }}
          </p>
        </div>
      </div>

      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 按钮 -->
      <button
        v-if="order.status == 1"
        class="tw-w-full tw-bg-rose-500 tw-text-white tw-font-semibold tw-rounded-full tw-py-2 tw-mt-6 hover:tw-bg-rose-600"
        @click="handleConfirm"
      >
        确认收款
      </button>
      <button 
        v-if="order.status == 1"
        class="tw-w-full tw-text-red-500 tw-font-medium tw-py-2 tw-mt-2"
        @click="handleClose"
      >
        取消
      </button>

      <!-- 底部版权 -->
      <p class="tw-absolute tw-bottom-4 tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import * as OrderApi from '@/api/order'
import store from '@/store'
import { formatPaymentMethod, formatOrderIdDisplay } from '@/utils/tool'

const userStore = store.user()
const router = useRouter();
const order = ref({
  id: 0,
  sell_account_name: '',
  payment_method: '',
  sell_account_number: '',
  sell_qr_code: '',
  buy_account_name: '',
  buy_account_number: '',
  created_at: null,
  status: 0,
  exchange_rate: 0,
  total_price: 0,
  total_cny_price: 0
});

const payStatusMap = {
  0: '等待买家付款',
  1: '等待商户确认',
  2: '已确认',
  3: '已完成',
  '-1': '超时未支付',
}

// 获取订单详情
const fetchOrderDetails = async (orderId) => {
  try {
    const response = await OrderApi.getOrderDetail(userStore.loginToken, orderId)
    if (response.data.code === 10000) {
      order.value = response.data.data.order;
    }
  } catch (error) {
    console.error('Error fetching order details:', error);
  }
};

// 确认付款
const handleConfirm = async () => {
  try {
    const response = await OrderApi.orderConfirm(userStore.loginToken, {
      role: 'seller',
      orderId: order.value.id
    })

    if (response.data.code === 10000) {
      order.value.status = 2;  // 更新状态

      ElMessage.success('已确认付款成功');
      setTimeout(() => {
        router.push(`/`);
      }, 3000);
    }
  } catch (error) {
    console.error('Error confirming payment:', error);
  }
};

// 关闭页面
const handleClose = () => {
  router.push('/');
};

// 页面加载时获取订单数据
onMounted(() => {
  const orderId = router.currentRoute.value.query.orderId;
  fetchOrderDetails(orderId);
});
</script>

<style scoped lang="scss">
</style>
