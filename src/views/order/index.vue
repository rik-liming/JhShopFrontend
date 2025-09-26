<template>
  <div>
    <button @click="startAnimation">点击触发动画</button>
    <div class="moving-div" :class="{ 'animate': animate }">这是一个从左边滑入的div</div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const animate = ref(false);

const startAnimation = () => {
  animate.value = false; // 先停止动画
  // 使用 setTimeout 来稍微延迟一下，让动画可以重新触发
  setTimeout(() => {
    animate.value = true; // 重新触发动画
  }, 500); // 短暂的延迟，确保动画能够重新启动
};
</script>

<style scoped>
.moving-div {
  position: absolute;
  top: 50%; /* 垂直居中 */
  left: -100%; /* 初始位置在屏幕外 */
  transform: translateY(-50%); /* 垂直居中 */
  background-color: lightcoral;
  padding: 10px;
  color: white;
  transition: left 2s ease-out;
  visibility: hidden;
}

.moving-div.animate {
  left: 50%; /* 结束时 div 移动到屏幕中央 */
  transform: translateX(-50%) translateY(-50%); /* 确保居中 */
  visibility: visible;
}
</style>
