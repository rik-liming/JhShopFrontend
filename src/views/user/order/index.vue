<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-flex tw-justify-center">
    <div class="tw-w-[90%] tw-p-1 tw-text-center tw-flex tw-flex-col tw-justify-start tw-items-center">
      <!-- 顶部图标 -->
      <div class="tw-w-full tw-flex tw-items-center tw-justify-between tw-mt-14 tw-mb-2 tw-relative">
        <div class="tw-flex tw-items-center tw-w-full">
          <img src="@/assets/logo.png" alt="logo" class="tw-w-[104px] tw-h-[100px] tw-mx-auto" />
        </div>
        <div class="tw-absolute tw-left-0 tw-flex tw-flex-col tw-items-end">
          <!-- <hamburger 
            id="hamburger-container" 
            :is-active="appStore.sidebar.opened" 
            class="hamburger-container"
            :iconStyle="2"
            @toggleClick="toggleSidebar" 
          /> -->
        </div>
        <div class="tw-absolute tw-top-[-10px] tw-right-0 tw-flex tw-flex-col tw-items-end">
          <!-- <button class="tw-text-[#D9001B] tw-font-pingfang tw-text-[17px] tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-rounded-lg tw-px-2 tw-py-1 tw-mb-16" @click="handleClose">关闭</button> -->
          <img 
            src="@/assets/close_icon.png" 
            alt="close" 
            class="cursor-pointer tw-w-8 tw-h-8" 
            @click="handleClose"
          />
        </div>
      </div>

      <div class="tw-w-[96%] tw-text-[#333333] tw-mt-8">
        <div class="table-wrapper" :class="{ 'animate': animate }">
          <el-table
            :data="list"
            border
            fit
            highlight-current-row
            class="main-table"
            key="orderTable"
            style="height: 680px; overflow: auto;"
            @row-click="handleRowClick"
            @touchstart="onTouchStart"
            @touchmove="onTouchMove"
            @touchend="onTouchEnd"
          >
            <el-table-column label="订单编号" :width="getAdjustWidth(120)" align="center">
              <template v-slot="{row}">
                <!-- 统一用buy_transaction_id来定位 -->
              <span :class="getStatusClass(row?.status)">{{ row?.buy_transaction_id }}</span>
                <!-- <span v-else class="opacity-30">-</span> -->
              </template>
            </el-table-column>
            <el-table-column label="金额 USDT" :width="getAdjustWidth(86)" align="center">
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
        </div>
      </div>

      <!-- 底部版权 -->
      <p 
        class="tw-absolute tw-bottom-2 tw-text-xs tw-text-gray-400"
      >
        Copy@ JH嘉禾商城</p>
    </div>
  </div>
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
const appStore = store.app()

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
const touchStartY = ref(0) // 触摸开始位置
const touchMoveY = ref(0) // 触摸移动位置
const threshold = ref(200) // 下拉刷新阈值

const animate = ref(false)

// --- 表格数据 ---
const tableWrapper = ref(null)
let scrollTopCache = 0

// 用于防止重复调用的标志位
let isFirstCall = true;

// 获取数据的逻辑
const getList = async () => {
  try {
    // emit('table-update-start');
    handleTableUpdateStart()

    setTimeout(() => {
      // emit('table-update-end');  
      handleTableUpdateEnd()
    }, 100);
    
    let response = null
    if (userStore.user?.value?.role === 'buyer'
    || userStore.user?.value?.role === 'autoBuyer') {
      response = await OrderApi.getMyBuyerOrder(userStore.loginToken, {
        page: listQuery.page,
        page_size: listQuery.limit,
      })
      
    } else if (userStore.user?.value?.role === 'seller' 
    || userStore.user?.value?.role === 'agent' ) {
      response = await OrderApi.getMySellerOrder(userStore.loginToken, {
        page: listQuery.page,
        page_size: listQuery.limit,
      })
    }

    if (response.data.code === 10000) {
      const orders = response.data.data.orders;

      // 判断是否少于 15 条数据
      if (orders.length < minTableRowCount.value) {
        // 填充空数据到 15 条
        list.value = [
          ...orders, // 将接口返回的数据放在前面
          ...Array.from({ length: minTableRowCount.value - orders.length }, () => ({ fakeId: Math.random() })) // 生成唯一的 fakeId
        ];
      } else {
        list.value = orders
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
    // 只有在 channel 变化时，才更新数据
    listQuery.tableType = newTableType;

    if (!isFirstCall 
      && props.currentShowTable === 'my'
      && props.tableType === 'order'
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

// 跳转到指定页面
const router = useRouter();

const handleRowClick = (row) => {
  const role = userStore.user?.value?.role
  let targetPage = ''
  if (role === 'buyer' || role === 'autoBuyer') {
    // 根据点击的行的数据，构造目标路由地址
    targetPage = `/order/buyer/detail?orderId=${row.id}`; // 假设根据 row.id 构造跳转路径
    router.push(targetPage); // 跳转到 /buy 页面，带上 tradeId 参数
  } else if (role === 'seller' || role === 'agent') {
    targetPage = `/order/seller/detail?orderId=${row.id}`; // 假设根据 row.id 构造跳转路径
    router.push(targetPage); // 跳转到 /buy 页面，带上 tradeId 参数
  }
};

const getStatusClass = (status) => {
  if (status !== null && status !== undefined) {
    switch (status) {
      case 0:
        return 'waitBuyerPay';
      case 1:
        return 'buyerConfirm';
      case 2:
        return 'sellerConfirm';
      case 3:
        return 'expired';
      case 4:
        return 'argue';
      case 5:
        return 'argueComplete';
      case 6:
        return 'argueCancel';
      default:
        return '';
    }
  }
  return '';
}

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

const toggleSidebar = () => {
  appStore.toggleSidebar();
}

const handleClose = () => {
  router.push('/');
};

function handleTableUpdateStart() {
  if (tableWrapper.value) {
    scrollTopCache = tableWrapper.value.scrollTop
  }
  animate.value = false;
}

async function handleTableUpdateEnd() {
  nextTick(() => {
    if (tableWrapper.value) {
      tableWrapper.value.scrollTop = scrollTopCache
    }
  })

  // 增加一定延时，以便播放动画效果
  await new Promise(resolve => setTimeout(resolve, 300));
  animate.value = true;
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

.table-wrapper {
  position: relative;
  left: -100%; /* 初始位置在屏幕外 */
  transform: translateY(-50%); /* 垂直居中 */
  color: white;
  transition: left 1s ease-out;
  // transition: left 1s cubic-bezier(0.1, 0, 0.5, 1); /* 自定义贝塞尔曲线 */
  visibility: hidden;
}

.table-wrapper.animate {
  left: 50%; /* 结束时 div 移动到屏幕中央 */
  // transform: translateX(-50%) translateY(-50%); /* 确保居中 */
  transform: translateX(-50%); /* 确保居中 */
  visibility: visible;
}

</style>
