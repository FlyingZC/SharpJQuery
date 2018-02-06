//定义公共操作 js公共代码
Function.prototype.delegate = function(context, params) {
	var func = this;
	return function() {
		if(params == null) {
			return func.apply(context);
		}
		return func.apply(context, params);
	};
};

var commonOp = {
	coverObject: function(obj1, obj2) {

		var o = this.cloneObject(obj1, false);
		var name;
		for(name in obj2) {
			if(obj2.hasOwnProperty(name)) {
				o[name] = obj2[name];
			}
		}
		return o;
	},

	cloneObject: function(obj, deep) {
		if(obj === null) {
			return null;
		}
		var con = new obj.constructor();
		var name;
		for(name in obj) {
			if(!deep) {
				con[name] = obj[name];
			} else {
				if(typeof(obj[name]) == "object") {
					con[name] = commonOp.cloneObject(obj[name], deep);
				} else {
					con[name] = obj[name];
				}
			}
		}
		return con;
	},

	///说明：
	///      创建委托
	delegate: function(func, context, params) {
		if((typeof(eval(func)) == "function")) {
			return func.delegate(context, params);
		} else {
			return function() {};
		}
	},

	getParam: function(param) {
		if(typeof(param) == "undefined") {
			return "";
		} else {
			return param;
		}
	},

	//说明：
	//  判断HTML元素是否存在 某个属性   true：不包含   false:包含 
	boolHasAttr: function(id, attr) {

		if(typeof(document.getElementById(id).attributes[attr]) != "undefined") {
			return false;
		}
		return true;
	},

	IsNull: function(str) {
		if(str.trim() == "" || isNaN(str)) {
			return true;
		}
		return false;
	},

	//说明：
	//  是否存在指定函数 
	isExitsFunction: function(funcName) {
		try {
			if(typeof(eval(funcName)) == "function") {
				return true;
			}
		} catch(e) {}
		return false;
	},

	//说明：
	//  是否存在指定变量 
	isExitsVariable: function(variableName) {
		try {
			if(typeof(variableName) == "undefined") {
				return false;
			} else {
				return true;
			}
		} catch(e) {}
		return false;
	},

	//说明：
	//  判断输入框中输入的日期格式为yyyy-mm-dd和正确的日期   短日期，形如 (2008-07-22)
	IsDate: function(str) {
		var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
		if(r == null) {
			return false;
		}
		var d = new Date(r[1], r[3] - 1, r[4]);
		return(d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4]);
	},

	//判断样式是否存在
	hasClass: function(obj, cls) {
		return obj.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
	},

	//为指定的dom元素添加样式
	addClass: function(obj, cls) {
		if(!this.hasClass(obj, cls)) {
			obj.className += " " + cls;
		}
	},

	//删除指定dom元素的样式
	removeClass: function(obj, cls) {
		if(this.hasClass(obj, cls)) {
			var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
			obj.className = obj.className.replace(reg, ' ');
		}
	},

	//如果存在(不存在)，就删除(添加)一个样式
	toggleClass: function(obj, cls) {
		if(this.hasClass(obj, cls)) {
			this.removeClass(obj, cls);
		} else {
			this.addClass(obj, cls);
		}
	},

	// 判断是否是函数
	isFunc: function(func) {
		return(typeof(eval(func)) == "function");
	},

	//初始化xhr
	initRequest: function() {
		var request = false;
		if(window.XMLHttpRequest) { //FireFox
			request = new XMLHttpRequest();
			if(request.overrideMimeType) {
				request.overrideMimeType('text/xml');
			}
		} else if(window.ActiveXObject) { //IE
			try {
				request = new ActiveXObject("Msxml2.XMLHTTP");
			} catch(e) {
				try {
					request = new ActiveXObject("Microsoft.XMLHTTP");
				} catch(e) {}
			}
		}
		if(!request) {
			window.alert("Create request error!");
			return false;
		}
		return request;
	},

	//js 发送ajax
	//参数说明：
	//  sendUrl      ：发送地址
	//  sendData     ：发送数据
	//  type         ：请求类型（post/get）
	//  isAsync      ：是否是一部
	//  callBackFunc ：回调函数
	sendAjax: function(sendUrl, sendData, type, isAsync, callBackFunc) {
		var httpRequest = commonOp.initRequest();
		if(!httpRequest) {
			return null;
		}

		httpRequest.onreadystatechange = function() {
			//readyState共有5中状态，0未初始化，1已初始化，2发送请求，3开始接收结果，4接收结果完毕。
			//status服务器响应状态码
			if(httpRequest.readyState == 4) {
				if(httpRequest.status == 200) {
					var text = httpRequest.responseText;
					if(commonOp.isFunc(callBackFunc)) {
						callBackFunc(text); //指定请求返回时的回调函数
					}
				} else if(httpRequest.status == 404) {
					alert("请求资源不存在！");
				}
			}
		};

		//get
		if(type.toUpperCase() === "GET") {
			httpRequest.open("GET", sendUrl, isAsync);
			httpRequest.send(sendData);
		}
		//post
		if(type.toUpperCase() === "POST") {
			httpRequest.open("POST", sendUrl, isAsync);
			httpRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			httpRequest.send(sendData);
		}
		return null;
	},

	/*************************验证信息begin*******************************/
	//验证手机号码(简单验证)
	//验证规则：11位数字，以1开头。
	isMobile: function(str) {
		var re = /^1\d{10}$/;
		return re.test(str);
	},

	//验证电话号码
	//验证规则：区号+号码，区号以0开头，3位或4位
	//号码由7位或8位数字组成
	//区号与号码之间可以无连接符，也可以“-”连接
	//如01088888888,010-88888888,0955-7777777 
	isPhone: function(str) {
		var re = /^0\d{2,3}-?\d{7,8}$/;
		return re.test(str);
	},

	//验证邮箱
	isEmail: function(str) {
		var reg = /^[0-9a-z][_.0-9a-z-]{0,31}@([0-9a-z][0-9a-z-]{0,30}\.){1,4}[a-z]{2,4}$/;
		return reg.test(str);
	}

	/*************************验证信息 end *******************************/
};


