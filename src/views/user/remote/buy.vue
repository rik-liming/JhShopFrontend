<template>
  <div class="page-container">

    <div class="main-box">
      <!-- 标题 -->
      <div class="title-container">
        <h2 class="welcome">欢迎来到</h2>
        <h1 class="app-name">金钱的世界</h1>
      </div>

      <!-- Logo -->
      <div class="logo-container">
        <img src="@/assets/logo.png" alt="logo" class="logo" />
      </div>

	  <div class="tw-flex tw-flex-col tw-items-center tw-mt-6 tw-mb-2">
		  <span class="tw-text-[#a30014] tw-text-[33px] tw-font-songti tw-font-bold">下 单</span>
	  </div>
    </div>

	<hr class="tw-w-full tw-mt-2 tw-mb-8 tw-bg-black tw-bg-opacity-30" />

	<div class="main-box tw-flex tw-flex-col tw-items-center">
		<div class="tw-flex tw-gap-8">
			<div
				v-for="amount in amountOptions"
				:key="amount"
				class="amountButton tw-cursor-pointer tw-border tw-rounded-lg tw-px-4 tw-py-2 tw-text-center tw-transition-all"
				:class="form.cny_amount === amount 
					? '!tw-bg-blue-500 !tw-text-white' 
					: ''"
				@click="radioSelectAmount(amount)"
			>
				{{ amount }}
			</div>
		</div>

		<div class="tw-flex tw-mt-6">
			<div class="amountInput tw-flex tw-justify-center">
				<input 
					v-model="form.cny_amount"
					placeholder="请输入充值金额"
					class="tw-w-[90%] tw-border-solid tw-border-0 tw-outline-none tw-placeholder-black"
				/>
			</div>
		</div>

		<div class="tw-flex tw-mt-10 tw-gap-10">
			<img
				v-for="paymentMethod in paymentMethodOptions"
				:key="paymentMethod"
				:src="getImageStyle(paymentMethod).src"
				:class="[
					getImageStyle(paymentMethod).class,
					form.payment_method === paymentMethod && '!tw-opacity-100'
				]"
				@click="radioSelectPaymentMethod(paymentMethod)"
			/>
		</div>

		<div class="tw-w-full tw-flex tw-flex-col tw-items-center tw-mt-20">
			<button
				type="button"
				class="tw-w-[70%] !tw-bg-[#a30014] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[23px] tw-rounded-3xl tw-py-3 hover:tw-bg-rose-600 tw-opacity-50"
				:class="form.cny_amount && form.payment_method && `!tw-opacity-100`"
				style="letter-spacing: 4px;"
				:disabled="!form.cny_amount || !form.payment_method || isApiRequesting"
				@click="handleCreateOrder"
			>
				{{ isApiRequesting ? '处理中...' : '立即下单' }}
			</button>
		</div>
	</div>

	<!-- Footer -->
	<div class="footer">Copy@ JH嘉禾商城</div>
  </div>
</template>

<script setup>

import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router';
import store from '@/store';
import * as UserApi from '@/api/user'
import * as OrderApi from '@/api/order'

const router = useRouter();
const route = useRoute();
const configStore = store.config()

const autoBuyerId = route.query.autoBuyerId

// 金额选项
const amountOptions = ref([])
const paymentMethodOptions = ref([])

const form = ref({
  cny_amount: null,
  payment_method: '',
  auto_buyer_id: autoBuyerId,
});

const isApiRequesting = ref(false)

const radioSelectAmount = (amount) => {
	form.value.cny_amount = amount
}

const radioSelectPaymentMethod = (paymentMethod) => {
	form.value.payment_method = paymentMethod
}

const getImageStyle = (paymentMethod) => {
  switch (paymentMethod) {
    case 'alipay':
      return {
        src: new URL('@/assets/ali_pay.png', import.meta.url).href,
        class: 'tw-w-[70px] tw-h-[60px] tw-opacity-30',
      }
    case 'wechat':
      return {
        src: new URL('@/assets/wechat_pay.png', import.meta.url).href,
        class: 'tw-w-[70px] tw-h-[58px] tw-opacity-30',
      }
    case 'bank':
      return {
        src: new URL('@/assets/bank_pay.png', import.meta.url).href,
        class: 'tw-w-[95px] tw-h-[60px] tw-opacity-30',
      }
    default:
      return {
        src: '',
        class: '',
      }
  }
}

