<template>
  <div class="page-container">

    <div class="main-box">

      <!-- Logo -->
      <div class="logo-container tw-relative">
        <img src="@/assets/logo.png" alt="logo" class="logo" />
		<span class="tw-absolute tw-right-10 tw-top-0 tw-text-[#d9001b] tw-text-[28px] tw-font-songti tw-font-bold">下单中</span>
		<div class="tw-absolute tw-right-2 tw-top-[-14px]">
			<!-- <img 
				src="@/assets/close_icon.png" 
				alt="close" 
				class="cursor-pointer tw-w-8 tw-h-8" 
				@click="handleClose"
			/> -->
		</div>
      </div>
    </div>

	<hr class="tw-w-full tw-mt-10 tw-mb-8 tw-bg-black tw-bg-opacity-30" />

	<div class="main-box tw-flex tw-flex-col tw-items-center">
		<div v-if="orderData?.payment_method !== 'bank'" class="tw-flex tw-gap-8 tw-w-full tw-items-center">
			<div class="tw-relative tw-flex tw-flex-col tw-items-center tw-w-1/4">
				<img 
					src="@/assets/finger_icon.svg" 
					alt="icon" 
					style="transform: rotate(90deg);"
					class="tw-w-[46px] tw-h-[50px]"
				/>
				<span class="tw-absolute tw-top-16 tw-text-md tw-font-pingfangsb tw-font-bold">请扫码</span>
			</div>
			<div>
				<img 
					:src="orderData?.sell_qr_code ? formatImageUrl(orderData?.sell_qr_code) : ''" 
					alt="qr_code"
					class="tw-w-[164px] tw-h-[208px]"
					@click="openPreview(formatImageUrl(orderData?.sell_qr_code))"
				/>
			</div>
		</div>
		<div v-else class="tw-w-[80%] tw-text-[#333333]">
			<div class="tw-relative tw-w-full tw-flex tw-flex-col tw-justify-start">
				<span class="tw-mt-[-44px] tw-text-center tw-text-md tw-font-pingfang tw-text-[#333333] tw-mb-4">收款信息</span>
			</div>

			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-2 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">商户姓名：</p>
				<p class="tw-font-semibold tw-text-right">{{ orderData?.sell_account_name }}</p>
			</div>

			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">收款方式：</p>
				<p class="tw-font-semibold tw-text-right">{{ formatPaymentMethod(orderData?.payment_method) }}</p>
			</div>

			<div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">银行名称：</p>
				<p class="tw-font-semibold tw-text-right">{{ orderData?.sell_bank_name }}</p>
			</div>

			<div class="tw-relative tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">开户行：</p>
				<p class="tw-font-semibold tw-text-right">{{ orderData?.sell_issue_bank_name }}</p>
				<img 
					src="@/assets/copy_icon.png" 
					alt="复制"
					class="tw-absolute tw-right-[-30px] tw-w-[20px] tw-h-[22px] tw-ml-4 cursor-pointer"
					@click="copySellIssueBankName"
				/>
			</div>

			<div class="tw-relative tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
				<p class="tw-text-left">收款账号：</p>
				<p class="tw-font-semibold tw-text-right">{{ orderData?.sell_account_number }}</p>
				<img 
					src="@/assets/copy_icon.png" 
					alt="复制"
					class="tw-absolute tw-right-[-30px] tw-w-[20px] tw-h-[22px] tw-ml-4 cursor-pointer"
					@click="copySellAccountNumber"
				/>
			</div>
		</div>

		<hr v-if="orderData?.payment_method === 'bank'" class="tw-w-full tw-mt-10 tw-mb-8 tw-bg-black tw-bg-opacity-30" />

		<div class="tw-w-[80%] tw-flex">
			<form @submit.prevent="confirmHandle" class="tw-w-full tw-mb-4 tw-flex tw-flex-col">

				<div v-if="orderData?.payment_method === 'alipay'">
					<div class="tw-text-left tw-mb-3 tw-mt-8">
						<p class="tw-text-md tw-font-pingfang tw-font-normal tw-text-[#333333]">付款人：</p>
					</div>
					<input
						type="text"
						placeholder="请输入姓名"
						v-model="form.account_name"
						required
						class="tw-w-full tw-border-solid tw-border-0 tw-border-b-[2px] tw-outline-none tw-text-sm tw-font-pingfang tw-placeholder-gray-700"
						style="border-color: rgba(215, 215, 215, 1)"
					/>
					<div class="tw-text-left tw-mb-3 tw-mt-12">
						<p class="tw-text-md tw-font-pingfang tw-font-normal tw-text-[#333333]">支付宝账号：</p>
					</div>
					<input
						type="text"
						placeholder="请输入支付宝账号"
						v-model="form.account_number"
						required
						class="tw-w-full tw-border-solid tw-border-0 tw-border-b-[2px] tw-outline-none tw-text-sm tw-font-pingfang tw-placeholder-gray-700"
						style="border-color: rgba(215, 215, 215, 1)"
					/>
				</div>
				<div v-if="orderData?.payment_method === 'wechat'">
					<div class="tw-text-left tw-mb-3 tw-mt-8">
						<p class="tw-text-md tw-font-pingfang tw-font-normal tw-text-[#333333]">付款人：</p>
					</div>
					<input
						type="text"
						placeholder="请输入姓名"
						v-model="form.account_name"
						required
						class="tw-w-full tw-border-solid tw-border-0 tw-border-b-[2px] tw-outline-none tw-text-sm tw-font-pingfang tw-placeholder-gray-700"
						style="border-color: rgba(215, 215, 215, 1)"
					/>
					<div class="tw-text-left tw-mb-3 tw-mt-12">
						<p class="tw-text-md tw-font-pingfang tw-font-normal tw-text-[#333333]">微信账号：</p>
					</div>
					<input
						type="text"
						placeholder="请输入微信账号"
						v-model="form.account_number"
						required
						class="tw-w-full tw-border-solid tw-border-0 tw-border-b-[2px] tw-outline-none tw-text-sm tw-font-pingfang tw-placeholder-gray-700"
						style="border-color: rgba(215, 215, 215, 1)"
					/>
				</div>
				<div v-if="orderData?.payment_method === 'bank'" class="tw-flex tw-flex-col tw-items-center">
					<div class="tw-w-full tw-text-[#333333]">
						<div class="tw-relative tw-w-full tw-flex tw-flex-col tw-justify-start">
							<span class="tw-mt-[-44px] tw-text-center tw-text-md tw-font-pingfang tw-text-[#333333] tw-mb-4">付款信息</span>
						</div>

						<div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-2 tw-mb-2 tw-items-center">
							<p class="tw-w-[30%] tw-text-left tw-text-md tw-font-songti">付款人：</p>
							<input
								type="text"
								placeholder="请输入付款人姓名"
								v-model="form.account_name"
								required
								class="tw-w-[70%] tw-text-md tw-font-pingfang tw-placeholder-[#d9001b] tw-placeholder-opacity-70 tw-border-solid tw-border-black tw-border-opacity-10 tw-rounded-md tw-py-1 tw-px-2"
							/>
						</div>

						<div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-2 tw-mb-2 tw-items-center">
							<p class="tw-w-[30%] tw-text-left">付款银行：</p>
							<input
								type="text"
								placeholder="请输入付款人银行"
								v-model="form.bank_name"
								required
								class="tw-w-[70%] tw-text-md tw-font-pingfang tw-placeholder-[#d9001b] tw-placeholder-opacity-70 tw-border-solid tw-border-black tw-border-opacity-10 tw-rounded-md tw-py-1 tw-px-2"
							/>
						</div>

						<div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-2 tw-mb-2 tw-items-center">
							<p class="tw-w-[30%] tw-text-left">付款卡号：</p>
							<input
								type="text"
								placeholder="请输入付款卡号"
								v-model="form.account_number"
								required
								class="tw-w-[70%] tw-text-md tw-font-pingfang tw-placeholder-[#d9001b] tw-placeholder-opacity-70 tw-border-solid tw-border-black tw-border-opacity-10 tw-rounded-md tw-py-1 tw-px-2"
							/>
						</div>

					</div>
					
				</div>

				<button
					type="submit"
					class="!tw-bg-[#a30014] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[23px] tw-rounded-3xl tw-py-3 tw-mt-16 hover:tw-bg-rose-600 tw-opacity-50"
					:class="form.account_name && form.account_number && `!tw-opacity-100`"
					style="letter-spacing: 4px;"
					:disabled="!form.account_name || !form.account_number || isApiRequesting"
				>
					{{ isApiRequesting ? '处理中...' : '我已付款' }}
				</button>
				<button 
					type="button"
					class="tw-w-full !tw-text-[#D82D15] tw-font-medium tw-font-pingfang tw-py-2 tw-mt-2"
					@click="handleClose"
				>
					取消
				</button>
			</form>
		</div>
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
import * as UserApi from '@/api/user'
import * as OrderApi from '@/api/order'
import { formatImageUrl, formatPaymentMethod } from '@/utils/tool'

