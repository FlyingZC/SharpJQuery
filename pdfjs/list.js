var app1 = new Vue({
				el: "#app1",
				data: {
					attractionList: [],
					themeList:[],
					dictListObj:{},
					inland:[]
				},
				methods: {
					findAttractionBySeasonAjax: function() {
						var currMonth = new Date().getMonth() + 1; //0
						var that=this;
						$.getJSON("findAttractionBySeason/" + [currMonth,currMonth+1] + ".do", function(result) {
							if(result) {
								that.attractionList=result;
							}
						});
					},
					detail:function(attraction){
						window.location.href='showAttractionDetailPage/'+attraction.id+'.do';
					},
					findAttractionByThemeAjax:function(){
						var that=this;
						//默认加载前9个主题
						$.getJSON("findAttractionByTheme.do", function(result) {
							if(result) {
								that.themeList=result;
							}
						});
					},
					findAttractionByDictAjax:function(dictName){
						var that=this;
						//默认加载前9个主题
						$.getJSON("findAttractionByDict/"+dictName+".do", function(result) {
							if(result) {
								console.log(result);
								that.inland=result;
							}
						});
					},
					dealHref: function(attractionId) {
						return "/MyTravel/attraction/showAttractionDetailPage/"+attractionId+".do";
					},
					dealSeasonHref:function(seasonId){debugger;
						  return "/MyTravel/foreground/attraction/page-list.jsp?seasonId="+seasonId;
					},
					dealThemeHref:function(themeId){
						window.location.href="/MyTravel/foreground/attraction/page-list.jsp?themeId="+themeId;
					},
					dealAreaHref:function(areaId){
						window.location.href="/MyTravel/foreground/attraction/page-list.jsp?areaId="+areaId;
					},
					dealMonthBg:function(monthId){
						var left=-(monthId-1)*75;
						return "background: url(/MyTravel/static/images/attraction/list/month-bg.png) no-repeat 0 "+left+"px";
					}
				},
				filters: {

				},
				computed: {
					
				},
				created:function(){
					var that = this;
					that.findAttractionBySeasonAjax();
					that.findAttractionByThemeAjax();
					that.findAttractionByDictAjax("inland");
				},
				mounted: function() { //参见vue生命周期.相当于ready
					/*var that=this;
					this.$nextTick(function() { 
						that.findAttractionBySeasonAjax();
						that.findAttractionByThemeAjax();
						that.findAttractionByDictAjax("inland");
					})*/
				}
			});
			
/*Vue.component('attraction-image-comp',{
	template:'<img class="attraction-img" src="${pageContext.request.contextPath}/static/images/attraction/list/attraction_mogaoku.jpg" 
								v-bind:style="attractionImageStyle"/>',
	data:{
		attractionImage:''
	}
});*/
$(function(){
	//修改导航栏状态
	$(".nav .active").removeClass("active");
	$(".nav #nav-attraction").addClass("active");
});
