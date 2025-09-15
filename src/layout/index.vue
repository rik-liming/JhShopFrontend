<template>
  <div :class="classObj" class="app-wrapper">
    <div v-if="device === 'mobile' && sidebar.opened" class="drawer-bg" @click="handleClickOutside" />
    <sidebar class="sidebar-container" />
    <div :class="{ hasTagsView: needTagsView }" class="main-container" :style="bgStyle">
      <div :class="{ 'fixed-header': fixedHeader }">
        <navbar />
        <!-- <tags-view v-if="needTagsView" /> -->
      </div>
      <app-main />
      <!-- <right-panel v-if="showSettings">
        <settings />
      </right-panel> -->
    </div>
  </div>
</template>

<script>
import RightPanel from '@/components/RightPanel';
import { AppMain, Navbar, Settings, Sidebar, TagsView } from './components';
import ResizeMixin from './mixin/ResizeHandler';
import { mapState } from 'pinia';
import store from '@/store';
import { defineComponent } from 'vue';
import mainBackground from '@/assets/main_background.jpg';

export default defineComponent({
  name: 'LayoutIndex',
  components: {
    AppMain,
    Navbar,
    RightPanel,
    Settings,
    Sidebar,
    TagsView
  },
  mixins: [ResizeMixin],
  data() {
    return {
      // 把图片放到 data/context 中，以便模板能访问到
      mainBackground
    };
  },
  computed: {
    ...mapState(store.app, ['sidebar', 'device']),
    ...mapState(store.settings, {
      showSettings: 'showSettings',
      needTagsView: 'tagsView',
      fixedHeader: 'fixedHeader'
    }),
    classObj() {
      return {
        hideSidebar: !this.sidebar.opened,
        openSidebar: this.sidebar.opened,
        withoutAnimation: this.sidebar.withoutAnimation,
        mobile: this.device === 'mobile'
      };
    },
    // 内联样式对象：确保 background-image 是合法 url(...)
    bgStyle() {
      return {
        backgroundImage: `url(${this.mainBackground})`,
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        backgroundRepeat: 'no-repeat'
      };
    },
  },
  methods: {
    handleClickOutside() {
      store.app().closeSidebar({ withoutAnimation: false });
    }
  }
});
</script>

<style lang="scss" scoped>
@use "@/styles/mixin.scss";
// @use "@/styles/variables.module.scss";

.app-wrapper {
  @include mixin.clearfix;
  position: relative;
  height: 100%;
  width: 100%;
  /* 为了避免祖先元素没有高度导致背景看不见，使用 min-height:100vh 作为保险 */
  // min-height: 100vh;

  &.mobile.openSidebar {
    position: fixed;
    top: 0;
  }
}

.drawer-bg {
  background: #000;
  opacity: 0.3;
  width: 100%;
  top: 0;
  height: 100%;
  position: absolute;
  z-index: 999;
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
</style>
