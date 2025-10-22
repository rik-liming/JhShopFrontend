import requestBase from './base';

// request user info
export async function getUserInfo(loginToken) {
    const response = await requestBase.get('/api/user/info', {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}

// request user info
export async function updatePassword(loginToken, data) {
    const response = await requestBase.put('/api/user/password', data, {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}
