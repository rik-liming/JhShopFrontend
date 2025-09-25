<template>
  <div class="login-container">
    <!-- <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form" autocomplete="on"
             label-position="left">

      <div class="title-container">
        <h3 class="title">Login Form</h3>
      </div>

      <el-form-item prop="username">
        <span class="svg-container">
          <svg-icon icon-class="user" />
        </span>
        <el-input ref="username" v-model="loginForm.username" placeholder="Username" name="username" type="text"
                  tabindex="1" autocomplete="on" />
      </el-form-item>

      <el-tooltip v-model="capsTooltip" content="Caps lock is On" placement="right" manual>
        <el-form-item prop="password">
          <span class="svg-container">
            <svg-icon icon-class="password" />
          </span>
          <el-input :key="passwordType" ref="password" v-model="loginForm.password" :type="passwordType"
                    placeholder="Password" name="password" tabindex="2" autocomplete="on" @keyup="checkCapslock"
                    @blur="capsTooltip = false" @keyup.enter="handleLogin" />
          <span class="show-pwd" @click="showPwd">
            <svg-icon :icon-class="passwordType === 'password' ? 'eye' : 'eye-open'" />
          </span>
        </el-form-item>
      </el-tooltip>

      <el-button :loading="loading" type="primary" style="width:100%;margin-bottom:30px;" @click.prevent="handleLogin">
        Login</el-button>

      <div style="position:relative">
        <div class="tips">
          <span>Username : admin</span>
          <span>Password : any</span>
        </div>
        <div class="tips">
          <span style="margin-right:18px;">Username : editor</span>
          <span>Password : any</span>
        </div>

        <el-button class="thirdparty-button" type="primary" @click="showDialog = true">
          Or connect with
        </el-button>
      </div>
    </el-form> -->

    <div class="login-box">
      <!-- 标题 -->
      <div class="title-container">
        <h2 class="welcome">欢迎来到</h2>
        <h1 class="app-name">金钱的世界</h1>
      </div>

      <!-- Logo -->
      <div class="logo-container">
        <img src="@/assets/logo.png" alt="logo" class="logo" />
      </div>

      <!-- 表单 -->
      <el-form :model="loginForm" :rules="loginRules" ref="loginForm" class="form-box">
        <el-form-item prop="email" label="邮箱">
          <el-input v-model="loginForm.email" placeholder="Money@bitcon.com" clearable />
        </el-form-item>

        <el-form-item prop="password" label="密码">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="Password"
            show-password
            clearable
          />
        </el-form-item>

        <!-- 登录按钮 -->
        <el-form-item>
          <el-button
            type="primary"
            class="login-btn"
            :loading="loading"
            @click="handleLogin"
          >
            登录
          </el-button>
        </el-form-item>
      </el-form>

      <!-- 新注册 -->
      <div class="register-link">
        <span @click="goRegister">新注册</span>
      </div>

      <!-- Footer -->
      <div class="footer">Copy@ JH嘉禾商城</div>
    </div>
  </div>

  <el-dialog v-model="needBindOtp" title="Bind Otp">
    <div>bind otp</div>
    <QrcodeVue :value="qrCodeUrl" :size="200" />

    <v-sheet color="surface">
      <v-otp-input
        v-model="otp"
        variant="outlined"
      ></v-otp-input>
    </v-sheet>

    <v-btn
      class="my-4 mx-auto"
      color="success"
      height="40"
      text="验证"
      variant="flat"
      width="70%"
      @click="submitOtp"
    ></v-btn>
  </el-dialog>

  <el-dialog v-model="needVerifyOtp" title="Verify Otp">
    <div>verify otp</div>

    <v-sheet color="surface">
      <v-otp-input
        v-model="otp"
        variant="outlined"
      ></v-otp-input>
    </v-sheet>

    <v-btn
      class="my-4 mx-auto"
      color="success"
      height="40"
      text="验证"
      variant="flat"
      width="70%"
      @click="submitOtp"
    ></v-btn>
  </el-dialog>
</template>

<script lang="ts">
import { validEmail } from '@/utils/validate';
import { defineComponent } from 'vue';
import type { FormItemRule } from 'element-plus';
import type { IForm } from '@/types/element-plus';
import store from '@/store';
import * as AuthApi from '@/api/auth';
import QrcodeVue from 'qrcode.vue'

interface QueryType {
  // 自定义key 任意字符串
  [propname:string]:string
}

