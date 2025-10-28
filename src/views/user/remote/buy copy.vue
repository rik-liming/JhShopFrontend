<template>
  <div class="page-container">

    <div class="main-box">
      <!-- 标题 -->
      <div class="title-container">
        <h2 class="welcome">欢迎来到</h2>
        <h1 class="app-name">金钱的世界</h1>
      </div>

      <!-- Logo -->
      <div class="logo-container">
        <img src="@/assets/logo.png" alt="logo" class="logo" />
      </div>

	  <div class="tw-flex tw-flex-col tw-items-center">
		  <span class="tw-text-[#a30014] tw-text-[33px] tw-font-songti tw-font-bold">下 单</span>
	  </div>
    </div>

	<hr class="tw-w-full tw-my-3" />

	<div class="main-box">
		<div id="u6_div"></div>
	</div>

	<!-- Footer -->
	<!-- <div class="footer">Copy@ JH嘉禾商城</div> -->
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
.page-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
//   justify-content: center;
  align-items: center;
  background-image: url('@/assets/login_background.jpg');
  background-size: cover; /* 图片铺满 */
  background-position: center; /* 居中 */

  /* 自适应 iPhone 风格圆角 */
  border-radius: min(11vw, 11vh); /* 取宽和高中较小的比例 */;
  overflow: hidden;

  .main-box {
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
    --el-input-placeholder-color: #333333 !important;
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

	#u6_div {
		border-width:0px;
		width:87px;
		height:54px;
		background:inherit;
		background-color:rgba(255, 255, 255, 0);
		box-sizing:border-box;
		border-width:2px;
		border-style:solid;
		border-color:rgba(163, 0, 20, 1);
		border-radius:10px;
		-moz-box-shadow:0px -5px 5px 0px rgba(85, 85, 85, 0.537254901960784) inset;
		-webkit-box-shadow:0px -5px 5px 0px rgba(85, 85, 85, 0.537254901960784) inset;
		box-shadow:0px -5px 5px 0px rgba(85, 85, 85, 0.537254901960784) inset;
		font-family:'PingFangSC-Regular', 'PingFang SC';
		font-weight:400;
		font-style:normal;
		font-size:25px;
		color:#D9001B;
		text-align:center;
	}
}


</style>
