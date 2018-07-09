import serverConfig from '/environment/resourceUploadConfig.jsp';

window.onclose = function () {
  let tp = appInstince.tp.data;
  if (tp.title || _editor.hasContents()) {
    return confirm('有未保存数据，是否关闭？');
  }
  return true;
}

window.appInstince = new Vue({
  el: "#app",
  data: {
    resource_server_url: '',
    resource_menu: [{
      label: '素材管理',
      children: [{
        label: '视频(8)'
      }, {
        label: '音频(4)'
      }, {
        label: '图片(34)'
      }]
    }],
    keyword: '',
    //当前目录
    currentCategory: {
      name: '所有类别'
    },
    tpager: {
      total: 0,
      current: 1,
      size: 10
    },
    //节目模版选择
    ptw: {
      visiable: false
    },
    rules: {
      notEmpty: [{
        required: true,
        message: "此项数据不能为空!",
        trigger: "blur"
      }],
      programTemplate: [{
        required: true,
        message: "请选择节目模版",
        trigger: "blur"
      }],
      programTemplateName: [{
        required: true,
        message: "请选择节目模版",
        trigger: "blur"
      }],
      name: [{
          required: true,
          message: "请输入名称",
          trigger: "blur"
        },
        {
          min: 1,
          max: 50,
          message: "长度在 1 到 50个字符",
          trigger: "blur"
        }
      ],
      remark: [{
          required: true,
          message: "请输入表述",
          trigger: "blur"
        },
        {
          min: 1,
          max: 50,
          message: "长度在 1 到 50个字符",
          trigger: "blur"
        }
      ],
      orderNum: [{
        required: true,
        message: "请输入排序序号",
        trigger: "blur"
      }],
      title: [{
          required: true,
          message: "请输入标题",
          trigger: "blur"
        },
        {
          min: 1,
          max: 50,
          message: "长度在 1 到 50个字符",
          trigger: "blur"
        }
      ],
      albumIds: [{
        required: true,
        message: "请选择分类",
        trigger: "change"
      }]
    },
    tpt_props: {
      label: "name",
      value: "albumId",
      children: 'children'
    },
    tp_empty: {
      previewPicture: ''
    },
    tp: {
      title: "文章模板编辑",
      visible: false,
      update: false,
      data: {
        title: "",
        content: "",
        albumId: '',
        albumIds: [],
        url: '',
        type: '',
        description: '',
        viewUrl: '',
        typeDisable: false,
        coverUrl: ''
      }
    },
    tpt: {
      title: "测试标题",
      visible: false,
      update: false, // 是否是更新
      data: {
        tpTypeId: "",
        name: "",
        remark: "",
        orderNum: 0,
        parent: 0
      }
    },
    currentDate: new Date(),
    props: {
      children: 'children',
      label(data, node) {
        let label = data.data.name;
        if (data.data.count) {
          label += '(' + data.data.count + ')';
        }
        return label;
      }
    },
    tpt_data: [],
    tps: [],
    tpt_data_normal: []
  },
  mounted() {
    this.loadTreeData();
    this.loadTpTypeData(null, this);
  },
  computed: {

  },
  watch: {
    "tp.data.type": function (val, old) {
      this.resource_server_url = serverConfig.getUploadUrl(this.tp.data.type);
    }
  },
  methods: {
    currentChange(node,data){
      node.data.showtoolbar = true;
      console.log(arguments)
    },
    card_hover(it) {
      it.showtoolbar = true;
    },
    card_leave(it) {
      it.showtoolbar = false;
    },

    //查询模板
    searchTemplate() {
      this.currentCategory.name = '所有类别';
      this.loadTpTypeData();
      this.loadTreeData();
    },
    // 加载类别树的数据
    loadTreeData: function () {
      var ins = this;
      let data = {
        keyword: this.keyword
      };
      ajax("/MaterialAlbum/Album", "get", data, function (result) {
        ins.tpt_data = ins.init_tpt_data(result.data);
        ins.tpt_data_normal = ins.toNormalData(result.data);
      });
    },
    init_tpt_data(data){
      data.forEach(item => {
        item.data.showtoolbar = false;
      })
      console.log(data);
      return data;
    },
    //转化为普通数据
    toNormalData(data) {
      function next(obj, chi) {
        if (chi) {
          let ay = [];
          chi.forEach(v => {
            let o = v.data;
            ay.push(o);
            next(o);
          });
          obj.children = ay;
        } else {
          return;
        }
      }

      let ret = [];
      data.map((v) => {
        let obj = v.data;
        ret.push(obj);
        next(obj, v.children);
      });
      return ret;
    },

    // 加载分类数据
    loadTpTypeData: function (data) {
      let ins = this;
      if (data) {
        this.currentCategory = data;
      } else {
        data = {};
      }
      let url = '/resource/Material/' + this.tpager.current + '-' + this.tpager.size;
      data.keyword = this.keyword;
      ajax_json(url, "post", data, function (result) {
        ins.tps = ins.initData(result.data);
        ins.tpager.total = result.pager.total;
      });
    }, // 重新加载分类数据
    reloadTpTypeData: function () {
      var node = this.$refs.tree.getCurrentNode();
      this.loadTpTypeData(node ? node.data : null, this);
    },
    checkTreeSelect: function () {
      var node = this.$refs.tree.getCurrentNode();
      if (!node) {
        $message("请先选择要操作的位置", "warning", this)
        return null;
      }
      return node;
    },
    initData(data) {
      data.forEach(element => {
        element.showtoolbar = false;
        element.cfv = false;
      });
      return data;
    },
    // 增加模板类别
    addTemplateType: function () {
      var node = this.checkTreeSelect();
      if (!node) return;

      var tpt = this.tpt;
      tpt.update = false;
      tpt.title = "新增分类类别";
      tpt.visible = true;
      tpt.data = {
        parent: node.data.albumId,
        parentLabel: node.data.name,
        orderNum: 0
      };
    },
    // 修改模板类别
    updateTemplateType: function () {
      var node = this.checkTreeSelect();
      if (!node) return;

      var tpt = this.tpt;
      tpt.title = "修改分类类别";
      tpt.update = true;
      tpt.visible = true;
      tpt.data = node.data;
    },
    // 保存或者更新数据
    saveOrUpdateTemplateType: function () {
      var ins = this;
      var tpt = this.tpt;
      this.$refs.tptForm.validate(function (valid) {
        if (!valid) {
          return false;
        }
        if (tpt.update) {
          // 更新数据
          ajax_json("/MaterialAlbum/Album", "put", tpt.data, function (result) {
            if (result.status) {
              tpt.visible = false;
              ins.loadTreeData();
            }
          });
        } else {
          // 新增数据
          ajax_json("/MaterialAlbum/Album", "post", tpt.data, function (result) {
            if (result.status) {
              tpt.visible = false;
              ins.loadTreeData();
            }
          });
        }
      });
    },
    deleteTemplateType: function () {
      var ins = this;
      var tpt = this.tpt;
      var node = this.checkTreeSelect();
      if (!node) return;
      var data = node.data;
      if (node.children && node.children.length > 0) {
        $message("本节点包含子节点,如需删除请先删除子节点。", "warning", this);
        return;
      }
      this.$confirm("此操作将永久该分类数据, 是否继续?", "提示", {
        type: "warning"
      }).then(function () {
        // 删除数据
        ajax_json("/MaterialAlbum/Album/" + data.albumId, "delete", null, function (
          result
        ) {
          if (result.status) {
            tpt.visible = false;
            ins.loadTreeData();
          }
        });
      });
    },
    // 类别点击
    tptTreeClick: function (_data, node) {
      var ins = this;
      var data = _data.data; // 类别节点数据
      this.loadTpTypeData(data, ins);
    },
    //预览模板
    viewTemplate: function (tp) {
      _editor.setContent(tp.content);
      _editor.execCommand("preview");
    },
    // 新增模板
    addTemplate: function () {
      this.resetTemplate();

      this.tp.visible = true;
      this.tp.update = false;
      this.tp.title = "素材上传";

    },
    //重置模板类别
    resetTemplate() {
      this.tp.data = {
        title: "",
        content: "",
        albumId: '',
        albumIds: [],
        url: '',
        type: 'image',
        description: '',
        viewUrl: '',
        typeDisable: false,
        coverUrl: ''
      };
      _editor.setContent("");
    },
    // 修改模板
    updateTemplate: function (tp) {
      this.resetTemplate();
      this.tp.visible = true;
      this.tp.update = true;
      this.tp.title = "修改素材";
      this.tp.data = tp;
      tp.typeDisable = true;

      _editor.setContent(tp.content);
      var ids = getTpTypeIds(this.tp.data, this.tpt_data);
      this.tp.data.albumIds = ids;
    },
    // 删除模板
    delTemplate: function (tp) {
      var ins = this;
      var tpId = tp.materialId;
      if (!tpId) {
        $message("请选择要删除的素材!", "warning", ins);
        return;
      }
      var url = "/resource/Material/" + tpId;
      ajax_json(url, "delete", null, function (result) {
        if (result.status) {
          ins.loadTreeData();
          ins.reloadTpTypeData();
        }
      });
    },
    saveOrUpdateTemplate: function () {
      var ins = this;
      var tp = this.tp;
      this.$refs.tpForm.validate(function (valid) {
        if (!valid) return false;
        // 更新tpTypeIds
        var ids = tp.data.albumIds;
        tp.data.albumId = ids[ids.length - 1];
        tp.data.content = _editor.getContent();
        if (tp.data.type == 'text' && !_editor.hasContents()) {
          $message("请输入内容!", "warning", ins);
          return;
        }
        console.log(tp.data);
        if (tp.update) {
          // 更新数据
          ajax_json("/resource/Material", "put", tp.data, function (result) {
            if (result.status) {
              tp.visible = false;
              ins.loadTreeData();
              ins.reloadTpTypeData();
              ins.resetTemplate();
            }
          });
        } else {
          // 新增数据
          ajax_json("/resource/Material", "post", tp.data, function (result) {
            if (result.status) {
              tp.visible = false;
              ins.loadTreeData();
              ins.reloadTpTypeData();
              ins.resetTemplate();
            }
          });
        }
      });
    },
    handleAvatarSuccess(res, file) {
      console.log('上传资源信息:', res.msg);
      let res_type = this.tp.data.type;
      this.tp.data.contentType = res.type;
      this.tp.data.size = res.size;
      if (res_type == 'image') {
        this.tp.data.coverUrl = res.thumbnail ? res.thumbnail : res.url;
      } else {
        this.tp.data.coverUrl = res.screenshot;
      }
      this.tp.data.url = res.url;
      this.tp.data.original = res.original;
      this.tp.data.timeLength = res.length; //时间长度
      if (res_type == 'text') {
        this.tp.data.contentType = "text/html";
        this.tp.data.coverUrl = res.thumbnail ? res.thumbnail : res.url;
        this.tp.data.url = null;
      }
      if(res_type == 'audio'){
        this.tp.data.coverUrl = '/assets/img/timg.png';
      }
    },
    beforeAvatarUpload(file) {
      const isType = file.type.startsWith('image');
      const isLt2M = file.size / 1024 / 1024 < 2;

      if (!isType) {
        this.$message.error('上传封面不许为图片!');
      }
      if (!isLt2M) {
        this.$message.error('上传资源大小不能超过 2MB!');
      }
      return isType && isLt2M;
    },
    beforeResourceUpload(file) {
      let type = this.tp.data.type;
      const isType = file.type.startsWith(type);
      const isLt2M = file.size / 1024 / 1024 < 200;

      if (!isType) {
        this.$message.error('上传文件资源和选择资源类型不符!');
      }
      if (!isLt2M) {
        this.$message.error('上传资源大小不能超过 200MB!');
      }
      return isType && isLt2M;
    },
    choseProgramTemplate(pt) {
      console.log("已选择节目模版", pt)
      this.ptw.visiable = false;
      this.tp.data.programTemplate = pt.programId;
      this.tp.data.programTemplateName = pt.name;
      this.tp.programTempate = pt;
      this.tp.data.categoryId = pt.categoryId;
    },
    handleSizeChange(val) {
      this.tpager.size = val;
      this.loadTpTypeData();
    },
    handleCurrentChange(val) {
      this.tpager.current = val;
      this.loadTpTypeData();
    },
    getResUrl(url) {
      return serverConfig.getUrl(url);
    }
  }
});


// 编辑器
var _editor = UE.getEditor("templateText", {

});

function getTpTypeIds(data, tpt_data) {
  var ay = [];
  pathScan(ay, data, tpt_data);
  return ay.reverse().map(function (a) {
    return a.pid;
  });
}

// 深度遍历路径
function pathScan(ay, data, tpt_data) {
  var pid = data.albumId;

  for (var i = 0; i < tpt_data.length; i++) {
    var v = tpt_data[i];
    if (v.children) {
      pathScan(ay, data, v.children);
      if (ay.length > 0) {
        var cn = ay[ay.length - 1];
        if (v.data.albumId == cn.parent) {
          ay.push({
            pid: v.data.albumId,
            parent: v.data.parent
          });
        }
      }
    } else {
      if (ay.length == 0) {
        // 找到了位置
        if (v.data.albumId == pid) {
          ay.push({
            pid: pid,
            parent: v.data.parent
          });
        }
      } else {
        var cn = ay[ay.length - 1];
        if (v.data.albumId == cn.parent) {
          ay.push({
            pid: v.data.albumId,
            parent: v.data.parent
          });
        }
      }
    }
  }
}