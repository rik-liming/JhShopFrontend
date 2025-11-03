<template>
  <div class="tw-w-full tw-flex tw-flex-col tw-justify-center tw-items-center">
    <!-- 卖场选择 -->
    <div class="tw-w-[86%] tw-mt-4 tw-text-left">
      <label class="tw-text-md tw-font-pingfang tw-font-normal">收款卡管理</label>
      <div class="tw-w-full tw-flex tw-justify-between tw-items-center">
        <div class="tw-w-2/3">
          <el-select v-model="currentPaymentMethod" class="filter-item">
            <el-option 
              v-for="item in paymentMethodOptions" 
              :key="item.value" 
              :label="item.label" 
              :value="item.value"
              :class="{ 'selected-item': currentPaymentMethod === item.value }"
            />
          </el-select>
        </div>
        <div class="tw-w-1/3 tw-flex tw-items-center">
          <img 
            src="@/assets/add_icon.png" 
            alt="新增"
            class="tw-w-[20px] tw-h-[22px] tw-ml-4 cursor-pointer"
            @click="addPaymentMethod"
          />
        </div>
      </div>
    </div>

    <!-- 支付方式列表 -->
    <div id="previewContainer" class="tw-overflow-y-scroll tw-w-full tw-max-h-[200px] tw-flex tw-mt-4">
      <div 
        v-if="paymentData && paymentData[currentPaymentMethod]?.length > 0"
        class="tw-w-full tw-flex tw-flex-col"
      >
        <div v-for="(item, index) in paymentData[currentPaymentMethod]" 
          :key="item.id"
          class="tw-w-full tw-flex tw-items-center tw-justify-center"
        >
          <div v-if="currentPaymentMethod === 'bank'">
            <div class="tw-relative">
              <img
                src="@/assets/bank_pay.png"
                alt="支付信息"
                class="tw-w-[264px] tw-h-[210px] tw-object-contain"
              />
              <p class="tw-absolute tw-left-7 tw-top-7 tw-font-bold">{{ item.bank_name }}</p>
              <p class="tw-absolute tw-right-7 tw-top-7 tw-font-bold">{{ item.issue_bank_name }}</p>
              <p class="tw-absolute tw-left-7 tw-bottom-10 tw-font-bold">{{ item.account_name }}</p>
              <p class="tw-absolute tw-left-7 tw-bottom-[70px] tw-font-bold">{{ item.account_number }}</p>
            </div>
          </div>
          <div v-else>
            <img
              :src="formatImageUrl(item?.qr_code)"
              alt="支付信息"
              class="tw-w-[180px] tw-h-[200px] tw-object-contain"
              @click="openPreview(formatImageUrl(item?.qr_code))"
            />
          </div>

		  <div>
			  <div>
				  <!-- 开关 -->
					<el-switch
						:model-value="item.default_payment"
						active-color="#13ce66"
						inactive-color="#ff4949"
						class="tw-ml-4"
						@change="onSwitchChange(item.id, $event)"
					/>
			  </div>
			
			  <div class="tw-mt-4">
				  <img 
						src="@/assets/edit_icon.png" 
						alt="编辑"
						class="tw-w-[30px] tw-h-[32px] tw-ml-4 cursor-pointer"
						@click="editPaymentMethod(item.id)"
					/>
					<img 
						src="@/assets/trash_icon.png" 
						alt="删除"
						class="tw-w-[30px] tw-h-[32px] tw-ml-1 cursor-pointer"
						@click="deletePaymentMethod(item.id)"
					/>
			  </div>
			
		  </div>
        </div>
      </div>
    </div>

    <!-- 图片预览 -->
    <el-dialog v-model="isPreviewOpen" align-center style="width: 380px; height: 540px;">
      <img
        :src="currentImageUrl"
        alt="Preview"
        class="tw-w-[350px] tw-max-h-[530px] tw-object-contain"
        @click.stop
      />
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import store from '@/store'
import * as PaymentMethodApi from '@/api/payment_method'
import { useRouter } from 'vue-router'
import { formatImageUrl } from '@/utils/tool'
import _ from 'lodash'

const paymentMethodOptions = [
  { label: '支付宝', value: 'alipay' },
  { label: '银行卡', value: 'bank' },
  { label: '微信', value: 'wechat' },
]

const userStore = store.user()
const router = useRouter()

const currentPaymentMethod = ref('alipay')
const paymentData = ref<Record<string, any[]>>({})
const isInitialized = ref(false)

const isPreviewOpen = ref(false)
const currentImageUrl = ref('')

// 页面加载获取支付方式
onMounted(fetchMyPaymentMethods)

async function fetchMyPaymentMethods() {
  try {
    const response = await PaymentMethodApi.getMyList(userStore.loginToken)
    if (response.data.code === 10000) {
      const channelData = response.data.data.payments
      // 确保每个 item 都有 default_payment 并是布尔值
      Object.keys(channelData).forEach(channel => {
        channelData[channel] = channelData[channel].map(item => ({
          ...item,
          default_payment: !!item.default_payment
        }))
      })
      paymentData.value = channelData
      isInitialized.value = true
    }
  } catch (error) {
    console.error(error)
  }
}

function addPaymentMethod() {
  router.push(`/payment_method/${currentPaymentMethod.value}`)
}

function editPaymentMethod(id: number) {
  router.push(`/payment_method/${currentPaymentMethod.value}?id=${id}`)
}

async function deletePaymentMethod(id: number) {
  try {
    const response = await PaymentMethodApi.deletePaymentMethod(userStore.loginToken, id)
    if (response.data.code === 10000) {
      const list = paymentData.value[currentPaymentMethod.value] || []
      paymentData.value[currentPaymentMethod.value] = list.filter(item => item.id !== id)
    }
  } catch (error) {
    console.error(error)
  }
}

function openPreview(url: string) {
  currentImageUrl.value = url
  isPreviewOpen.value = true
}

// 渠道内互斥开关逻辑
async function onSwitchChange(id: number, value: boolean) {
  if (!isInitialized.value) return // 初始化阶段不触发 API

  const list = paymentData.value[currentPaymentMethod.value] || []
  if (value) {
    list.forEach(item => item.default_payment = item.id === id)
  } else {
    const item = list.find(i => i.id === id)
    if (item) item.default_payment = false
  }

  // 准备请求数据
  const updatedData = list.map(item => ({
    id: item.id,
    default_payment: item.default_payment ? 1 : 0
  }))

  await PaymentMethodApi.setDefault(userStore.loginToken, updatedData)
}

</script>

<style scoped lang="scss">
:deep(.el-select__wrapper) {
  background-color: transparent !important;
  box-shadow: none !important;
  font-weight: bold !important;
  padding: 2px !important;
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

.selected-item {
  background-color: #19a5f1;
  color: white;
}
</style>
