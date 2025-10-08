import requestBase from './base';

// request register
export async function register(data) {
    const response = await requestBase.post('/api/register', data)
    return response
}

// request login
export async function login(data) {
    const response = await requestBase.post('/api/login', data)
    return response
}

// request otp verify
export async function verifyOtp(data) {
    const response = await requestBase.post('/api/verify_otp', data)
    return response
}

// request logout
export async function logout(loginToken) {
    const response = await requestBase.post('/api/logout', {}, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}