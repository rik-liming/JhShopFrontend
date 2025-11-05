<template>
  <div>
    <el-table
        :data="list"
        border
        fit
        highlight-current-row
        class="main-table"
        key="groupTable"
        style="height: 500px; overflow: auto;"
        @touchstart="onTouchStart"
        @touchmove="onTouchMove"
        @touchend="onTouchEnd"
    >
        <el-table-column label="订单编号" :width="getAdjustWidth(120)" align="center">
          <template v-slot="{row}">
            <span v-if="row.sell_transaction_id">{{ row.sell_transaction_id }}</span>
            <span v-else class="opacity-30">-</span>
          </template>
        </el-table-column>
        <el-table-column label="队员" :width="getAdjustWidth(70)" align="center">
          <template v-slot="{row}">
            <span v-if="row.sell_user_id">{{ formatIdDisplay(row.sell_user_id) }}</span>
            <span v-else class="opacity-30">-</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" :width="getAdjustWidth(60)" align="center">
          <template v-slot="{row}">
            <span v-if="row.status">{{ `成功` }}</span>
            <span v-else class="opacity-30">-</span>
          </template>
        </el-table-column>
        <el-table-column label="金额 (USTD)" :width="getAdjustWidth(90)" align="center">
          <template v-slot="{row}">
            <span v-if="row.total_price">{{ row.total_price }}</span>
            <span v-else class="opacity-30">-</span>
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
import { formatIdDisplay, getAdjustWidth } from '@/utils/tool'

const emit = defineEmits();

const props = defineProps({
  startTime: String,
  endTime: String,
  tableType: String,
});

const userStore = store.user()

// 定义数据
const list = ref([]);
const totalAmount = ref(0.00);

const minTableRowCount = ref(15)
const isRefreshing = ref(false)
const touchStartY = ref(0) // 触摸开始位置
const touchMoveY = ref(0) // 触摸移动位置
const threshold = ref(200) // 下拉刷新阈值

// 用于防止重复调用的标志位
let isFirstCall = true;

// 获取数据的逻辑
const getList = async () => {
  try {
    emit('table-update-start');
    
    const response = await OrderApi.getGroupOrderReport(userStore.loginToken, {
      startTime: props.startTime,
      endTime: props.endTime,
    })

    if (response.data.code === 10000) {
      const orders = response.data.data.orders;
      totalAmount.value = response.data.data.totalAmount

      // 判断是否少于 15 条数据
      if (orders.length < minTableRowCount.value) {
        // 填充空数据到 15 条
        list.value = [
          ...orders, // 将接口返回的数据放在前面
          // ...Array(minTableRowCount.value - orders.length).fill({}) // 填充空数据
          ...Array.from({ length: minTableRowCount.value - orders.length }, () => ({ fakeId: Math.random() })) // 生成唯一的 fakeId
        ];
      } else {
        list.value = orders
      }
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
    isFirstCall = false;
  });
});

// 监听 startTime 变化，获取数据
watch(
  () => props.startTime,
  () => {
    if (!isFirstCall && props.tableType == 'group') {
      getList();
    }
  },
  { immediate: true } // immediate 保证在首次渲染时监听
);

// 监听 endTime 变化，获取数据
watch(
  () => props.endTime,
  () => {
    if (!isFirstCall && props.tableType == 'group') {
      getList();
    }
  },
  { immediate: true } // immediate 保证在首次渲染时监听
);

// 监听 tableType 变化，获取数据
watch(
  () => props.tableType,
  () => {
    if (!isFirstCall && props.tableType == 'group') {
      getList();
    }
  },
  { immediate: true } // immediate 保证在首次渲染时监听
);

// 跳转到指定页面
const router = useRouter();

const onTouchStart = (event) => {
  // 记录触摸开始的位置
  touchStartY.value = event.changedTouches[0].clientY;
}

const onTouchMove = (event) => {
  // 获取触摸移动的 Y 轴位置
  touchMoveY.value = event.changedTouches[0].clientY;

  // 如果下拉距离超过阈值，显示刷新提示
  if (touchMoveY.value - touchStartY.value > threshold.value) {
    isRefreshing.value = true;
  }
}

const onTouchEnd = () => {
  // 判断是否触发刷新
  if (touchMoveY.value - touchStartY.value > threshold.value) {
    triggerRefresh();
  } else {
    isRefreshing.value = false;
  }
}

// 触发刷新
const triggerRefresh = () => {
  isRefreshing.value = true; // 显示刷新状态
  getList()
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

.sticky-bottom {
  position: sticky;
  bottom: 0;
  z-index: 10;
  padding: 10px;
  text-align: right;

  border: 1px solid rgba(127,127,127,0.4) !important;
  font-size: 13px;
  font-weight: normal;
  color: #333333;
  font-family: 'Arial Normal', 'Arial';
}
</style>
