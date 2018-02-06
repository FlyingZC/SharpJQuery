<%@page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title></title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/bootstrap3/css/bootstrap.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/travel.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/js/slidebox/css/jquery.slideBox.css" />
		<script src="${pageContext.request.contextPath}/static/js/jquery-2.1.4.js"></script>
		<script src="${pageContext.request.contextPath}/static/js/slidebox/jquery.slideBox.js"></script>
		<script src="${pageContext.request.contextPath}/static/js/travel/common-tool.js"></script>

		<style>
			ul {
				list-style: none;
			}
			
			#rightNav>li .nav-item-name {
				cursor: pointer;
				width: 190px;
				height: 46px;
				line-height: 46px;
				padding-left: 13px;
				background: url(${pageContext.request.contextPath}/static/images/attraction/list/menu-item-bg01.png) no-repeat;
			}
			
			.nav-item-name-current {
				cursor: pointer;
				background: blue !important;
				width: 157px !important;
				color: white;
				-webkit-border-radius: 10px;
				/*圆角矩形半径*/
				box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
			}
			
			#rightNav .rightMenu {
				border: 2px solid blue;
				-webkit-border-radius: 10px;
				box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
				position: absolute;
				left: 160px;
				width: 250px;
				z-index: 100;
				background-color: white;
				padding: 5px 10px;
				display: none;
			}
			
			#rightNav .rightMenu a:hover {
				cursor: pointer;
			}
			
			.attraction-img {
				width: 320px;
				height: 210px;
			}
			
			.attraction-img:hover {
				cursor: pointer;
			}
			
			.img-descr {
				position: absolute;
				background-color: rgba(0, 0, 0, 0.6);
				width: 320px;
				height: 60px;
			}
			
			.month-bg {
				width: 113px;
				height: 60px;
				/*距离左,上距离.负值越小越靠近左上角,第四象限*/
				background: url(${pageContext.request.contextPath}/static/images/attraction/list/bubble-bg.png) no-repeat 0 0px;
				overflow: hidden;
				display: inline-block;
			}
			
			.month-name {
				font-size: 32px;
				margin-left: 29px;
				font-weight: normal;
				color: white;
				margin-top: 6px;
			}
			
			.bubble-bg {
				width: 113px;
				height: 60px;
				/*距离左,上距离.负值越小越靠近左上角,第四象限*/
				background: url(${pageContext.request.contextPath}/static/images/attraction/list/bubble-bg.png) no-repeat 0 0px;
				overflow: hidden;
				display: inline-block;
			}
			
			.month-bg:hover {
				cursor: pointer;
			}
			
			.month-simple-word {
				display: inline-block;
				/*默认底部对齐*/
				vertical-align: top;
				padding-top: 7px;
				padding-left: 20px;
			}
			
			.attraction-name {
				font-size: 20px;
				margin-left: 30px;
				font-weight: normal;
				color: white;
				margin-top: 3px;
			}
			
			.attraction-name:hover {
				cursor: pointer;
				color: orange;
			}
			
			.attraction-item .attraction-name {
				padding-top: 10px;
			}
			
			.attraction-item .attraction-simple {
				padding-top: 10px;
			}
			
			.attraction-simple {
				font-size: 15px;
				color: white;
			}
		</style>
		<script>
			$(function() {
				initEventBind();
				initPageData();
			});
			var initEventBind = function() {
				//由于菜单在li里,所以也在hover范围内
				$("#rightNav>li").hover(function() {
					$(this).find(".nav-item-name").addClass("nav-item-name-current").css("cursor", "pointer");
					//stop立即停止当前动画
					$(this).find(".rightMenu").stop().show(500);
				}, function() {
					$(this).find(".nav-item-name").removeClass("nav-item-name-current");
					$(this).find(".rightMenu").stop().hide(500);
				}).mousemove(function() {
					$(this).find(".nav-item-name").css("cursor", "pointer");
					$(this).find(".rightMenu a").css("cursor", "pointer");
				});
				commonTool.initSlideBoxAndData("attraction");
			}

			var initPageData = function() {
				loadMenu();
				//loadAttractionBySeason();
			}

			var loadMenu = function() {
				findMenuDataAjax();
			}

			var showMenuData = function(menuData) {
				debugger;
				$("#rightNav .menuItemDescr").each(function(i, elem) {
					if(!menuData[i]) {
						$(this).empty();
						return;
					}
					var currMenuItem = menuData[i];
					$(this).text(currMenuItem["menuItemDescr"]).data("menuId", currMenuItem["menuId"]);

					var dictArray = currMenuItem["dicts"];
					$(this).next(".rightMenu").find(".item").each(function(i, elem) {
						if(!dictArray[i]) {
							$(elem).parent("li").remove();
							return;
						}
						var currDict = dictArray[i];
						$(elem).text(currDict["itemDescr"]);

						var attractions = currDict["attractions"];
						$(this).siblings(".attraction").each(function(i, elem) { //elem为每个attraction,每个<a>
							if(!attractions[i]) {
								$(elem).remove();
								return;
							}
							var currAttraction = attractions[i];
							$(elem).text(currAttraction["attractionName"]).data("attractionId", currAttraction["id"]);
							$(elem).attr("href", "/MyTravel/attraction/showAttractionDetailPage/" + currAttraction.id + ".do");
						});
					});

				});
			}

			var showSlideImage = function(topObjs) {
				$("#indexSlideBox .items li").each(function(index) {
					var currObj = topObjs[index];
					var url = "${pageContext.request.contextPath}/attraction/showAttractionDetailPage/" + currObj.id + ".do";
					$(this).attr("noteId", currObj.id);
					$(this).find("a").attr("title", currObj.attractionName)
						.attr("href", url);
					$(this).find("img").attr("src", currObj.attractionImage);
					$(this).click(function() {
						window.location.href = url;
					});
				});
			}

			var loadAttractionBySeason = function() {
				var currMonth = new Date().getMonth() + 1; //0
				//加载当月 和 下月 流行景点
				findAttractionBySeasonAjax([currMonth, currMonth + 1]);
			}

			var findMenuDataAjax = function() {
				$.getJSON("showMenu.do", function(result) {
					if(result) {
						showMenuData(result);
					}
				});
			}

			var showSeasonAttraction = function() {
				$("#seasonAttraction").find(".attraction-season-item").each(function() {

				});
			}
		</script>
	</head>

	<body class="container">
		<%@include file="../common/top.jsp"%>
		<div class="row">
			<div class="col-md-2">
				<ul id="rightNav">
					<li>
						<div class="row">
							<div class="nav-item-name col-md-4 menuItemDescr">Top推荐</div>
							<div style="" class="rightMenu">
								<div style="">
									<ul>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</li>
					<!--End one li-->
					<li>
						<div class="row">
							<div class="nav-item-name col-md-4 menuItemDescr">Top推荐</div>
							<div style="" class="rightMenu">
								<div style="">
									<ul>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</li>
					<!--End one li-->
					<li>
						<div class="row">
							<div class="nav-item-name col-md-4 menuItemDescr">Top推荐</div>
							<div style="" class="rightMenu">
								<div style="">
									<ul>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</li>
					<!--End one li-->
					<li>
						<div class="row">
							<div class="nav-item-name col-md-4 menuItemDescr">Top推荐</div>
							<div style="" class="rightMenu">
								<div style="">
									<ul>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</li>
					<!--End one li-->
					<li>
						<div class="row">
							<div class="nav-item-name col-md-4 menuItemDescr">Top推荐</div>
							<div style="" class="rightMenu">
								<div style="">
									<ul>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</li>
					<!--End one li-->
					<li>
						<div class="row">
							<div class="nav-item-name col-md-4 menuItemDescr">Top推荐</div>
							<div style="" class="rightMenu">
								<div style="">
									<ul>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
										<li>
											<span class="item">华南</span> |
											<a class="attraction">海边</a>
											<a class="attraction">三亚</a>
											<a class="attraction">北海</a>
											<a class="attraction">苏梅岛</a>
											<a class="attraction">帕劳巴厘岛</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</li>
					<!--End one li-->
				</ul>
			</div>
			<!--End col-md-4-->
			<div class="col-md-8">
				<!--slidebox图片轮播-->
				<div id="indexSlideBox" class="slideBox">
					<ul class="items">
						<li>
							<a href="" title="这里是测试标题一"><img src="${pageContext.request.contextPath}/static/js/slidebox/img/1.jpg" style="width:640px;"></a>
						</li>
						<li>
							<a href="" title="这里是测试标题二"><img src="${pageContext.request.contextPath}/static/js/slidebox/img/2.jpg" style="width:640px;"></a>
						</li>
						<li>
							<a href="" title="这里是测试标题三"><img src="${pageContext.request.contextPath}/static/js/slidebox/img/3.jpg" style="width:640px;"></a>
						</li>
						<li>
							<a href="" title="这里是测试标题四"><img src="${pageContext.request.contextPath}/static/js/slidebox/img/4.jpg" style="width:640px;"></a>
						</li>
						<li>
							<a href="" title="这里是测试标题五"><img src="${pageContext.request.contextPath}/static/js/slidebox/img/5.jpg" style="width:640px;"></a>
						</li>
					</ul>
				</div>
			</div>
			<!--End col-md-8-->
		</div>
		<!--End row-->
		<div id="app1">

			<div class="row nav-row">
				<div class="col-md-4">
					<img src="${pageContext.request.contextPath}/static/images/index/title_label.png" class="title-label" />
					<span class="index-title nav-font">当季游</span>
				</div>
				<div class="col-md-2 col-md-offset-6">
					<a v-bind:href="dealSeasonHref(attractionList[0].seasonId)" class="more">更多...</a>
				</div>
			</div>
			<!--End row-->
			<div class="row">
				<div class="col-md-4 attraction-season-item" v-for="(season,index) in attractionList">
					<template v-for="(attraction,i) in season['attractions']">
						<template v-if="i==0">
							<div class="img-descr">
								<div class="month-bg">
									<div class="month-name">{{season.seasonId}}月</div>
								</div>
								<div class="month-simple-word">
									<div class="attraction-name">{{attraction["attractionName"]}}</div>
									<div class="attraction-simple">{{attraction["simpleDescr"]}}</div>
								</div>
							</div>

							<div class="">
								<!--<attraction-image-comp></attraction-image-comp>-->
								<img class="attraction-img" v-bind:src="attraction['attractionImage']" v-on:click="detail(attraction)" />
							</div>
						</template>
						<template v-else>
							<div class="other-attraction">
								<div>
									<a v-bind:href="dealHref(attraction['id'])">{{attraction["attractionName"]}}</a><span>：{{attraction["simpleDescr"]}}</sapn>
								</div>
							</div>	
						</template>
					</template>
				</div>
			<!--End col-md-6 attraction-season-item-->
		</div>
		<!--End row-->
		<div class="row nav-row">
			<div class="col-md-4">
				<img src="${pageContext.request.contextPath}/static/images/index/title_label.png" class="title-label"/>
				<span class="index-title nav-font">主题游</span>
			</div>
			<div class="col-md-2 col-md-offset-6">
				<a href="/MyTravel/foreground/attraction/page-list.jsp" class="more">更多...</a>
			</div>
		</div>
		<!--End row-->
		<div class="row" v-for="n in 3">

			<div class="col-md-4 attraction-item" v-for="(theme,index) in themeList">
				<template v-if="index>=(n-1)*3&&index<=n*3-1">
					<template>
						<div class="img-descr">
							<div class="bubble-bg">
								<div class="attraction-name" v-on:click="dealThemeHref(theme['themeId'])">{{theme["themeName"]}}</div>
							</div>
							<div class="month-simple-word">
								<div class="attraction-simple">{{theme["themeDescr"]}}</div>
							</div>
						</div>

						<div class="">
							<!--<attraction-image-comp></attraction-image-comp>-->
							<img class="attraction-img" v-bind:src="theme['themePic']" v-on:click="dealThemeHref(theme['themeId'])"/>
						</div>
					</template>
					<template v-for="(attraction,i) in theme['attractions']">
						<div class="other-attraction">
							<div>
								<a v-bind:href="dealHref(attraction['id'])">{{attraction["attractionName"]}}</a><span>：{{attraction["simpleDescr"]}}</sapn>
							</div>
						</div>	
					</template>
				</template>
			</div>
			<!--End col-md-6 attraction-item-->
		</div>
		<!--End row-->
		<div class="row nav-row">
			<div class="col-md-4">
				<img src="${pageContext.request.contextPath}/static/images/index/title_label.png" class="title-label"/>
				<span class="index-title nav-font">国内游</span>
			</div>
			<div class="col-md-2 col-md-offset-6">
				<a href="/MyTravel/foreground/attraction/page-list.jsp" class="more">更多...</a>
			</div>
		</div>
		<!--End row-->
		<!--国内-->
		<div class="row" v-for="n in 3">
			<div class="col-md-4 attraction-item" v-for="(dict,index) in inland">
				<template v-if="index>=(n-1)*3&&index<=n*3-1">
					<template v-for="(attraction,i) in dict['attractions']">
						<template v-if="i==0">
							<div class="img-descr">
								<div class="bubble-bg">
									<div class="attraction-name" v-on:click="dealAreaHref(dict.dictId)">{{dict["itemDescr"]}}</div>
								</div>
								<div class="month-simple-word">
									<div class="attraction-simple">{{attraction["simpleDescr"]}}</div>
								</div>
							</div>

							<div class="">
								<!--<attraction-image-comp></attraction-image-comp>-->
								<img class="attraction-img" v-bind:src="attraction['attractionImage']" v-on:click="detail(attraction)" />
							</div>
						</template>
						<template v-else>
							<div class="other-attraction">
								<div>
									<a v-bind:href="dealHref(attraction['id'])">{{attraction["attractionName"]}}</a><span>：{{attraction["simpleDescr"]}}</sapn>
								</div>
							</div>	
						</template>
					</template>
				</template>
			</div>
			<!--End col-md-6 attraction-item-->
		</div>
		</div>	<!--End app1-->
		<script src="${pageContext.request.contextPath}/static/js/vue.js"></script>
		<script src="${pageContext.request.contextPath}/foreground/attraction/list.js"></script>
	</body>

</html>