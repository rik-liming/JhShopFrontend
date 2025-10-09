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
    >
        <el-table-column label="订单编号" width="'40%'" align="center">
            <template v-slot="{row}">
            <span :class="getStatusClass(row.status)">{{ formatOrderIdDisplay(row.id, row.created_at) }}</span>
            </template>
        </el-table-column>
        <el-table-column label="金额 USDT" width="'20%'" align="center">
            <template v-slot="{row}">
            <span :class="getStatusClass(row.status)">{{ row.amount }}</span>
            </template>
        </el-table-column>
        <el-table-column label="市场" width="'20%'" align="center">
            <template v-slot="{row}">
            <span :class="getStatusClass(row.status)">{{ formatPaymentMethod(row.payment_method) }}</span>
            </template>
        </el-table-column>
        <el-table-column label="状态" width="'20%'" align="center">
            <template v-slot="{row}">
            <span :class="getStatusClass(row.status)">{{ payStatusMap[row.status] }}</span>
            </template>
        </el-table-column>
    </el-table>
</template>

<script setup>
import { ref, onMounted, reactive, watch, defineEmits, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import store from '@/store';
import * as OrderApi from '@/api/order'
import { formatIdDisplay, formatOrderIdDisplay, formatPaymentMethod } from '@/utils/tool'

const payStatusMap = {
  0: '待付款',
  1: '待卖家确认',
  2: '已确认',
  3: '已完成',
  '-1': '超时未支付',
}

const emit = defineEmits();

const userStore = store.user()

const props = defineProps({
  channel: String,
  tableType: String,
});

// 定义数据
const list = ref([]);
const listQuery = reactive({
  page: 1,
  limit: 20,
  channel: props.channel,
  title: undefined,
  tableType: 'order',
  sort: '+id'
});

// 用于防止重复调用的标志位
let isFirstCall = true;

// 获取数据的逻辑
const getList = async () => {
  try {
    emit('table-update-start');
    
    let response = null
    if (userStore.user?.value?.role === 'buyer') {
      response = await OrderApi.getMyBuyerOrder(userStore.loginToken, {
        page: listQuery.page,
        pagesize: listQuery.limit,
        channel: listQuery.channel
      })
      if (response.data.code === 10000) {
        list.value = response.data.data.orders;
      }
    } else if (userStore.user?.value?.role === 'seller' 
    || userStore.user?.value?.role === 'agent' ) {
      response = await OrderApi.getMySellerOrder(userStore.loginToken, {
        page: listQuery.page,
        pagesize: listQuery.limit,
        channel: listQuery.channel
      })
      if (response.data.code === 10000) {
        list.value = response.data.data.orders;
      }
    }

    emit('table-update-end');
  } catch (error) {
    console.error('获取数据失败', error);
  }
};

// 监听 channel 变化，获取数据
watch(
  () => props.channel,
  (newChannel) => {
    // 只有在 channel 变化时，才更新数据
    listQuery.channel = newChannel;
    
    // 确保只有在 channel 改变时才调用 getList
    if (!isFirstCall && props.tableType === 'order') {
      getList();
    } else {
      isFirstCall = false; // 第一次加载后设置为 false
    }
  },
  { immediate: true } // immediate 保证在首次渲染时监听
);

watch(
  () => props.tableType,
  (newTableType) => {
    // 只有在 channel 变化时，才更新数据
    listQuery.tableType = newTableType;
    
    // 确保只有在 channel 改变时才调用 getList
    if (!isFirstCall && props.tableType === 'order') {
      getList();
    } else {
      isFirstCall = false; // 第一次加载后设置为 false
    }
  },
  { immediate: true } // immediate 保证在首次渲染时监听
);

// 生命周期钩子，组件加载时获取数据
onMounted(() => {
  nextTick(() => {
    // 确保 getList 在 DOM 更新后调用
    getList();
  });
});

// 跳转到指定页面
const router = useRouter();

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
