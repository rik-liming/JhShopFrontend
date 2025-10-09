<template>
  <el-table
    :data="list"
    border
    fit
    highlight-current-row
    class="main-table"
    key="marketTable"
    style="height: 600px; overflow: auto;"
    @row-click="handleRowClick"
  >
    <el-table-column label="商户" width="'30%'" align="center">
      <template v-slot="{ row }">
        <span>{{ formatIdDisplay(row.user_id) }}</span>
      </template>
    </el-table-column>
    <el-table-column label="售卖数量" width="'40%'" align="center">
      <template v-slot="{ row }">
        <span>{{ row.remain_amount }}</span>
      </template>
    </el-table-column>
    <el-table-column label="等值人民币" width="'30%'" align="center">
      <template v-slot="{ row }">
        <span>{{ getExchangeCNY(row.amount) }}</span>
      </template>
    </el-table-column>
  </el-table>
</template>

<script setup>
import { ref, onMounted, reactive, watch, defineEmits, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import store from '@/store';
import * as OrderApi from '@/api/order'
import { formatIdDisplay } from '@/utils/tool'
import Decimal from 'decimal.js'

const emit = defineEmits();

const props = defineProps({
  channel: String,
  tableType: String,
});

const userStore = store.user()
const configStore = store.config()

// 定义数据
const list = ref([]);
const listQuery = reactive({
  page: 1,
  limit: 100,
  channel: props.channel,
  tableType: props.tableType,
});

// 用于防止重复调用的标志位
let isFirstCall = true;

// 获取数据的逻辑
const getList = async () => {
  try {
    emit('table-update-start');
    
    const response = await OrderApi.getOrderListingByPage(userStore.loginToken, {
      page: listQuery.page,
      pagesize: listQuery.limit,
      channel: listQuery.channel
    })
    if (response.data.code === 10000) {
      list.value = response.data.data.orderListings;
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
    if (!isFirstCall && props.tableType === 'market') {
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
    if (!isFirstCall && props.tableType === 'market') {
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
  if (role === 'buyer') {
    // 根据点击的行的数据，构造目标路由地址
    const targetPage = `/order/buyer/buy?orderListingId=${row.id}`; // 假设根据 row.id 构造跳转路径
    router.push(targetPage); // 跳转到 /buy 页面，带上 tradeId 参数
  }
};

function getExchangeRate() {
  const configStore = store.config();
  console.log(configStore)
  if (!configStore || !configStore.config) {
    return 0.00;
  }
  let exchangeRate = 0.00;
  switch (listQuery.channel) {
    case 'alipay':
      exchangeRate = configStore.config.value.exchange_rate_alipay;
      break;
    case 'wechat':
      exchangeRate = configStore.config.value.exchange_rate_wechat;
      break;
    case 'bank':
      exchangeRate = configStore.config.value.exchange_rate_bank;
      break;
  }
  return exchangeRate;
}

const getExchangeCNY = (amount) => {
  const num1 = new Decimal(amount);  // 第一个数
  const num2 = new Decimal(getExchangeRate());    // 第二个数

  // 相乘并保留 2 位小数
  const result = num1.mul(num2).toFixed(2, Decimal.ROUND_UP);
  return result
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
</style>
