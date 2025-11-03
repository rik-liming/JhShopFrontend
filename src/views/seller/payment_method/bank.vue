<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-flex tw-justify-center">
    <div class="tw-w-[90%] tw-p-1 tw-text-center tw-flex tw-flex-col tw-justify-start tw-items-center">
      <!-- 顶部图标 -->
      <div class="tw-w-full tw-flex tw-items-center tw-justify-between tw-mt-14 tw-mb-2 tw-relative">
        <div class="tw-flex tw-items-center tw-w-full">
          <img src="@/assets/bank_pay.png" alt="logo" class="tw-w-[168px] tw-h-[105px] tw-mx-auto" />
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
        <div class="tw-absolute tw-right-2 tw-top-[-10px] tw-flex tw-flex-col tw-items-end">
          <!-- <button class="tw-text-[#D9001B] tw-font-pingfang tw-text-[17px] tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-rounded-lg tw-px-2 tw-py-1 tw-mb-16" @click="handleClose">关闭</button> -->
          <img 
            src="@/assets/close_icon.png" 
            alt="close" 
            class="cursor-pointer tw-w-8 tw-h-8" 
            @click="handleClose"
          />
        </div>
        <div class="tw-absolute tw-top-[-40px] tw-right-[-20px] tw-flex tw-flex-col tw-items-end tw-mt-36">
          <p class="tw-text-sm tw-mb-2 tw-mr-4 tw-font-songti tw-font-bold tw-text-[#333333]">市场汇率：<span class="tw-text-red-500 tw-font-pingfang tw-font-normal" style="color: rgba(rgba(217, 0, 27, 0.854901960784314))">{{ configStore.config?.value?.exchange_rate_platform }}</span></p>
        </div>
      </div>

      <hr class="tw-w-[90%] tw-my-3 tw-border-black tw-border-opacity-30" />
      <div class="tw-w-[70%] tw-text-[#333333]">

        <!-- 表单 -->
        <form @submit.prevent="paymentHandle" class="tw-mb-4">
          <div class="tw-text-left tw-mb-3 tw-mt-12">
            <p class="tw-text-md tw-font-pingfang tw-font-normal">银行：</p>
          </div>
          <input
            type="text"
            placeholder="请输入银行"
            v-model="form.bank_name"
            required
            class="tw-w-full tw-border-solid tw-border-0 tw-border-b-[2px] tw-outline-none tw-text-md tw-font-bold tw-placeholder-gray-400"
            style="border-color: rgba(215, 215, 215, 1)"
          />

          <div class="tw-text-left tw-mb-3 tw-mt-8">
            <p class="tw-text-md tw-font-pingfang tw-font-normal">开户行：</p>
          </div>
          <input
            type="text"
            placeholder="请输入开户行"
            v-model="form.issue_bank_name"
            required
            class="tw-w-full tw-border-solid tw-border-0 tw-border-b-[2px] tw-outline-none tw-text-md tw-font-bold tw-placeholder-gray-400"
            style="border-color: rgba(215, 215, 215, 1)"
          />

		  <div class="tw-text-left tw-mb-3 tw-mt-8">
            <p class="tw-text-md tw-font-pingfang tw-font-normal">持卡人：</p>
          </div>
          <input
            type="text"
            placeholder="请输入持卡人"
            v-model="form.account_name"
            required
            class="tw-w-full tw-border-solid tw-border-0 tw-border-b-[2px] tw-outline-none tw-text-md tw-font-bold tw-placeholder-gray-400"
            style="border-color: rgba(215, 215, 215, 1)"
          />

		  <div class="tw-text-left tw-mb-3 tw-mt-8">
            <p class="tw-text-md tw-font-pingfang tw-font-normal">银行卡号：</p>
          </div>
          <input
            type="text"
            placeholder="请输入银行卡号"
            v-model="form.account_number"
            required
            class="tw-w-full tw-border-solid tw-border-0 tw-border-b-[2px] tw-outline-none tw-text-md tw-font-bold tw-placeholder-gray-400"
            style="border-color: rgba(215, 215, 215, 1)"
          />

          <div class="tw-text-left tw-mb-3 tw-mt-8">
            <p class="tw-text-md tw-font-pingfang tw-font-normal">验证码：</p>
          </div>
          <input
            type="text"
            placeholder="请输入谷歌验证码"
            v-model="form.verify_code"
            required
            class="tw-w-full tw-border-solid tw-border-0 tw-border-b-[2px] tw-outline-none tw-text-md tw-font-bold tw-placeholder-gray-400"
            style="border-color: rgba(215, 215, 215, 1)"
          />

          <!-- 按钮 -->
          <button
            v-if="!paymentMethodId"
            type="submit"
            class="tw-w-full !tw-bg-[rgba(217,0,27,0.67843137254902)] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[20px] tw-rounded-3xl tw-py-3 tw-mt-10 hover:tw-bg-rose-600"
            style="letter-spacing: 4px;"
          >
            添加
          </button>
          <button
            v-else
            type="submit"
            class="tw-w-full !tw-bg-[rgba(217,0,27,0.67843137254902)] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[20px] tw-rounded-3xl tw-py-3 tw-mt-10 hover:tw-bg-rose-600"
            style="letter-spacing: 4px;"
          >
            更新
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

      <!-- 底部版权 -->
      <p class="tw-absolute tw-bottom-4 tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import CustomFileUpload from '@/components/CustomFileUpload';
