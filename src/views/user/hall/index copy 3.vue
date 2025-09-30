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

    <div class="transaction-container">
      <div class="transaction-menu">
        <div class="left-menu" @click="onDeposit">
          <img src="@/assets/buy_icon.svg" class="buy-icon">
          <span>充值</span>
        </div>

        <div class="right-menu">
          <div class="avatar-container right-menu-item hover-effect" @click="onTradePublish">
            <div class="avatar-wrapper">
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
        <el-select v-model="listQuery.sort" style="width: 140px" class="filter-item" @change="handleFilter">
          <el-option v-for="item in sortOptions" :key="item.key" :label="item.label" :value="item.key" />
        </el-select>
      </div>

      <!-- 包裹表格的容器 -->
      <div class="table-wrapper">
        <!-- 使用 transition 来滑动表格 -->
        <transition name="slide-fade" mode="out-in">
          <el-table
            v-loading="listLoading"
            :data="list"
            border
            fit
            highlight-current-row
            style="width: 100%;"
            @sort-change="sortChange"
            :key="tableKey"
          >
            <el-table-column label="ID" prop="id" sortable="custom" align="center" width="80" :class-name="getSortClass('id')">
              <template v-slot="{row}">
                <span>{{ row.id }}</span>
              </template>
            </el-table-column>
            <el-table-column label="Date" width="150px" align="center">
              <template v-slot="{row}">
                <span>{{ parseTime(row.timestamp, '{y}-{m}-{d} {h}:{i}') }}</span>
              </template>
            </el-table-column>
            <el-table-column label="Author" width="110px" align="center">
              <template v-slot="{row}">
                <span>{{ row.author }}</span>
              </template>
            </el-table-column>
            <el-table-column label="Imp" width="80px">
              <template v-slot="{row}">
                <svg-icon v-for="n in row.importance" :key="n" icon-class="star" class="meta-item__icon" />
              </template>
            </el-table-column>
            <el-table-column label="Status" class-name="status-col" width="100">
              <template v-slot="{row}">
                <el-tag :type="statusFilter(row.status)">
                  {{ row.status }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </transition>
      </div>

      <!-- 分页功能修改 -->
      <pagination v-show="total > 0" :total="total" v-model:page="listQuery.page" v-model:limit="listQuery.limit" @pagination="getList" />
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, markRaw, watch } from 'vue'
import { Vue3Marquee } from 'vue3-marquee'
import { toast } from 'vue3-toastify'
import Pagination from '@/components/Pagination'
import waves from '@/directive/waves'
import { fetchList } from '@/api/article'
import { parseTime } from '@/utils'
import Navbar from './navbar.vue';
import store from '@/store';
import { useRouter } from 'vue-router';

// --- 广告轮播图片 ---
const ad_imgs = [
  new URL('@/assets/scroll_ad_1.png', import.meta.url).href,
  new URL('@/assets/scroll_ad_2.png', import.meta.url).href,
  new URL('@/assets/scroll_ad_3.png', import.meta.url).href
]

// --- 表格数据 ---

const tableKey = ref(0)
const channelOptions = ref(
  [
    {
      'label': '支付宝',
      'value': 'alipay'
    },
    {
      'label': '银行卡',
      'value': 'bank'
    },
    {
      'label': '微信',
      'value': 'wechat'
    },
  ]
)
const tableTypeOptions = ref(
  [
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
const sortOptions = ref(
  [{ label: 'ID Ascending', key: '+id' }, { label: 'ID Descending', key: '-id' }]
)
const list = ref([])
const total = ref(0)
const listLoading = ref(true)
const listQuery = reactive({
  page: 1,
  limit: 20,
  channel: 'alipay',
  title: undefined,
  tableType: 'order',
  sort: '+id'
})

const router = useRouter();

// --- 生命周期 ---
onMounted(() => {
  getList()
})

watch(() => listQuery.page, () => {
  getList()
})

// --- 方法 ---
function getList() {
  listLoading.value = true
  fetchList(listQuery).then(response => {
    list.value = response.data.items
    total.value = response.data.total
    setTimeout(() => {
      listLoading.value = false
    }, 1500)
  })
}

function handleFilter() {
  listQuery.page = 1
  getList()
}

function sortChange({ prop, order }) {
  if (prop === 'id') {
    sortByID(order)
  }
}

function sortByID(order) {
  listQuery.sort = order === 'ascending' ? '+id' : '-id'
  handleFilter()
}

function statusFilter(status) {
  const statusMap = { published: 'success', draft: 'info', deleted: 'danger' }
  return statusMap[status]
}

function getSortClass(key) {
  const sort = this.listQuery.sort;
  return sort === `+${key}` ? 'ascending' : 'descending';
}

function onScroll(event) {
  const bottom = event.target.scrollHeight === event.target.scrollTop + event.target.clientHeight
  if (bottom && list.length < total.value) {
    listQuery.page += 1
    getList()
  }
}

function onTradePublish() {
  router.push('/trade')
};

function onDeposit() {
  router.push('/deposit')
};

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

/* Transition for table sliding effect */
.table-wrapper {
  position: relative;
}

.slide-fade-enter-active, .slide-fade-leave-active {
  transition: transform 0.5s ease;
}
.slide-fade-enter, .slide-fade-leave-to /* .slide-fade-leave-active in <2.1.8 */ {
  transform: translateX(100%);
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

      .avatar-container {
        margin-right: 10px;

        .avatar-wrapper {
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

          .el-icon-caret-bottom {
            cursor: pointer;
            position: absolute;
            right: -20px;
            top: 25px;
            font-size: 12px;
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

// .publish-btn:hover {
//   color: #409EFF; /* Element Plus 默认主题蓝色 */
// }

.sale-icon {
  width: 40px;
  height: 40px;
}

</style>