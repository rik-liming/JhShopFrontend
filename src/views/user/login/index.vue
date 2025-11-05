<template>
  <div class="login-container">

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
        <el-form-item prop="email" label="邮箱" class="custom-form-item">
          <el-input v-model="loginForm.email" placeholder="Money@bitcon.com" clearable />
        </el-form-item>

        <el-form-item prop="password" label="密码" class="custom-form-item">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="Password"
            show-password
            clearable
          />
        </el-form-item>

        <!-- 登录按钮 -->
        <el-form-item class="custom-form-item">
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

    <el-dialog 
      v-model="needBindOtp" 
      align-center
      class="custom-dialog !tw-rounded-xl"
    >
      <div class="tw-text-[20px] tw-font-bold tw-font-pingfang tw-mb-4">绑定验证器</div>
      <div class="tw-text-[16px] tw-font-pingfang tw-text-center">首次登陆，请使用Google Authenticator扫描二维码，完成账号绑定</div>
      <QrcodeVue :value="qrCodeUrl" :size="200" class="qrcode" />

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

      <div class="tw-text-[16px] tw-font-pingfang tw-text-center">如果验证器遗失，请联系客服重置。</div>
    </el-dialog>

    <el-dialog v-model="needVerifyOtp" class="custom-dialog" align-center>
      <div class="tw-text-[20px] tw-font-bold tw-font-pingfang tw-mb-4">安全验证</div>
      <div class="tw-text-[16px] tw-font-pingfangsb tw-text-center">请打开Google Authenticator应用中显示的6位数字</div>
      <v-chip
        class="my-2"
        color="teal"
        label
      >
        {{ `JHShop [${loginForm.email}]` }}
      </v-chip>

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

      <div class="tw-text-[16px] tw-font-pingfang tw-text-center">如果验证器遗失，请联系客服重置。</div>
    </el-dialog>
  </div>
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
    this.$nextTick(() => {
      if (this.loginForm.email === '') {
        this.$refs.email?.focus();  // 这里使用 optional chaining (?.) 避免 undefined 错误
      } else if (this.loginForm.password === '') {
        this.$refs.password?.focus();  // 这里使用 optional chaining (?.) 避免 undefined 错误
      }
    });
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
      const isValid = await (this.$refs.loginForm as IForm).validate();

      if (isValid) {
        this.loading = true

        try {
          const loginResp = await AuthApi.login(this.loginForm)
          if (loginResp.data.code == 10000) {
            if (loginResp.data.data.qr_code_url) {
              this.needBindOtp = true
              this.qrCodeUrl = loginResp.data.data.qr_code_url
            } else if (loginResp.data.data.need_otp) {
              this.needVerifyOtp = true
            }
          } else {
            ElMessage.error(loginResp.data.msg);
          }
        } catch (error) {
          ElMessage.error("登录失败，请重试")
        } finally {
          this.loading = false
        }
      }
    },
    async submitOtp() {
      const userStore = store.user()
      const configStore = store.config()
      try {
        const response = await userStore.verifyOtp(this.loginForm.email, this.otp)
        if (response.data.code == 10000) {
          this.$router.push({ path: this.redirect || '/', query: this.otherQuery })

          // 登录成功后，同步个人账户信息
          await userStore.getUserInfo()
          // 同步全局配置
          await configStore.getConfig()
        } else {
          ElMessage.error(response.data.msg);
        }
      } catch (e) {
        console.log(e)
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
  // align-items: center;
  background-image: url('@/assets/login_background.jpg');
  background-size: cover; /* 图片铺满 */
  background-position: center; /* 居中 */

  /* 自适应 iPhone 风格圆角 */
  border-radius: min(11vw, 11vh); /* 取宽和高中较小的比例 */;
  overflow: hidden;

  .login-box {
    width: 70%;
    // padding: 30px 20px;
    // background: rgba(255, 255, 255, 0.2);
    // border-radius: 20px;
    // text-align: center;
  }

  .title-container {
    display: flex;
    flex-direction: column;
    margin-top: 60px;
    margin-left: 110px;
    gap: 0px;

    .welcome {
      font-size: 20px;
      color: #4b7902;
      font-weight: 400;
      font-family: "Times New Roman", Times, serif;
    }

    .app-name {
      font-size: 30px;
      font-weight: 700;
      color: #000;
      font-family: 'STXingkaiSC-Bold', 'Xingkai SC Bold', 'Xingkai SC', serif;
      margin-top: -10px;
    }
  }

  .logo-container {
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 10px;
    margin-bottom: 50px;

    .logo {
      width: 180px;
      height: 178px;
    }
  }

  .form-box {
    margin-top: 40px;
  }

  // :deep(.login-container .el-form-item) {
  //   border: 0px !important;
  //   background: transparent !important;
  // }

  .custom-form-item {
    display: block;
    margin-top: 2rem;
    margin-bottom: 1.5rem; /* Add space between each item */
    border: 0px !important;
    background: transparent !important;
  }

  :deep(.custom-form-item .el-form-item__label) {
    display: inline-flex; /* Ensure label is on a new line */
    margin-bottom: 0.5rem; /* Space between label and input */
    font-family: "'PingFangSC-Regular', 'PingFang SC'" !important;
    font-weight: normal !important;
    color: #333333 !important;
  }

  :deep(.el-form-item--label-right .el-form-item__label) {
    font-size: 16px !important;
    color: #333 !important;
    font-weight: 400;
  }

  :deep(.el-input__wrapper) {
    background-color: transparent !important;
    box-shadow: none !important;
    border: 2px solid rgb(215, 215, 215) !important;
    border-left: 0px !important;
    border-right: 0px !important;
    border-top: 0px !important;
    --el-input-text-color: #333333;
    font-family: "'PingFangSC-Regular', 'PingFang SC'" !important;
  }

  :deep(.el-input input) {
    color: black !important;
    font-size: 16px !important;
    --el-input-placeholder-color: rgba(51, 51, 51, 0.4) !important;
  }

  .custom-form-item .el-input input {
    color: black !important;
    font-size: 16px !important;
  }

  :deep(.el-form-item__error) {
    padding-top: 12px !important;
    color: #ea5543 !important;
  }

  .custom-form-item .el-input {
    width: 100%; /* Ensure input takes full width */
  }

  .login-btn {
    width: 100%;
    background: black;
    opacity: 0.57;
    border: none;
    color: #F2F2F2;
    letter-spacing: 4px;
    font-size: 20px;
    border-radius: 20px;
    width: 300px;
    height: 53px;
    padding: 2px;
    margin-top: 60px;
  }

  .register-link {
    margin-left: 220px;
    margin-top: -10px;;
    font-size: 16px;
    color: #4B7902;
    cursor: pointer;
    font-family: 'STSongti-SC-Regular', 'Songti SC';
  }

  .footer {
    // position: fixed;
    // bottom: 6px;
    // left: calc(50% - 54px);
    font-size: 11px;
    text-align: center;
    font-family: Arial Normal, Arial;
    color: #333333;
    opacity: 0.57;
    margin: 180px 0 10px;
  }

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

  :deep(.qrcode) {
    margin-top: 20px !important;
  }

  .verifyOtpHint{
    margin: 20px;
  }
}


</style>
