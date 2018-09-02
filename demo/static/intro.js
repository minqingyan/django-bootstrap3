angular.module('webdir_bsrc').controller('intro', ['$http', '$scope', function($http, $scope) {
  $scope.scanBtnText = '请先点击上方区域选择文件';

  $scope.supported = [
    'php', 'phtml', 'inc', 'php3', 'php4', 'php5',
    'war', 'jsp', 'jspx',
    'asp', 'aspx', 'cer', 'cdx', 'asa', 'ashx', 'asmx', 'cfm'
  ];
  $scope.supported_arc = [    
    'rar', 'zip', 'tar', 'xz', 'tbz', 'tgz', 'tbz2', 'bz2', 'gz', 
  ];

  $scope.qa = [
    {
      q: '这个服务是免费的吗?',
      a: '是的，目前不收费，也不限制上传数量'
    },
    {
      q: 'WEBDIR+ 都会对文件做哪些操作?',
      a: '上传后的文件或者压缩包，会经过WEBDIR+三种引擎的检测，检测后文件会被立即删除，全程无人工介入'
    },
    {
      q: 'WEBDIR+ 是如何检测木马的?',
      a: '传统的正则表达式方式，存在高误报、低查杀率的问题，WEBDIR+采用先进的动态监测技术，结合多种引擎零规则查杀'
    }
  ];

  $scope.hashes = [];
  $scope.startScan = function() {
    location.href = '#/pages/scan_result?hash=' + $scope.hashes.join(',');
  }

  angular.element('#file-dropzone').dropzone({
    url: 'https://scanner.baidu.com/enqueue',
    maxFilesize: 50, // MB 
    paramName: 'archive',
    maxThumbnailFilesize: 5,
    dictDefaultMessage: '点击上传文件',
    init: function() {
      this.on('success', function(file, json) {
        var data = JSON.parse (json);
        $scope.$apply(function() {
          $scope.hashes[$scope.hashes.length] = data['md5'];
          $scope.scanBtnText = '开始扫描（' + $scope.hashes.length + '个文件）';
        });
      });

      this.on('addedfile', function(file) {

      });

      this.on('drop', function(file) {

      });

    }

  });
}]);
