<template>
  <div>
    <div class="navbar-container">
      <navbar />
    </div>
    <div class="promotion-container">
      <div class="carousel-wrapper" v-if="store.app().device !== 'mobile'">
        <VCarousel height="200" show-arrows="hover" cycle hide-delimiter-background :interval="2000">
          <VCarouselItem v-for="(item, index) in ad_imgs" :key="index">
            <img :src="item" style="width: 100%; height: 100%; object-fit: cover;" />
          </VCarouselItem>
        </VCarousel>
      </div>

      <div class="marquee-container">
        <Vue3Marquee :duration="10">
          <span class="marquee-text">
            欢迎来到财富的世界！By嘉禾商城
          </span>
        </Vue3Marquee>
      </div>
    </div>

    <div class="transaction-container" v-if="store.user().user?.value?.role === 'agent' || store.user().user?.value?.role === 'seller'">
      <div class="transaction-menu">
        <div class="left-menu" @click="onDeposit">
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

    <div class="app-container" @scroll="onScroll">
      <div class="filter-container">
        <el-select v-model="listQuery.channel" clearable style="width: 90px" class="filter-item">
          <el-option v-for="item in channelOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
        <el-select v-model="listQuery.tableType" clearable class="filter-item" style="width: 130px">
          <el-option v-for="item in tableTypeOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
        <!-- <el-select v-model="listQuery.sort" style="width: 140px" class="filter-item">
          <el-option v-for="item in sortOptions" :key="item.key" :label="item.label" :value="item.key" />
        </el-select> -->
      </div>

      <!-- 包裹表格的容器 -->
      <div class="table-wrapper" :class="{ 'animate': animate }">
          <market-table
            :channel="listQuery.channel"
            :tableType="listQuery.tableType"
            @table-update-start="handleTableUpdateStart"
            @table-update-end="handleTableUpdateEnd"
            v-show="listQuery.tableType == 'market'"
          ></market-table>
          <order-table
            :channel="listQuery.channel"
            :tableType="listQuery.tableType"
            @table-update-start="handleTableUpdateStart"
            @table-update-end="handleTableUpdateEnd"
            v-show="listQuery.tableType == 'order'"
          ></order-table>
          <finance-table
            :channel="listQuery.channel"
            :tableType="listQuery.tableType"
            @table-update-start="handleTableUpdateStart"
            @table-update-end="handleTableUpdateEnd"
            v-show="listQuery.tableType == 'finance'"
          ></finance-table>
      </div>

      <!-- 分页功能修改 -->
      <!-- <pagination v-show="total > 0" :total="total" v-model:page="listQuery.page" v-model:limit="listQuery.limit" @pagination="getList" /> -->
    </div>

    <el-dialog v-model:visible="isNotificationDialogVisible" title="Notification">
      <div>sdfsf</div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, markRaw, watch, computed, nextTick } from 'vue'
import { Vue3Marquee } from 'vue3-marquee'
import { toast } from 'vue3-toastify'
import Pagination from '@/components/Pagination'
import waves from '@/directive/waves'
import { fetchList } from '@/api/article'
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

// --- 表格数据 ---
const tableWrapper = ref(null)
let scrollTopCache = 0

const tableKey = ref(0)
const channelOptions = ref(
  [
    {
      'label': '支付宝',
      'value': 'ali_pay'
    },
    {
      'label': '银行卡',
      'value': 'bank_pay'
    },
    {
      'label': '微信',
      'value': 'wechat_pay'
    },
  ]
)
const tableTypeOptions = ref(
  [
    {
      'label': '市场',
      'value': 'market'
    },
    {
      'label': '订单',
      'value': 'order'
    },
    {
      'label': '财务变动',
      'value': 'finance'
    },
  ]
)

const listQuery = reactive({
  channel: 'ali_pay',
  tableType: 'market',
})

const isNotificationDialogVisible = ref(true)

const router = useRouter();

const animate = ref(false)

function onOrderPublish() {
  router.push('/order/seller/publish')
};

function onDeposit() {
  router.push('/deposit')
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

watch(() => listQuery.tableType, async () => {
  animate.value = false
  await nextTick()
  setTimeout(() => {
    animate.value = true
  }, 300)
})

onMounted(() => {
  globalThis.addEventListener('show-notification-dialog', () => {
    isNotificationDialogVisible.value = true
  });
});

</script>

<style scoped lang="scss">

.navbar-container {
  margin-top: 30px;
}

.carousel-wrapper {
  margin: 10px !important;
}

.marquee-container {
  margin: 4px 20px;
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
  margin-top: 10px;

  .transaction-menu {
    width: 90%;
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
      font-size: 18px;
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
        font-size: 18px;
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

.fixed-header {
  position: fixed;
  top: 0;
  right: 0;
  z-index: 9;
  width: calc(100% - var(--side-bar-width));
  transition: width 0.28s;
}

.hideSidebar .fixed-header {
  width: calc(100% - 54px)
}

.mobile .fixed-header {
  width: 100%;
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

</style>