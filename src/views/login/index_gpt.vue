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
      <el-form :model="form" :rules="rules" ref="loginForm" class="form-box">
        <el-form-item prop="email" label="邮箱">
          <el-input v-model="form.email" placeholder="Money@bitcon.com" clearable />
        </el-form-item>

        <el-form-item prop="password" label="密码">
          <el-input
            v-model="form.password"
            type="password"
            placeholder="Password"
            show-password
            clearable
          />
        </el-form-item>

        <el-form-item prop="qrcode" label="验证码">
          <el-input v-model="form.qrcode" placeholder="QRCode" clearable />
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
</template>

<script setup lang="ts">
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import type { FormInstance, FormRules } from "element-plus";

const router = useRouter();
const loginForm = ref<FormInstance>();
const loading = ref(false);

// 表单数据
const form = reactive({
  email: "",
  password: "",
  qrcode: "",
});

// 表单校验规则
const rules: FormRules = {
  email: [
    { required: true, message: "请输入邮箱", trigger: "blur" },
    { type: "email", message: "请输入正确的邮箱地址", trigger: "blur" },
  ],
  password: [{ required: true, message: "请输入密码", trigger: "blur" }],
  qrcode: [{ required: true, message: "请输入验证码", trigger: "blur" }],
};

// 登录方法
const handleLogin = () => {
  loginForm.value?.validate((valid) => {
    if (valid) {
      loading.value = true;
      setTimeout(() => {
        loading.value = false;
        console.log("登录成功:", form);
        router.push("/home"); // 登录成功跳转
      }, 1500);
    }
  });
};

// 跳转注册页
const goRegister = () => {
  router.push("/register");
};
</script>

<style scoped lang="scss">
.login-container {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(#f9e49f, #e2c08c, #b6a694, #9eb1a3);

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
