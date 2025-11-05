<template>
    <el-table
        :data="list"
        border
        fit
        highlight-current-row
        class="main-table"
        key="orderTable"
        style="height: 600px; overflow: auto;"
        @row-click="handleRowClick"
        @touchstart="onTouchStart"
        @touchmove="onTouchMove"
        @touchend="onTouchEnd"
        @scroll="handleScroll"
    >
        <el-table-column label="订单编号" :width="getAdjustWidth(120)" align="center">
          <template v-slot="{row}">
            <span :class="getStatusClass(row?.status)">{{ row?.buy_transaction_id }}</span>
          </template>
        </el-table-column>
        <el-table-column label="金额 (USTD)" :width="getAdjustWidth(86)" align="center">
          <template v-slot="{row}">
            <span v-if="row.status !== null && row.status !== undefined" :class="getStatusClass(row.status)">{{ row.amount }}</span>
            <span v-else class="opacity-30">-</span>
          </template>
        </el-table-column>
        <el-table-column label="市场" :width="getAdjustWidth(66)" align="center">
          <template v-slot="{row}">
            <span v-if="row.status !== null && row.status !== undefined" :class="getStatusClass(row.status)">{{ formatPaymentMethod(row.payment_method) }}</span>
            <span v-else class="opacity-30">-</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" :width="getAdjustWidth(92)" align="center">
          <template v-slot="{row}">
            <span v-if="row.status !== null && row.status !== undefined" :class="getStatusClass(row.status)">{{ payStatusMap[row.status] }}</span>
            <span v-else class="opacity-30">-</span>
          </template>
        </el-table-column>
    </el-table>
</template>

<script setup>
import { ref, onMounted, reactive, watch, defineEmits, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import store from '@/store';
import * as OrderApi from '@/api/order'
import { formatPaymentMethod, getAdjustWidth } from '@/utils/tool'

const payStatusMap = {
  0: '待买家付款',
  1: '待商户确认',
  2: '已完成',
  3: '超时取消',
  4: '争议',
  5: '争议（已通过）',
  6: '争议（已撤单）',
}

const emit = defineEmits();

const userStore = store.user()

const props = defineProps({
  currentShowTable: String,
  tableType: String,
});

// 定义数据
const list = ref([]);
const listQuery = reactive({
  page: 1,
  limit: 20,
  tableType: 'order',
});
const minTableRowCount = ref(15)
const isRefreshing = ref(false)
const touchStartY = ref(0)
const touchMoveY = ref(0)
const threshold = ref(200)
const hasMore = ref(true)             
const loadingMore = ref(false)        

let isFirstCall = true;

// 获取数据的逻辑
const getList = async (append = false) => {  
  try {
    emit('table-update-start');
    setTimeout(() => emit('table-update-end'), 100);

    let response = null
    if (userStore.user?.value?.role === 'buyer') {
      response = await OrderApi.getMyBuyerOrder(userStore.loginToken, {
        page: listQuery.page,
        page_size: listQuery.limit,
      })
    } else if (userStore.user?.value?.role === 'seller' || userStore.user?.value?.role === 'agent') {
      response = await OrderApi.getMySellerOrder(userStore.loginToken, {
        page: listQuery.page,
        page_size: listQuery.limit,
      })
    }

    if (response.data.code === 10000) {
      const orders = response.data.data.orders;

      if (append) {
        list.value = [...list.value, ...orders]
      } else {
        if (orders.length < minTableRowCount.value) {
          list.value = [
            ...orders,
            ...Array.from({ length: minTableRowCount.value - orders.length }, () => ({ fakeId: Math.random() }))
          ];
        } else {
          list.value = orders
        }
      }

      hasMore.value = orders.length === listQuery.limit
    }
  } catch (error) {
    console.error('获取数据失败', error);
    list.value = Array.from({ length: minTableRowCount.value }, () => ({ fakeId: Math.random() }))
  } finally {
    loadingMore.value = false;
  }
};

const handleScroll = (e) => {
  const el = e.target;
  const distanceToBottom = el.scrollHeight - el.scrollTop - el.clientHeight;
  if (distanceToBottom < 50 && hasMore.value && !loadingMore.value) {
    loadingMore.value = true;
    listQuery.page += 1;
    getList(true);
  }
};

watch(
  () => props.tableType,
  (newTableType) => {
    listQuery.tableType = newTableType;

    if (!isFirstCall 
      && props.currentShowTable === 'my'
      && props.tableType === 'order'
    ) {
      listQuery.page = 1;
      getList();
    } else {
      isFirstCall = false;
    }
  },
  { immediate: true }
);

onMounted(() => {
  nextTick(() => {
    getList();
  });
});

const router = useRouter();

const handleRowClick = (row) => {
  if (!row.id) {
    return
  }
  const role = userStore.user?.value?.role
  let targetPage = ''
  if (role === 'buyer') {
    targetPage = `/order/buyer/detail?orderId=${row.id}`;
    router.push(targetPage);
  } else if (role === 'seller' || role === 'agent') {
    targetPage = `/order/seller/detail?orderId=${row.id}`;
    router.push(targetPage);
  }
};

const getStatusClass = (status) => {
  if (status !== null && status !== undefined) {
    switch (status) {
      case 0: return 'waitBuyerPay';
      case 1: return 'buyerConfirm';
      case 2: return 'sellerConfirm';
      case 3: return 'expired';
      case 4: return 'argue';
      case 5: return 'argueComplete';
      case 6: return 'argueCancel';
      default: return '';
    }
  }
  return '';
}

const onTouchStart = (event) => {
  touchStartY.value = event.changedTouches[0].clientY;
}

const onTouchMove = (event) => {
  touchMoveY.value = event.changedTouches[0].clientY;
  if (touchMoveY.value - touchStartY.value > threshold.value) {
    isRefreshing.value = true;
  }
}

const onTouchEnd = () => {
  if (touchMoveY.value - touchStartY.value > threshold.value) {
    triggerRefresh();
  } else {
    isRefreshing.value = false;
  }
}

const triggerRefresh = () => {
  isRefreshing.value = true;
  listQuery.page = 1;   
  getList();
}

</script>



<style scoped lang="scss">

.main-table {
  width: 100%;
  background-color: transparent !important;
  border: 1px solid rgba(0,0,0,0.4) !important;
}

:deep(.el-table__header th) {
  border: 1px solid rgba(127,127,127,0.4) !important;
  background-color: transparent !important;
  font-size: 14px;
  font-weight: 600;
  color: black;
  font-family: 'PingFangSC-Semibold', 'PingFang SC Semibold', 'PingFang SC';
}

:deep(.el-table__header tr) {
  background-color: transparent !important;
}

:deep(.el-table__body td) {
  border: 1px solid rgba(127,127,127,0.2) !important;
  font-size: 13px;
  font-weight: normal;
  color: #333333;
  font-family: 'Arial Normal', 'Arial';
}

:deep(.el-table__body tr) {
  background-color: transparent !important;
  border: 1px solid rgba(127,127,127,0.4) !important;
}

:deep(.el-table__body tr .waitBuyerPay) {
  color: #eab308;
}

:deep(.el-table__body tr .buyerConfirm) {
  color: #3b82f6;
}

:deep(.el-table__body tr .sellerConfirm) {
  color: #22c55e;
}

:deep(.el-table__body tr .expired) {
  color: #333333;
}

:deep(.el-table__body tr .argue) {
  color: #ef4444;
}

:deep(.el-table__body tr .argueComplete) {
  color: #22c55e;
}

:deep(.el-table__body tr .argueCancel) {
  color: #333333;
}

</style>
