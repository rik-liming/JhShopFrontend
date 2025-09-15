<template>
  <div style="padding: 6px 15px;" @click="handleClick">
    <img
      src="@/assets/logo.png"
      class="hamburger-logo"
      :class="{ 'is-rotating': isRotating }"
    />
  </div>
</template>

<script setup>
import { ref } from 'vue'

// 动画状态
const isRotating = ref(false)

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
  width: 60px;
  height: 60px;
  transition: transform 1s;
}

.hamburger-logo.is-rotating {
  transform: rotate(360deg);
}
</style>
