import requestBase from './base';

// request config info
export async function getConfigInfo() {
    const response = await requestBase.get('/api/config/info')
    return response
}