const router = useRouter();
const route = useRoute();

const autoBuyerId = route.query.autoBuyerId
const orderId = route.query.orderId

const isPreviewOpen = ref(false)
const currentImageUrl = ref('');
const isApiRequesting = ref(false)

const orderData = ref(null)

const form = ref({
  account_number: '',
  account_name: '',
  bank_name: '',
  order_id: orderId,
  auto_buyer_id: autoBuyerId,
});

const confirmHandle = async () => {
	try {
		if (isApiRequesting.value) {
			ElMessage.error('处理中');
			return;
		}

		if (!form.value.account_number 
			|| !form.value.account_name
		) {
			ElMessage.error('请完整输入各项内容!');
			return;
		}

		isApiRequesting.value = true
		const resp = await OrderApi.autoBuyerOrderConfirm(form.value)
		if (resp.data.code === 10000) {
			ElMessage.success('确认成功');
			const orderId = resp.data.data.order.id
			setTimeout(() => {
				router.push(`/remote/detail?autoBuyerId=${autoBuyerId}&orderId=${orderId}`);
			}, 1000);
		} else {
			ElMessage.error(resp.data.msg);
		}
	} catch (error) {
		console.log(error)
		ElMessage.error('确认失败');
	}
}

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

const openPreview = (imageUrl) => {
	currentImageUrl.value = imageUrl;
	isPreviewOpen.value = true;
}

const copySellIssueBankName = async () => {
  const sellIssueBankName = orderData?.value.sell_issue_bank_name

  if (sellIssueBankName) {
    try {
      // 使用 Clipboard API 复制文本到剪贴板
      await navigator.clipboard.writeText(sellIssueBankName);
      ElMessage.success('已复制！');
    } catch (err) {
      ElMessage.error('复制失败，请手动复制！');
    }
  }
};

const copySellAccountNumber = async () => {
  const sellAccountNumber = orderData?.value.sell_account_number

  if (sellAccountNumber) {
    try {
      // 使用 Clipboard API 复制文本到剪贴板
      await navigator.clipboard.writeText(sellAccountNumber);
      ElMessage.success('已复制！');
    } catch (err) {
      ElMessage.error('复制失败，请手动复制！');
    }
  }
};

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
    margin-top: 60px;

    .logo {
      width: 180px;
      height: 170px;
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
	margin-top: 10px;
  }
}

</style>
