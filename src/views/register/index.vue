<template>
  <div class="register-container">
    <!-- 卡片 -->
    <div class="register-card">
      <!-- Logo -->
      <div class="logo-container">
        <img src="@/assets/logo.png" alt="logo" class="logo" />
        <span class="new-text">New</span>
        <el-button type="danger" size="small" class="close-btn" @click="onCancel">关闭</el-button>
      </div>

      <!-- 表单 -->
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-position="top"
        class="register-form"
      >
        <el-form-item label="注册邮箱" prop="email">
          <el-input v-model="form.email" placeholder="Money@bitcon.com" />
        </el-form-item>

        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" placeholder="Password" />
        </el-form-item>

        <el-form-item label="密码确认" prop="confirmPassword">
          <el-input v-model="form.confirmPassword" type="password" placeholder="Password" />
        </el-form-item>

        <el-form-item label="邀请码" prop="inviteCode">
          <el-input v-model="form.inviteCode" placeholder="Money@bitcon.com" />
        </el-form-item>

        <!-- 按钮 -->
        <div class="btn-group">
          <el-button type="primary" class="submit-btn" @click="handleSubmit">注册</el-button>
          <el-button type="danger" link @click="onCancel">取 消</el-button>
        </div>
      </el-form>

      <!-- 底部 -->
      <div class="footer">Copy@ JH嘉禾商城</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from "vue";
import type { FormInstance, FormRules } from "element-plus";
import { useRouter } from 'vue-router'
import * as AuthApi from '@/api/auth';

const router = useRouter()

interface RegisterForm {
  email: string;
  password: string;
  confirmPassword: string;
  inviteCode: string;
}

const formRef = ref<FormInstance>();
const form = reactive<RegisterForm>({
  email: "",
  password: "",
  confirmPassword: "",
  inviteCode: "",
});

// 表单验证规则
const rules: FormRules<RegisterForm> = {
  email: [{ required: true, message: "请输入邮箱", trigger: "blur" }],
  password: [{ required: true, message: "请输入密码", trigger: "blur" }],
  confirmPassword: [
    { required: true, message: "请确认密码", trigger: "blur" },
    {
      validator: (_, value, callback) => {
        if (value !== form.password) {
          callback(new Error("两次输入的密码不一致"));
        } else {
          callback();
        }
      },
      trigger: "blur",
    },
  ],
};

const handleSubmit = async () => {
  try {
   // 校验表单
    const valid = await formRef.value.validate();
    if (!valid) return; // 校验不通过，直接返回

    console.log("表单提交：", form);

    // 提交请求
    const registerResp = await AuthApi.register(form);
    console.log(registerResp);

    if (registerResp.data.code === 10000) {
      ElMessage.success("注册成功");
      router.push('/register/success');
    } else {
      ElMessage.error(registerResp.data.msg || "注册失败");
    }
  } catch (error) {
    console.error(error);
    ElMessage.error(error.message || "请求异常");
  }
};


const onCancel = () => {
  router.push('/login');
};
</script>

<style lang="scss">

$bg: #283443;
$light_gray: #fff;
$cursor: #fff;

@supports (-webkit-mask: none) and (not (cater-color: $cursor)) {
  .login-container .el-input input {
    color: $cursor;
  }
}

/* reset element-plus css */
.login-container {
  background-image: url('@/assets/login_background.jpg');
  background-size: cover;   /* 图片铺满容器 */
  background-position: center;
  background-repeat: no-repeat;

  .el-input {
    height: 47px;
    width: 85%;

    .el-input__wrapper,
    input {
      background: transparent;
      border: 0px;
      -webkit-appearance: none;
      border-radius: 0px;
      box-shadow: none;
    }

    input {
      padding: 12px 5px 12px 15px;
      color: $light_gray;
      height: 47px;
      caret-color: $cursor;

      &:-webkit-autofill {
        box-shadow: 0 0 0px 1000px $bg inset !important;
        -webkit-text-fill-color: $cursor  !important;
      }
    }
  }

  .el-form-item {
    border: 1px solid rgba(255, 255, 255, 0.1);
    background: rgba(0, 0, 0, 0.1);
    border-radius: 5px;
    color: #454545;
  }
}
</style>

<style scoped>
.register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(to bottom right, #ffd86f, #fc6262, #6dd5ed);
}

.register-card {
  width: 350px;
  padding: 20px;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.85);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
  text-align: center;
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

.new-text {
  position: absolute;
  top: 10px;
  right: 70px;
  color: limegreen;
  font-weight: bold;
}

.close-btn {
  position: absolute;
  top: 5px;
  right: 5px;
}

.register-form {
  margin-top: 10px;
  text-align: left;
}

.btn-group {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 15px;
}

.submit-btn {
  width: 100%;
  border-radius: 20px;
}

.footer {
  margin-top: 20px;
  font-size: 12px;
  color: #666;
}
</style>
