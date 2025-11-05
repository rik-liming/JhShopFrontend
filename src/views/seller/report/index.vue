<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-flex tw-justify-center">
    <div class="tw-w-[90%] tw-p-1 tw-text-center tw-flex tw-flex-col tw-justify-start tw-items-center">
      <!-- 顶部图标 -->
      <div class="tw-w-full tw-flex tw-items-center tw-justify-between tw-mt-8 tw-mb-2 tw-relative">
        <div class="tw-flex tw-flex-col tw-items-center tw-w-full">
          <div class="">
            <h2 class="tw-text-[26px] tw-font-pingfangsb tw-text-[#333333]">{{ listQuery.tableType == 'person' ? '个人报表' : '团队报表' }}</h2>
          </div>
          <div class="tw-flex tw-gap-10 tw-mt-6 tw-mb-4">
            <img src="@/assets/person_icon.svg" alt="person" class="tw-w-12 tw-h-12 tw-mx-auto cursor-pointer" @click="handleTableTypeChange('person')" />
            <img v-if="userStore.user?.value?.role === 'agent'" src="@/assets/group_icon.svg" alt="group" class="tw-w-12 tw-h-12 tw-mx-auto cursor-pointer" @click="handleTableTypeChange('group')" />
          </div>
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
        <div class="tw-absolute tw-top-4 tw-right-0 tw-flex tw-flex-col tw-items-end">
          <!-- <button class="tw-text-[#D9001B] tw-font-pingfang tw-text-[17px] tw-border tw-border-solid tw-border-black tw-border-opacity-30 tw-rounded-lg tw-px-2 tw-py-1 tw-mb-16" @click="handleClose">关闭</button> -->
          <img 
            src="@/assets/close_icon.png" 
            alt="close" 
            class="cursor-pointer tw-w-8 tw-h-8" 
            @click="handleClose"
          />
        </div>
      </div>

      <div class="tw-w-[90%] tw-text-[#333333]">
        <div class="tw-w-full tw-flex tw-gap-4 tw-mb-4">
          <!-- 开始时间选择器 -->
          <el-date-picker
            v-model="startTime"
            type="date"
            placeholder="选择开始时间"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            class="tw-w-full"
          />
          
          ~

          <!-- 结束时间选择器 -->
          <el-date-picker
            v-model="endTime"
            type="date"
            placeholder="选择结束时间"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            class="tw-w-full"
          />
        </div>

        <!-- 包裹表格的容器 -->
        <div 
          class="table-wrapper" 
          :class="{ 
            'animate': animate,
            'from-left': listQuery.tableType === 'person', 
            'from-right': listQuery.tableType === 'group'
          }"
        >
          <person-table
            :startTime="startTime"
            :endTime="endTime"
            :tableType="listQuery.tableType"
            @table-update-start="handleTableUpdateStart"
            @table-update-end="handleTableUpdateEnd"
            v-show="listQuery.tableType == 'person'"
          ></person-table>
          <group-table
            v-if="userStore.user?.value?.role === 'agent'"
            :startTime="startTime"
            :endTime="endTime"
            :tableType="listQuery.tableType"
            @table-update-start="handleTableUpdateStart"
            @table-update-end="handleTableUpdateEnd"
            v-show="listQuery.tableType == 'group'"
          ></group-table>
        </div>

        <!-- 按钮 -->
        <button
          type="type"
          class="tw-w-[80%] !tw-bg-[rgba(217,0,27,0.67843137254902)] !tw-text-[#f2f2f2] tw-font-normal tw-font-pingfang tw-text-[20px] tw-rounded-3xl tw-py-3 tw-mt-8 hover:tw-bg-rose-600"
          style="letter-spacing: 4px;"
          @click="handleClose"
        >
          关闭
        </button>
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
import { useRouter } from 'vue-router';
import { ref, reactive, watch, nextTick } from 'vue'
import PersonTable from './components/PersonTable.vue'
import GroupTable from './components/GroupTable.vue'
import store from '@/store'
import dayjs from 'dayjs'

const userStore = store.user()
const appStore = store.app()
const router = useRouter()
const startTime = ref(dayjs().format('YYYY-MM-DD'));
const endTime = ref(dayjs().format('YYYY-MM-DD'));

const animate = ref(false)
const tableWrapper = ref(null)

const listQuery = reactive({
  tableType: 'person',
})

const handleClose = () => {
  router.push('/')
}

const handleTableTypeChange = (tableType) => {
  listQuery.tableType = tableType
}

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

const toggleSidebar = () => {
  appStore.toggleSidebar();
}

</script>

<style scoped lang="scss">

.table-wrapper {
  position: relative;
  // left: -100%; /* 初始位置在屏幕外 */
  transform: translateY(-50%); /* 垂直居中 */
  color: white;
  // transition: left 1s ease-out;
  // transition: left 1s cubic-bezier(0.1, 0, 0.5, 1); /* 自定义贝塞尔曲线 */
  visibility: hidden;
}

.table-wrapper.from-left {
  left: -100%; /* 初始位置在屏幕外 */
  transition: left 1s ease-out;
}

.table-wrapper.from-right {
  left: 100%; /* 初始位置在屏幕外 */
  transition: left 1s ease-out;
}

.table-wrapper.animate {
  left: 50%; /* 结束时 div 移动到屏幕中央 */
  // transform: translateX(-50%) translateY(-50%); /* 确保居中 */
  transform: translateX(-50%); /* 确保居中 */
  visibility: visible;
}

</style>
