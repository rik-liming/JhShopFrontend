<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-flex tw-justify-center">
    <div class="tw-w-[90%] tw-p-1 tw-text-center tw-flex tw-flex-col tw-justify-start tw-items-center">
      <!-- 顶部图标 -->
      <div class="tw-w-full tw-flex tw-items-center tw-justify-between tw-mt-14 tw-mb-2 tw-relative">
        <div class="tw-flex tw-items-center tw-w-full">
          <img 
            :src="getImageStyle(orderListingData?.payment_method).src" 
            alt="logo" 
            class="tw-mx-auto"
            :class="getImageStyle(orderListingData?.payment_method).class"
          />
        </div>
        <div class="tw-absolute tw-left-0 tw-flex tw-flex-col tw-items-end">
          <hamburger 
            id="hamburger-container" 
            :is-active="appStore.sidebar.opened" 
            class="hamburger-container"
            :iconStyle="1"
            @toggleClick="toggleSidebar" 
          />
        </div>
        <div class="tw-absolute tw-right-0 tw-flex tw-flex-col tw-items-end">
          <button class="tw-text-[#D9001B] tw-font-pingfang tw-text-[17px] tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-rounded-lg tw-px-2 tw-py-1 tw-mb-16" @click="handleClose">关闭</button>
        </div>
        <div class="tw-absolute tw-right-0 tw-flex tw-flex-col tw-items-end tw-mt-48">
          <p class="tw-text-sm tw-mb-2 tw-mr-4 tw-font-songti tw-font-bold tw-text-[#333333]">市场汇率：<span class="tw-text-[#333333] tw-font-pingfang tw-font-normal">{{ exchangeRate }}</span></p>
        </div>
      </div>

      <div class="tw-w-[86%] tw-text-[#333333] tw-mt-16">
        <!-- 商户号 -->
        <div class="tw-flex tw-justify-between tw-space-x-4 tw-mt-6 tw-mb-2 tw-font-pingfangsb tw-font-semibold">
          <p class="tw-text-left">购买信息（店铺名）：{{ formatIdDisplay(orderListingData?.user_id) }}</p>
        </div>

        <!-- 表单 -->
        <form @submit.prevent="handleBuy" class="tw-mb-4">
          <div class="tw-relative">
            <label class="tw-absolute tw-left-4 tw-top-7 tw-font-pingfang tw-text-md tw-font-normal">库存</label>
            <input
              type="text"
              :value="`${orderListingData?.remain_amount} USDT`"
              disabled
              class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mt-10 tw-mb-2"
            />
          </div>

          <input
            v-if="orderListingData?.payment_method == 'bank'"
            type="text"
            placeholder="请输入付款银行名称"
            v-model="form.bank_name"
            required
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mt-4 tw-mb-2"
          />

          <input
            v-if="orderListingData?.payment_method == 'bank'"
            type="text"
            placeholder="请输入付款银行开户行"
            v-model="form.issue_bank_name"
            required
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mt-4 tw-mb-2"
          />

          <input
            type="text"
            :placeholder="accountPlaceHolder"
            v-model="form.account_number"
            required
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mt-4 tw-mb-2"
          />

          <input
            type="text"
            placeholder="请输入姓名"
            v-model="form.account_name"
            required
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mt-4 tw-mb-2"
          />

          <el-tooltip
            placement="top"
            trigger="focus"
            v-if="orderListingData?.min_sale_amount > 0"
          >
            <template #content>
              <div class="tw-max-w-[300px] tw-text-lg tw-text-white tw-bg-blue tw-rounded tw-px-3 tw-py-1">
                {{ `根据商家设置，下单金额至少为人民币：${minBuyCnyAmount} 元` }}
              </div>
            </template>

            <input
              type="number"
              placeholder="请输入人民币金额"
              v-model="form.cny_amount"
              ref="cnyAmountInput"
              :min="minBuyCnyAmount"
              required
              class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mt-4 tw-mb-2"
            />
          </el-tooltip>
          <input
            v-else
            type="number"
            placeholder="请输入人民币金额"
            v-model="form.cny_amount"
            ref="cnyAmountInput"
            :min="minBuyCnyAmount"
            required
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mt-4 tw-mb-2"
          />

          <span
            v-show="form.cny_amount"
            class="tw-absolute tw-text-[#333333] tw-text-md tw-mt-[25px]"
            :style="cnyAmountUnitStyle"
          >
            元
          </span>

          <input
            type="text"
            v-model="form.amount"
            ref="amountInput"
            disabled
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mt-4 tw-mb-2"
          />

          <span
            v-show="form.amount"
            class="tw-absolute tw-text-[#333333] tw-text-opacity-70 tw-text-md tw-mt-[25px]"
            :style="amountUnitStyle"
          >
            USDT
          </span>

          <input
            type="text"
            placeholder="请输入支付密码"
            v-model="form.payment_password"
            required
            class="tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-2 tw-text-md tw-placeholder-black tw-placeholder-opacity-35 tw-mt-4 tw-mb-4"
          />

          <!-- 按钮 -->
          <button
            type="submit"
            class="tw-w-[80%] !tw-bg-[rgba(217,0,27,0.67843137254902)] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[20px] tw-rounded-3xl tw-py-3 tw-mt-12 hover:tw-bg-rose-600"
            style="letter-spacing: 4px;"
          >
            立即购买
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
      <p class="tw-text-xs tw-text-gray-400 tw-mt-12 tw-mb-2">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, reactive, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import * as OrderListingApi from '@/api/order_listing'
