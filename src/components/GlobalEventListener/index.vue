<template>
  <div>
	<el-dialog
		v-model="forceLogoutVisible"
		:close-on-click-modal="false"
		:close-on-press-escape="false"
		:show-close="false"
		class="tw-w-[80%] tw-rounded-xl !tw-flex !tw-flex-col !tw-items-center"
		align-center
	>
		<div class="tw-text-[20px] tw-font-bold tw-font-pingfang tw-mb-4">{{ forceLogoutTitle }}</div>
		<div class="tw-text-[16px] tw-font-pingfang tw-text-center">{{ forceLogoutMsg }}</div>

		<v-btn
			class="my-4 mx-auto"
			color="success"
			height="40"
			text="重新登录"
			variant="flat"
			width="70%"
			@click="logoutHandle"
		></v-btn>
	</el-dialog>

	<el-dialog v-model="messageDialogVisible" class="messageDialog">
      <div class="tw-text-[20px] tw-text-center tw-mb-4">{{ messageDialogTitle }}</div>
      <notification-table :tableKey="messageDialogTableKey" />
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, ref, watch } from 'vue';
import { ElMessageBox } from 'element-plus';
import emitter from '@/event/eventBus';
import { useRouter, useRoute } from 'vue-router';
import store from '@/store'

const router = useRouter()
const route = useRoute()
const userStore = store.user()
const configStore = store.config()

const forceLogoutVisible = ref(false);
const forceLogoutTitle = ref('')
const forceLogoutMsg = ref('')

const messageDialogVisible = ref(false)
const messageDialogTitle = ref('')
const messageDialogTableKey = ref(Math.random())

const onUserRoleChanged = async(data) => {
	// 如果是自己
	if (data.user_id === userStore?.user?.value?.id) {
		forceLogoutTitle.value = "角色变更"
		forceLogoutMsg.value = "您的角色已变更，请重新登录"
		forceLogoutVisible.value = true;
	}
}

const onUserStatusChanged = async(data) => {
	// 如果是自己
	if (data.user_id === userStore?.user?.value?.id) {
		forceLogoutTitle.value = "状态变更"
		forceLogoutMsg.value = "您的账户状态已变更，请重新登录"
		forceLogoutVisible.value = true;
	}
}

const onUserPasswordChanged = async(data) => {
	// 如果是自己
	if (data.user_id === userStore?.user?.value?.id) {
		forceLogoutTitle.value = "密码变更"
		forceLogoutMsg.value = "您的密码已变更，请重新登录"
		forceLogoutVisible.value = true;
	}
}

const onConfigChanged = async(data) => {
	await configStore.getConfig()
	window.location.reload()
}

const onTransactionUpdated = async(data) => {
	// 如果是自己
	if (data.user_id === userStore?.user?.value?.id) {
		messageDialogTitle.value = "系统消息"

		updateTableKey()

		if (!messageDialogVisible.value) {
			messageDialogVisible.value = true;
		}
	}
}

const onMessageRead = async(data) => {
	// 如果是自己
	if (data.user_id === userStore?.user?.value?.id) {
		messageDialogVisible.value = false;
	}
}

onMounted(() => {

	// 检查是否存在强制退出弹框
	checkForceLogout()

	// 监听用户角色变更事件
	emitter.on('user:roleChanged', onUserRoleChanged);

	// 监听用户状态变更事件
	emitter.on('user:statusChanged', onUserStatusChanged);

	// 监听用户密码变更事件
	emitter.on('user:passwordChanged', onUserPasswordChanged);

	// 监听配置变更事件
	emitter.on('config:changed', onConfigChanged);

	// 监听交易状态变更事件
	emitter.on('transaction:updated', onTransactionUpdated);

	// 监听消息弹框状态变更事件
	emitter.on('message:read', onMessageRead);
  
});

onUnmounted(() => {
  // 移除事件，防止重复监听
  emitter.off('user:roleChanged', onUserRoleChanged);
  emitter.off('user:statusChanged', onUserStatusChanged);
  emitter.off('user:passwordChanged', onUserPasswordChanged);
  emitter.off('config:changed', onConfigChanged);
  emitter.off('transaction:updated', onTransactionUpdated);
  emitter.off('message:read', onMessageRead);
});

const logoutHandle = async() => {
	forceLogoutVisible.value = false
	router.replace('/forcelogout')
}

const updateTableKey = () => {
	messageDialogTableKey.value = Math.random()
}

// 监听弹窗状态，动态注册/移除刷新拦截事件
watch(forceLogoutVisible, (newVal) => {
  if (newVal) {
    // 弹窗打开时，拦截刷新
    window.addEventListener('beforeunload', forceLogoutBeforeUnload)
  } else {
    // 弹窗关闭时，取消拦截
    window.removeEventListener('beforeunload', forceLogoutBeforeUnload)
  }
})

const forceLogoutBeforeUnload = (e) => {
  // 如果检测到刷新，就强制退出
//   if (forceLogoutVisible.value) {
// 	  router.replace('/forcelogout')
//   }
  const data = {
	flag: true,
	expiresAt: Date.now() + 5 * 60 * 1000 // 5分钟有效
  }
  localStorage.setItem(`forceLogout_${userStore?.user?.value?.id}`, JSON.stringify(data))
}

/** 检测是否有强制登出标记 */
const checkForceLogout = () => {
	if (!userStore?.user?.value?.id) return
	const data = localStorage.getItem(`forceLogout_${userStore?.user?.value?.id}`)
	if (!data) return

	try {
		const { flag, expiresAt } = JSON.parse(data)
		if (flag && Date.now() < expiresAt) {
			localStorage.removeItem(`forceLogout_${userStore?.user?.value?.id}`)
			router.replace('/forcelogout')
		} else {
			localStorage.removeItem(`forceLogout_${userStore?.user?.value?.id}`) // 清理过期数据
		}
	} catch {
		localStorage.removeItem(`forceLogout_${userStore?.user?.value?.id}`)
	}
}

</script>

<style scoped lang="scss">

:deep(div.el-dialog.custom-dialog) {
	width: 80% !important;
	--el-dialog-width: 80% !important;
	display: flex !important;
	flex-direction: column !important;
	align-items: center !important;
}

:deep(.el-dialog__header) {
/* Adjust the header if needed */
	padding: 10px 20px !important;
	margin-left: -180px !important;
}

:deep(.el-dialog__body) {
	padding: 20px !important; /* Adjust body padding */
	display: flex !important;
	flex-direction: column !important;
	align-items: center !important;
}

:deep(.el-dialog__footer) {
	padding: 10px 20px !important; /* Adjust footer padding */
}

:deep(.el-dialog.messageDialog) {
  background-image: url('@/assets/main_background.jpg'); /* 设置背景图片 */
  background-size: cover; /* 背景图片覆盖整个区域 */
  background-position: center; /* 背景图片居中 */
  background-repeat: no-repeat; /* 背景图片不重复 */
  width: 80% !important;
  --el-dialog-width: 80% !important;
  padding: 0 !important;
}

</style>
