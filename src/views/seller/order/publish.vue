<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-flex tw-justify-center">
    <div class="tw-w-[90%] tw-p-1 tw-text-center tw-flex tw-flex-col tw-justify-start tw-items-center">
      <!-- 顶部图标 -->
      <div class="tw-w-full tw-flex tw-items-center tw-justify-between tw-mt-10 tw-mb-4 tw-relative">
        <div class="tw-flex tw-items-center tw-w-full">
          <img src="@/assets/sale_icon.png" alt="logo" class="tw-w-[98px] tw-h-[94px] tw-mx-auto" />
        </div>
        <div class="tw-absolute tw-left-0 tw-flex tw-flex-col tw-items-end">
          <hamburger id="hamburger-container" :is-active="appStore.sidebar.opened" class="hamburger-container"
               @toggleClick="toggleSidebar" />
        </div>
        <div class="tw-absolute tw-right-0 tw-flex tw-flex-col tw-items-end">
          <button class="tw-text-[#D9001B] tw-font-pingfang tw-text-[17px] tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-rounded-lg tw-px-2 tw-py-1 tw-mb-16" @click="handleClose">关闭</button>
        </div>
        <div class="tw-absolute tw-right-0 tw-flex tw-flex-col tw-items-end tw-mt-36">
          <!-- <p class="tw-text-sm tw-mb-2 tw-mr-4 tw-font-songti tw-font-bold tw-text-[#333333]">市场汇率：<span class="tw-text-red-500 tw-font-pingfang tw-font-normal" style="color: rgba(rgba(217, 0, 27, 0.854901960784314))">{{ configStore.config?.value?.exchange_rate_platform }}</span></p> -->
        </div>
      </div>
      
      <!-- 标题 & 汇率 -->
      <h2 class="tw-text-[16px] tw-font-semibold tw-font-pingfangsb">发布交易</h2>
      <hr class="tw-w-[90%] tw-my-3 tw-border-black tw-border-opacity-30" />

      <div class="tw-w-[72%] tw-text-[#333333] tw-mt-4">
        <!-- 商户号 -->
        <div class="tw-flex tw-justify-start tw-mt-6 tw-mb-2">
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">商户号：</p>
          <p class="tw-font-pingfangsb tw-font-semibold">{{ formatIdDisplay(userStore?.user?.value?.id) }}</p>
        </div>

        <!-- 总资产 -->
        <div class="tw-flex tw-justify-start tw-mb-2">
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">总资产：</p>
          <p class="tw-font-pingfangsb tw-font-semibold">{{ userStore?.account?.value?.totalBalance }} USDT</p>
        </div>

        <!-- 可用资产 -->
        <div class="tw-flex tw-justify-between tw-mb-2">
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">可出售资产：</p>
          <p class="tw-w-3/5 tw-text-left tw-font-pingfangsb tw-font-semibold">{{ userStore?.account?.value?.availableBalance }} USDT</p>
        </div>

        <!-- 地址展示 -->
        <div class="tw-text-left tw-mb-3 tw-mt-10">
          <p class="tw-font-pingfang tw-text-md">出售数量：</p>
        </div>

        <!-- 表单 -->
        <form @submit.prevent="handlePublish" class="tw-mb-4">
          <!-- 输入金额 -->
          <input
            type="number"
            placeholder="请输入出售数量"
            v-model="form.amount"
            ref="amountInput"
            name="amount"
            required
            min="1"
            :max="userStore.account?.value?.availableBalance || 10000"
            title="出售数量必须大于1并且小于可出售资产"
            class="tw-w-full tw-text-[#D9001B] tw-text-md tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-md tw-px-3 tw-py-2 tw-placeholder-gray-400 tw-mb-4"
          />

          <span
            v-show="form.amount"
            class="tw-absolute tw-text-[#D9001B] tw-text-md tw-mt-[9px]"
            :style="amountUnitStyle"
          >
            USDT
          </span>

          <!-- 最低购买金额 -->
          <div class="tw-mt-4 tw-text-left">
            <label class="tw-text-md tw-font-pingfang tw-font-normal">最低购买金额</label>
            <el-select 
              v-model="form.min_sale_amount"
              class="filter-item"
            >
              <el-option 
                v-for="item in minSaleAmountOptions" 
                :key="item.value" 
                :label="item.label" 
                :value="item.value"
                :class="{
                  'selected-item': form.min_sale_amount === item.value
                }" 
              />
            </el-select>
          </div>

          <!-- 卖场选择 -->
          <div class="tw-mt-8 tw-text-left">
            <label class="tw-text-md tw-font-pingfang tw-font-normal">卖场选择</label>
            <el-select 
              v-model="form.payment_method"
              class="filter-item"
            >
              <el-option 
                v-for="item in paymentMethodOptions" 
                :key="item.value" 
                :label="item.label" 
                :value="item.value"
                :class="{
                  'selected-item': form.payment_method === item.value
                }" 
              />
            </el-select>
          </div>

          <!-- 按钮 -->
          <button
            type="submit"
            class="tw-w-[90%] !tw-bg-[rgba(217,0,27,0.67843137254902)] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[20px] tw-rounded-3xl tw-py-3 tw-mt-16 hover:tw-bg-rose-600"
            style="letter-spacing: 4px;"
          >
            发布
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
      <p class="tw-text-xs tw-text-gray-400 tw-mt-24">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import store from '@/store'
