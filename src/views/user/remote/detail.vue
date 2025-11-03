<template>
  <div class="page-container">

    <div class="main-box">

      <!-- Logo -->
      <div class="logo-container tw-relative">
        <img src="@/assets/logo.png" alt="logo" class="logo" />
		<span 
			class="tw-absolute tw-right-10 tw-top-2 tw-text-[#d9001b] tw-text-[28px] tw-font-bold"
			style="font-family: 'Rockwell-Bold', 'Rockwell Bold', 'Rockwell'"
		>
			Good!
		</span>
		<div class="tw-absolute tw-right-4 tw-top-12 tw-flex tw-flex-col tw-items-end">
			<!-- <button class="tw-text-[#D9001B] tw-font-pingfang tw-text-[17px] tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-rounded-lg tw-px-2 tw-py-1 tw-mb-16" @click="handleClose">关闭</button> -->
			<img 
				src="@/assets/close_icon.png" 
				alt="close" 
				class="cursor-pointer tw-w-8 tw-h-8" 
				@click="handleClose"
			/>
		</div>
      </div>
    </div>

	<div class="main-box tw-flex tw-flex-col tw-items-center">

		<div class="tw-w-[86%] tw-text-[#333333]">
			<div class="tw-relative tw-w-full tw-flex tw-flex-col tw-justify-start">
				<h1 class="tw-text-left tw-text-[23px] tw-font-pingfangsb tw-mt-4 tw-mb-4">订单详情</h1>
			</div>

			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-2 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
			<p class="tw-text-left">商户姓名：</p>
			<p class="tw-font-semibold tw-text-right">{{ orderData?.sell_account_name }}</p>
			</div>

			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
			<p class="tw-text-left">收款方式：</p>
			<p class="tw-font-semibold tw-text-right">{{ formatPaymentMethod(orderData?.payment_method) }}</p>
			</div>

			<div v-if="orderData?.payment_method === 'bank'" class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
			<p class="tw-text-left">银行名称：</p>
			<p class="tw-font-semibold tw-text-right">{{ 'sell_bank_name' }}</p>
			</div>

			<div v-if="orderData?.payment_method === 'bank'" class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
			<p class="tw-text-left">开户行：</p>
			<p class="tw-font-semibold tw-text-right">{{ 'sell_issue_bank_name' }}</p>
			</div>

			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
			<p class="tw-text-left">收款账号：</p>
			<p class="tw-font-semibold tw-text-right">{{ orderData?.sell_account_number }}</p>
			</div>

		</div>

		<hr class="tw-w-full tw-my-1 tw-border-black tw-border-opacity-30" />

		<div v-if="orderData?.payment_method !== 'bank'" class="tw-w-[86%] tw-text-[#333333]">
			<div class="tw-flex tw-justify-between tw-space-x-4 tw-items-center tw-font-pingfangsb tw-font-semibold">
			<p class="tw-text-left">收款码：</p>
			<img 
				:src="orderData?.sell_qr_code ? formatImageUrl(orderData.sell_qr_code) : ''"
				alt="payment" 
				class="tw-w-32 tw-h-40 tw-mx-auto"
				@click="openPreview(formatImageUrl(orderData?.sell_qr_code))"
			/>
			</div>
		</div>

		<hr v-if="orderData?.payment_method !== 'bank'" class="tw-w-full tw-my-1 tw-border-black tw-border-opacity-30" />

		<div class="tw-w-[86%] tw-text-[#333333]">
			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">买家姓名：</p>
				<p class="tw-font-semibold tw-text-right">{{ orderData?.buy_account_name }}</p>
			</div>

			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">付款方式：</p>
				<p class="tw-font-semibold tw-text-right">{{ formatPaymentMethod(orderData?.payment_method) }}</p>
			</div>

			<div v-if="orderData?.payment_method === 'bank'" class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">银行名称：</p>
				<p class="tw-font-semibold tw-text-right">{{ orderData?.buy_bank_name }}</p>
			</div>

			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">付款账号：</p>
				<p class="tw-font-semibold tw-text-right">{{ orderData?.buy_account_number }}</p>
			</div>

			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">付款金额：</p>
				<p class="tw-font-semibold tw-text-right"><span class="tw-text-[#d9001b]">{{ orderData?.total_cny_price }}</span> 元</p>
			</div>
		</div>

		<hr class="tw-w-full tw-my-1 tw-border-black tw-border-opacity-30" />

		<div class="tw-w-[86%] tw-text-[#333333]">
			<!-- 商户号 -->
			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">创建时间：</p>
				<p class="tw-font-semibold tw-text-right">{{ orderData?.created_at }}</p>
			</div>

			<!-- 总资产 -->
			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">订单编号：</p>
				<p class="tw-font-semibold tw-text-right">{{ orderData?.display_order_id }}</p>
			</div>

			<div 
				class="tw-flex tw-justify-between tw-space-x-4 tw-font-pingfangsb tw-font-semibold"
				:class="orderData?.payment_method === 'bank' ? `tw-mb-20` : `tw-mb-10`"
			>
				<p class="tw-text-left">订单状态：</p>
				<p class="tw-font-semibold tw-text-right" :class="getStatusStyle(orderData?.status).style">{{ getStatusStyle(orderData?.status).text }}</p>
			</div>
		</div>

		<button
          type="button"
          class="tw-w-[80%] !tw-bg-[#a30014] !tw-opacity-60 !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[20px] tw-rounded-3xl tw-py-3 hover:tw-bg-rose-600"
          style="letter-spacing: 4px;"
          @click="handleClose"
        >
          我已知晓
        </button>
	</div>

	<el-dialog
      v-model="isPreviewOpen"
      align-center
	    style="width: 380px; height: 540px;"
    >
      <img
        :src="currentImageUrl"
        alt="Preview"
        class="tw-w-full tw-object-contain"
        @click.stop
      />
    </el-dialog>

	<!-- Footer -->
	<div class="footer">Copy@ JH嘉禾商城</div>
  </div>