export default defineComponent({
  name: 'Login',
  components: {
    QrcodeVue,
  },
  data() {
    const validateEmail: FormItemRule['validator'] = (_rule, value, callback) => {
      if (!validEmail(value)) {
        callback(new Error('请输入正确的邮箱'));
      } else {
        callback();
      }
    };
    const validatePassword: FormItemRule['validator'] = (_rule, value, callback) => {
      if (value.length < 6) {
        callback(new Error('密码不能少于6位'));
      } else {
        callback();
      }
    };
    return {
      loginForm: {
        email: '',
        password: '',
      },
      loginRules: {
        email: [{ required: true, trigger: 'blur', validator: validateEmail }],
        password: [{ required: true, trigger: 'blur', validator: validatePassword }]
      },
      passwordType: 'password',
      loading: false,
      showDialog: false,
      redirect: undefined,
      otherQuery: {},
      needBindOtp: false,
      qrCodeUrl: '',
      needVerifyOtp: false,
      otp: '',
    };
  },
  watch: {
    $route: {
      handler: function(route) {
        const query = route.query;
        if (query) {
          this.redirect = query.redirect;
          this.otherQuery = this.getOtherQuery(query);
        }
      },
      immediate: true
    }
  },
  created() {
  },
  mounted() {
    if (this.loginForm.email === '') {
      (this.$refs.email as HTMLElement).focus();
    } else if (this.loginForm.password === '') {
      (this.$refs.password as HTMLElement).focus();
    }
  },
  methods: {
    showPwd() {
      if (this.passwordType === 'password') {
        this.passwordType = '';
      } else {
        this.passwordType = 'password';
      }
      this.$nextTick(() => {
        (this.$refs.password as HTMLElement).focus();
      });
    },
    async handleLogin() {
      // (this.$refs.loginForm as IForm).validate(valid => {
      //   return new Promise((resolve, reject) => {
      //     if (valid) {
      //       this.loading = true;
      //       store.user().login(this.loginForm)
      //         .then(() => {
      //           this.$router.push({ path: this.redirect || '/', query: this.otherQuery });
      //           this.loading = false;
      //         })
      //         .catch(() => {
      //           this.loading = false;
      //         }).finally(() => {
      //           resolve();
      //         });
      //     } else {
      //       console.log('error submit!!');
      //       reject();
      //     }
      //   });
      // });
      const loginResp = await AuthApi.login(this.loginForm)
      console.log(loginResp)
      if (loginResp.data.code == 10000) {
        if (loginResp.data.data.qrCodeUrl) {
          this.needBindOtp = true
          this.qrCodeUrl = loginResp.data.data.qrCodeUrl
        } else if (loginResp.data.data.needOtp) {
          this.needVerifyOtp = true
        }
      }

    },
    async submitOtp() {
      const userStore = store.user()
      try {
        const response = await userStore.verifyOtp(this.loginForm.email, this.otp)
        if (response.data.code == 10000) {
          this.$router.push({ path: this.redirect || '/', query: this.otherQuery })
        } else {
          ElMessage.error(response.data.msg);
        }
      } catch (e) {
        ElMessage.error("登录失败，请重试")
      }
    },
    getOtherQuery(query:QueryType) {
      return Object.keys(query).reduce((acc:QueryType, cur) => {
        if (cur !== 'redirect') {
          acc[cur] = query[cur];
        }
        return acc;
      }, {});
    },

    // 跳转注册页
    goRegister() {
      this.$router.push("/register");
    }
  }
});
</script>

<style scoped lang="scss">
.login-container {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-image: url('@/assets/login_background.jpg');
  background-size: cover; /* 图片铺满 */
  background-position: center; /* 居中 */

  /* 自适应 iPhone 风格圆角 */
  border-radius: min(11vw, 11vh); /* 取宽和高中较小的比例 */;
  overflow: hidden;

  .login-box {
    width: 360px;
    padding: 30px 20px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 20px;
    text-align: center;
  }

  .title-container {
    margin-bottom: 10px;

    .welcome {
      font-size: 16px;
      color: #7fbd34;
      margin: 0;
    }
    .app-name {
      font-size: 22px;
      font-weight: bold;
      color: #000;
      margin: 5px 0 20px;
    }
  }

  .logo-container {
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 20px;
  }

  .logo {
    width: 100px;
  }

  .form-box {
    text-align: left;
  }

  .login-btn {
    width: 100%;
    background: linear-gradient(to right, #444, #222);
    border: none;
    color: #fff;
  }

  .register-link {
    margin-top: 15px;
    font-size: 14px;
    color: darkgreen;
    cursor: pointer;
  }

  .footer {
    margin-top: 20px;
    font-size: 12px;
    color: #aaa;
  }
}
</style>
