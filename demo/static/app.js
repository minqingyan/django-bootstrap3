require.config({
  baseUrl: './',

  paths: {
    master: 'assets/js/master',
  },

  shim: {
    app: {
      deps: ['master']
    }
  },

  urlArgs: ''
});

require(['app'], function() {
  angular.bootstrap(document, ['webdir_bsrc']);
  console.log ('欢迎！本网站并没有安全漏洞，请不要浪费时间\n如果您需要扫描API，点击右上角的 开放API 查看用法');
});
