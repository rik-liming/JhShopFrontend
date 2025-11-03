<template>
	<div class="tw-w-full tw-flex tw-flex-col tw-justify-center tw-items-center">
		<!-- 卖场选择 -->
		<div class="tw-w-[86%] tw-mt-4 tw-text-left">
			<label class="tw-text-md tw-font-pingfang tw-font-normal">收款卡管理</label>
			<div class="tw-w-full tw-flex tw-justify-between tw-items-center">
				<div class="tw-w-2/3">
					<el-select 
						class="filter-item"
						v-model="currentPaymentMethod"
					>
						<el-option 
							v-for="item in paymentMethodOptions" 
							:key="item.value" 
							:label="item.label" 
							:value="item.value"
							:class="{
								'selected-item': currentPaymentMethod === item.value
							}" 
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

		<div id="previewContainer" class="tw-overflow-y-scroll tw-w-full tw-max-h-[200px] tw-flex tw-mt-4">
			<div 
				v-if="paymentData && paymentData[currentPaymentMethod]?.length > 0"
				class="tw-w-full tw-flex tw-flex-col"
			>
				<div v-for="(item, index) in paymentData[currentPaymentMethod] || []" 
					:key="index"
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
					<!-- 支付方式启用开关 -->
					<!-- @change="(val) => onSwitchChange(item.id, val)" -->
					<!-- :model-value="item.default_payment" -->
					<!-- @click="() => handleUserSwitch(item.id)" -->
					<el-switch
						v-if="item.default_payment !== undefined"
						v-model="item.default_payment"
						class="tw-ml-4"
						@change="() => handleSwitchChange(item.id)"
					/>
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

	<el-dialog
      v-model="isPreviewOpen"
      align-center
	  style="width: 380px; height: 540px; "
    >
      <img
        :src="currentImageUrl"
        alt="Preview"
        class="tw-w-[350px] tw-max-h-[530px] tw-object-contain"
        @click.stop
      />
    </el-dialog>
</template>

<script setup>

import { ref, onMounted, reactive, nextTick } from 'vue'
import store from '@/store';
import * as PaymentMethodApi from '@/api/payment_method'
import { useRouter } from 'vue-router';
import { formatImageUrl } from '@/utils/tool'
import it from 'node:test';
import { inputEmits } from 'element-plus';
import _ from "lodash";

const paymentMethodOptions = [
  { label: '支付宝', value: 'alipay' },
  { label: '银行卡', value: 'bank' },
  { label: '微信', value: 'wechat' },
]

const userStore = store.user()
const router = useRouter()

const currentPaymentMethod = ref('alipay')
const paymentData = reactive({
  alipay: [],
  bank: [],
  wechat: []
})

const isPreviewOpen = ref(false)
const currentImageUrl = ref('');

// 页面加载时获取支付卡数据
onMounted(async () => {
  fetchMyPaymentMethods();

  await nextTick()
  isInitialized.value = true
});

const fetchMyPaymentMethods = async () => {
  try {
    const response = await PaymentMethodApi.getMyList(userStore.loginToken)
    if (response.data.code === 10000) {
	//   paymentData.value = response.data.data.payments;
	  
	  const payments = response.data.data.payments || {}
      // 深度响应式数组
      paymentData.alipay = (payments.alipay || []).map(item => ({ ...item }))
      paymentData.bank = (payments.bank || []).map(item => ({ ...item }))
      paymentData.wechat = (payments.wechat || []).map(item => ({ ...item }))
    } else {
      console.error('获取数据失败');
    }
  } catch (error) {
    console.error('请求错误:', error);
  }
};

const addPaymentMethod = async() => {
	router.push(`/payment_method/${currentPaymentMethod.value}`)
}

const editPaymentMethod = async(id) => {
	router.push(`/payment_method/${currentPaymentMethod.value}?id=${id}`)
}

const deletePaymentMethod = async(id) => {
	try {
		const response = await PaymentMethodApi.deletePaymentMethod(userStore.loginToken, id)
		if (response.data.code === 10000) {
			// 删除成功，删除对应的数据
			const method = currentPaymentMethod.value; // 获取当前选择的支付方式
      		paymentData.value[method] = paymentData.value[method].filter(item => item.id !== id);
		} else {
			console.error('删除失败');
		}
	} catch (error) {
		console.error('请求错误:', error);
	}
}

