<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-items-center tw-justify-center">
    <div class="tw-w-[360px] tw-p-2 tw-text-center">
      <!-- 顶部图标 -->
      <div class="tw-flex tw-items-center tw-justify-between tw-mb-2 tw-relative">
        <div class="tw-flex tw-items-center tw-w-full">
          <img src="@/assets/sale_icon.png" alt="logo" class="tw-w-32 tw-h-32 tw-mx-auto" />
        </div>
        <div class="tw-absolute tw-right-0 tw-flex tw-flex-col tw-items-end tw-z-20">
          <button 
            class="tw-text-red-500 tw-text-sm tw-border tw-border-solid tw-border-black tw-rounded tw-px-4 tw-py-2 tw-mb-4" 
            @click="handleClose"
          >
            关闭
          </button>
        </div>
      </div>

      <!-- 标题 & 汇率 -->
      <h2 class="tw-text-lg tw-font-semibold">发布交易</h2>
      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 用户信息 -->
      <div class="tw-mb-6 tw-mt-8">
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">商户号：</p>
          <p class="tw-font-semibold tw-text-right">{{ formatIdDisplay(userStore.user?.value?.id) }}</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">总资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ userStore?.account?.value?.totalBalance }} USDT</p>
        </div>
        <div class="tw-flex tw-justify-between tw-space-x-4">
          <p class="tw-text-left">可用资产：</p>
          <p class="tw-font-semibold tw-text-right">{{ userStore?.account?.value?.availableBalance }} USDT</p>
        </div>
      </div>

      <!-- 使用 el-form 和 el-form-item -->
      <el-form :model="form" ref="formRef" label-width="100px" class="tw-mt-6">
        
        <!-- 出售数量 -->
        <el-form-item label="出售数量（USDT）" prop="amount" :rules="amountRules">
          <el-input-number v-model="form.amount" :min="1" :max="Math.floor(userStore?.account?.value?.availableBalance)" label="出售数量" class="tw-w-full" />
        </el-form-item>

        <!-- 最低购买金额 -->
        <el-form-item label="最低购买金额" prop="minAmount" :rules="minAmountRules">
          <el-select v-model="form.minAmount" placeholder="选择最低购买金额" class="tw-w-1/2">
            <el-option label="0 USDT" value="0" />
            <el-option label="100 USDT" value="100" />
            <el-option label="500 USDT" value="500" />
          </el-select>
        </el-form-item>

        <!-- 卖场选择 -->
        <el-form-item label="卖场选择" prop="paymentMethod" :rules="paymentMethodRules">
          <el-select v-model="form.paymentMethod" placeholder="选择支付方式" class="tw-w-1/2">
            <el-option label="支付宝" value="alipay" />
            <el-option label="微信" value="wechat" />
            <el-option label="银行卡" value="bank" />
          </el-select>
        </el-form-item>

      </el-form>

      <!-- 按钮 -->
      <button
        class="tw-w-full tw-bg-rose-500 tw-text-white tw-font-semibold tw-rounded-full tw-py-2 tw-mt-14 hover:tw-bg-rose-600"
        @click="handlePublish"
      >
        发布
      </button>
      <button 
        class="tw-w-full tw-text-red-500 tw-font-medium tw-py-2 tw-mt-2"
        @click="handleClose"
      >
        取消
      </button>

      <!-- 底部版权 -->
      <p class="tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import store from '@/store';
import axios from 'axios';
import { formatIdDisplay } from '@/utils/tool';
import { ElMessage } from 'element-plus';
import * as OrderListingApi from '@/api/order_listing';

// 支付方式选择项
const paymentMethodOptions = [
  { key: 'alipay', label: '支付宝' },
  { key: 'wechat', label: '微信' },
  { key: 'bank', label: '银行卡' },
];

const formRef = ref(null);
// 表单数据
const form = ref({
  amount: 350, // 出售数量
  minAmount: 0, // 最低购买金额
  paymentMethod: 'alipay', // 支付方式
});

// 表单验证规则
const amountRules = [
  { required: true, message: '请输入出售数量', trigger: 'blur' },
  { type: 'number', min: 1, message: '数量必须大于0', trigger: 'blur' },
  {
    validator: (rule, value, callback) => {
      if (value > userStore?.account?.value?.availableBalance) {
        callback(new Error(`数量不能大于可用余额 ${userStore?.account?.value?.availableBalance} USDT`));
      } else {
        callback();
      }
    },
    trigger: 'blur',
  },
];
const minAmountRules = [
  { required: true, message: '请选择最低购买金额', trigger: 'change' },
  {
    validator: (rule, value, callback) => {
      if (value > userStore?.account?.value?.availableBalance) {
        callback(new Error(`数量不能大于可用余额 ${userStore?.account?.value?.availableBalance} USDT`));
      } else {
        callback();
      }
    },
    trigger: 'blur',
  },
];
const paymentMethodRules = [
  { required: true, message: '请选择支付方式', trigger: 'change' },
];

const router = useRouter();
const userStore = store.user();

// 关闭按钮操作
const handleClose = () => {
  router.push('/');
};

// 发布按钮操作
const handlePublish = async () => {
  try {
    // 表单验证
    await formRef.value.validate();

    // 构建请求数据
    const payload = {
      amount: form.value.amount,
      min_sale_amount: form.value.minAmount,
      payment_method: form.value.paymentMethod,
    };

    // 发送请求到 /api/publish
    const response = await OrderListingApi.createOrderListing(userStore.loginToken, payload)

    if (response.data.code === 10000) {
      ElMessage.success('交易发布成功');
      await userStore.getUserInfo()
      setTimeout(() => {
        router.push('/'); // 发布成功后跳转  
      }, 3000);
    } else {
      ElMessage.error(response.data.msg || '发布失败');
    }
  } catch (error) {
    console.log(error)
    ElMessage.error('发布失败，请重试');
  }
};
</script>

<style scoped lang="scss">
/* select 去除浏览器默认的箭头 */
select {
  appearance: none; /* 去除默认箭头 */
  -webkit-appearance: none; /* Safari 和 Chrome */
  -moz-appearance: none; /* Firefox */
}

/* 自定义的下拉箭头 */
.tw-relative select {
  padding-right: 30px; /* 给右侧留出空间，显示箭头 */
}

.select-arrow {
  pointer-events: none; /* 防止箭头干扰 select 的点击 */
  font-size: 16px; /* 箭头的大小 */
}
</style>
