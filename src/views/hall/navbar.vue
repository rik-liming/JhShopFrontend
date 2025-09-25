<template>
  <div class="navbar">
    <hamburger id="hamburger-container" :is-active="sidebar.opened" class="hamburger-container"
               @toggleClick="toggleSidebar" />

    <div class="right-menu">
        <div class="right-menu-item">
          <notification-bell />
        </div>

        <div class="right-menu-item">
          <avatar-with-id />
        </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'pinia';
import store from '@/store';
import Hamburger from '@/components/Hamburger';
import NotificationBell from '@/components/NotificationBell';
import AvatarWithId from '@/components/AvatarWithId';
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Navbar',
  components: {
    Hamburger,
    NotificationBell,
    AvatarWithId,
  },
  computed: {
    ...mapState(store.app, [
      'sidebar',
      'device'
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
  // box-shadow: 0 1px 4px rgba(0, 21, 41, .08);

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

  .right-menu {
    float: right;
    height: 100%;
    line-height: 50px;
    margin-right: 10px;

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
      // vertical-align: text-bottom;

      &.hover-effect {
        cursor: pointer;
        transition: background .3s;

        &:hover {
          background: rgba(0, 0, 0, .025)
        }
      }
    }
  }
}
</style>
