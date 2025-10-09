import requestBase from './base';

// request config info
export async function getConfigInfo(loginToken) {
    const response = await requestBase.get('/api/config/info', {
        headers: {
            Authorization: `Bearer ${loginToken}`,
        }
    })
    return response
}