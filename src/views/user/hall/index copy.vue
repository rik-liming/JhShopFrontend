<template>
  <div>
    <div class="navbar-container">
      <navbar />
      <!-- <tags-view v-if="needTagsView" /> -->
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

    <div class="app-container">
      <div class="filter-container">
        <el-select v-model="listQuery.importance" placeholder="Imp" clearable style="width: 90px" class="filter-item">
          <el-option v-for="item in importanceOptions" :key="item" :label="item" :value="item" />
        </el-select>
        <el-select v-model="listQuery.type" placeholder="Type" clearable class="filter-item" style="width: 130px">
          <el-option v-for="item in calendarTypeOptions" :key="item.key" :label="item.display_name+'('+item.key+')'" :value="item.key" />
        </el-select>
        <el-select v-model="listQuery.sort" style="width: 140px" class="filter-item" @change="handleFilter">
          <el-option v-for="item in sortOptions" :key="item.key" :label="item.label" :value="item.key" />
        </el-select>
        <el-checkbox v-model="showReviewer" class="filter-item" style="margin-left:15px;" @change="tableKey=tableKey+1">
          reviewer
        </el-checkbox>
      </div>

      <el-table
        :key="tableKey"
        v-loading="listLoading"
        :data="list"
        border
        fit
        highlight-current-row
        style="width: 100%;"
        @sort-change="sortChange"
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
        <el-table-column label="Title" min-width="150px">
          <template v-slot="{row}">
            <span class="link-type" @click="handleUpdate(row)">{{ row.title }}</span>
            <el-tag>{{ typeFilter(row.type) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="Author" width="110px" align="center">
          <template v-slot="{row}">
            <span>{{ row.author }}</span>
          </template>
        </el-table-column>
        <el-table-column v-if="showReviewer" label="Reviewer" width="110px" align="center">
          <template v-slot="{row}">
            <span style="color:red;">{{ row.reviewer }}</span>
          </template>
        </el-table-column>
        <el-table-column label="Imp" width="80px">
          <template v-slot="{row}">
            <svg-icon v-for="n in row.importance" :key="n" icon-class="star" class="meta-item__icon" />
          </template>
        </el-table-column>
        <el-table-column label="Readings" align="center" width="95">
          <template v-slot="{row}">
            <span v-if="row.pageviews" class="link-type" @click="handleFetchPv(row.pageviews)">{{ row.pageviews }}</span>
            <span v-else>0</span>
          </template>
        </el-table-column>
        <el-table-column label="Status" class-name="status-col" width="100">
          <template v-slot="{row}">
            <el-tag :type="statusFilter(row.status)">
              {{ row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="Actions" align="center" width="230" class-name="small-padding fixed-width">
          <template v-slot="{row,$index}">
            <el-button type="primary" size="small" @click="handleUpdate(row)">
              Edit
            </el-button>
            <el-button v-if="row.status!='published'" size="small" type="success" @click="handleModifyStatus(row,'published')">
              Publish
            </el-button>
            <el-button v-if="row.status!='draft'" size="small" @click="handleModifyStatus(row,'draft')">
              Draft
            </el-button>
            <el-button v-if="row.status!='deleted'" size="small" type="danger" @click="handleDelete(row,$index)">
              Delete
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination v-show="total>0" :total="total" v-model:page="listQuery.page" v-model:limit="listQuery.limit" @pagination="getList" />

      <el-dialog :title="textMap[dialogStatus]" v-model="dialogFormVisible">
        <el-form ref="dataForm" :rules="rules" :model="temp" label-position="left" label-width="70px" style="width: 400px; margin-left:50px;">
          <el-form-item label="Type" prop="type">
            <el-select v-model="temp.type" class="filter-item" placeholder="Please select">
              <el-option v-for="item in calendarTypeOptions" :key="item.key" :label="item.display_name" :value="item.key" />
            </el-select>
          </el-form-item>
          <el-form-item label="Date" prop="timestamp">
            <el-date-picker v-model="temp.timestamp" type="datetime" placeholder="Please pick a date" />
          </el-form-item>
          <el-form-item label="Title" prop="title">
            <el-input v-model="temp.title" />
          </el-form-item>
          <el-form-item label="Status">
            <el-select v-model="temp.status" class="filter-item" placeholder="Please select">
              <el-option v-for="item in statusOptions" :key="item" :label="item" :value="item" />
            </el-select>
          </el-form-item>
          <el-form-item label="Imp">
            <el-rate v-model="temp.importance" :colors="['#99A9BF', '#F7BA2A', '#FF9900']" :max="3" style="margin-top:8px;" />
          </el-form-item>
          <el-form-item label="Remark">
            <el-input v-model="temp.remark" :autosize="{ minRows: 2, maxRows: 4}" type="textarea" placeholder="Please input" />
          </el-form-item>
        </el-form>
        <template #footer>
          <div class="dialog-footer">
            <el-button @click="dialogFormVisible = false">
              Cancel
            </el-button>
            <el-button type="primary" @click="dialogStatus==='create'?createData():updateData()">
              Confirm
            </el-button>
          </div>
        </template>
      </el-dialog>

      <el-dialog v-model="dialogPvVisible" title="Reading statistics">
        <el-table :data="pvData" border fit highlight-current-row style="width: 100%">
          <el-table-column prop="key" label="Channel" />
          <el-table-column prop="pv" label="Pv" />
        </el-table>
        <template #footer>
          <span class="dialog-footer">
            <el-button type="primary" @click="dialogPvVisible = false">Confirm</el-button>
          </span>
        </template>
      </el-dialog>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, markRaw } from 'vue'
import { Vue3Marquee } from 'vue3-marquee'
import { toast } from 'vue3-toastify'
import Pagination from '@/components/Pagination'
import waves from '@/directive/waves'
import { Search, Edit, Download } from '@element-plus/icons-vue'
import { fetchList, fetchPv, createArticle, updateArticle } from '@/api/article'
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

// --- 图标 ---
const iconSearch = markRaw(Search)
const iconEdit = markRaw(Edit)
const iconDownload = markRaw(Download)

// --- 表格数据 ---

const showReviewer = ref(false)
const tableKey = ref(0)
const textMap = ref({
  update: 'Edit',
  create: 'Create'
})
const dialogPvVisible = ref(false)
const importanceOptions = ref([1, 2, 3])
const sortOptions = ref(
  [{ label: 'ID Ascending', key: '+id' }, { label: 'ID Descending', key: '-id' }]
)
const list = ref([])
const total = ref(0)
const listLoading = ref(true)
const listQuery = reactive({
  page: 1,
  limit: 20,
  importance: undefined,
  title: undefined,
  type: undefined,
  sort: '+id'
})

// --- 弹窗状态 ---
const dialogFormVisible = ref(false)
const dialogStatus = ref('')
const temp = reactive({
  id: undefined,
  importance: 1,
  remark: '',
  timestamp: new Date(),
  title: '',
  type: '',
  status: 'published'
})
const pvData = ref([])
const downloadLoading = ref(false)

// --- Calendar 类型 ---
const calendarTypeOptions = [
  { key: 'CN', display_name: 'China' },
  { key: 'US', display_name: 'USA' },
  { key: 'JP', display_name: 'Japan' },
  { key: 'EU', display_name: 'Eurozone' }
]
const calendarTypeKeyValue = calendarTypeOptions.reduce((acc, cur) => {
  acc[cur.key] = cur.display_name
  return acc
}, {})

const router = useRouter();

// --- 生命周期 ---
onMounted(() => {
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

function handleModifyStatus(row, status) {
  ElMessage({
    message: '操作Success',
    type: 'success'
  })
  row.status = status
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

function resetTemp() {
  Object.assign(temp, {
    id: undefined,
    importance: 1,
    remark: '',
    timestamp: new Date(),
    title: '',
    status: 'published',
    type: ''
  })
}

function handleCreate() {
  resetTemp()
  dialogStatus.value = 'create'
  dialogFormVisible.value = true
  nextTick(() => {
    if ($refs.dataForm) $refs.dataForm.clearValidate()
  })
}

function createData() {
  if ($refs.dataForm) {
    $refs.dataForm.validate((valid) => {
      if (valid) {
        temp.id = parseInt(Math.random() * 100) + 1024
        temp.author = 'vue-element-admin'
        createArticle(temp).then(() => {
          list.value.unshift({ ...temp })
          dialogFormVisible.value = false
          ElNotification({
            title: 'Success',
            message: 'Created Successfully',
            type: 'success',
            duration: 2000
          })
        })
      }
    })
  }
}

function handleUpdate(row) {
  Object.assign(temp, row)
  temp.timestamp = new Date(temp.timestamp)
  dialogStatus.value = 'update'
  dialogFormVisible.value = true
  nextTick(() => {
    if ($refs.dataForm) $refs.dataForm.clearValidate()
  })
}

function updateData() {
  if ($refs.dataForm) {
    $refs.dataForm.validate((valid) => {
      if (valid) {
        const tempData = { ...temp, timestamp: +new Date(temp.timestamp) }
        updateArticle(tempData).then(() => {
          const index = list.value.findIndex(v => v.id === temp.id)
          list.value.splice(index, 1, { ...temp })
          dialogFormVisible.value = false
          ElNotification({
            title: 'Success',
            message: 'Update Successfully',
            type: 'success',
            duration: 2000
          })
        })
      }
    })
  }
}

function handleDelete(row, index) {
  ElNotification({
    title: 'Success',
    message: 'Delete Successfully',
    type: 'success',
    duration: 2000
  })
  list.value.splice(index, 1)
}

function handleFetchPv(pv) {
  fetchPv(pv).then(response => {
    pvData.value = response.data.pvData
    dialogPvVisible.value = true
  })
}

function handleDownload() {
  downloadLoading.value = true
  import('@/vendor/Export2Excel').then(excel => {
    const tHeader = ['timestamp', 'title', 'type', 'importance', 'status']
    const filterVal = ['timestamp', 'title', 'type', 'importance', 'status']
    const data = list.value.map(v => filterVal.map(j => j === 'timestamp' ? parseTime(v[j]) : v[j]))
    excel.export_json_to_excel({ header: tHeader, data, filename: 'table-list' })
    downloadLoading.value = false
  })
}

function statusFilter(status) {
  const statusMap = { published: 'success', draft: 'info', deleted: 'danger' }
  return statusMap[status]
}

function typeFilter(type) {
  return calendarTypeKeyValue[type]
}

function getSortClass(key) {
  const sort = this.listQuery.sort;
  return sort === `+${key}` ? 'ascending' : 'descending';
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