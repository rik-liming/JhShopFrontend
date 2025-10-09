<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-items-center tw-justify-center">
    <div class="tw-w-[360px] tw-p-2 tw-text-center">
      <!-- 顶部图标 -->
      <div class="tw-flex tw-items-center tw-justify-between tw-mb-2 tw-relative">
        <div class="tw-flex tw-items-center tw-w-full">
          <img src="@/assets/ali_pay.png" alt="logo" class="tw-w-32 tw-h-32 tw-mx-auto" />
        </div>
        <div class="tw-absolute tw-right-0 tw-top-0 tw-flex tw-flex-col tw-items-end">
          <button class="tw-text-red-500 tw-text-sm tw-border tw-border-solid tw-border-black tw-rounded tw-px-4 tw-py-2 tw-mb-4" @click="handleClose">关闭</button>
        </div>
      </div>

      <!-- 标题 & 汇率 -->
      <h2 class="tw-text-right tw-text-lg tw-font-semibold tw-mt-8 tw-mb-12">市场汇率: {{ exchangeRate }}</h2>

      <div class="tw-mt-4 tw-text-left">
        <div class="tw-text-lg tw-font-bold">购买信息(店铺名)： {{ formatIdDisplay(orderListing?.user_id) }}</div>
      </div>

      <!-- el-form 表单 -->
      <el-form :model="formData" ref="formRef" @submit.prevent="handleSubmit" :rules="formRules" class="tw-mt-10">
        <!-- 输入字段 -->
        <el-form-item label="库存">
          <el-input :value="`${orderListing?.remain_amount} USDT`" class="tw-w-5/6" disabled />
        </el-form-item>

        <el-form-item prop="buy_account_number">
          <el-input v-model="formData.buy_account_number" placeholder="付款人支付宝号" class="tw-w-5/6" />
        </el-form-item>

        <el-form-item prop="buy_account_name">
          <el-input v-model="formData.buy_account_name" placeholder="付款人姓名" class="tw-w-5/6" />
        </el-form-item>

        <el-form-item prop="amount">
          <el-input v-model="formData.amount" placeholder="USDT金额" class="tw-w-5/6" />
        </el-form-item>

        <el-form-item>
          <el-input :value="`${ getExchangeCNY(formData.amount) }`" placeholder="CNY金额" class="tw-w-5/6" />
        </el-form-item>


        <!-- 按钮 -->
        <el-form-item>
          <el-button type="primary" class="tw-w-full tw-bg-rose-500 tw-text-white tw-font-semibold" @click="handleBuy">
            立即购买
          </el-button>
        </el-form-item>

        <el-form-item>
          <el-button class="tw-w-full tw-text-red-500 tw-font-medium" @click="handleClose">
            取消
          </el-button>
        </el-form-item>
      </el-form>

      <!-- 底部版权 -->
      <p class="tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, reactive } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import * as OrderApi from '@/api/order'
import { ElMessage } from 'element-plus';
import store from '@/store'
import { formatIdDisplay } from '@/utils/tool'
import Decimal from 'decimal.js'

const configStore = store.config()
const userStore = store.user()

const route = useRoute()
const router = useRouter();

let orderListing = reactive({
  user_id: 0,
  amount: 0,
  remain_amount: 0,
  min_sale_amount: 0,
  payment_method: '',
});
const orderListingId = ref(route.query.orderListingId)

// 数据绑定
const formData = ref({
  order_listing_id: 0,
  amount: 0,
  payment_method: '',
  buy_user_id: '',
  buy_account_name: '',
  buy_account_number: '',
  buy_bank_name: '',
  buy_issue_bank_name: '',
});

// 表单引用
const formRef = ref(null);

// 校验规则
const formRules = {
  buy_account_number: [
    { required: true, message: '付款人支付宝号不能为空', trigger: 'blur' }
  ],
  buy_account_name: [
    { required: true, message: '付款人姓名不能为空', trigger: 'blur' }
  ],
  amount: [
    { required: true, message: 'USDT金额不能为空', trigger: 'blur' },
    { pattern: /^[1-9]\d*$/, message: 'USDT金额必须为正数', trigger: 'blur' },
    {
      validator: async (rule, value, callback) => {
        if (!value) {
          return callback(new Error('USDT金额不能为空'));
        }

        // 确保 orderListing 已加载完
        if (orderListing?.remain_amount === undefined || orderListing?.remain_amount === null) {
          return callback(new Error('库存信息加载失败'));
        }

        // 校验购买量不能大于库存量
        if (Number(value) > Number(orderListing.remain_amount)) {
          return callback(new Error(`购买量不能大于库存 ${orderListing.remain_amount} USDT`));
        }

        // 校验通过
        callback();
      },
      trigger: 'blur',
    },
  ]
};

// 页面加载时获取订单列表信息
onMounted(async () => {
  const resp = await OrderApi.getOrderListing(userStore.loginToken, orderListingId.value)
  if (resp.data.code === 10000) {
    Object.assign(orderListing, resp.data.data.orderListing);
  }
});

// 关闭页面
const handleClose = () => {
  router.push('/');
};

// 提交表单
const handleSubmit = async() => {
  // 触发表单验证
  // 如果表单验证通过，则进行提交操作
  console.log(formData.value);

  formData.value.order_listing_id = orderListing.id;
  formData.value.buy_user_id = userStore.user?.value?.id
  formData.value.payment_method = orderListing.payment_method

  const resp = await OrderApi.createOrder(userStore.loginToken, formData.value)
  if (resp.data.code === 10000) {
    ElMessage.success('订单创建成功');
    setTimeout(() => {
      router.push(`/order/buyer/detail?orderId=${resp.data.data.order.id}`); // 订单创建成功，调到详情 
    }, 3000);
  }
};


// 购买按钮处理
const handleBuy = () => {
  // 触发表单验证
  formRef.value?.validate((valid) => {
    if (valid) {
      // 验证通过后，执行提交操作
      handleSubmit();  // 调用 handleSubmit 执行数据提交
    } else {
      // 验证失败，提示用户
      ElMessage.error('表单验证失败，请检查输入项');
    }
  });
};

const exchangeRate = computed(() => {
  let rate = 0.00;
  if (!orderListing?.payment_method) {
    return rate
  }

  switch (orderListing.payment_method) {
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

const getExchangeCNY = (amount) => {
  const num1 = new Decimal(amount);  // 第一个数
  const num2 = new Decimal(exchangeRate.value);    // 第二个数

  // 相乘并保留 2 位小数
  const result = num1.mul(num2).toFixed(2, Decimal.ROUND_UP);
  return result
}

</script>

<style scoped lang="scss">
</style>
