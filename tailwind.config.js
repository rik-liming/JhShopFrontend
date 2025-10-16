/** @type {import('tailwindcss').Config} */
export default {
  prefix: "tw-",
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        songti: ["'STSsongti-SC-Bold'", "'Songti SC Bold'", "'Songti SC'", 'serif'],
        pingfang: ["'PingFangSC-Regular'", "'PingFang SC'"],
        pingfangsb: ["'PingFangSC-Semibold'", "'PingFang SC Semibold'", "'PingFang SC'"],
        arial: ["'Arial Normal'", "'Arial'"],
        times: ["'Times-Roman'", "'Times'"],
      }
    },
  },
  plugins: [],
}