const handleCreateOrder = async() => {
	try {
		if (isApiRequesting.value) {
			ElMessage.error('处理中');
			return;
		}
		
		if (!form.value.cny_amount
			|| !form.value.payment_method
		) {
			ElMessage.error('请完整输入各项内容!');
			return;
		}

		isApiRequesting.value = true
		const resp = await OrderApi.createAutoBuyerOrder(form.value)
		if (resp.data.code === 10000) {
			ElMessage.success('下单成功');
			const orderId = resp.data.data.order.id
			setTimeout(() => {
				router.push(`/remote/pay?autoBuyerId=${autoBuyerId}&orderId=${orderId}`);
			}, 1000);
		} else {
			ElMessage.error(resp.data.msg);
		}
	} catch (error) {
		console.log(error)
		ElMessage.error('下单失败');
	} finally {
		setTimeout(() => {
			isApiRequesting.value = false  
		}, 3000);
  	}
}

onMounted(async () => {
  const verifyResp = await UserApi.autoBuyerVerify(autoBuyerId)
  if (verifyResp.data.code !== 10000) {
	  ElMessage.error('远程下单身份校验失败!');
	  return;
  }

  await configStore.getConfig()
  amountOptions.value = configStore?.config?.value?.remote_order_config?.amountOptions
  paymentMethodOptions.value = configStore?.config?.value?.remote_order_config?.openMarkets
});

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

  .title-container {
    display: flex;
    flex-direction: column;
    margin-top: 60px;
    margin-left: 160px;
    gap: 0px;

    .welcome {
      font-size: 20px;
      color: #4b7902;
      font-weight: 400;
      font-family: "Times New Roman", Times, serif;
    }

    .app-name {
      font-size: 30px;
      font-weight: 700;
      color: #000;
      font-family: 'STXingkaiSC-Bold', 'Xingkai SC Bold', 'Xingkai SC', serif;
      margin-top: -10px;
    }
  }

  .logo-container {
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 10px;

    .logo {
      width: 180px;
      height: 178px;
    }
  }

  .footer {
    font-size: 11px;
    text-align: center;
    font-family: Arial Normal, Arial;
    color: #333333;
	opacity: 0.57;
	margin-top: 100px;
	// position: absolute;
    // bottom: 4px;
  }

	.amountButton {
		border-width:0px;
		width:87px;
		height:54px;
		background:inherit;
		background-color:rgba(255, 255, 255, 0);
		box-sizing:border-box;
		border-width:2px;
		border-style:solid;
		border-color:rgba(163, 0, 20, 1);
		border-radius:10px;
		-moz-box-shadow:0px -5px 5px 0px rgba(85, 85, 85, 0.537254901960784) inset;
		-webkit-box-shadow:0px -5px 5px 0px rgba(85, 85, 85, 0.537254901960784) inset;
		box-shadow:0px -5px 5px 0px rgba(85, 85, 85, 0.537254901960784) inset;
		font-family:'PingFangSC-Regular', 'PingFang SC';
		font-weight:400;
		font-style:normal;
		font-size:25px;
		color:#D9001B;
		text-align:center;
	}

	.amountInput {
		border-width:0px;
		width:327px;
		height:54px;
		background:inherit;
		background-color:rgba(255, 255, 255, 0);
		box-sizing:border-box;
		border-width:2px;
		border-style:solid;
		border-color:rgba(163, 0, 20, 1);
		border-radius:10px;
		-moz-box-shadow:0px -5px 5px 0px rgba(85, 85, 85, 0.537254901960784) inset;
		-webkit-box-shadow:0px -5px 5px 0px rgba(85, 85, 85, 0.537254901960784) inset;
		box-shadow:0px -5px 5px 0px rgba(85, 85, 85, 0.537254901960784) inset;
		font-family:'PingFangSC-Ultralight', 'PingFang SC Ultralight', 'PingFang SC';
		font-weight:100;
		font-style:normal;
		font-size:20px;
		color:#333333;
	}
}

</style>
