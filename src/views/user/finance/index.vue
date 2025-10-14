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
      

      <!-- 标题 & 汇率 -->
      <h2 class="tw-text-lg tw-font-semibold tw-mb-10">财务变动</h2>

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
          <el-table-column label="记录编号" width="'40%'" align="center">
              <template v-slot="{row}">
              <span>{{ row.transaction_id }}</span>
              </template>
          </el-table-column>
          <el-table-column label="金额" width="'20%'" align="center">
              <template v-slot="{row}">
              <span>{{ row.amount }}</span>
              </template>
          </el-table-column>
          <el-table-column label="类型" width="'20%'" align="center">
              <template v-slot="{row}">
              <span>{{ row.transaction_type }}</span>
              </template>
          </el-table-column>
          <el-table-column label="余额" width="'20%'" align="center">
              <template v-slot="{row}">
              <span>{{ row.balance_after }}</span>
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
import * as FinanceApi from '@/api/finance'
import store from '@/store';

const router = useRouter()
const userStore = store.user()

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
    const response = await FinanceApi.getMyFinanceRecord(userStore.loginToken, {
      page: listQuery.page,
      pagesize: listQuery.limit,
      channel: listQuery.channel
    })
    if (response.data.code === 10000) {
      list.value = response.data.data.records;
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
  let targetPage = ''
  switch(row.transaction_type) {
    case 'recharge':
      targetPage = `/charge/detail?transactionId=${row.transaction_id}`
      break;
    case 'transfer':
      targetPage = `/transfer/detail?transactionId=${row.transaction_id}`
      break;
    case 'withdraw':
      targetPage = `/withdraw/detail?transactionId=${row.transaction_id}`
      break;
    case 'order':
      const role = userStore.user?.value?.role
      if (role === 'buyer') {
        targetPage = `/order/buyer/detail?orderId=${row.order_id}`;
      } else if (role === 'seller' || role === 'agent') {
        targetPage = `/order/seller/detail?orderId=${row.order_id}`;
      }
      break;
  }

  if (targetPage.length > 0) {
    router.push(targetPage);
  }
};
</script>

<style scoped lang="scss">
.transfer-text {
    text-decoration: underline rgb(215, 215, 215);
    text-decoration-thickness: 3px; /* 增加下划线的粗细 */
    text-underline-offset: 5px; /* 增加下划线与文字的距离 */
}

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
</style>
