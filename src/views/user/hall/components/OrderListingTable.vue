<template>
    <el-table
        :data="list"
        border
        fit
        highlight-current-row
        class="main-table"
        key="orderListingTable"
        style="height: 600px; overflow: auto;"
        @touchstart="onTouchStart"
        @touchmove="onTouchMove"
        @touchend="onTouchEnd"
    >
        <el-table-column label="商户" width="'30%'" align="center">
          <template v-slot="{ row }">
            <span v-if="row.user_id">{{ formatIdDisplay(row.user_id) }}</span>
            <span v-else class="opacity-30">-</span>
          </template>
        </el-table-column>
        <el-table-column label="售卖数量 (USTD)" width="'40%'" align="center">
          <template v-slot="{ row }">
            <span v-if="row.remain_amount">{{ row.remain_amount }}</span>
            <span v-else class="opacity-30">-</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="'30%'" align="center">
          <template v-slot="{ row }">
            <div v-if="row.user_id">
              <button 
                type="button"
                class="tw-w-full !tw-text-[#D82D15] tw-font-medium tw-font-pingfang"
                @click="handleCancel(row.id)"
              >
                撤销
              </button>
            </div>
            <div v-else><span class="opacity-30">-</span></div>
          </template>
        </el-table-column>
    </el-table>
</template>

<script setup>
import { ref, onMounted, reactive, watch, defineEmits, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import store from '@/store';
import * as OrderListingApi from '@/api/order_listing'
import { getAdjustWidth, formatIdDisplay } from '@/utils/tool'

const emit = defineEmits();

const userStore = store.user()
const appStore = store.app()

const props = defineProps({
  currentShowTable: String,
  tableType: String,
});

// 定义数据
const list = ref([]);
const listQuery = reactive({
  page: 1,
  limit: 100,
  tableType: props.tableType,
});

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

    setTimeout(() => {
      emit('table-update-end');
    }, 100);
    
    const response = await OrderListingApi.getMyOrderListing(userStore.loginToken)
    if (response.data.code === 10000) {
      const orderListings = response.data.data.orderListings;

      // 判断是否少于 15 条数据
      if (orderListings.length < minTableRowCount.value) {
        // 填充空数据到 15 条
        list.value = [
          ...orderListings, // 将接口返回的数据放在前面
          // ...Array(minTableRowCount.value - records.length).fill({}) // 填充空数据
          ...Array.from({ length: minTableRowCount.value - orderListings.length }, () => ({ fakeId: Math.random() })) // 生成唯一的 fakeId
        ];
      } else {
        list.value = Array.from({ length: minTableRowCount.value }, () => ({ fakeId: Math.random() })) // 生成唯一的 fakeId
      }
    }
  } catch (error) {
    console.error('获取数据失败', error);
    list.value = Array.from({ length: minTableRowCount.value }, () => ({ fakeId: Math.random() })) // 生成唯一的 fakeId
  }
};

watch(
  () => props.tableType,
  (newTableType) => {
    // 只有在 tableType 变化时，才更新数据
    listQuery.tableType = newTableType;
    
    // 确保只有在 tableType 改变时才调用 getList
    if (!isFirstCall 
      && props.currentShowTable === 'my'
      && props.tableType === 'orderListing'
    ) {
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

const handleCancel = async(orderListingId) => {
  const response = await OrderListingApi.cancelOrderListing(userStore.loginToken, orderListingId)
  if (response.data.code === 10000) {
    ElMessage.success('撤销挂单成功');
    setTimeout(() => {
      getList()
    }, 1000);
  } else {
    ElMessage.error(response.data.msg);
  }
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
</style>