import store from '@/store'
import { formatIdDisplay } from '@/utils/tool'
import * as PaymentMethodApi from '@/api/payment_method'
import Hamburger from '@/components/Hamburger';
import { formatImageUrl } from '@/utils/tool'

const configStore = store.config()
const userStore = store.user()
const appStore = store.app()

const router = useRouter();
const route = useRoute();

const form = ref({
  account_number: '',
  account_name: '',
  bank_name: '',
  issue_bank_name: '',
});

const paymentMethodId = route.query.id

const handleClose = () => {
  router.back();
};

const paymentHandle = async() => {
  try {
    if (!form.value.account_number
	  || !form.value.account_name
	  || !form.value.bank_name
	  || !form.value.issue_bank_name
      || !form.value.verify_code
    ) {
      ElMessage.error('请填写各项内容!');
      return;
    }

    const formData = new FormData();
    if (paymentMethodId) {
      formData.append('id', paymentMethodId);
    }
    formData.append('payment_method', 'bank');
    formData.append('account_number', form.value.account_number);
	formData.append('account_name', form.value.account_name);
	formData.append('bank_name', form.value.bank_name);
	formData.append('issue_bank_name', form.value.issue_bank_name);
    formData.append('verify_code', form.value.verify_code);
    formData.append('qr_code', form.value.qr_code)

    let resp = null;
    if (paymentMethodId) {
      resp = await PaymentMethodApi.updatePaymentMethod(userStore.loginToken, formData)
    } else {
      resp = await PaymentMethodApi.createPaymentMethod(userStore.loginToken, formData)
    }

    if (resp.data.code === 10000) {
	  ElMessage.success('操作成功');
	  setTimeout(() => {
		router.push(`/profile`);	  
	  }, 2000);
    } else {
      ElMessage.error(resp.data.msg);
    }
  } catch (error) {
    console.log(error)
    ElMessage.error('操作失败');
  }
};

const toggleSidebar = () => {
  appStore.toggleSidebar();
}

onMounted(() => {
  if (paymentMethodId) {
    fetchPaymentMethodDetail();
  }
});

// 获取详情数据
const fetchPaymentMethodDetail = async () => {
  try {
    const response = await PaymentMethodApi.getPaymentMethodInfo(userStore.loginToken, paymentMethodId)
    if (response.data.code === 10000) {
      const paymentMethod = response.data.data.payment_method
      
      form.value.account_number = paymentMethod.account_number
	  form.value.account_name = paymentMethod.account_name
	  form.value.bank_name = paymentMethod.bank_name
	  form.value.issue_bank_name = paymentMethod.issue_bank_name
    } else {
      console.error('获取数据失败');
    }
  } catch (error) {
    console.error('请求错误:', error);
  }
};

</script>

<style scoped lang="scss">
/* 保持样式不变 */
</style>
