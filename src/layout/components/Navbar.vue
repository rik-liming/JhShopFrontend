<template>
  <div class="navbar">
    <hamburger id="hamburger-container" :is-active="sidebar.opened" class="hamburger-container"
               @toggleClick="toggleSidebar" />

    <!-- <breadcrumb id="breadcrumb-container" class="breadcrumb-container" /> -->

    <div class="right-menu">
      <!-- <template v-if="device !== 'mobile'"> -->
      <!-- <template> -->
        <div class="right-menu-item">
          <notification-bell />
        </div>
<!-- 
        <search id="header-search" class="right-menu-item" />
        <error-log class="errLog-container right-menu-item hover-effect" />

        <screenfull id="screenfull" class="right-menu-item hover-effect" />

        <el-tooltip content="全局组件尺寸" effect="dark" placement="bottom">
          <size-select id="size-select" class="right-menu-item hover-effect" />
        </el-tooltip> -->

      <!-- </template> -->

      <el-dropdown class="avatar-container right-menu-item hover-effect" trigger="click">
        <div class="avatar-wrapper">
          <img src="@/assets/profile_icon.png" class="profile-icon">
          <span>ID：{{ user?.value?.id }}</span>
          
          <!-- <el-icon class="el-icon-caret-bottom" size="small">
            <CaretBottom />
          </el-icon> -->
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <router-link to="/profile/index">
              <el-dropdown-item>个人中心</el-dropdown-item>
            </router-link>
            <el-dropdown-item divided @click="logout">
              <span style="display:block;">退出登录</span>
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </div>
</template>

<script>
import { mapState } from 'pinia';
import store from '@/store';
import Breadcrumb from '@/components/Breadcrumb';
import Hamburger from '@/components/Hamburger';
import ErrorLog from '@/components/ErrorLog';
import Screenfull from '@/components/Screenfull';
import SizeSelect from '@/components/SizeSelect';
import Search from '@/components/HeaderSearch';
import NotificationBell from '@/components/NotificationBell';
import { defineComponent } from 'vue';
import { CaretBottom } from '@element-plus/icons-vue';

export default defineComponent({
  components: {
    Breadcrumb,
    Hamburger,
    ErrorLog,
    Screenfull,
    SizeSelect,
    Search,
    NotificationBell,
    CaretBottom
  },
  computed: {
    ...mapState(store.app, [
      'sidebar',
      'device'
    ]),
    ...mapState(store.user, [
      'user'
    ]),
  },
  methods: {
    toggleSidebar() {
      store.app().toggleSidebar();
    },
    async logout() {
      await store.user().logout();
      this.$router.push(`/login?redirect=${this.$route.fullPath}`);
    }
  }
});
</script>

<style lang="scss" scoped>
.navbar {
  height: 70px;
  overflow: hidden;
  position: relative;
  // background: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, .08);

  .hamburger-container {
    line-height: 46px;
    height: 100%;
    float: left;
    cursor: pointer;
    transition: background .3s;
    -webkit-tap-highlight-color: transparent;

    &:hover {
      background: rgba(0, 0, 0, .025)
    }
  }

  .breadcrumb-container {
    float: left;
  }

  .errLog-container {
    display: inline-block;
    vertical-align: top;
  }

  .right-menu {
    float: right;
    height: 100%;
    line-height: 50px;

    &:focus {
      outline: none;
    }

    .right-menu-item {
      display: inline-block;
      padding: 0 8px;
      height: 100%;
      line-height: 50px;
      font-size: 18px;
      color: #5a5e66;
      vertical-align: text-bottom;

      &.hover-effect {
        cursor: pointer;
        transition: background .3s;

        &:hover {
          background: rgba(0, 0, 0, .025)
        }
      }
    }

    .avatar-container {
      margin-right: 10px;

      .avatar-wrapper {
        margin-top: 5px;
        position: relative;
        height: 60px;
        display: flex;
        align-items: center;
        gap: 20px;

        .profile-icon {
          cursor: pointer;
          width: 53px;
          height: 58px;
          // border-radius: 10px;
        }

        .el-icon-caret-bottom {
          cursor: pointer;
          position: absolute;
          right: -20px;
          top: 25px;
          font-size: 12px;
        }
      }
    }
  }
}
</style>