</template>

<script setup>

import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router';
import * as OrderApi from '@/api/order'
import * as UserApi from '@/api/user'
import { formatImageUrl, formatPaymentMethod } from '@/utils/tool'

const router = useRouter();
const route = useRoute();

const autoBuyerId = route.query.autoBuyerId
const orderId = route.query.orderId

const isPreviewOpen = ref(false)
const currentImageUrl = ref('');

const orderData = ref(null)

const handleClose = () => {
	router.push(`/remote/buy?autoBuyerId=${autoBuyerId}`);
}

onMounted(async () => {
  const verifyResp = await UserApi.autoBuyerVerify(autoBuyerId)
  if (verifyResp.data.code !== 10000) {
	  ElMessage.error('远程下单身份校验失败!');
	  return;
  }

  fetchOrderDetail()
});

const fetchOrderDetail = async () => {
  try {
    const response = await OrderApi.getAutoBuyerOrderDetail(orderId)
    if (response.data.code === 10000) {
      orderData.value = response.data.data.order;
    }
  } catch (error) {
    console.error('Error fetching order details:', error);
  }
};

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
      return { style: 'tw-text-green-500', text: '已完成（争议撤单）'};
    default:
      return { style: 'tw-text-gray-500', text: '-'};
  }
}

const openPreview = (imageUrl) => {
	currentImageUrl.value = imageUrl;
	isPreviewOpen.value = true;
}

</script>

<style scoped lang="scss">

.page-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  background-image: url('@/assets/login_background.jpg');
  background-size: cover; /* 图片铺满 */
  background-position: center; /* 居中 */

  /* 自适应 iPhone 风格圆角 */
  border-radius: min(11vw, 11vh); /* 取宽和高中较小的比例 */;
  overflow: hidden;

  .main-box {
    width: 90%;
  }

  .logo-container {
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;

    .logo {
      width: 170px;
      height: 160px;
    }
  }

  .footer {
    font-size: 11px;
    text-align: center;
    font-family: Arial Normal, Arial;
    color: #333333;
    opacity: 0.57;
	// position: absolute;
	// bottom: 4px;
	margin-top: 30px;
  }
}

</style>
