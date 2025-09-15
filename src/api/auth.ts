import request from '@/utils/request';

import axios from 'axios';

// export function login(data) {
//   return request({
//     url: '/xxx/article/create',
//     method: 'post',
//     data
//   });
// }

// request register
export async function register(data) {

    const axiosInstance = axios.create({
        baseURL: 'http://be.jhshop.kuntai-tech.com',
        timeout: 5000 // request timeout
    });

    const response = await axiosInstance.post('/api/register', data)
    return response
}

// request login
export async function login(data) {

    const axiosInstance = axios.create({
        baseURL: 'http://be.jhshop.kuntai-tech.com',
        timeout: 5000 // request timeout
    });

    const response = await axiosInstance.post('/api/login', data)
    return response
}

// request otp verify
export async function verifyOtp(data) {

    const axiosInstance = axios.create({
        baseURL: 'http://be.jhshop.kuntai-tech.com',
        timeout: 5000 // request timeout
    });

    const response = await axiosInstance.post('/api/verify_otp', data)
    return response
}

// request logout
export async function logout(loginToken) {

    const axiosInstance = axios.create({
        baseURL: 'http://be.jhshop.kuntai-tech.com',
        timeout: 5000 // request timeout
    });

    const response = await axiosInstance.post('/api/logout', {}, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
}