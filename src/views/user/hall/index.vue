<template>
  <div>
    <div class="navbar-container">
      <navbar />
    </div>
    <div class="promotion-container">
      <div class="carousel-wrapper">
        <VCarousel
          :height="store.app().device === 'mobile' ? '100' : '200'"
          show-arrows="hover" 
          cycle 
          hide-delimiter-background 
          :interval="3000"
        >
          <VCarouselItem v-for="(item, index) in ad_imgs" :key="index">
            <img :src="item" style="width: 100%; height: 100%; object-fit: cover;" />
          </VCarouselItem>
        </VCarousel>
      </div>

      <div class="marquee-container">
        <Vue3Marquee :duration="10">
          <span class="marquee-text">
            <!-- 欢迎来到财富的世界！By嘉禾商城 -->
            {{ configStore?.config?.value?.advertisement_text }}
          </span>
        </Vue3Marquee>
      </div>
    </div>

    <div class="transaction-container" v-if="userStore.user?.value?.role === 'agent' || userStore?.user?.value?.role === 'seller'">
      <div class="transaction-menu">
        <div class="left-menu" @click="onRecharge">
          <img src="@/assets/buy_icon.svg" class="buy-icon">
          <span>充值</span>
        </div>

        <div class="right-menu">
          <div class="publish-container right-menu-item hover-effect" @click="onOrderPublish">
            <div class="publish-wrapper">
              <img src="@/assets/sale_icon.png" class="sale-icon">
              <span>发布交易</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="tw-mt-2 tw-mx-8" @scroll="onScroll">
      <div class="filter-container tw-flex tw-flex-items-center justify-center tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-px-4 tw-pt-4 tw-mb-4">
        <div class="tw-w-1/3">
          <el-select 
            v-model="listQuery.marketTableType"
            class="filter-item"
            :class="{ 'selected-table': listQuery.currentShowTable == 'market' }"
            @change="updateCurrentShowTable('market')"
          >
            <el-option 
              v-for="item in marketTableTypeOptions" 
              :key="item.value" 
              :label="item.label" 
              :value="item.value"
              :class="{
                'selected-item': listQuery.marketTableType === item.value
              }" 
            />
          </el-select>
        </div>
        <div class="tw-w-1/3">
          <el-select 
            v-model="listQuery.myTableType"
            class="filter-item"
            :class="{ 'selected-table': listQuery.currentShowTable == 'my' }"
            @change="updateCurrentShowTable('my')"
          >
            <el-option 
              v-for="item in myTableTypeOptions" 
              :key="item.value" 
              :label="item.label" 
              :value="item.value"
              :class="{
                'selected-item': listQuery.myTableType === item.value
              }" 
            />
          </el-select>
        </div>
        <div class="tw-flex tw-flex-col tw-w-1/3">
          <div class="tw-flex tw-justify-between ">
            <p class="tw-text-sm tw-text-left tw-font-bold">市场汇率：</p>
            <p class="tw-text-sm tw-text-right">{{ getExchangeRate() }}</p>
          </div>
          <div class="tw-flex tw-justify-between ">
            <p class="tw-text-sm tw-text-left tw-font-bold tw-ml-4">刷新：</p>
            <p class="tw-text-sm tw-text-right tw-text-red-400">{{ countdown }}s</p>
          </div>
        </div>
        <!-- <el-select v-model="listQuery.sort" style="width: 140px" class="filter-item">
          <el-option v-for="item in sortOptions" :key="item.key" :label="item.label" :value="item.key" />
        </el-select> -->
      </div>

      <!-- 包裹表格的容器 -->
      <div class="table-wrapper" :class="{ 'animate': animate }">
          <market-table
            :currentShowTable="listQuery.currentShowTable"
            :tableType="listQuery.marketTableType"
            @table-update-start="handleTableUpdateStart"
            @table-update-end="handleTableUpdateEnd"
            v-show="listQuery.currentShowTable == 'market'"
          ></market-table>
          <order-table
            :currentShowTable="listQuery.currentShowTable"
            :tableType="listQuery.myTableType"
            @table-update-start="handleTableUpdateStart"
            @table-update-end="handleTableUpdateEnd"
            v-show="listQuery.myTableType == 'order' && listQuery.currentShowTable == 'my'"
          ></order-table>
          <finance-table
            :currentShowTable="listQuery.currentShowTable"
            :tableType="listQuery.myTableType"
            @table-update-start="handleTableUpdateStart"
            @table-update-end="handleTableUpdateEnd"
            v-show="listQuery.myTableType == 'finance' && listQuery.currentShowTable == 'my'"
          ></finance-table>
      </div>
    </div>

    <!-- Footer -->
    <div class="footer">Copy@ JH嘉禾商城</div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, markRaw, watch, computed, nextTick, onBeforeUnmount } from 'vue'
import { Vue3Marquee } from 'vue3-marquee'
import { toast } from 'vue3-toastify'
import waves from '@/directive/waves'
import { parseTime } from '@/utils'
import Navbar from './navbar.vue';
import store from '@/store';
import { useRouter } from 'vue-router';
import MarketTable from './components/MarketTable.vue'
import OrderTable from './components/OrderTable.vue'
import FinanceTable from './components/FinanceTable.vue'

// --- 广告轮播图片 ---
const ad_imgs = [
  new URL('@/assets/scroll_ad_1.png', import.meta.url).href,
  new URL('@/assets/scroll_ad_2.png', import.meta.url).href,
  new URL('@/assets/scroll_ad_3.png', import.meta.url).href
]

const userStore = store.user()
const configStore = store.config()

