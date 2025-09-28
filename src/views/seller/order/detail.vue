<template>
  <div class="tw-bg-gradient-to-b tw-from-blue-100 tw-to-blue-200 tw-min-h-screen tw-flex tw-items-center tw-justify-center tw-p-4">
    <div class="tw-bg-white tw-rounded-2xl tw-shadow-lg tw-w-full tw-max-w-md tw-overflow-hidden">

      <!-- Header -->
      <div class="tw-flex tw-justify-between tw-items-center tw-p-4 tw-border-b">
        <h2 class="tw-text-lg tw-font-bold">订单详情</h2>
        <button class="tw-text-red-500">关闭</button>
      </div>

      <!-- 商家信息 -->
      <div class="tw-p-4 tw-space-y-2 tw-text-sm tw-border-b">
        <div class="tw-flex tw-justify-between">
          <span>商家姓名：</span><span>曾智</span>
        </div>
        <div class="tw-flex tw-justify-between">
          <span>收款方式：</span><span>支付宝</span>
        </div>
        <div class="tw-flex tw-justify-between">
          <span>收款账号：</span><span>8669008@163.com</span>
        </div>

        <!-- 收款码 -->
        <div class="tw-mt-2 tw-text-center">
          <img src="https://via.placeholder.com/120" alt="收款码" class="tw-w-32 tw-h-32 tw-mx-auto tw-rounded-md tw-border" />
          <p class="tw-text-xs tw-mt-1">Alipay HK</p>
        </div>
      </div>

      <!-- 买家信息 -->
      <div class="tw-p-4 tw-space-y-2 tw-text-sm tw-border-b">
        <div class="tw-flex tw-justify-between">
          <span>买家姓名：</span><span>郭子仪</span>
        </div>
        <div class="tw-flex tw-justify-between">
          <span>付款方式：</span><span>支付宝</span>
        </div>
        <div class="tw-flex tw-justify-between">
          <span>付款账号：</span><span>5623895@qq.com</span>
        </div>
      </div>

      <!-- 金额信息 -->
      <div class="tw-p-4 tw-space-y-2 tw-text-sm tw-border-b">
        <div class="tw-flex tw-justify-between">
          <span>USDT币价：</span><span>7.16 元</span>
        </div>
        <div class="tw-flex tw-justify-between">
          <span>USDT金额：</span><span>$ 126</span>
        </div>
        <div class="tw-flex tw-justify-between">
          <span>CNY金额：</span><span>902.16 元</span>
        </div>
      </div>

      <!-- 订单信息 -->
      <div class="tw-p-4 tw-space-y-2 tw-text-sm tw-border-b">
        <div class="tw-flex tw-justify-between">
          <span>付款时间：</span><span>2025-07-16 18:30:15</span>
        </div>
        <div class="tw-flex tw-justify-between">
          <span>订单编号：</span><span>202507161830150003</span>
        </div>
        <div class="tw-flex tw-justify-between">
          <span>订单状态：</span>
          <span class="tw-text-red-500">等待商家确认</span>
        </div>
      </div>

      <!-- 按钮 -->
      <div class="tw-flex tw-flex-col tw-items-center tw-gap-2 tw-p-4">
        <button class="tw-bg-red-500 tw-text-white tw-font-bold tw-rounded-full tw-py-2 tw-w-2/3 hover:tw-bg-red-600">
          确认收款
        </button>
        <button class="tw-text-red-500 tw-font-semibold">取消</button>
      </div>
    </div>
  </div>
</template>
