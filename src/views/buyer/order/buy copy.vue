<template>
  <div class="tw-w-full tw-min-h-screen tw-bg-gradient-to-b tw-from-sky-100 tw-to-sky-200 tw-flex tw-items-center tw-justify-center">
    <div class="tw-w-[360px] tw-bg-white/60 tw-rounded-2xl tw-shadow-lg tw-p-6 tw-text-center">
      <!-- 顶部图标 -->
      <div class="tw-flex tw-items-center tw-justify-between tw-mb-4">
        <img src="@/assets/ali_pay.png" alt="alipay" class="tw-w-16 tw-h-16 tw-mx-auto" />
        <button class="tw-text-red-500 tw-text-sm">关闭</button>
      </div>

      <!-- 标题 & 汇率 -->
      <h2 class="tw-text-lg tw-font-semibold">购买信息(店铺名): JH001</h2>
      <p class="tw-text-sm tw-text-gray-600 tw-mb-2">市场汇率：<span class="tw-text-red-500">7.26</span></p>
      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 库存 -->
      <div class="tw-text-left tw-mb-3">
        <p class="tw-font-medium">库存</p>
        <div
          class="tw-w-full tw-bg-gray-100 tw-rounded-md tw-border tw-border-gray-300 tw-px-2 tw-py-2 tw-text-sm"
        >
          1250 USDT
        </div>
      </div>

      <!-- 表单 -->
      <form class="tw-space-y-3 tw-mb-4">
        <input
          type="text"
          placeholder="付款人支付宝号（此处字体透明度35%）"
          class="tw-w-full tw-border tw-border-gray-300 tw-rounded-md tw-px-3 tw-py-2 tw-text-sm tw-placeholder-gray-400"
        />
        <input
          type="text"
          placeholder="付款人姓名（此处字体透明度35%）"
          class="tw-w-full tw-border tw-border-gray-300 tw-rounded-md tw-px-3 tw-py-2 tw-text-sm tw-placeholder-gray-400"
        />
        <input
          type="text"
          placeholder="USDT金额"
          class="tw-w-full tw-border tw-border-gray-300 tw-rounded-md tw-px-3 tw-py-2 tw-text-sm"
        />
        <input
          type="text"
          placeholder="CNY金额"
          class="tw-w-full tw-border tw-border-gray-300 tw-rounded-md tw-px-3 tw-py-2 tw-text-sm"
        />
        <input
          type="password"
          placeholder="支付密码（此处字体透明度35%）"
          class="tw-w-full tw-border tw-border-gray-300 tw-rounded-md tw-px-3 tw-py-2 tw-text-sm tw-placeholder-gray-400"
        />
      </form>

      <!-- 按钮 -->
      <button
        class="tw-w-full tw-bg-rose-500 tw-text-white tw-font-semibold tw-rounded-full tw-py-2 hover:tw-bg-rose-600"
      >
        立即购买
      </button>
      <button class="tw-w-full tw-text-red-500 tw-font-medium tw-py-2 tw-mt-2">取消</button>

      <!-- 底部版权 -->
      <p class="tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH源禾商城</p>
    </div>
  </div>
</template>

<script setup>
// 可以在这里写表单提交逻辑
import { useRoute } from 'vue-router';

const route = useRoute();
const tradeId = route.query.tradeId; // 获取 URL 参数 tradeId
</script>
