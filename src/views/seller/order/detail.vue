<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-flex tw-justify-center">
    <div class="tw-w-[90%] tw-p-1 tw-text-center tw-flex tw-flex-col tw-justify-start tw-items-center">

      <div class="tw-w-[86%] tw-text-[#333333]">
        <div class="tw-relative tw-w-full tw-flex tw-flex-col tw-justify-start">
          <h1 class="tw-text-left tw-text-[23px] tw-font-pingfangsb tw-mt-16 tw-mb-4">订单详情</h1>

          <div class="tw-absolute tw-right-0 tw-top-14 tw-flex tw-flex-col tw-items-end">
            <!-- <button class="tw-text-[#D9001B] tw-font-pingfang tw-text-[17px] tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-rounded-lg tw-px-2 tw-py-1 tw-mb-16" @click="handleClose">关闭</button> -->
            <img 
              src="@/assets/close_icon.png" 
              alt="close" 
              class="cursor-pointer tw-w-8 tw-h-8" 
              @click="handleClose"
            />
          </div>
        </div>

        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-2 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">商户姓名：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.sell_account_name }}</p>
        </div>

        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">收款方式：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatPaymentMethod(order?.payment_method) }}</p>
        </div>

        <div v-if="order?.payment_method === 'bank'" class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">银行名称：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.sell_bank_name }}</p>
        </div>

        <div v-if="order?.payment_method === 'bank'" class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">开户行：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.sell_issue_bank_name }}</p>
        </div>

        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">收款账号：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.sell_account_number }}</p>
        </div>

      </div>

      <hr class="tw-w-full tw-my-1 tw-border-black tw-border-opacity-30" />

      <div v-if="order?.payment_method !== 'bank'" class="tw-w-[86%] tw-text-[#333333]">
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-items-center tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">收款码：</p>
          <img 
            :src="order?.sell_qr_code ? formatImageUrl(order.sell_qr_code) : ''"
            alt="payment" 
            class="tw-w-32 tw-h-40 tw-mx-auto" 
          />
        </div>
      </div>

      <hr v-if="order?.payment_method !== 'bank'" class="tw-w-full tw-my-1 tw-border-black tw-border-opacity-30" />

      <div class="tw-w-[86%] tw-text-[#333333]">
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">买家姓名：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.buy_account_name }}</p>
        </div>

        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">付款方式：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatPaymentMethod(order?.payment_method) }}</p>
        </div>

        <div v-if="order?.payment_method === 'bank'" class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">银行名称：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.buy_bank_name }}</p>
        </div>

        <div v-if="order?.payment_method === 'bank'" class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">开户行：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.buy_issue_bank_name }}</p>
        </div>

        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">付款账号：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.buy_account_number }}</p>
        </div>
      </div>

      <hr class="tw-w-full tw-my-1 tw-border-black tw-border-opacity-30" />

      <div class="tw-w-[86%] tw-text-[#333333]">
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">USDT币价：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.exchange_rate }} 元</p>
        </div>

        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">USDT金额：</p>
          <p class="tw-font-semibold tw-text-right">$ {{ order?.total_price }}</p>
        </div>

        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">CNY金额：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.total_cny_price }} 元</p>
        </div>
      </div>

      <hr class="tw-w-full tw-my-1 tw-border-black tw-border-opacity-30" />

      <div class="tw-w-[86%] tw-text-[#333333]">
        <!-- 商户号 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">创建时间：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.created_at }}</p>
        </div>

        <!-- 总资产 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">订单编号：</p>
          <p class="tw-font-semibold tw-text-right">{{ order?.display_order_id }}</p>
        </div>

        <!-- 可用资产 -->
        <div 
          class="tw-flex tw-justify-between tw-space-x-4 tw-font-pingfangsb tw-font-semibold"
          :class="order?.payment_method === 'bank' ? `tw-mb-20` : `tw-mb-10`"
        >
          <p class="tw-text-left">订单状态：</p>
          <p class="tw-font-semibold tw-text-right" :class="getStatusStyle(order?.status).style">{{ getStatusStyle(order?.status).text }}</p>
        </div>

        <button
          v-if="order?.status == 1"
          type="button"
          class="tw-w-[80%] !tw-bg-[rgba(217,0,27,0.67843137254902)] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[20px] tw-rounded-3xl tw-py-3 hover:tw-bg-rose-600"
          style="letter-spacing: 4px;"
          @click="handleConfirm"
        >
          确认收款
        </button>

        <button
          v-else
          type="button"
          class="tw-w-[80%] !tw-bg-[rgba(217,0,27,0.67843137254902)] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[20px] tw-rounded-3xl tw-py-3 hover:tw-bg-rose-600"
          style="letter-spacing: 4px;"
          @click="handleClose"
        >
          我已知晓
        </button>

        <button 
          type="button"
          class="tw-w-full !tw-text-[#D82D15] tw-font-medium tw-font-pingfang tw-py-2 tw-mt-2"
          @click="handleClose"
        >
          取消
        </button>
      </div>

      <!-- 底部版权 -->
      <p 
        class="tw-absolute tw-bottom-2 tw-text-xs tw-text-gray-400"
      >
        Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import * as OrderApi from '@/api/order'
import store from '@/store'
import { formatPaymentMethod, formatImageUrl } from '@/utils/tool'

const userStore = store.user()
const router = useRouter();
const order = ref(null);

const getStatusStyle = (status) => {
  switch (status) {
    case 0:
      return { style: 'tw-text-yellow-500', text: '等待买家付款' };
    case 1:
      return { style: 'tw-text-blue-500', text: '等待商户确认'};
    case 2:
      return { style: 'tw-text-green-500', text: '已完成'};
    case 3:
      return { style: 'tw-text-gray-500', text: '超时取消'};
    case 4:
      return { style: 'tw-text-red-500', text: '争议'};
    case 5:
      return { style: 'tw-text-green-500', text: '已完成（争议结束）'};
    case 6:
      return { style: 'tw-text-gray-500', text: '已完成（争议撤单）'};
    default:
      return { style: 'tw-text-gray-500', text: '-'};
  }
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
      role: userStore?.user?.value?.role,
      orderId: order.value.id
    })

    if (response.data.code === 10000) {

      ElMessage.success('确认收款成功');
      order.value.status = 2;  // 更新状态
      await userStore.getUserInfo()
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
/* 保持样式不变 */
</style>
