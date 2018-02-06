;(function($){
	$.fn.extend({
		"myColor":function(value){
			//定义默认值.若传入$("#xx").myColor({odd:"myOdd",even:"myEven",selected:"selected"});则使用自定义的值
			//否则传入$("#xx").myColor()则使用默认值
			value=$.extend({
				odd:"odd",
				even:"even",
				selected:"selected"
			},value);
			//这里写插件代码,this为jQuery对象
			console.log(value);
			if(value==undefined||value==null||value==""){
				return this.css("color");
			}
			return this.css("color",value);
		},
		"myBorder":function(){
			
		}
	});
	//调用
	$(function(){
		$("div").myColor("red");
	});
})(jQuery);
