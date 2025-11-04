<template>
  <div class="tw-w-full tw-min-h-screen tw-flex tw-flex tw-justify-center">
    <div class="tw-w-[90%] tw-text-center tw-flex tw-flex-col tw-justify-start tw-items-center">
      <!-- 顶部图标 -->
      <div class="tw-w-full tw-flex tw-items-center tw-justify-between tw-mt-14 tw-mb-2 tw-relative">
        <div class="tw-flex tw-items-center tw-w-full">
          <img 
            src="@/assets/profile_icon.png" 
            alt="avatar" 
            class="tw-w-[96px] tw-h-[105px] tw-mx-auto" 
            @click="handleClose"
          />
        </div>
        <div class="tw-absolute tw-left-0 tw-top-0 tw-flex tw-flex-col tw-items-end">
          <hamburger 
            id="hamburger-container" 
            :is-active="appStore.sidebar.opened" 
            class="hamburger-container"
            :iconStyle="1"
            @toggleClick="toggleSidebar" 
          />
        </div>
        <div class="tw-absolute tw-top-[-12px] tw-right-0 tw-flex tw-flex-col tw-items-end">
          <notification-bell @toggleClick="showMessageBox" />
        </div>
      </div>

      <!-- 标题 -->
      <h2 class="tw-text-[16px] tw-font-pingfang tw-font-normal tw-text-black">会员信息</h2>
      <hr class="tw-w-full tw-my-3 tw-border-black tw-border-opacity-30" />

      <div class="tw-w-[86%] tw-text-[#333333]">
        <!-- 商户号 -->
        <div class="tw-flex tw-justify-start tw-mt-2 tw-mb-2">
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">会员号：</p>
          <p class="tw-font-pingfangsb tw-font-bold">{{ formatIdDisplay(userStore?.user?.value?.id) }}</p>
        </div>

        <div class="tw-flex tw-justify-start tw-mb-2">
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">注册邮箱：</p>
          <p class="tw-font-pingfangsb tw-font-bold">{{ userStore?.user?.value?.email }}</p>
        </div>
      </div>

      <div class="tw-w-[86%] tw-text-[#333333]">
        <!-- 商户号 -->
        <div class="tw-flex tw-justify-start tw-mt-4 tw-mb-2">
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">角色：</p>
          <p class="tw-font-pingfangsb tw-font-bold">{{ formatRole(userStore?.user?.value?.role) }}</p>
        </div>

        <div v-if="userStore?.user?.value?.role === 'agent'" class="tw-flex tw-justify-start tw-mb-2 tw-items-center">
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">邀请码：</p>
          <p class="tw-font-pingfangsb tw-font-bold">{{ userStore?.user?.value?.inviteCode }}</p>
          <img 
            src="@/assets/copy_icon.png" 
            alt="复制邀请码"
            class="tw-w-[20px] tw-h-[22px] tw-ml-4 cursor-pointer"
            @click="copyInviteCode"
          />
        </div>

        <div 
          v-if="userStore?.user?.value?.role === 'agent'" 
          class="tw-flex tw-justify-start tw-mb-2"
        >
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">团队报表：</p>
          <router-link to="/report" class="tw-font-pingfangsb tw-font-bold">点击查看详情 🔍</router-link>
        </div>

        <div 
          v-if="userStore?.user?.value?.role === 'seller'" 
          class="tw-flex tw-justify-start tw-mb-2"
        >
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">个人报表：</p>
          <router-link to="/report" class="tw-font-pingfangsb tw-font-bold">点击查看详情 🔍</router-link>
        </div>
      </div>

      <div class="tw-w-[86%] tw-text-[#333333]">
        <div class="tw-flex tw-justify-start tw-mt-4 tw-mb-2 tw-items-center">
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">登录密码: </p>
          <div v-if="!editingLoginPassword" class="tw-flex">
            <p class="tw-font-pingfangsb tw-font-bold">******</p>
            <img 
              src="@/assets/edit_icon.png" 
              alt="修改密码"
              class="tw-w-[20px] tw-h-[22px] tw-ml-4 cursor-pointer"
              @click="editLoginPassword"
            />
          </div>
          <div v-else class="tw-flex tw-items-center">
            <input
              type="text"
              placeholder="请输入登录密码"
              v-model="newLoginPassword"
              class="tw-ml-4 tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-1 tw-text-[16px] tw-placeholder-black tw-placeholder-opacity-35"
            />
            <img 
              src="@/assets/tick_icon.png" 
              alt="确定"
              class="tw-w-[20px] tw-h-[22px] tw-ml-4 cursor-pointer"
              @click="confirmLoginPassword"
            />
            <img 
              src="@/assets/cross_icon.png" 
              alt="取消"
              class="tw-w-[20px] tw-h-[22px] tw-ml-4 cursor-pointer"
              @click="cancelLoginPassword"
            />
          </div>
        </div>

        <div class="tw-flex tw-justify-start tw-mb-2 tw-items-center">
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">支付密码: </p>
          <div v-if="!editingPaymentPassword" class="tw-flex">
            <p class="tw-font-pingfangsb tw-font-bold">******</p>
            <img 
              src="@/assets/edit_icon.png" 
              alt="修改密码"
              class="tw-w-[20px] tw-h-[22px] tw-ml-4 cursor-pointer"
              @click="editPaymentPassword"
            />
          </div>
          <div v-else class="tw-flex tw-items-center">
            <input
              type="text"
              placeholder="请输入支付密码"
              v-model="newPaymentPassword"
              class="tw-ml-4 tw-w-full tw-border tw-border-solid tw-border-black tw-border-opacity-40 tw-rounded-lg tw-px-3 tw-py-1 tw-text-[16px] tw-placeholder-black tw-placeholder-opacity-35"
            />
            <img 
              src="@/assets/tick_icon.png" 
              alt="确定"
              class="tw-w-[20px] tw-h-[22px] tw-ml-4 cursor-pointer"
              @click="confirmPaymentPassword"
            />
            <img 
              src="@/assets/cross_icon.png" 
              alt="取消"
              class="tw-w-[20px] tw-h-[22px] tw-ml-4 cursor-pointer"
              @click="cancelPaymentPassword"
            />
          </div>
        </div>
      </div>

      <div 
        class="tw-w-[86%] tw-text-[#333333]"
        v-if="userStore?.user?.value?.role === 'agent' 
          || userStore?.user?.value?.role === 'seller'"
      >
        <!-- 商户号 -->
        <div class="tw-flex tw-justify-start tw-mt-4 tw-mb-2">
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">总资产：</p>
          <p class="tw-font-pingfangsb tw-font-bold">{{ userStore?.account?.value?.totalBalance }} USDT</p>
        </div>

        <div class="tw-flex tw-justify-start tw-mb-2">
          <p class="tw-w-2/5 tw-text-left tw-font-pingfang tw-font-normal">可用资产：</p>
          <p class="tw-font-pingfangsb tw-font-bold">{{ userStore?.account?.value?.availableBalance }} USDT</p>
        </div>
      </div>

      <div 
        v-if="userStore?.user?.value?.role === 'agent' 
          || userStore?.user?.value?.role === 'seller'" 
        class="tw-w-full tw-text-[#333333]">
        <payment-method />
      </div>

      <!-- 底部版权 -->
      <p class="tw-absolute tw-bottom-4 tw-text-xs tw-text-gray-400 tw-mt-4">Copy@ JH嘉禾商城</p>
    </div>
  </div>
