//开发插件
//(function($){...})(jQuery)实际上是匿名函数
//function(arg){...}为 定义一个匿名函数,参数为arg.
//(function(arg){...})(param);定义一个匿名函数后,立即传param调用该函数
(function($){
	var methods={
		init:function(args,args2){
			console.log("--init--"+args+args2);
		},
		show:function(options){
			console.log("--show--");
		},
		hide:function(options){
			console.log("--hide--");
		},
		update:function(options){
			console.log("--update--");
		}
	};
	
	$.fn.myFun1=function(){
		alert("myFun1");
	};
	$.fn.maxHeight=function(){
		var max=0;
		this.each(function(){
			max=Math.max(max,$(this).height());
		});
		return max;
	}
	
	$.fn.myTool=function(method){
		if(methods[method]){
			for(var i=0;i<arguments.length;i++){
				console.log(arguments[i]);				
			}
			var a=arguments[1];
			console.log(a);
			methods[method].apply(this, Array.prototype.slice.call(arguments,1));
			return methods[method].apply(this, Array.prototype.slice.call(arguments,1));
		}
	};
	
	$(function(){
		$("div").maxHeight();
		$("div").myTool("init",{
			name:"zdx"
		},"hehe");
	});
})(jQuery);
