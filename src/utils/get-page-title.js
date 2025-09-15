import defaultSettings from '@/settings';

const title = defaultSettings.title || '嘉禾商城';

export default function getPageTitle(pageTitle) {
  if (pageTitle) {
    return `${pageTitle} - ${title}`;
  }
  return `${title}`;
}
