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
        <div class="tw-absolute tw-right-2 tw-top-[-6px] tw-flex tw-flex-col tw-items-end">
          <!-- <button class="tw-text-[#D9001B] tw-font-pingfang tw-text-[17px] tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-rounded-lg tw-px-2 tw-py-1 tw-mb-16" @click="handleClose">关闭</button> -->
          <img 
            src="@/assets/close_icon.png" 
            alt="close" 
            class="cursor-pointer tw-w-8 tw-h-8" 
            @click="handleClose"
          />
        </div>
        <div class="tw-absolute tw-right-0 tw-flex tw-flex-col tw-items-end tw-mt-36">
          <p class="tw-text-sm tw-mb-2 tw-mr-4 tw-font-songti tw-font-bold tw-text-[#333333]">市场汇率：<span class="tw-text-red-500 tw-font-pingfang tw-font-normal" style="color: rgba(rgba(217, 0, 27, 0.854901960784314))">{{ configStore.config?.value?.exchange_rate_platform }}</span></p>
        </div>
      </div>
      
      <!-- 标题 & 汇率 -->
      <h2 class="tw-text-[16px] tw-font-semibold tw-font-pingfangsb">充 值</h2>
      <hr class="tw-w-full tw-my-3 tw-border-black tw-border-opacity-30" />

      <div class="tw-w-[86%] tw-text-[#333333]">
        <!-- 商户号 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-6 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">商户号：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatIdDisplay(userStore?.user?.value?.id) }}</p>
        </div>

        <!-- 总资产 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">总资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ userStore?.account?.value?.totalBalance }} USDT</p>
        </div>

        <!-- 可用资产 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">可用资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ userStore?.account?.value?.availableBalance }} USDT</p>
        </div>

        <!-- 地址展示 -->
        <div class="tw-text-left tw-mb-3 tw-mt-12">
          <p class="tw-text-md tw-font-pingfangsb tw-font-semibold">接收地址（平台）：<span class="tw-font-arial tw-font-normal">USDT-TRC20</span></p>
          <div
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-rounded-md tw-px-2 tw-py-2 tw-break-all tw-text-sm tw-mt-1 tw-font-pingfang tw-font-normal"
          >
            {{ configStore.config?.value?.payment_address }}
          </div>
        </div>

        <!-- 表单 -->
        <form @submit.prevent="handleRecharge" class="tw-mb-4">
          <!-- 输入金额 -->
          <input
            type="number"
            placeholder="请输入充值金额"
            v-model="form.amount"
            required
            min="0"
            @input="onAmountInput"
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-20 tw-rounded-md tw-px-3 tw-py-2 tw-text-sm tw-placeholder-gray-400 tw-mb-4"
          />

          <!-- 上传截图 -->
          <div class="tw-text-left tw-mt-4 tw-mb-3">
            <div class="tw-flex tw-justify-start tw-mb-6">
              <img src="@/assets/upload_icon.svg" alt="upload" class="tw-w-10 tw-h-7 tw-mr-2" />
              <p class="tw-font-medium tw-font-pingfang tw-text-black tw-font-normal tw-mt-[4px]">上传充值截图</p>
              <span class="tw-text-red-500 tw-ml-2">*</span>
            </div>

            <CustomFileUpload v-model:file="form.screenshot" />
          </div>

          <!-- 按钮 -->
          <button
            type="submit"
            class="tw-w-[90%] !tw-bg-[rgba(217,0,27,0.67843137254902)] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[20px] tw-rounded-3xl tw-py-3 tw-mt-10 hover:tw-bg-rose-600"
            style="letter-spacing: 4px;"
          >
            立即充值
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
      <p class="tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import CustomFileUpload from '@/components/CustomFileUpload';
import store from '@/store'
import { formatIdDisplay } from '@/utils/tool'
import * as RechargeApi from '@/api/recharge'
import Hamburger from '@/components/Hamburger';

const configStore = store.config()
const userStore = store.user()
const appStore = store.app()

const form = ref({
  amount: '',
  screenshot: null,
});

const router = useRouter();

const handleClose = () => {
  router.push('/');
};

const handleRecharge = async() => {
  try {
    if (!form.value.amount || !form.value.screenshot) {
      ElMessage.error('请填写充值金额并上传截图!');
      return;
    }

    if (form.value.amount <= 0) {
      ElMessage.error('充值金额必须大于0!');
      return;
    }

    const formData = new FormData();
    formData.append('amount', form.value.amount);
    formData.append('screenshot', form.value.screenshot)

    const resp = await RechargeApi.createRecharge(userStore.loginToken, formData)

    if (resp.data.code === 10000) {
      ElMessage.success('提交充值成功');
      const reference_id = resp.data.data.recharge.id
      router.push(`/recharge/detail?reference_id=${reference_id}`);
    } else {
      ElMessage.error(resp.data.msg);
    }
  } catch (error) {
    console.log(error)
    ElMessage.error('提交充值失败');
  }
};

const toggleSidebar = () => {
  appStore.toggleSidebar();
}

onMounted(async () => {
  await userStore.getAccountInfo()
});

const onAmountInput = (e) => {
  if (e.target.value < 0) {
    e.target.value = 0
    form.amount = 0
  }
}

</script>

<style scoped lang="scss">

:deep(input[type=number])::-webkit-inner-spin-button,
:deep(input[type=number])::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

:deep(input[type=number]) {
  -moz-appearance: textfield;
}

</style>