// --- 表格数据 ---
const tableWrapper = ref(null)
let scrollTopCache = 0

const tableKey = ref(0)
const marketTableTypeOptions = [
  { label: '支付宝', value: 'alipay' },
  { label: '银行卡', value: 'bank' },
  { label: '微信', value: 'wechat' },
]

const myTableTypeOptions = [
  { label: '订单', value: 'order' },
  { label: '财务变动', value: 'finance' },
]

const listQuery = reactive({
  currentShowTable: 'market',  // market/my
  myTableType: '我的',        // default/order/finance
  marketTableType: 'alipay',   // alipay/wechat/bank
})

const router = useRouter();

const animate = ref(false)

function onOrderPublish() {
  router.push('/order/seller/publish')
};

function onRecharge() {
  router.push('/recharge')
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

function getExchangeRate() {
  if (!configStore || !configStore.config) {
    return '-';
  }
  let exchangeRate = 0.00;
  switch (listQuery.marketTableType) {
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
  if (exchangeRate == 0) {
    return '-'
  }
  return String(exchangeRate);
}

let countdown = ref(10)
let timer = null

// 启动倒计时
const startCountdown = () => {
  if (timer) {
    clearInterval(timer)
  }
  countdown.value = 10
  timer = setInterval(() => {
    if (countdown.value > 0) {
      countdown.value -= 1
    } else {
      // 倒计时到0时重新开始
      countdown.value = 10
    }
  }, 1000)
}

// 页面加载时开始倒计时
onMounted(() => {
  startCountdown()
})

// 页面卸载前清理定时器
onBeforeUnmount(() => {
  if (timer) {
    clearInterval(timer)
  }
})

const updateCurrentShowTable = (currentShowTable) => {
  listQuery.currentShowTable = currentShowTable

  if (currentShowTable == 'market') {
    listQuery.myTableType = "我的"
  } else if (currentShowTable == 'my') {
    listQuery.marketTableType = "市场"
  }
}

</script>

<style scoped lang="scss">

.navbar-container {
  margin-top: 40px;
}

.carousel-wrapper {
  margin: 10px !important;
}

.marquee-container {
  margin: 4px 20px 0px 20px;
}

.marquee-text {
  color: red;
  font-size: 18px;
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

.transaction-container {
  display: flex;
  justify-content: center;
  // margin-top: -10px;
  margin-bottom: -10px;

  .transaction-menu {
    width: 84%;
    height: 70px;
    overflow: hidden;
    position: relative;
    // box-shadow: 0 1px 4px rgba(0, 21, 41, .08);

    .left-menu {
      line-height: 50px;
      padding: 10px;
      height: 100%;
      float: left;
      cursor: pointer;
      transition: background .3s;
      -webkit-tap-highlight-color: transparent;
      font-size: 16px;
      font-family: 'STSongti-SC-Bold', 'Songti SC Bold', 'Songti SC';
      color: #d9001b;
      font-weight: bold;
      display: flex;
      align-items: center;
      gap: 8px;

      &:hover {
        background: rgba(0, 0, 0, .025)
      }

      .buy-icon {
        cursor: pointer;
        width: 23px;
        height: 32px;
        // border-radius: 10px;
      }
    }

    .right-menu {
      float: right;
      height: 100%;
      line-height: 50px;

      &:focus {
        outline: none;
      }

      .right-menu-item {
        display: inline-block;
        height: 100%;
        line-height: 50px;
        font-size: 16px;
        font-family: 'STSongti-SC-Bold', 'Songti SC Bold', 'Songti SC';
        color: #d9001b;
        font-weight: bold;
        vertical-align: text-bottom;

        &.hover-effect {
          cursor: pointer;
          transition: background .3s;

          &:hover {
            background: rgba(0, 0, 0, .025)
          }
        }
      }

      .publish-container {
        margin-right: 10px;

        .publish-wrapper {
          margin-top: 5px;
          position: relative;
          height: 60px;
          display: flex;
          align-items: center;
          gap: 8px;

          .sale-icon {
            cursor: pointer;
            width: 31px;
            height: 28px;
            // border-radius: 10px;
          }
        }
      }
    }
  }
}

.publish-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: #333;
  cursor: pointer;
}

.sale-icon {
  width: 40px;
  height: 40px;
}

:deep(.el-select__wrapper) {
  background-color: transparent !important;
  box-shadow: none !important;
  font-weight: bold !important;
  // font-size: 28px !important;
  // color: red !important;
}

:deep(.el-select__placeholder) {
  color: black !important;
  font-size: 18px !important;
  margin: 4px 0px !important;
  font-family: 'Arial Negreta', 'Arial Normal', 'Arial' !important;
}

:deep(.el-select__caret) {
  color: black !important;
}

.filter-item.selected-table {
  // background-color: rgba(0, 0, 0, 0.1);
  // border-radius: 4px; /* 如果想要圆角效果 */
  // transform: scale(1.05); /* 放大 5% */
  // box-shadow: 0 0 10px rgba(0, 0, 0, 0.2); /* 添加阴影效果 */
  // transition: transform 0.3s ease, box-shadow 0.3s ease; /* 添加平滑过渡效果 */
  // color: black !important;
}

:deep(.filter-item.selected-table .el-select__placeholder) {
  color: blue !important;
  font-size: 20px !important;
}

.footer {
  font-size: 11px;
  text-align: center;
  font-family: Arial Normal, Arial;
  color: #333333;
  opacity: 0.57;
  margin: 50px 0 10px 0;
}

.selected-item {
  background-color: #19a5f1;
  color: white;
}

</style>