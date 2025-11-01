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
        <div class="tw-absolute tw-right-0 tw-flex tw-flex-col tw-items-end tw-mt-36">
          <p class="tw-text-sm tw-mb-2 tw-mr-4 tw-font-songti tw-font-bold tw-text-[#333333]">市场汇率：<span class="tw-text-red-500 tw-font-pingfang tw-font-normal" style="color: rgba(rgba(217, 0, 27, 0.854901960784314))">{{ configStore.config?.value?.exchange_rate_platform }}</span></p>
        </div>
      </div>
      
      <!-- 标题 & 汇率 -->
      <h2 class="tw-text-[16px] tw-font-semibold tw-font-pingfangsb">提 现</h2>
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

        <div class="tw-mt-10 tw-text-left">
        <div class="tw-text-md tw-font-pingfang tw-font-normal">提现</div>
        <div class="tw-text-md tw-font-pingfang tw-font-normal tw-text-[#D9001B] tw-mt-2 tw-mb-10 withdraw-fee-text">
          每笔提现收取手续费 {{ configStore?.config?.value?.withdrawl_fee }} USDT
        </div>
      </div>

        <!-- 地址展示 -->
        <div class="tw-text-left tw-mt-12">
          <p class="tw-text-md tw-font-pingfang tw-font-normal">提现地址：<span class="tw-font-arial tw-font-normal tw-text-black">USDT-TRC20</span></p>
        </div>

        <!-- 表单 -->
        <form @submit.prevent="handleWithdraw" class="tw-mb-4">
          <!-- 输入金额 -->
          <input
            type="text"
            placeholder="请输入提现地址"
            v-model="form.withdraw_address"
            required
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mb-4"
          />

          <input
            type="number"
            placeholder="请输入提现金额"
            v-model="form.amount"
            min="1"
            @input="onAmountInput"
            :max="maxWithdrawAmount"
            title="提现金额必须大于1并且小于可用资产"
            required
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mb-4"
          />

          <input
            type="password"
            placeholder="请输入支付密码"
            v-model="form.payment_password"
            required
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mb-4"
          />

          <!-- 按钮 -->
          <button
            type="submit"
            class="tw-w-[80%] !tw-bg-[rgba(217,0,27,0.67843137254902)] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[20px] tw-rounded-3xl tw-py-3 tw-mt-12 hover:tw-bg-rose-600"
            style="letter-spacing: 4px;"
          >
            立即提现
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
      <p class="tw-text-xs tw-text-gray-400 tw-mt-16">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import CustomFileUpload from '@/components/CustomFileUpload';
import store from '@/store'
import { formatIdDisplay } from '@/utils/tool'
import * as WithdrawApi from '@/api/withdraw'
import Hamburger from '@/components/Hamburger';
import Decimal from 'decimal.js';

const configStore = store.config()
const userStore = store.user()
const appStore = store.app()

const form = ref({
  amount: '',
  withdraw_address: '',
  payment_password: '',
});

const maxWithdrawAmount = computed(() => {
  const totalAvailableBalance = new Decimal(userStore?.account?.value?.availableBalance || 1)
  const withdrawFee = new Decimal(configStore?.config?.value?.withdrawl_fee || 1)
  return totalAvailableBalance.minus(withdrawFee).toFixed(2);
});

const router = useRouter();

const handleClose = () => {
  router.push('/');
};

const handleWithdraw = async() => {
  try {
    if (!form.value.amount || !form.value.withdraw_address || !form.value.payment_password) {
      ElMessage.error('请完整输入各项内容!');
      return;
    }

    if (form.value.amount > maxWithdrawAmount.value) {
      ElMessage.error('提现金额必须小于等于可用资产+手续费!');
      return;
    }

    const resp = await WithdrawApi.createWithdraw(userStore.loginToken, form.value)

    if (resp.data.code === 10000) {
      ElMessage.success('提现申请成功');
      const reference_id = resp.data.data.withdraw.id
      router.push(`/withdraw/detail?reference_id=${reference_id}`);
    } else {
      ElMessage.error(resp.data.msg);
      if (resp.data.code === 20008) {
        setTimeout(() => {
          router.push('/profile')  
        }, 2000);
      }
    }
  } catch (error) {
    console.log(error)
    ElMessage.error('提现申请失败');
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
.withdraw-fee-text {
    text-decoration: underline rgb(215, 215, 215);
    text-decoration-thickness: 3px; /* 增加下划线的粗细 */
    text-underline-offset: 5px; /* 增加下划线与文字的距离 */
}

:deep(input[type=number])::-webkit-inner-spin-button,
:deep(input[type=number])::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

:deep(input[type=number]) {
  -moz-appearance: textfield;
}

</style>