const openPreview = (imageUrl) => {
	currentImageUrl.value = imageUrl;
	isPreviewOpen.value = true;
}

const lastSwitchData = ref(null)
const isInitialized = ref(false)

// 渠道内互斥开关逻辑
const onSwitchChange = async (id, value) => {
  
//   // 若初始化阶段，直接跳过逻辑
//   if (!isInitialized.value) return

//   const channel = currentPaymentMethod.value
//   const list = paymentData[channel] || []

//   // 如果要开启某项（value === true），则让该渠道内其余项全部关闭，并设置此项为 true
//   if (value) {
//     const newList = list.map(item => {
//       if (!item || typeof item !== 'object') return item
//       return {
//         ...item,
//         default_payment: item.id === id, // 互斥，只开启当前
//       }
//     })
//     list.splice(0, list.length, ...newList)
//   } else {
//     // 如果是关掉当前项
//     const idx = list.findIndex(it => it && it.id === id)
//     if (idx !== -1) {
//       const item = list[idx]
//       const newItem = { ...item, default_payment: false }
//       list.splice(idx, 1, newItem)
//     }
//   }

//   // 整理要提交的数据：[{id: 1, default_payment: 1}, ...]
//   const updatedDefaultData = list.map(item => ({
//     id: item.id,
//     default_payment: item.default_payment ? 1 : 0,
//   }))

//   if (lastSwitchData.value && _.isEqual(lastSwitchData.value, updatedDefaultData)) {
// 	  return;
//   }

//   lastSwitchData.value = updatedDefaultData
//   await PaymentMethodApi.setDefault(userStore.loginToken, updatedDefaultData)

  // 确保是用户点击，而不是初始化触发
  if (!isInitialized.value) return

  const channel = currentPaymentMethod.value
  const list = paymentData[channel] || []

  // 更新界面显示：互斥逻辑
  list.forEach(item => {
    if (item) {
      item.default_payment = item.id === id && value
    }
  })

  // 构建提交数据
  const updatedDefaultData = list.map(item => ({
    id: item.id,
    default_payment: item.default_payment ? 1 : 0,
  }))

  // 如果数据没变化，不发送
  if (lastSwitchData.value && _.isEqual(lastSwitchData.value, updatedDefaultData)) return

  lastSwitchData.value = updatedDefaultData
  await PaymentMethodApi.setDefault(userStore.loginToken, updatedDefaultData)
}

const handleUserSwitch = async (id) => {
  const channel = currentPaymentMethod.value
  const list = paymentData[channel] || []

  // 互斥逻辑
  list.forEach(item => {
    if (item) item.default_payment = item.id === id
  })

  // 构造请求数据
  const updatedDefaultData = list.map(item => ({
    id: item.id,
    default_payment: item.default_payment ? 1 : 0,
  }))

  // 防止重复请求
  if (lastSwitchData.value && _.isEqual(lastSwitchData.value, updatedDefaultData)) return

  lastSwitchData.value = updatedDefaultData
  await PaymentMethodApi.setDefault(userStore.loginToken, updatedDefaultData)
}

const handleSwitchChange = async (id) => {
  if (isInitialized) return // 初始化阶段不发请求

  const channel = currentPaymentMethod.value
  const list = paymentData[channel] || []

  list.forEach(item => {
    item.default_payment = item.id === id
  })

  const updatedDefaultData = list.map(item => ({
    id: item.id,
    default_payment: item.default_payment ? 1 : 0
  }))

  if (lastSwitchData.value && _.isEqual(lastSwitchData.value, updatedDefaultData)) return

  lastSwitchData.value = _.cloneDeep(updatedDefaultData)
  await PaymentMethodApi.setDefault(userStore.loginToken, updatedDefaultData)
}

</script>

<style scoped lang="scss">

:deep(.el-select__wrapper) {
  background-color: transparent !important;
  box-shadow: none !important;
  font-weight: bold !important;
  padding: 2px !important;
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

.selected-item {
  background-color: #19a5f1;
  color: white;
}

</style>