$(function(){
	//21-94 定义一些变量 和 函数 
	//比较重要的 61行jQuery=function(){};
	// Define a local copy of jQuery
	jQuery = function( selector, context ) {
		// The jQuery object is actually just the init constructor 'enhanced'
		return new jQuery.fn.init( selector, context, rootjQuery );
	},
	
//96-283行 给jQuery对象,基于面对象 ,给jQuery对象添加一些方法和属性
	//$("#div").css();这种用法类似于使用对象(或函数执行后返回一个jQuery对象,再)调用方法
	jQuery.fn = jQuery.prototype = {
		jquery: core_version,版本
		constructor:修正指向问题
		init():初始化和参数管理
		selector:存储选择字符串
		length:this对象的长度
		toArray():转为数组
		get():转为原生集合
		pushStack():jQ对象的入栈
		each():遍历集合
		ready():dom加载的接口
		slice():集合的截取
		first():集合的第一项
		last():集合的最后一项
	}
	
	//60行 即$("#div")返回一个对象,继续调用css()等方法
	// Define a local copy of jQuery
	jQuery = function( selector, context ) {
		// The jQuery object is actually just the init constructor 'enhanced'
		return new jQuery.fn.init( selector, context, rootjQuery );
	},


//285-347行  jQuery.extend是jQuery中的一个继承方法.即后续添加方法时,可以通过jQuery.extend挂载到jQuery对象下
	jQuery.extend = jQuery.fn.extend = function() {
		
	}
	
//349-817行 使用jQuery.extend()拓展工具方法(静态方法)
	jQuery.extend({
	//$("#a").css():前面选择器函数返回一个对象,调用css方法.实例方法
	//$.trim():$为一个函数.既可以给jQuery对象或原生js使用.静态方法
	

//877行-2856行:Sizzle:复杂选择器的一个实现
	(function( window, undefined ) {
		var i,
		support
		

//2880行-3042行 Callbacks:回调函数:函数的一个统一管理

//3043行-3183行 Deferred:延迟对象:对异步的统一管理

//3184行-3295行 support:功能检测 
	
//3308行-3652行 data():数据缓存

//3653行-3797行 queue(),deque():队列管理,入队,出队(常用于动画)

//3803行-4299行 attr(),prop(),val(),addClass()等对元素属性的操作

//4300行-5128行 on(),trigger():事件操作的相关方法

//5140行-6057行 DOM操作:添加append(),删除,获取,包装,DOM筛选

//6058行-6620行 css():样式的操作(兼容性支持)

//6621行-7854行 提交的数据和ajax的操作 ajax(),load(),getJSON()

//7855行-8584行 animate(),show(),hide()等:动画的方法

//8585行-8792行 offset():位置与尺寸的方法

//8804行-8821行 jQuery支持模块化的模式

//8826行至结尾 window.jQuery=window.$=jQuery;对外提供的接口
})();
