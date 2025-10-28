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

// request account info
export async function getAccountInfo(loginToken) {
    const response = await requestBase.get('/api/user/account/info', {
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

// request verify auto buyer info
export async function autoBuyerVerify(id) {
    const response = await requestBase.get(`/api/user/auto_buyer/verify?auto_buyer_id=${id}`)
    return response
}
