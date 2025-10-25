<template>
  <div>
    <el-table
      :data="list"
      border
      fit
      highlight-current-row
      class="main-table"
      key="personTable"
      style="height: 500px; overflow: auto;"
    >
      <el-table-column label="订单号" align="center">
        <template v-slot="{ row }">
          <span>{{ row.id }}</span>
        </template>
      </el-table-column>
      <el-table-column label="商户" align="center">
        <template v-slot="{ row }">
          <span>{{ formatIdDisplay(row.sell_user_id) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单状态" align="center" min-width="90">
        <template v-slot="{ row }">
          <span>{{ row.author }}</span>
        </template>
      </el-table-column>
      <el-table-column label="金额" align="center">
        <template v-slot="{ row }">
          <span>{{ row.author }}</span>
        </template>
      </el-table-column>
    </el-table>

    <!-- 固定的底部行 -->
    <div class="sticky-bottom">
      <span class="tw-mr-4">总计：{{ totalAmount }} USDT</span>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive, watch, defineEmits, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import store from '@/store';
import * as OrderApi from '@/api/order'
import { formatIdDisplay } from '@/utils/tool'

const emit = defineEmits();

const props = defineProps({
  startTime: String,
  endTime: String,
});

const userStore = store.user()

// 定义数据
const list = ref([]);
const totalAmount = ref(0.00);

// 用于防止重复调用的标志位
let isFirstCall = true;

// 获取数据的逻辑
const getList = async () => {
  try {
    emit('table-update-start');
    
    const response = await OrderApi.getMyOrderReport(userStore.loginToken, {
      startTime: props.startTime,
      endTime: props.endTime,
    })
    if (response.data.code === 10000) {
      list.value = response.data.data.orders;
    }

    emit('table-update-end');
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

// 监听 startTime 变化，获取数据
watch(
  () => props.startTime,
  () => {
    getList();
  },
  { immediate: true } // immediate 保证在首次渲染时监听
);

// 监听 endTime 变化，获取数据
watch(
  () => props.endTime,
  () => {
    getList();
  },
  { immediate: true } // immediate 保证在首次渲染时监听
);

// 跳转到指定页面
const router = useRouter();

const handleRowClick = (row) => {
  const role = userStore.user?.value?.role
  if (role === 'buyer') {
    // 根据点击的行的数据，构造目标路由地址
    const targetPage = `/order/buyer/buy?tradeId=${row.id}`; // 假设根据 row.id 构造跳转路径
    router.push(targetPage); // 跳转到 /buy 页面，带上 tradeId 参数
  }
};
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

.sticky-bottom {
  position: sticky;
  bottom: 0;
  border: 1px solid black;
  z-index: 10;
  padding: 10px;
  color: black;
  text-align: right;
}
</style>
