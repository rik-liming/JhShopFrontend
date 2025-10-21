<template>
  <div style="" @click="handleClick">
    <img
      v-if="props.iconStyle == 1"
      src="@/assets/logo.png"
      class="hamburger-logo"
      :class="{ 'is-rotating': isRotating }"
      :style="{ width: iconSize + 'px', height: iconSize + 'px' }"
    />
    <!-- <svg-icon
      v-if="props.iconStyle == 2"
      icon-class="list"
      class="hamburger-logo cursor-pointer"
      :class="{ 'is-rotating': isRotating }"
      :style="{ width: iconSize + 'px', height: iconSize + 'px' }"
    /> -->
    <svg
      v-if="props.iconStyle == 2"
      :class="{ 'is-active': props.isActive }" 
      class="hamburger-logo cursor-pointer"
      viewBox="0 0 1024 1024" 
      xmlns="http://www.w3.org/2000/svg"
      :style="{ width: iconSize + 'px', height: iconSize + 'px' }"
    >
      <path
        d="M408 442h480c4.4 0 8-3.6 8-8v-56c0-4.4-3.6-8-8-8H408c-4.4 0-8 3.6-8 8v56c0 4.4 3.6 8 8 8zm-8 204c0 4.4 3.6 8 8 8h480c4.4 0 8-3.6 8-8v-56c0-4.4-3.6-8-8-8H408c-4.4 0-8 3.6-8 8v56zm504-486H120c-4.4 0-8 3.6-8 8v56c0 4.4 3.6 8 8 8h784c4.4 0 8-3.6 8-8v-56c0-4.4-3.6-8-8-8zm0 632H120c-4.4 0-8 3.6-8 8v56c0 4.4 3.6 8 8 8h784c4.4 0 8-3.6 8-8v-56c0-4.4-3.6-8-8-8zM142.4 642.1L298.7 519a8.84 8.84 0 0 0 0-13.9L142.4 381.9c-5.8-4.6-14.4-.5-14.4 6.9v246.3a8.9 8.9 0 0 0 14.4 7z" />
    </svg>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import store from '@/store'

// 动画状态
const isRotating = ref(false)

const props = defineProps({
  iconStyle: {
    type: Number,
    default: 1,
  },
  isActive: Boolean,
});

// 设置初始图标大小
let iconSize = ref(36)

// 动态监听 device 的变化
watch(() => store.app().device, (newDevice) => {
  if (newDevice === 'mobile') {
    iconSize.value = 36
  } else if (newDevice === 'desktop') {
    iconSize.value = 60
  } else {
    iconSize.value = 36 // 默认值
  }
}, { immediate: true }) // { immediate: true } 确保页面加载时会立即获取 device 的值

// emit 事件
const emit = defineEmits(['toggleClick'])

function handleClick() {
  // 触发旋转
  isRotating.value = true
  setTimeout(() => {
    isRotating.value = false

    // 触发原来的事件
    emit('toggleClick')
  }, 300) // 动画时间 1s
}
</script>

<style scoped>
.hamburger-logo {
  transition: transform 1s;
}

.hamburger-logo.is-rotating {
  transform: rotate(360deg);
}

.hamburger-logo.is-active {
  transform: rotate(180deg);
}
</style>
