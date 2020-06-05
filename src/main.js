import Vue from 'vue'
import App from './App.vue'

Vue.config.productionTip = false
import Vant from 'vant';
import 'vant/lib/index.css';
import axios from 'axios'
//挂载axios
Vue.prototype.$axios = axios

Vue.use(Vant);
new Vue({
  render: h => h(App),
}).$mount('#app')
