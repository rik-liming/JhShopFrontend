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