//业务公共代码部分
//这里仅仅对页面控件id前缀进行了定义，目的就是为了实现控件的复用性！
//定义id前缀
var defineIdPrefix = {
    FirstPage: "firstPage_",
    PreviousPage: "previousPage_",
    PageCount: "pageCount_",
    PageNo: "pageNo_",
    NextPage: "nextPage_",
    LastPage: "lastPage_"
};

//业务逻辑实现代码 ,pagging逻辑实现
(function () {

    //定义id前缀
    var defineIdPrefix = {
        FirstPage: "firstPage_",
        PreviousPage: "previousPage_",
        PageCount: "pageCount_",
        PageNo: "pageNo_",
        NextPage: "nextPage_",
        LastPage: "lastPage_"
    };

    var paging = function () {
        this.defaultParams = {
            id: "",
            url: "",
            sendData: "",   //请求参数
            pageSize: 10,   //页大小
            callback: function () { } //回调函数
        };
    };

    paging.prototype = {
        constructor: paging,

        init: function (params) {
            this.options = commonOp.coverObject(this.defaultParams, params);

            this._init();
        },

        _init: function () {
            if (!document.getElementById(defineIdPrefix.FirstPage + this.options.id)) {
                this.createPagingHtml();
            }

            //初始化时候主动发起请求，获取第一页的信息
            this.senAjaxRequest(1);

            //注册事件
            this._registerFirstPageClick();
            this._registerPreviousPageClick();
            this._registerNextPageClick();
            this._registerLastPageClick();
        },

        //创建分页html
        createPagingHtml: function () {
            var id = this.options.id;
            var pagingHtml = "";
            pagingHtml += "<div class='paging-opArea paging-enable' id='" + defineIdPrefix.FirstPage + id + "'>[首页]</div>";
            pagingHtml += "<div class='paging-opArea paging-enable' id='" + defineIdPrefix.PreviousPage + id + "'>上一页</div>";
            pagingHtml += "<div class='paging-pageInfo' attrCount='1' id='" + defineIdPrefix.PageCount + id + "'>共1页</div>";
            pagingHtml += "<div class='paging-pageInfo' attrNo='1' id='" + defineIdPrefix.PageNo + id + "'>第1页</div>";
            pagingHtml += "<div class='paging-opArea paging-enable' id='" + defineIdPrefix.NextPage + id + "'>下一页</div>";
            pagingHtml += "<div class='paging-opArea paging-enable' id='" + defineIdPrefix.LastPage + id + "'>[尾页]</div>";

            var divEl = document.createElement("div");
            divEl.className = "paging";
            divEl.id = "paging_" + id;
            divEl.innerHTML = pagingHtml;
            document.getElementById(id).appendChild(divEl);
        },

        /***********************************(注册事件 begin)***********************************/

        //注册首页事件
        _registerFirstPageClick: function () {
            var id = defineIdPrefix.FirstPage + this.options.id;
            var handleEvent = commonOp.delegate(this._handleFirstPageClick, this);
            document.getElementById(id).onclick = handleEvent;
        },

        //注册上一页事件
        _registerPreviousPageClick: function () {
            var id = defineIdPrefix.PreviousPage + this.options.id;
            var handleEvent = commonOp.delegate(this._handlerPreviousPageClick, this);
            document.getElementById(id).onclick = handleEvent;
        },

        //注册下一页页事件
        _registerNextPageClick: function () {
            var id = defineIdPrefix.NextPage + this.options.id;
            var handleEvent = commonOp.delegate(this._handleNextPageClick, this);
            document.getElementById(id).onclick = handleEvent;
        },

        //注册尾页事件
        _registerLastPageClick: function () {
            var id = defineIdPrefix.LastPage + this.options.id;
            var handleEvent = commonOp.delegate(this._handleLastPageClick, this);
            document.getElementById(id).onclick = handleEvent;

        },

        /***********************************(注册事件  end )***********************************/

        /***********************************(事件句柄 begin)***********************************/

        //注册首页事件
        _handleFirstPageClick: function () {
            var pageNo = 1;
            if (this.getPageNo() == pageNo) {
                alert("已经是第一页！");
                return;
            }
            this.senAjaxRequest(pageNo);
        },

        //注册上一页事件
        _handlerPreviousPageClick: function () {
            var value = this.getPageNo();
            var pageNo = value - 1;
            this.senAjaxRequest(pageNo);
        },

        //注册下一页页事件
        _handleNextPageClick: function () {
            var value = this.getPageNo();
            var pageNo = value + 1;
            this.senAjaxRequest(pageNo);
        },

        //注册尾页事件
        _handleLastPageClick: function () {
            var pageNo = this.getPageCount();
            if (this.getPageNo() == pageNo) {
                alert("已经是最后一页！");
                return;
            }
            this.senAjaxRequest(pageNo);
        },

        /***********************************(事件句柄  end )***********************************/

        //发送ajax请求，获取表格数据
        senAjaxRequest: function (pageNo) {
            if (!this.isPageNoValid(pageNo)) {
                return;
            }
            var options = this.options;
            var sendUrl = options.url;

            var sendData = "pageSize=" + options.pageSize + "&pageNo=" + pageNo;
            if (options.sendData != "") {
                sendData += "&" + options.sendData;
            }
            var type = "post";

            //发送ajax请求。注意作用域
            commonOp.sendAjax(sendUrl, sendData, type, true, function (ret) {
                var objRet = eval('(' + ret + ')');
                var gridData, pageCount;
                if (objRet == null || objRet == undefined || objRet == "null") {
                    gridData = null;
                    pageCount = null;
                }
                else {
                    gridData = objRet.Data;
                    pageCount = objRet.PageCount;
                }

                if (commonOp.isFunc(options.callback)) {
                    var callbackRet = options.callback(gridData);
                    if (callbackRet) {
                        //设置共几页和第几页
                        paging.prototype.setPageCountText(options, pageCount);
                        paging.prototype.setPageNoText(options, pageNo);
                    }
                }
            });
        },

        //判断页码是否有效
        isPageNoValid: function (pageNo) {
            if (parseInt(pageNo) < 1) {
                alert("已经是第一页！");
                return false;
            }
            if (parseInt(pageNo) > parseInt(this.getPageCount())) {
                alert("已经是最后一页！");
                return false;
            }
            return true;
        },

        //设置总页数
        setPageCountText: function (options, pageCount) {
            var id = defineIdPrefix.PageCount + options.id;
            var pageCountEl = document.getElementById(id);
            pageCountEl.innerHTML = "共" + pageCount + "页";
            pageCountEl.setAttribute("attrCount", pageCount);
        },

        //设置第几页
        setPageNoText: function (options, pageNo) {
            var id = defineIdPrefix.PageNo + options.id;
            var pageNoEl = document.getElementById(id);
            pageNoEl.innerHTML = "第" + pageNo + "页";
            pageNoEl.setAttribute("attrNo", pageNo);
        },

        //获取当前的页码
        getPageNo: function () {
            var id = defineIdPrefix.PageNo + this.options.id;
            var pageNoEl = document.getElementById(id);
            var value = parseInt(pageNoEl.getAttribute("attrNo"));
            return parseInt(value);
        },

        //获取当前的总页数
        getPageCount: function () {
            var id = defineIdPrefix.PageCount + this.options.id;
            var pageNoEl = document.getElementById(id);
            var value = parseInt(pageNoEl.getAttribute("attrCount"));
            return parseInt(value);
        }

    };

    window.paging = paging;
})();   

