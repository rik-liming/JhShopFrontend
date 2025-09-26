<template>
  <div class="tw-w-full tw-min-h-screen tw-bg-gradient-to-b tw-from-sky-100 tw-to-sky-200 tw-flex tw-items-center tw-justify-center">
    <div class="tw-w-[360px] tw-bg-white/60 tw-rounded-2xl tw-shadow-lg tw-p-6 tw-text-center">
      <!-- 顶部图标 -->
      <div class="tw-flex tw-items-center tw-justify-between tw-mb-4">
        <img src="@/assets/logo.png" alt="logo" class="tw-w-16 tw-h-16 tw-mx-auto" />
        <button class="tw-text-red-500 tw-text-sm">关闭</button>
      </div>

      <!-- 标题 & 汇率 -->
      <h2 class="tw-text-lg tw-font-semibold">充值</h2>
      <p class="tw-text-sm tw-text-gray-600 tw-mb-2">市场汇率：<span class="tw-text-red-500">7.26</span></p>
      <hr class="tw-my-3 tw-border-gray-300" />

      <!-- 用户信息 -->
      <div class="tw-text-left tw-space-y-1 tw-mb-4">
        <p>商户号：<span class="tw-font-semibold">JH001</span></p>
        <p>总资产：<span class="tw-font-semibold">1650 USDT</span></p>
        <p>可用资产：<span class="tw-font-semibold">1250 USDT</span></p>
      </div>

      <!-- 地址展示 -->
      <div class="tw-text-left tw-mb-3">
        <p class="tw-font-medium">接收地址（平台）：USDT-TRC20</p>
        <div
          class="tw-w-full tw-bg-gray-100 tw-rounded-md tw-border tw-border-gray-300 tw-px-2 tw-py-1 tw-break-all tw-text-sm tw-mt-1"
        >
          TAqVNKoVVfVKLU31s3tPBdhRZFKgJVeRH5
        </div>
      </div>

      <!-- 输入金额 -->
      <input
        type="text"
        placeholder="请输入充值金额（此处字体透明度35%）"
        class="tw-w-full tw-border tw-border-gray-300 tw-rounded-md tw-px-3 tw-py-2 tw-text-sm tw-placeholder-gray-400 tw-mb-4"
      />

      <!-- 上传截图 -->
      <div class="tw-text-left tw-mb-3">
        <p class="tw-font-medium">上传充值截图（必选）</p>
        <div
          class="tw-w-full tw-h-28 tw-bg-gray-100 tw-border tw-border-dashed tw-border-gray-400 tw-rounded-md tw-flex tw-items-center tw-justify-center"
        >
          <span class="tw-text-gray-400 tw-text-sm">上传区域</span>
        </div>
      </div>

      <!-- 按钮 -->
      <button
        class="tw-w-full tw-bg-rose-500 tw-text-white tw-font-semibold tw-rounded-full tw-py-2 tw-mt-4 hover:tw-bg-rose-600"
      >
        立即充值
      </button>
      <button class="tw-w-full tw-text-red-500 tw-font-medium tw-py-2 tw-mt-2">取消</button>

      <!-- 底部版权 -->
      <p class="tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH源禾商城</p>
    </div>
  </div>
</template>

<script setup>
// 这里可以加入逻辑，比如上传截图、输入金额校验等
</script>