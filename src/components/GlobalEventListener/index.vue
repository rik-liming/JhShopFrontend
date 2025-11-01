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
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
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

onMounted(() => {

  // 监听用户角色变更事件
  emitter.on('user:roleChanged', async (data: any) => {

	// 如果是自己
	if (data.user_id === userStore?.user?.value?.id) {
		forceLogoutTitle.value = "角色变更"
		forceLogoutMsg.value = "您的角色已变更，请重新登录"
		forceLogoutVisible.value = true;
	}
  });

  // 监听配置变更事件
  emitter.on('config:changed', async (data: any) => {
	await configStore.getConfig()
	window.location.reload()
  });

  // 可以在这里继续监听其他全局事件
  // emitter.on('user:assetChanged', ...)
});

const logoutHandle = async() => {
	forceLogoutVisible.value = false
	router.replace('/forcelogout')
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

</style>