import { formatIdDisplay } from '@/utils/tool'
import * as OrderListingApi from '@/api/order_listing'
import Hamburger from '@/components/Hamburger';

const configStore = store.config()
const userStore = store.user()
const appStore = store.app()

const form = ref({
  amount: '',
  min_sale_amount: 0,
  payment_method: 'alipay',
});

const amountInput = ref(null);
const amountUnitStyle = computed(() => {
  const element = amountInput.value;
  if (element) {
    const rect = element.getBoundingClientRect();
    const x = rect.left;
    let offsetX = rect.left + 20;

    if (form.value.amount) {
      const amountStr = String(form.value.amount);
      const length = amountStr.length;
      offsetX += 10 * length;
    }
    return `left: ${offsetX}px;`;
  }
  return 'display: none;';
});

const minSaleAmountOptions = [
  { label: '0 USDT', value: 0 },
  { label: '25 USDT', value: 25 },
  { label: '50 USDT', value: 50 },
]

const paymentMethodOptions = [
  { label: '支付宝', value: 'alipay' },
  { label: '银行卡', value: 'bank' },
  { label: '微信', value: 'wechat' },
]

const router = useRouter();

const handleClose = () => {
  router.push('/');
};

const handlePublish = async() => {
  try {
    if (!form.value.amount || form.value.amount > userStore.account?.value?.availableBalance) {
      ElMessage.error('出售数量不在合理区间，请检查！');
      return;
    }

    // 发送请求到 /api/publish
    const response = await OrderListingApi.createOrderListing(userStore.loginToken, form.value)

    if (response.data.code === 10000) {
      ElMessage.success('交易发布成功');
      await userStore.getUserInfo()
      setTimeout(() => {
        router.push('/'); // 发布成功后跳转  
      }, 3000);
    } else {
      ElMessage.error(response.data.msg || '发布失败');
      if (response.data.code === 20011) {
        setTimeout(() => {
          router.push('/profile'); // 未设置收款信息，需要先设置
        }, 3000);
      }
    }
  } catch (error) {
    console.log(error)
    ElMessage.error('发布失败');
  }
};

const toggleSidebar = () => {
  appStore.toggleSidebar();
}

</script>

<style scoped lang="scss">

:deep(.el-select__wrapper) {
  background-color: transparent !important;
  box-shadow: none !important;
  font-weight: bold !important;
  padding: 2px !important;
  // font-size: 28px !important;
  // color: red !important;
}

:deep(.el-select__placeholder) {
  color: black !important;
  font-size: 18px !important;
  margin: 4px 0px !important;
  font-family: 'Arial Negreta', 'Arial Normal', 'Arial' !important;
}

:deep(.el-select__caret) {
  color: black !important;
}

.selected-item {
  background-color: #19a5f1;
  color: white;
}
</style>
