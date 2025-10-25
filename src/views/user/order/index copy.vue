<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-items-center tw-justify-center">
    <div class="tw-w-[360px] tw-p-2 tw-text-center">
      <!-- 顶部图标 -->
      <div class="tw-flex tw-items-center tw-justify-between tw-mb-2 tw-relative">
        <div class="tw-flex tw-items-center tw-w-full">
          <img src="@/assets/logo.png" alt="logo" class="tw-w-32 tw-h-32 tw-mx-auto" />
        </div>
        <div class="tw-absolute tw-right-0 tw-flex tw-flex-col tw-items-end">
          <button class="tw-text-red-500 tw-text-sm tw-border tw-border-solid tw-border-black tw-rounded tw-px-4 tw-py-2 tw-mb-4" @click="handleClose">关闭</button>
        </div>
      </div>
      
      <h2 class="tw-text-lg tw-font-semibold tw-mb-10">订单</h2>

      <div class="tw-mb-20">
        <el-table
          :data="list"
          border
          fit
          highlight-current-row
          class="main-table"
          key="notificationTable"
          style="height: 600px; overflow: auto;"
          @row-click="handleRowClick"
        >
          <el-table-column label="订单编号" align="center">
            <template v-slot="{ row }">
              <span :class="getStatusClass(row.status)">{{ formatOrderIdDisplay(row.id, row.created_at) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="金额" align="center">
            <template v-slot="{ row }">
              <span :class="getStatusClass(row.status)">{{ row.amount }} USTD</span>
            </template>
          </el-table-column>
          <el-table-column label="市场" align="center">
            <template v-slot="{ row }">
              <span :class="getStatusClass(row.status)">{{ formatPaymentMethod(row.payment_method) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="状态" align="center" min-width="90">
            <template v-slot="{ row }">
              <span :class="getStatusClass(row.status)">{{ payStatusMap[row.status] }}</span>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 底部版权 -->
      <p class="tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH源禾商城</p>
    </div>
  </div>
</template>

<script setup>

import { useRouter } from 'vue-router';
import { ref, onMounted, reactive, watch, defineEmits, nextTick } from 'vue';
import * as OrderApi from '@/api/order'
import store from '@/store'
import { formatIdDisplay, formatOrderIdDisplay, formatPaymentMethod } from '@/utils/tool'

const payStatusMap = {
  0: '待买家付款',
  1: '待卖家确认',
  2: '已确认',
  3: '已完成',
  '-1': '超时未支付',
}

const userStore = store.user()
const router = useRouter()

const handleClose = () => {
  router.push('/')
}

// 定义数据
const list = ref([]);
const listQuery = reactive({
  page: 1,
  limit: 100,
});

// 获取数据的逻辑
const getList = async () => {
  try {
    let response = null
    if (userStore.user?.value?.role === 'buyer') {
      response = await OrderApi.getMyBuyerOrder(userStore.loginToken, {
        page: listQuery.page,
        pagesize: listQuery.limit,
      })
      if (response.data.code === 10000) {
        list.value = response.data.data.orders;
      }
    } else if (userStore.user?.value?.role === 'seller' 
    || userStore.user?.value?.role === 'agent' ) {
      response = await OrderApi.getMySellerOrder(userStore.loginToken, {
        page: listQuery.page,
        page_size: listQuery.limit,
      })
      if (response.data.code === 10000) {
        list.value = response.data.data.orders;
      }
    }
  } catch (error) {
    console.error('获取数据失败', error);
  }
};

// 生命周期钩子，组件加载时获取数据
onMounted(() => {
  nextTick(() => {
    // 确保 getList 在 DOM 更新后调用
    getList();
  });
});

const handleRowClick = (row) => {
  const role = userStore.user?.value?.role
  let targetPage = ''
  if (role === 'buyer') {
    // 根据点击的行的数据，构造目标路由地址
    targetPage = `/order/buyer/detail?orderId=${row.id}`; // 假设根据 row.id 构造跳转路径
    router.push(targetPage); // 跳转到 /buy 页面，带上 tradeId 参数
  } else if (role === 'seller' || role === 'agent') {
    targetPage = `/order/seller/detail?orderId=${row.id}`; // 假设根据 row.id 构造跳转路径
    router.push(targetPage); // 跳转到 /buy 页面，带上 tradeId 参数
  }
};

const getStatusClass = (status) => {
  switch (status) {
    case 0:
      return 'waitBuyerPay';
    case 1:
      return 'buyerConfirm';
    case 2:
      return 'sellerConfirm';
    case 3:
      return 'complete';
    default:
      return '';
  }
}

</script>

<style scoped lang="scss">

.main-table {
  width: 100%;
  background-color: transparent !important;
  border: 1px solid black !important;
}

:deep(.el-table__header th) {
  border: 1px solid #7f7f7f !important;
  background-color: transparent !important;
  font-size: 16px;
  font-weight: bold;
  color: black;
}

:deep(.el-table__header tr) {
  background-color: transparent !important;
}

:deep(.el-table__body td) {
  border: 1px solid #7f7f7f !important;
}

:deep(.el-table__body tr) {
  background-color: transparent !important;
  border: 1px solid #7f7f7f !important;
}

:deep(.el-table__body tr .waitBuyerPay) {
  color: red;
}

:deep(.el-table__body tr .buyerConfirm) {
  color: yellow;
}

:deep(.el-table__body tr .sellerConfirm) {
  color: green;
}

:deep(.el-table__body tr .complete) {
  color: blue;
}
</style>