</template>

<script setup>

import { useRouter } from 'vue-router';
import { ref, onMounted } from 'vue'
import Hamburger from '@/components/Hamburger';
import NotificationBell from '@/components/NotificationBell';
import PaymentMethod from './components/PaymentMethod';
import store from '@/store';
import { formatIdDisplay, formatRole } from '@/utils/tool'
import * as UserApi from '@/api/user'
import emitter from '@/event/eventBus';

const appStore = store.app()
const userStore = store.user()
const router = useRouter()

const newLoginPassword = ref('')
const newPaymentPassword = ref('')

const editingLoginPassword = ref(false)
const editingPaymentPassword = ref(false)

const handleClose = () => {
  router.push('/')
}

const toggleSidebar = () => {
  appStore.toggleSidebar();
}

const profileIconClick = () => {
  router.push('/')
}

const showMessageBox = () => {
  emitter.emit('transaction:updated', {'user_id': userStore.user?.value?.id });
}

const editLoginPassword = () => {
  editingLoginPassword.value = true
  newLoginPassword.value = ''
}

const confirmLoginPassword = async () => {
  editingLoginPassword.value = false

  try {
    const resp = await UserApi.updatePassword(userStore.loginToken, {
      type: 'login',
      password: newLoginPassword.value
    })

    if (resp.data.code === 10000) {
      ElMessage.success('密码修改成功');
    } else {
      ElMessage.error(resp.data.msg);
    }
  } catch (error) {
    console.log(error)
    ElMessage.error('密码修改失败');
  }
}

const cancelLoginPassword = () => {
  editingLoginPassword.value = false
}

const editPaymentPassword = () => {
  editingPaymentPassword.value = true
  newPaymentPassword.value = ''
}

const confirmPaymentPassword = async () => {
  editingPaymentPassword.value = false

  try {
    const resp = await UserApi.updatePassword(userStore.loginToken, {
      type: 'payment',
      password: newPaymentPassword.value
    })

    if (resp.data.code === 10000) {
      ElMessage.success('密码修改成功');
    } else {
      ElMessage.error(resp.data.msg);
    }
  } catch (error) {
    console.log(error)
    ElMessage.error('密码修改失败');
  }
}

const cancelPaymentPassword = () => {
  editingPaymentPassword.value = false
}

// 复制邀请码函数
const copyInviteCode = async () => {
  const inviteCode = userStore?.user?.value?.inviteCode;

  if (inviteCode) {
    try {
      // 使用 Clipboard API 复制文本到剪贴板
      await navigator.clipboard.writeText(inviteCode);
      ElMessage.success('邀请码已复制！');
    } catch (err) {
      ElMessage.error('复制失败，请手动复制！');
    }
  }
};

onMounted(async () => {
  await userStore.getAccountInfo()
});

</script>

<style scoped lang="scss">

</style>