import * as OrderApi from '@/api/order'
import { ElMessage } from 'element-plus';
import store from '@/store'
import { formatIdDisplay } from '@/utils/tool'
import Decimal from 'decimal.js'

const configStore = store.config()
const userStore = store.user()
const appStore = store.app()

const route = useRoute()
const router = useRouter();

const orderListingData = ref(null);
const orderListingId = ref(route.query.orderListingId)

const form = ref({
  order_listing_id: 0,
  account_name: '',
  account_number: '',
  bank_name: '',
  issue_bank_name: '',
  amount: 0.00,
  cny_amount: null,
  payment_password: '',
});

watch(() => form.value.cny_amount, (newCNYAmount) => {
  if (newCNYAmount !== null) {
    form.value.amount = getExchangeUSDT(newCNYAmount);
  } else {
    form.value.amount = 0.00;
  }
});

const minBuyCnyAmount = computed(() => {
  const minSaleAmount = orderListingData?.value?.min_sale_amount || 0.00
  return getExchangeCNY(minSaleAmount);
});

const accountPlaceHolder = computed(() => {
  let placeHolder = ''

  if (!orderListingData?.value?.payment_method) {
    return placeHolder
  }

  switch (orderListingData.value.payment_method) {
    case 'alipay':
      placeHolder = '请输入支付宝号'
      break;
    case 'wechat':
      placeHolder = '请输入微信号'
      break;
    case 'bank':
      placeHolder = '请输入银行卡号'
      break;
  }

  return placeHolder
})

// 页面加载时获取订单列表信息
onMounted(async () => {
  const resp = await OrderListingApi.getOrderListing(userStore.loginToken, orderListingId.value)
  if (resp.data.code === 10000) {
    orderListingData.value = resp.data.data.orderListing;
    form.value.order_listing_id = orderListingData.value.id
  }
});

// 关闭页面
const handleClose = () => {
  router.push('/');
};

// 提交表单
const handleBuy = async() => {
  try {
    if (!form.value.account_name 
      || !form.value.account_number
      || !form.value.amount
      || !form.value.cny_amount
      || !form.value.payment_password
    ) {
      ElMessage.error('请完整输入各项内容!');
      return;
    }

    if (form.value.cny_amount < minBuyCnyAmount.value) {
      ElMessage.error('低于最少购买数量!');
      return;
    }

    const resp = await OrderApi.createOrder(userStore.loginToken, form.value)

    if (resp.data.code === 10000) {
      ElMessage.success('订单创建成功');
      setTimeout(() => {
        router.push(`/order/buyer/detail?orderId=${resp.data.data.order.id}`); // 订单创建成功，调到详情 
      }, 3000);
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
    ElMessage.error('订单创建失败');
  }
};

const exchangeRate = computed(() => {
  let rate = 0.00;
  if (!orderListingData?.value?.payment_method) {
    return rate
  }

  switch (orderListingData.value.payment_method) {
    case 'alipay':
      rate = configStore.config.value.exchange_rate_alipay;
      break;
    case 'wechat':
      rate = configStore.config.value.exchange_rate_wechat;
      break;
    case 'bank':
      rate = configStore.config.value.exchange_rate_bank;
      break;
  }
  return rate;
})

const getExchangeUSDT = (cnyAmount) => {
  let result = 0.00
  if (cnyAmount) {
    const num1 = new Decimal(cnyAmount);  // 第一个数
    const num2 = new Decimal(exchangeRate.value);    // 第二个数

    // 相除并保留 2 位小数
    if (num2 !== 0) {
      result = num1.div(num2).toFixed(2, Decimal.ROUND_UP);
    }
  }
  
  return result
}

const getExchangeCNY = (amount) => {
  const num1 = new Decimal(amount);  // 第一个数
  const num2 = new Decimal(exchangeRate.value);    // 第二个数

  // 相乘并保留 2 位小数
  const result = num1.mul(num2).toFixed(2, Decimal.ROUND_UP);
  
  return result
}

const toggleSidebar = () => {
  appStore.toggleSidebar();
}

const getImageStyle = (paymentMethod) => {
  switch (paymentMethod) {
    case 'alipay':
      return {
        src: new URL('@/assets/ali_pay.png', import.meta.url).href,
        class: 'tw-w-[100px] tw-h-[90px]',
      }
    case 'wechat':
      return {
        src: new URL('@/assets/wechat_pay.png', import.meta.url).href,
        class: 'tw-w-[104px] tw-h-[92px]',
      }
    case 'bank':
      return {
        src: new URL('@/assets/bank_pay.png', import.meta.url).href,
        class: 'tw-w-[140px] tw-h-[90px]',
      }
    default:
      return {
        src: '',
        class: '',
      }
  }
}

const cnyAmountInput = ref(null);
const cnyAmountUnitStyle = computed(() => {
  const element = cnyAmountInput.value;
  if (element) {
    const rect = element.getBoundingClientRect();
    const x = rect.left;
    let offsetX = rect.left + 20;

    if (form.value.cny_amount) {
      const cnyAmountStr = String(form.value.cny_amount);
      const length = cnyAmountStr.length;
      offsetX += 10 * length;
    }
    return `left: ${offsetX}px;`;
  }
  return 'display: none;';
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

</script>

<style scoped lang="scss">

</style>
