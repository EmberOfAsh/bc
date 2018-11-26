<%@ page language="java" contentType="text/html;charset=UTF-8"
pageEncoding="UTF-8"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":"
+ request.getServerPort() + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>党员信息管理</title>
	<%@include file="/include/head_notbootstrap.jsp"%>
	<script type="text/javascript" src="/json/address-pca.json"></script>
	<style type="text/css">
	body {
		
	}
	#partyUser_manager_pagesdididi {
		text-align: center;
	}
	.el-row {
		margin-bottom: 10px;
	}
	.partyUserTitleFont {
		font-weight:bold;
		font-size:16px
	}
	.partyUserForm .el-input {
		width: 160px;
	}
	.el-date-editor {
		width: 160px;
	}
	.box{
		width: 340px;
		height: 200px;
		border-radius: 10px;
		transition: transform 0.2s,box-shadow 0.3s;
		padding: 20px;
		margin-bottom: 10px;
		float:left;
		margin-left: 10px;
		background-size: 100% 100%;
		background-color: #fcfdff;
	}
	.box:hover {
		box-shadow: 0 8px 15px rgba(0,0,0,0.15);
		transform:translateY(-2px);
		cursor: pointer;
	}
	.up{
		height: 192px;
		overflow: auto;
	}
	.up-left{
		width: 65%;
		float: left;
	}
	.up-left p{
		/*width: 90%;*/
		overflow: auto;
		margin-bottom: 3px;
	}
	.up-left p span{
		float: left;
		display: inline-block;
		font-size: 12px;
	}
	.up-left p .title{
		width: 22%;
	}
	.up-left p .content{
		width: 55%;
	}
	.up-right{
		float: left;
		width: 35%;
	}
	.up-right img{
		width: 100px;
		height: 140px;
		display: block;
		outline: none;

	}
	.down p{
		margin:0;
	}
	.title{
		font-size: 17px;
		font-weight: bold;
		min-width: 38px;
		font-size: 12px;
	}
	.content{
		margin-left: 20px;
		margin-right: 30px;
		font-size: 12px;
	}
	.nan{
		margin-right: 30px;
		margin-left: 20px;
	}
	.han{
		display: inline;
	}
	.bigClose .el-dialog__header {
		height: 100px;
	}
	.bigClose .el-dialog__close {
		font-size: 100px;
	}
	.el-main {
		padding-left: 0px;
		padding-right: 0px;
	}
	.shijiImgStyle {
		margin: 10px;
		box-shadow: 0 8px 15px rgba(0,0,0,0.55);
		float: left;
	}
	.shijiImgStyle:hover{
	    transform: scale(1.1);
	}
</style>
</head>
<body>
	<div id="app">
		<el-container>
			<el-header>
				<el-row class="toolbar" :gutter="20">
					<shiro:hasPermission name="party:user:insert">
						<el-button class="margin-left-10" size="small" type="primary" @click="partyUser_manager_openInsertPartyUserDialog()">
							<i class="el-icon-circle-plus-outline"></i>
							添加人员
						</el-button>
					</shiro:hasPermission>
				  	<shiro:hasPermission name="party:user:insert">  
				  		<el-popover class="margin-left-10"
							placement="bottom" 
						  	width="400" 
						  	trigger="click" >
						  	<el-button size="small" type="primary" slot="reference">
						  		<i class="el-icon-upload"></i>
						  		导入党员
						  	</el-button>
						  	<div>
								<el-button type="text" @click="partyUser_manager_exportPartyUserInfosExcelExample">下载Excel模板</el-button>，按照模板填写
						  		<el-upload
						  			action="" 
						 	   		:http-request="partyUser_manager_importPartyUserInfosExcel"
						 	   		:multiple="true" 
						 	   		:before-upload="partyUser_manager_validatePartyUserInfosExcel" >
							      	<el-button type="text">点击上传excel文件</el-button>
								</el-upload>
								<el-button type="text" @click="partyUser_manager_showImportPartyUserExcelErrorMsgDialog">显示导入错误信息</el-button>
						  	</div>
						</el-popover>
				  	</shiro:hasPermission>
				  	<shiro:hasPermission name="party:user:query">  
				  		<el-popover 
				  			class="margin-left-10"
				  			v-if="signInAccountType != 'party_role'"
							placement="bottom" 
						  	width="200" 
						  	trigger="click" >
						  	<el-button size="small" type="primary" slot="reference">
						  		<i class="el-icon-search"></i>
						  		搜索人员
						  	</el-button>
						  	<div>
								<el-row>
									<el-input size="small" clearable
										@change="partyUser_manager_queryPartyUserInfos()"
										v-model="partyUser_manager_queryPartyUserInfosCondition.name" placeholder="请输入用户名"></el-input>
								</el-row>
								<el-row>
									<el-select @change="partyUser_manager_queryPartyUserInfos()" 
											clearable v-model="partyUser_manager_queryPartyUserInfosCondition.isParty"
											size="small"
											placeholder="是否党员">
										<el-option label="否" :value="0"></el-option>
										<el-option label="是" :value="1"></el-option>
									</el-select>
								</el-row>
								<el-row>
									<el-select @change="partyUser_manager_queryPartyUserInfos()" 
											clearable v-model="partyUser_manager_queryPartyUserInfosCondition.sex"
											size="small"
											placeholder="性别">
										<el-option label="男" value="男"></el-option>
										<el-option label="女" value="女"></el-option>
									</el-select>
								</el-row>
								<el-row>
									<el-select size="small" clearable 
											@change="partyUser_manager_queryPartyUserInfos()"
											v-model="partyUser_manager_queryPartyUserInfosCondition.orgInfoId" placeholder="党组织">
										<el-option
											v-for="item in selectOptions.havePartyUserOrgs"
											:key="item.orgInfoId"
											:label="item.orgInfoName"
											:value="item.orgInfoId">
											<span style="float: left; margin-right: 15px;">{{item.orgInfoName}}</span>
											<span style="float: right;">{{item.orgInfoId}}</span>
										</el-option>
									</el-select>
								</el-row>
						  	</div>
						</el-popover>
					</shiro:hasPermission>
					<el-button-group class="margin-left-10">
                        <el-button size="small" :type="!dis_h_v?'primary':''" icon="el-icon-menu" @click="dis_h_v=false"></el-button>
                        <el-button size="small" :type="dis_h_v?'primary':''" icon="el-icon-tickets" @click="dis_h_v=true"></el-button>
					</el-button-group>
					<span class="margin-left-10" v-if="false">
						<el-button size="small" type="primary" @click="zidonghuachengxu_video()">开始</el-button>
					</span>
					<span class="margin-left-10" v-if="false">
						<el-popover
							placement="bottom" 
						  	width="400" 
						  	trigger="click" >
						  	<el-button size="small" type="primary" slot="reference">
						  		<i class="el-icon-upload"></i>
						  		演示文件
						  	</el-button>
						  	<div>
								<el-upload
									style="width: 360px" 
									drag
									action=""
									ref="variableJoinOrgFile" 
									:auto-upload="false" 
									:multiple="true">
									<i class="el-icon-upload"></i>
									<div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
									<div class="el-upload__tip" slot="tip">只能上传doc或docx文件</div>
								</el-upload>
						  	</div>
						</el-popover>
					</span>
                    <span style="float: right;">
	                    <el-pagination id="partyUser_manager_pagesdididi" 
						  	layout="total, prev, pager, next, jumper" 
			      		 	@current-change="partyUser_manager_pagerCurrentChange"
						  	:current-page.sync="partyUser_manager_pager.pageNum"
						  	:page-size.sync="partyUser_manager_pager.pageSize"
						  	:total="partyUser_manager_pager.total">
						</el-pagination>
					</span>
				</el-row>
			</el-header>
			<el-main>
		  		<div 
		  				style="background-image: url(/view/pm/img/userInfoBg.png)"
		  				@click="partyUser_manager_jumpToUserDetailInfo(item)" 
		  				v-show="!dis_h_v" 
		  				class="box" 
		  				v-for="item in partyUser_manager_pager.list">
					<div class="up">
						<div class="up-left">
							<p><span class="title">姓名</span>  <span class="content">{{item.name}}</span></p>
							<p>
								<span class="title">性别</span>  <span class="nan"><img style="width: 16px; height: 20px;" :src="getSexImg(item)" />
								</span> <span class="title">民族</span> <span class="han">{{item.nation}}</span></p>
							<p><span class="title">出生</span>  <span class="content">{{item.birthDate}}</span></p>
							<p>
								<span class="title">类型</span>  
								<span 
										class="content" 
										:style="item.typeName == '正式党员' 
											? 'color: red; font-weight: bold' 
												: item.typeName == '预备党员' 
											? 'color: green; font-weight: bold' 
												: 'color: blue; font-weight: bold'">
									{{item.typeName == null ? "普通人员" : item.typeName}}
								</span>
							</p>
							<p v-if="item.isParty == 1"><span class="title">党龄</span>  <span class="content">{{item.joinDateFormalAge}} 年</span></p>
							<p><span class="title">学历</span>  <span class="content">{{item.education}}</span></p>
							<p><span class="title">现住址</span>  
								<span class="content">
									{{item.presentAddressProvince}}&nbsp;&nbsp;
									{{item.presentAddressCity}}&nbsp;&nbsp;
									{{item.presentAddressArea}}&nbsp;&nbsp;
									{{item.presentAddressDetail}}
								</span>
							</p>
						</div>
						<div class="up-right">
							<img :src="getPath(item)">
						</div>
					</div>
					<div class="down">
						<p><span class="title">身份证号</span>  <span class="content">{{item.idCard}}</span></p>
					</div>
				</div>
		  		<span v-show="dis_h_v">
					<el-table 
							row-key="id" 
							ref="partyUser_manager_userInfoDetailTables" 
							:expand-row-keys="partyUser_manager_jumpToUserDetailInfoArray" 
							size="small" 
							:data="partyUser_manager_pager.list" 
							style="width: 100%">
						<el-table-column id="partyUserDetailed" type="expand">
							<template slot-scope="scope">
								<el-row :gutter="20">
									<el-col :span="0.1"><span class="partyUserTitleFont">个人照片：</span></el-col>
									<el-col :span="4"><img :src="getPath(scope.row)" width="100" /></el-col>
									<shiro:hasPermission name="party:user:query">  
										<el-button 
											v-if="signInAccountType != 'party_role'"
											size="small" 
											@click="partyUser_manager_exportPartyUserInfo(scope.row)" 
											type="primary">导出此党员信息
										</el-button>
									</shiro:hasPermission>
									<shiro:hasPermission name="party:user:update">  
										<el-button 
											v-if="signInAccountType != 'party_role'"
											size="small" 
											@click="partyUser_manager_openUpdatePartyUserDialog(scope.row)" 
											type="primary">信息修改
										</el-button>
									</shiro:hasPermission>
									<shiro:hasPermission name="party:user:query">  
										<el-popover
											v-if="signInAccountType != 'party_role' && 1 == 2"
											placement="bottom" 
											style="margin-left: 10px;"
										  	width="50" 
										  	trigger="click" >
										  	<el-button size="small" type="primary" slot="reference">
										  		个人风采
										  	</el-button>
										  	<div>
												<el-row>
													<el-button size="small" type="text" @click="openPartyUserLL(scope.row, 192, 108)">横屏</el-button>
													<el-button size="small" type="text" @click="openPartyUserLL(scope.row, 108, 192)">竖屏</el-button>
												</el-row>
										  	</div>
										</el-popover>
									</shiro:hasPermission>
									<shiro:hasPermission name="party:user:insert">  
										<el-button 
											v-if="signInAccountType != 'party_role'"
											size="small" 
											style="margin-left: 10px;"
											@click="partyUser_manager_openDeedsUserDialog(scope.row)" 
											type="primary">人物事迹
										</el-button>
									</shiro:hasPermission>
								</el-row>
								<el-row :gutter="20">
									<span style="margin: 10px">用户ID：{{scope.row.id}}</span>
									<span v-if="scope.row.orgInfoId != null && scope.row.orgInfoId != ''" style="margin: 10px">
										已加入组织：
										<span style="color: red; font-weight: bold;">
											{{scope.row.orgInfoName}}
										</span>
									</span>
									<span style="margin: 10px;">
										加入组织时间：
										{{scope.row.orgJoinTime}}
									</span>
								</el-row>
								<el-row :gutter="20">
									<el-col :span="24"><span class="partyUserTitleFont">基本信息</span></el-col>
								</el-row>
								<el-row :gutter="20" style="margin-bottom: 0px;">
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												姓名：
											</el-col>
											<el-col :span="15">
												{{scope.row.name}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												性别：
											</el-col>
											<el-col :span="15">
												{{scope.row.sex}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												籍贯：
											</el-col>
											<el-col :span="15">
												{{scope.row.nativePlace}}
											</el-col>
										</el-row>
									</el-col>
								</el-row>
								<el-row :gutter="20" style="margin-bottom: 0px;">
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												生日：
											</el-col>
											<el-col :span="15">
												{{scope.row.birthDate}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												年龄：
											</el-col>
											<el-col :span="15">
												{{scope.row.age}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												民族：
											</el-col>
											<el-col :span="15">
												{{scope.row.nation}}
											</el-col>
										</el-row>
									</el-col>
								</el-row>
								<el-row :gutter="20" style="margin-bottom: 0px;">
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												毕业学校：
											</el-col>
											<el-col :span="15">
												{{scope.row.graduationSchool}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												学习专业：
											</el-col>
											<el-col :span="15">
												{{scope.row.major}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												学历：
											</el-col>
											<el-col :span="15">
												{{scope.row.education}}
											</el-col>
										</el-row>
									</el-col>
								</el-row>
								<el-row :gutter="20" style="margin-bottom: 0px;">
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												学位：
											</el-col>
											<el-col :span="15">
												{{scope.row.academicDegree}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												特长（文艺）：
											</el-col>
											<el-col :span="15">
												{{scope.row.specialityLiterature}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												特长（专业）：
											</el-col>
											<el-col :span="15">
												{{scope.row.specialityMajor}}
											</el-col>
										</el-row>
									</el-col>
								</el-row>
								<el-row :gutter="20" style="margin-bottom: 0px;">
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												身份证号码：
											</el-col>
											<el-col :span="15">
												{{scope.row.idCard}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												手机号码：
											</el-col>
											<el-col :span="15">
												{{scope.row.mobilePhone}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												电子邮箱：
											</el-col>
											<el-col :span="15">
												{{scope.row.email}}
											</el-col>
										</el-row>
									</el-col>
								</el-row>
								<el-row :gutter="20" style="margin-bottom: 0px;">
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												微信号：
											</el-col>
											<el-col :span="15">
												{{scope.row.wechat}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												QQ号：
											</el-col>
											<el-col :span="15">
												{{scope.row.qq}}
											</el-col>
										</el-row>
									</el-col>
								</el-row>
								<el-row :gutter="20" style="margin-bottom: 0px;">
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												入学时间：
											</el-col>
											<el-col :span="15">
												{{scope.row.enrolmentTime}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												毕业时间：
											</el-col>
											<el-col :span="15">
												{{scope.row.graduationTime}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												婚姻状况：
											</el-col>
											<el-col :span="15">
												{{scope.row.marriageStatus}}
											</el-col>
										</el-row>
									</el-col>
								</el-row>
								<el-row :gutter="20" style="margin-bottom: 0px;">
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												子女状况：
											</el-col>
											<el-col :span="15">
												{{scope.row.childrenStatus}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												是否积极份子：
											</el-col>
											<el-col :span="15">
												{{scope.row.positiveUserName}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												工作单位：
											</el-col>
											<el-col :span="15">
												{{scope.row.workUnit}}
											</el-col>
										</el-row>
									</el-col>
								</el-row>
								<el-row :gutter="20" style="margin-bottom: 0px;">
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												工作性质：
											</el-col>
											<el-col :span="15">
												{{scope.row.workNature}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													加入工作时间：
												</el-col>
												<el-col :span="15">
													{{scope.row.joinWorkDate}}
												</el-col>
											</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												聘任时长：
											</el-col>
											<el-col :span="15">
												{{scope.row.appointmentTimeLength}} 年
											</el-col>
										</el-row>
									</el-col>
								</el-row>
								<el-row :gutter="20" style="margin-bottom: 0px;">
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												一线情况：
											</el-col>
											<el-col :span="15">
												{{scope.row.firstLineTypeName}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												现住址：
											</el-col>
											<el-col :span="15">
												{{scope.row.presentAddressProvince}}&nbsp;&nbsp;
												{{scope.row.presentAddressCity}}&nbsp;&nbsp;
												{{scope.row.presentAddressArea}}&nbsp;&nbsp;
												{{scope.row.presentAddressDetail}}
											</el-col>
										</el-row>
									</el-col>
									<el-col :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												家庭住址：
											</el-col>
											<el-col :span="15">
												{{scope.row.homeAddressProvince}}&nbsp;&nbsp;
												{{scope.row.homeAddressCity}}&nbsp;&nbsp;
												{{scope.row.homeAddressArea}}&nbsp;&nbsp;
												{{scope.row.homeAddressDetail}}
											</el-col>
										</el-row>
									</el-col>
								</el-row>
								<el-row>
									<el-col v-if="scope.row.devPeople != null && scope.row.devPeople != ''" :span="6">
										<el-row :gutter="20">
											<el-col :span="9" style="text-align: right;">
												是否发展对象：
											</el-col>
											<el-col :span="15">
												{{scope.row.devPeople == 1 ? '是' : '否'}}
											</el-col>
										</el-row>
									</el-col>
								</el-row>
								<template v-if="scope.row.isParty == 1">
									<el-row :gutter="20">
										<el-col :span="24"><span class="partyUserTitleFont">党员信息</span></el-col>
									</el-row>
									<el-row :gutter="20" style="margin-bottom: 0px;">
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													党员类型：
												</el-col>
												<el-col :span="15">
													{{scope.row.typeName}}
												</el-col>
											</el-row>
										</el-col>
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													党员状态：
												</el-col>
												<el-col :span="15">
													{{scope.row.statusName}}
												</el-col>
											</el-row>
										</el-col>
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													入党时间 (正式)：
												</el-col>
												<el-col :span="15">
													{{scope.row.joinDateFormal}}
												</el-col>
											</el-row>
										</el-col>
									</el-row>
									<el-row :gutter="20" style="margin-bottom: 0px;">
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													入党时间 (预备)：
												</el-col>
												<el-col :span="15">
													{{scope.row.joinDateReserve}}
												</el-col>
											</el-row>
										</el-col>
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													如何加入党支部：
												</el-col>
												<el-col :span="15">
													{{scope.row.joinPartyBranchType}}
												</el-col>
											</el-row>
										</el-col>
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													是否党务工作者：
												</el-col>
												<el-col :span="15">
													{{scope.row.partyStaffName}}
												</el-col>
											</el-row>
										</el-col>
									</el-row>
									<el-row :gutter="20" style="margin-bottom: 0px;">
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													是否党代表：
												</el-col>
												<el-col :span="15">
													{{scope.row.partyRepresentativeName}}
												</el-col>
											</el-row>
										</el-col>
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													是否志愿者：
												</el-col>
												<el-col :span="15">
													{{scope.row.volunteerName}}
												</el-col>
											</el-row>
										</el-col>
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													是否困难党员：
												</el-col>
												<el-col :span="15">
													{{scope.row.difficultUserName}}
												</el-col>
											</el-row>
										</el-col>
									</el-row>
									<el-row :gutter="20" style="margin-bottom: 0px;">
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													是否失联党员：
												</el-col>
												<el-col :span="15">
													{{scope.row.missingUserName}}
												</el-col>
											</el-row>
										</el-col>
									</el-row>
									<el-row v-if="signInAccountType != 'party_role'" :gutter="20" style="margin-bottom: 0px;">
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													是否先进党员：
												</el-col>
												<el-col :span="15">
													{{scope.row.advancedUserName}}
												</el-col>
											</el-row>
										</el-col>
										<el-col :span="6">
											<el-row :gutter="20">
												<el-col :span="9" style="text-align: right;">
													是否发展党员：
												</el-col>
												<el-col :span="15">
													{{scope.row.developUserName}}
												</el-col>
											</el-row>
										</el-col>
									</el-row>
									<el-row v-if="false" :gutter="20">
										<el-col :span="24"><span class="partyUserTitleFont">个人简介</span></el-col>
									</el-row>
									<el-row v-if="false" :gutter="20" style="margin-bottom: 0px;">
										<el-col :span="22">{{scope.row.introduce}}</el-col>
									</el-row>
								</template>
								<el-row v-if="scope.row.shiji != null && scope.row.shiji.length > 0">
									<p style="text-align: center; font-size: 24px;">事迹</p>
								</el-row>
								<template v-if="signInAccountType != 'party_role'">
									<div v-for="item in scope.row.shiji" style="margin-bottom: 50px;">
										<el-button size="small" type="text" @click="openPartyUser_manager_supplyDeedsUserDialog(item)">
									  		<span 
									  			style="font-size: 14px; 
									  			border: 1px solid #ddd;
									  			border-radius: 6px; 
									  			padding: 5px;
									  			background-color: #ddd;
									  			font-weight: bold;">
									  			事迹补充
									  		</span>
									  	</el-button>
										<el-row v-if="item.个人经历 != null && item.个人经历.length != 0">
											<el-col :span="24"><span class="partyUserTitleFont">个人经历</span></el-col>
										</el-row>
										<el-row v-for="it in item.个人经历">
											<p style="text-indent:2em; font-weight: bold;">
												{{it.deedsTitle}}
												<el-button size="small" type="text" @click="deleteDeedsUser(it)">
									  				删除
									  			</el-button>
									  			<el-button size="small" type="text" @click="openUpdateDeedsUserDialog(it)">
									  				修改事迹
									  			</el-button>
											</p>
											<p style="text-indent:2em; width: 80%;">{{it.deedsDetail}}</p>

											<template v-if="it.diMgs != null && it.diMgs.length != 0">
												<template v-for="diMg in it.diMgs">
													<div class="shijiImgStyle">
														<a href="javascript:void(0)" @click="openBigShijiImgDialog(diMg.paths)">
															<img style="margin: 5px; cursor: zoom-in;" :src="getNewPath(diMg.paths)" height="100px">
														</a>
													</div>
												</template>
											</template>
										</el-row>
										
										<el-row v-if="item.获得荣誉 != null && item.获得荣誉.length != 0">
											<el-col :span="24"><span class="partyUserTitleFont">获得荣誉</span></el-col>
										</el-row>
										<el-row v-for="it in item.获得荣誉">
											<p style="text-indent:2em;">
												时间：{{it.occurrenceTime}}
												<el-button size="small" type="text" @click="deleteDeedsUser(it)">
									  				删除
									  			</el-button>
									  			<el-button size="small" type="text" @click="openUpdateDeedsUserDialog(it)">
									  				修改事迹
									  			</el-button>
											</p>
											<p style="text-indent:2em; width: 80%;">{{it.deedsDetail}}</p>

											<template v-if="it.diMgs != null && it.diMgs.length != 0">
												<template v-for="diMg in it.diMgs">
													<div class="shijiImgStyle">
														<a href="javascript:void(0)" @click="openBigShijiImgDialog(diMg.paths)">
															<img style="margin: 5px; cursor: zoom-in;" :src="getNewPath(diMg.paths)" height="100px">
														</a>
													</div>
												</template>
											</template>
										</el-row>

										<el-row v-if="item.个人感言 != null && item.个人感言.length != 0">
											<el-col :span="24"><span class="partyUserTitleFont">个人感言</span></el-col>
										</el-row>
										<el-row v-for="it in item.个人感言">
											<p style="text-indent:2em; font-weight: bold;">
												{{it.deedsTitle}}
												<el-button size="small" type="text" @click="deleteDeedsUser(it)">
									  				删除
									  			</el-button>
									  			<el-button size="small" type="text" @click="openUpdateDeedsUserDialog(it)">
									  				修改事迹
									  			</el-button>
											</p>
											<p style="text-indent:2em; width: 80%;">{{it.deedsDetail}}</p>

											<template v-if="it.diMgs != null && it.diMgs.length != 0">
												<template v-for="diMg in it.diMgs">
													<div class="shijiImgStyle">
														<a href="javascript:void(0)" @click="openBigShijiImgDialog(diMg.paths)">
															<img style="margin: 5px; cursor: zoom-in;" :src="getNewPath(diMg.paths)" height="100px">
														</a>
													</div>
												</template>
											</template>
										</el-row>

										<el-row v-if="item.他人评价 != null && item.他人评价.length != 0">
											<el-col :span="24"><span class="partyUserTitleFont">他人评价</span></el-col>
										</el-row>
										<el-row v-for="it in item.他人评价">
											<p style="text-indent:2em; font-weight: bold;">
												{{it.deedsTitle}}
												<el-button size="small" type="text" @click="deleteDeedsUser(it)">
									  				删除
									  			</el-button>
									  			<el-button size="small" type="text" @click="openUpdateDeedsUserDialog(it)">
									  				修改事迹
									  			</el-button>
											</p>
											<p style="text-indent:2em; width: 80%;">{{it.deedsDetail}}</p>

											<template v-if="it.diMgs != null && it.diMgs.length != 0">
												<template v-for="diMg in it.diMgs">
													<div class="shijiImgStyle">
														<a href="javascript:void(0)" @click="openBigShijiImgDialog(diMg.paths)">
															<img style="margin: 5px; cursor: zoom-in;" :src="getNewPath(diMg.paths)" height="100px">
														</a>
													</div>
												</template>
											</template>
										</el-row>
									</div>
								</template>

							</template>
						</el-table-column>
						<el-table-column label="姓名" prop="name" width=100></el-table-column>
						<el-table-column label="性别" prop="sex" width=50></el-table-column>
						<el-table-column label="电话" prop="mobilePhone"></el-table-column>
						<el-table-column label="邮箱" prop="email"></el-table-column>
						<el-table-column label="籍贯" prop="nativePlace"></el-table-column>
						<el-table-column label="生日" prop="birthDate"></el-table-column>
						<el-table-column fixed="right" label="操作" width=270>
							<template slot-scope="scope">
								<shiro:hasPermission name="party:user:delete">  
									<el-button @click="partyUser_manager_deletePartyUserInfo(scope.row)" type="text" size="small">删除</el-button>
								</shiro:hasPermission>
								<shiro:hasPermission name="party:user:update">  
									<el-button @click="partyUser_manager_openUpdatePartyUserDialog(scope.row)" type="text" size="small">修改信息</el-button>
								</shiro:hasPermission>
								<shiro:hasPermission name="org:relation:insert">  
									<el-button v-if="scope.row.isParty == 1" @click="partyUser_manager_openJoinOrgInfoDialog(scope.row)" type="text" size="small">
										{{scope.row.orgInfoId == null || scope.row.orgInfoId == '' ? '加入组织' : '变更组织'}}
									</el-button>
								</shiro:hasPermission>
								<template>
									<el-button 
										v-if="scope.row.joinPartyUserInfo == null && scope.row.isParty != 1"
										@click="openApplyJoinPartyOrgDialog(scope.row)" 
										type="text" size="small">申请入党
									</el-button>
									<el-button 
										style="color: red;"
										v-if="scope.row.joinPartyUserInfo != null && scope.row.type != 1"
										@click="openApplyJoinPartyOrgDialog(scope.row)" 
										type="text" size="small">申请状态
									</el-button>
								</template>
							</template>
						</el-table-column>
					</el-table>
				</span>
			</el-main>
		</el-container>






		<el-dialog title="导入党员错误信息" :visible.sync="partyUser_manager_importPartyUserExcelErrorMsgDialog" width="50%">
			<span style="margin: 0 15px">
				可以在
				<span style="color: blue"> 导入党员->显示导入错误信息 </span>
				再次打开
			</span>
			<div style="margin: 0 15px">
				<el-input 
				  	type="textarea"
				 	:autosize="{ minRows: 10, maxRows: 15}"
				 	placeholder="导入党员信息失败时，对表格校验的错误信息将显示在这里"
					v-model="partyUser_manager_importPartyUserExcelErrorMsg">
				</el-input>
			</div>
		</el-dialog>

		<el-dialog @close="resetApplyJoinPartyOrgDialog" title="申请入党" :visible.sync="joinPartyOrg.applyJoinPartyOrgDialog" width="80%">
			<div v-loading="joinPartyOrg.joinPartyOrgLoading" element-loading-text="资料提交中，请稍后..." style="width: 100%">
				<el-row>
					<el-steps :active="joinPartyOrg.joinPartyOrgStepNum" finish-status="success">
						<template v-for="item in joinPartyOrg.joinPartyOrgProcess">
							<el-step :title="item.name" :status="item.status"></el-step>
						</template>
					</el-steps>
				</el-row>

				<!-- 公共提示信息 -->
				<span style="font-size: 12px;">
					<!-- thisStepInfoNull代表没有查询到这个步骤信息 -->
					<el-row v-if="joinPartyOrg.joinPartyOrgStepInfo.stepStatus != null">	
						<p>
							提交时间：{{joinPartyOrg.joinPartyOrgStepInfo.stepTime}}
						</p>
						<p>
							希望加入的组织：{{joinPartyOrg.userInfo.joinPartyUserInfo.orgInfoName}}
						</p>
						<p>
							加入方式：{{joinPartyOrg.userInfo.joinPartyUserInfo.joinPartyType}}
						</p>
						<p>审核状态：
							<span :style="joinPartyOrg.joinPartyOrgStepInfo.stepStatus == 'success' ? 
								'color: green; font-weight: bold;' : joinPartyOrg.joinPartyOrgStepInfo.stepStatus == 'wait' ? 
								'color: #808080; font-weight: bold;' : joinPartyOrg.joinPartyOrgStepInfo.stepStatus == 'error' ? 
								'color: red; font-weight: bold;' : 'color: black; font-weight: bold;'">
								{{joinPartyOrg.joinPartyOrgStepInfo.stepStatus}}
							</span>
						</p>
						<p>
							附加消息：{{joinPartyOrg.joinPartyOrgStepInfo.stepStatusReason}}
						</p>
					</el-row>
				</span>
				<!-- 公共材料提交 -->
				<el-row v-if="joinPartyOrg.joinPartyOrgStepInfo.stepStatus == null">
					<el-form size="small" :model="joinPartyOrg.applyJoinPartyOrgForm" status-icon 
						:rules="joinPartyOrg.applyJoinPartyOrgRules" 
						label-position="top"
						ref="applyJoinPartyOrgForm" label-width="100px">
						<!-- 没有申请入党记录，第一次申请入党，填写希望加入的组织，后续有记录就不显示加入组织了 -->
						<span v-if="joinPartyOrg.userInfo.joinPartyUserInfo == null">	
							<el-form-item label="选择组织" prop="orgInfoId">
								<el-select size="small" clearable 
										v-model="joinPartyOrg.applyJoinPartyOrgForm.orgInfoId" placeholder="党组织">
									<el-option
										v-for="item in joinPartyOrg.orgInfosSelect"
										:key="item.orgInfoId"
										:label="item.orgInfoName"
										:value="item.orgInfoId">
										<span style="float: left; margin-right: 15px;">{{item.orgInfoName}}</span>
										<span style="float: right;">{{item.orgInfoId}}</span>
									</el-option>
								</el-select>
							</el-form-item>

							<el-form-item label="加入方式" prop="joinOrgType">
								<el-select size="small" clearable 
										v-model="joinPartyOrg.applyJoinPartyOrgForm.joinOrgType" placeholder="加入党组织方式">
									<el-option
										v-for="item in joinPartyOrg.joinOrgTypeSelects"
										:key="item.jpbtId"
										:label="item.joinType"
										:value="item.jpbtId">
									</el-option>
								</el-select>
							</el-form-item>
						</span>
						<span v-if="(joinPartyOrg.flag.flagContent || joinPartyOrg.flag.flagFile) && joinPartyOrg.commonTips != null">
							<p>{{joinPartyOrg.commonTips}}</p>
						</span>
						<span v-if="joinPartyOrg.flag.flagContent">
							
						</span>
						<!-- 需要申请人操作时提供材料提交 -->
						<span v-if="joinPartyOrg.flag.flagFile">
							<el-upload
								style="width: 360px" 
								drag
								action=""
								ref="upload_joinPartyOrg" 
								:auto-upload="false" 
								:multiple="true">
								<i class="el-icon-upload"></i>
								<div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
								<div class="el-upload__tip" slot="tip">只能上传doc或docx文件</div>
							</el-upload>
						</span>
					</el-form>
				</el-row>

				<el-row>
					<el-button v-if="joinPartyOrg.joinPartyOrgStepNum > 1" size="small" @click="joinPartyOrgStepSet('s')">
						查看上一步结果
					</el-button>
					<el-button v-if="joinPartyOrg.joinPartyOrgStepNum < joinPartyOrg.joinPartyOrgStepNumNow" 
						size="small" @click="joinPartyOrgStepSet('x')">查看下一步结果
					</el-button>
					<el-button v-if="joinPartyOrg.joinPartyOrgStepNum == joinPartyOrg.joinPartyOrgStepNumNow && 
						joinPartyOrg.joinPartyOrgStepInfo.stepStatus == 'success'" 
						size="small" type="primary" @click="joinPartyOrgStepSet('x')">审核通过，下一步
					</el-button>
					<!-- 该步骤有提交材料并且步骤对应 -->
					<el-button 
						v-if="joinPartyOrg.joinPartyOrgStepNum == joinPartyOrg.joinPartyOrgStepNumNow + 1 && 
						joinPartyOrg.flag.flagFile" 
						size="small" type="primary" @click="submitJoinPartyOrg">提交
					</el-button>
				</el-row>
			</div>
		</el-dialog>

		<el-dialog @close="partyUser_manager_resetJoinOrgInfoForm" title="加入组织" :visible.sync="partyUser_manager_joinOrgInfoDialog" width="50%">
			<el-form class="partyUserForm" size="small" :model="partyUser_manager_joinOrgInfoForm" status-icon :rules="partyUser_manager_joinOrgInfoRules" 
				ref="partyUser_manager_joinOrgInfoForm" label-width="100px">
				<el-row :gutter="20">
					<el-col :span="24">
						<el-form-item label="加入时间">
							<el-date-picker
								clearable
						    	v-model="partyUser_manager_joinOrgInfoForm.joinTime"
						    	type="date" 
						    	value-format="yyyy-MM-dd" 
						    	placeholder="不选默认当前时间">
						    </el-date-picker>
						</el-form-item>
					</el-col>
				</el-row>
				<el-row :gutter="20">
					<el-col :span="24">
						<el-form-item label="选择组织" prop="orgInfoId">
						    <el-tree :expand-on-click-node="false" 
						    	:highlight-current="true" 
						    	:data="partyUser_manager_joinOrgInfoForm.orgInfoTreeOfJoinOrg" 
						    	:props="partyUser_manager_joinOrgInfoFormProps" 
						    	@node-click="partyUser_manager_setOrgInfoIdAndQueryOrgDuty">
						  	</el-tree>
						</el-form-item>
					</el-col>
				</el-row>
				<el-row :gutter="20">
					<el-col :span="24">
						<el-form-item label="对应身份" prop="orgRltDutyIds">
						    <el-tree :default-expand-all="true" 
						    	node-key="id" 
						    	ref="partyUser_manager_joinOrgInfoTree"
						    	show-checkbox 
						    	:expand-on-click-node="false" 
						    	:highlight-current="true" 
						    	:default-checked-keys="partyUser_manager_joinOrgInfoForm.haveDutyForThisOrgInfo"
						    	:data="partyUser_manager_joinOrgInfoForm.orgDutyTreesForOrgInfo" 
						    	:props="partyUser_manager_joinOrgInfoOrgDutyTreesForOrgInfoProps" 
						    	:check-strictly="true" >
						  	</el-tree>
						</el-form-item>
					</el-col>
				</el-row>
				<el-row :gutter="20">
					<el-col :span="24">
						<el-button @click="partyUser_manager_joinOrgInfo()" type="primary" size="small">确认加入</el-button>
					</el-col>
				</el-row>
			</el-form>
		</el-dialog>

		<el-dialog title="添加党员" class="bigClose" :fullscreen="true" :visible.sync="partyUser_manager_insertPartyUserDialog">
			<el-form class="partyUserForm" size="small" :model="partyUser_manager_insertPartyUserForm" status-icon :rules="partyUser_manager_insertPartyUserRules" 
				ref="partyUser_manager_insertPartyUserForm" label-width="100px">
				<el-row :gutter="20">
					<el-col :span="24">
						<el-form-item label="个人照片" prop="idPhoto">
							<el-upload 
								action="" 
								:before-upload="partyUser_manager_validatePartyUserIdPhoto"
								ref="insertPartyUserIdPhoto"
								:auto-upload="false"
								:limit="1"
								list-type="picture-card" >
								<div slot="tip" class="el-upload__tip">只能上传小于500kb的图片文件（jpg、jpeg或png格式）</div>
							</el-upload>
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="24"><span class="partyUserTitleFont">基本信息</span></el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="姓名：" prop="name">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.name" placeholder="姓名"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="性別：" prop="sex">
							<el-select clearable v-model="partyUser_manager_insertPartyUserForm.sex">
								<el-option label="女" value="女"></el-option>
								<el-option label="男" value="男"></el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="籍贯：" prop="nativePlace">
							<el-input :disabled="true" clearable v-model="partyUser_manager_insertPartyUserForm.nativePlace" placeholder="省市"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="生日：" prop="birthDate">
							<el-date-picker class="partyUserDate"
								clearable 
								:disabled="true"
						    	v-model="partyUser_manager_insertPartyUserForm.birthDate"
						    	type="date" 
						    	value-format="yyyy-MM-dd" 
						    	placeholder="请输入身份证号码">
						    </el-date-picker>
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="民族：" prop="nation">
							<el-select clearable v-model="partyUser_manager_insertPartyUserForm.nation" filterable placeholder="请选择，可搜索">
								<el-option
									v-for="nationType in partyUser_manager_nationTypes"
									:key="nationType.name"
									:label="nationType.name"
									:value="nationType.ntId">
								</el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="身份证号：" prop="idCard">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.idCard" placeholder="15或18位身份证号码"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="手机号码：" prop="mobilePhone">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.mobilePhone" placeholder="11位手机号码"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="电子邮箱：" prop="email">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.email" placeholder="xxxxxx@xx.xx"></el-input>
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="QQ号码：" prop="qq">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.qq" placeholder="QQ号码"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="微信号：" prop="wechat">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.wechat" placeholder="微信号"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="教育水平：" prop="education">
							<el-select clearable v-model="partyUser_manager_insertPartyUserForm.education" filterable placeholder="请选择">
								<el-option
									v-for="educationLevel in partyUser_manager_educationLevels"
									:key="educationLevel.name"
									:label="educationLevel.name"
									:value="educationLevel.eduLevelEid">
								</el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="学位水平：" prop="academicDegree">
							<el-select ref="partyUser_manager_academicDegree" clearable v-model="partyUser_manager_insertPartyUserForm.academicDegree" filterable placeholder="请选择">
								<el-option
									v-for="academicDegreeLevel in partyUser_manager_academicDegreeLevels"
									:key="academicDegreeLevel.name"
									:label="academicDegreeLevel.name"
									:value="academicDegreeLevel.adDAid">
								</el-option>
							</el-select>
						</el-form-item>
					</el-col>
				</el-row>
				
				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="入学时间：" prop="enrolmentTime">
							<el-date-picker
								clearable
						    	v-model="partyUser_manager_insertPartyUserForm.enrolmentTime"
						    	type="date" 
						    	value-format="yyyy-MM-dd" 
						    	placeholder="选择入学日期">
						    </el-date-picker>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="毕业时间：" prop="graduationTime">
							<el-date-picker
								clearable
						    	v-model="partyUser_manager_insertPartyUserForm.graduationTime"
						    	type="date" 
						    	value-format="yyyy-MM-dd" 
						    	placeholder="选择毕业日期">
						    </el-date-picker>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="毕业学校：" prop="graduationSchool">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.graduationSchool" placeholder="请输入毕业学校"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="学习专业：" prop="major">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.major" placeholder="请输入在校学习专业"></el-input>
						</el-form-item>
					</el-col>
				</el-row>
				
				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="文艺特长：" prop="specialityLiterature">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.specialityLiterature" placeholder="请输入自己的文艺特长"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="专业特长：" prop="specialityMajor">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.specialityMajor" placeholder="请输入自己的专业特长"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="婚姻状况：" prop="marriageStatus">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.marriageStatus" placeholder="请输入婚姻状况，这不是必须的"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="子女状况：" prop="childrenStatus">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.childrenStatus" placeholder="请输入子女状况，这不是必须的"></el-input>
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="家庭住址：" prop="homeAddress_pca">
							<el-cascader clearable :props="partyUser_manager_address_prop"
								@change="partyUser_managet_getPartyUserNativePlace"
								v-model="partyUser_manager_insertPartyUserForm.homeAddress_pca"
								separator="/"
								placeholder="可搜索地点" :options="partyUser_manager_address_pca" 
								filterable >
							</el-cascader>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="详细地址：" prop="homeAddressDetail">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.homeAddressDetail" placeholder="家庭住址详细街道/乡镇"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="现居住址：" prop="presentAddress_pca">
							<el-cascader clearable :props="partyUser_manager_address_prop"
								v-model="partyUser_manager_insertPartyUserForm.presentAddress_pca"
								separator="/"
								placeholder="可搜索地点" :options="partyUser_manager_address_pca" 
								filterable >
							</el-cascader>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="详细地址" prop="presentAddressDetail">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.presentAddressDetail" placeholder="现居住住址详细街道/乡镇"></el-input>
						</el-form-item>
					</el-col>
				</el-row>
				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="积极份子：" prop="positiveUser">
							<el-select clearable v-model="partyUser_manager_insertPartyUserForm.positiveUser">
								<el-option label="是" :value="1"></el-option>
								<el-option label="否" :value="0"></el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="是否党员：" prop="isParty">
							<el-select v-model="partyUser_manager_insertPartyUserForm.isParty">
								<el-option label="否" :value="0"></el-option>
								<el-option label="是" :value="1"></el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="工作单位：" prop="workUnit">
							<el-input clearable v-model="partyUser_manager_insertPartyUserForm.workUnit" placeholder="请输工作单位"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="工作性质：" prop="workNature">
							<el-select clearable v-model="partyUser_manager_insertPartyUserForm.workNature" filterable placeholder="请选择工作性质">
								<el-option
									v-for="workNatureType in partyUser_manager_workNatureTypes"
									:key="workNatureType.name"
									:label="workNatureType.name"
									:value="workNatureType.workNatureId">
								</el-option>
							</el-select>
						</el-form-item>
					</el-col>
				</el-row>
				<el-row :gutter="20">
						<el-col :span="6">
							<el-form-item label="工作时间：" prop="joinWorkDate">
								<el-date-picker
									clearable
							    	v-model="partyUser_manager_insertPartyUserForm.joinWorkDate"
							    	type="date" 
							    	value-format="yyyy-MM-dd" 
							    	placeholder="选择开始工作时间">
							    </el-date-picker>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="聘任时长" prop="appointmentTimeLength">
								<el-input clearable v-model="partyUser_manager_insertPartyUserForm.appointmentTimeLength" placeholder="请输公司聘任时长"></el-input>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="一线情况：" prop="firstLineTypeName">
								<el-select clearable v-model="partyUser_manager_insertPartyUserForm.firstLineTypeName" filterable placeholder="请选择一线情况">
									<el-option
										v-for="firstLineType in partyUser_manager_firstLineTypes"
										:key="firstLineType.firstLineTypeName"
										:label="firstLineType.firstLineTypeName"
										:value="firstLineType.fltId">
									</el-option>
								</el-select>
							</el-form-item>
						</el-col>
					</el-row>
				
				<template v-if="partyUser_manager_insertPartyUserForm.isParty == 1">
					<el-row :gutter="20">
						<el-col :span="24"><span class="partyUserTitleFont">党员信息</span></el-col>
					</el-row>
					
					<el-row :gutter="20">
						<el-col :span="6">
							<el-form-item label="党员类型：" prop="type">
								<el-select clearable v-model="partyUser_manager_insertPartyUserForm.type">
									<el-option label="预备党员" :value="0"></el-option>
									<el-option label="正式党员" :value="1"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="党员状态：" prop="status">
								<el-select clearable v-model="partyUser_manager_insertPartyUserForm.status">
									<el-option label="停止党籍" :value="0"></el-option>
									<el-option label="正常" :value="1"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-tooltip class="item" effect="dark" content="正式党员批准时间" placement="top-start">
								<el-form-item label="入党时间：" prop="joinDateFormal">
									<el-date-picker
										clearable
								    	v-model="partyUser_manager_insertPartyUserForm.joinDateFormal"
								    	type="date" 
								    	value-format="yyyy-MM-dd" 
								    	placeholder="加入或批准入党时间">
								    </el-date-picker>
								</el-form-item>
							</el-tooltip>
						</el-col>
						<el-col :span="6">
							<el-tooltip class="item" effect="dark" content="预备党员批准时间" placement="top-start">
								<el-form-item label="入党时间：" prop="joinDateReserve">
									<el-date-picker
										clearable
								    	v-model="partyUser_manager_insertPartyUserForm.joinDateReserve"
								    	type="date" 
								    	value-format="yyyy-MM-dd" 
								    	placeholder="预备党员批准时间">
								    </el-date-picker>
								</el-form-item>
							</el-tooltip>
						</el-col>
					</el-row>

					<el-row :gutter="20">
						<el-col :span="6">
							<el-tooltip class="item" effect="dark" content="加入党支部方式" placement="top-start">
								<el-form-item label="加入方式：" prop="joinPartyBranchType">
									<el-select clearable v-model="partyUser_manager_insertPartyUserForm.joinPartyBranchType" filterable placeholder="请选择加入党支部方式">
										<el-option
											v-for="joinPartyBranchType in partyUser_manager_joinPartyBranchTypes"
											:key="joinPartyBranchType.joinType"
											:label="joinPartyBranchType.joinType"
											:value="joinPartyBranchType.jpbtId">
										</el-option>
									</el-select>
								</el-form-item>
							</el-tooltip>
						</el-col>
						<el-col :span="6">
							<el-form-item label="党务工作者：" prop="partyStaff">
								<el-select clearable v-model="partyUser_manager_insertPartyUserForm.partyStaff">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="党代表：" prop="partyRepresentative">
								<el-select clearable v-model="partyUser_manager_insertPartyUserForm.partyRepresentative">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="志愿者：" prop="volunteer">
								<el-select clearable v-model="partyUser_manager_insertPartyUserForm.volunteer">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
					</el-row>

					<el-row :gutter="20">
						<el-col :span="6">
							<el-form-item label="困难党员：" prop="difficultUser">
								<el-select clearable v-model="partyUser_manager_insertPartyUserForm.difficultUser">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="先进党员：" prop="advancedUser">
								<el-select clearable v-model="partyUser_manager_insertPartyUserForm.advancedUser">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="发展党员：" prop="developUser">
								<el-select clearable v-model="partyUser_manager_insertPartyUserForm.developUser">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="失联党员：" prop="missingUser">
								<el-select clearable v-model="partyUser_manager_insertPartyUserForm.missingUser">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
					</el-row>

					<el-row v-if="false" :gutter="20">
						<el-col :span="24"><span class="partyUserTitleFont">个人简介</span></el-col>
					</el-row>

					<el-row v-if="false" :gutter="20">
						<el-col :span="24">
							<el-form-item label="简介：" prop="introduce">
								<el-input
								  	type="textarea"
								 	:autosize="{ minRows: 4}"
								 	placeholder="请输入内容"
									v-model="partyUser_manager_insertPartyUserForm.introduce">
								</el-input>
							</el-form-item>
						</el-col>
					</el-row>
				</template>

				<el-form-item>
					<el-button size="small" type="primary" @click="partyUser_manager_insertPartyUser()">添加党员</el-button>
					<el-button size="small" @click="partyUser_manager_resetInsertPartyUserForm()">重置信息</el-button>
				</el-form-item>
			</el-form>
		</el-dialog>

		<el-dialog title="修改证件照" :visible.sync="partyUser_manager_updatePartyUserIdPhotoDialog" width="30%">
			<el-upload 
				action="" 
				ref="updatePartyUserIdPhoto"
				:before-upload="partyUser_manager_validatePartyUserIdPhoto"
				:limit="1"
				list-type="picture-card"
				:auto-upload="false" >
				<div slot="tip" class="el-upload__tip">只能上传小于500kb的图片文件（jpg、jpeg或png格式）</div>
			</el-upload>
			<el-button style="margin-bottom: 10px;" size="small" type="primary" @click="partyUser_manager_updatePartyUserIdPhoto">更改照片</el-button>
		</el-dialog>

		<el-dialog title="修改党员信息" class="bigClose" :fullscreen="true" :visible.sync="partyUser_manager_updatePartyUserDialog">
			<el-form class="partyUserForm" size="small" :model="partyUser_manager_updatePartyUserForm" status-icon :rules="partyUser_manager_updatePartyUserRules" 
				ref="partyUser_manager_updatePartyUserForm" label-width="100px">
				<el-row>
					<el-form-item label="个人照片（点击以修改）">
						<a href="javascript:void(0)" @click="partyUser_manager_openUpdatePartyUserIdPhoto">
							<img :src="getPath(partyUser_manager_updatePartyUserForm)" width="100" />
						</a>
					</el-form-item>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="24"><span class="partyUserTitleFont">基本信息</span></el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="姓名：" prop="name">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.name" placeholder="姓名"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="性別：" prop="sex">
							<el-select :disabled="true" clearable v-model="partyUser_manager_updatePartyUserForm.sex">
								<el-option label="女" value="女"></el-option>
								<el-option label="男" value="男"></el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="籍贯：" prop="nativePlace">
							<el-input :disabled="true" :disabled="true" clearable v-model="partyUser_manager_updatePartyUserForm.nativePlace" placeholder="省市"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="生日：" prop="birthDate">
							<el-date-picker
								:disabled="true"
								clearable
						    	v-model="partyUser_manager_updatePartyUserForm.birthDate"
						    	type="date" 
						    	value-format="yyyy-MM-dd" 
						    	placeholder="请输入身份证号码">
						    </el-date-picker>
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="民族：" prop="nation">
							<el-select :disabled="true" clearable v-model="partyUser_manager_updatePartyUserForm.nation" filterable placeholder="请选择，可搜索">
								<el-option
									v-for="nationType in partyUser_manager_nationTypes"
									:key="nationType.name"
									:label="nationType.name"
									:value="nationType.ntId">
								</el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="身份证号：" prop="idCard">
							<el-input :disabled="true" clearable v-model="partyUser_manager_updatePartyUserForm.idCard" placeholder="15或18位身份证号码"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="手机号码：" prop="mobilePhone">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.mobilePhone" placeholder="11位手机号码"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="电子邮箱：" prop="email">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.email" placeholder="xxxxxx@xx.xx"></el-input>
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="QQ号码：" prop="qq">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.qq" placeholder="QQ号码"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="微信号：" prop="wechat">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.wechat" placeholder="微信号"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="教育水平：" prop="education">
							<el-select clearable v-model="partyUser_manager_updatePartyUserForm.education" filterable placeholder="请选择">
								<el-option
									v-for="educationLevel in partyUser_manager_educationLevels"
									:key="educationLevel.name"
									:label="educationLevel.name"
									:value="educationLevel.eduLevelEid">
								</el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="学位水平：" prop="academicDegree">
							<el-select ref="partyUser_manager_academicDegree" clearable v-model="partyUser_manager_updatePartyUserForm.academicDegree" filterable placeholder="请选择">
								<el-option
									v-for="academicDegreeLevel in partyUser_manager_academicDegreeLevels"
									:key="academicDegreeLevel.name"
									:label="academicDegreeLevel.name"
									:value="academicDegreeLevel.adDAid">
								</el-option>
							</el-select>
						</el-form-item>
					</el-col>
				</el-row>
				
				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="入学时间：" prop="enrolmentTime">
							<el-date-picker
								clearable
						    	v-model="partyUser_manager_updatePartyUserForm.enrolmentTime"
						    	type="date" 
						    	value-format="yyyy-MM-dd" 
						    	placeholder="选择入学日期">
						    </el-date-picker>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="毕业时间：" prop="graduationTime">
							<el-date-picker
								clearable
						    	v-model="partyUser_manager_updatePartyUserForm.graduationTime"
						    	type="date" 
						    	value-format="yyyy-MM-dd" 
						    	placeholder="选择毕业日期">
						    </el-date-picker>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="毕业学校：" prop="graduationSchool">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.graduationSchool" placeholder="请输入毕业学校"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="学习专业：" prop="major">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.major" placeholder="请输入在校学习专业"></el-input>
						</el-form-item>
					</el-col>
				</el-row>
				
				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="文艺特长：" prop="specialityLiterature">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.specialityLiterature" placeholder="请输入自己的文艺特长"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="专业特长：" prop="specialityMajor">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.specialityMajor" placeholder="请输入自己的专业特长"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="婚姻状况：" prop="marriageStatus">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.marriageStatus" placeholder="请输入婚姻状况，这不是必须的"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="子女状况：" prop="childrenStatus">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.childrenStatus" placeholder="请输入子女状况，这不是必须的"></el-input>
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="家庭住址：" prop="homeAddress_pca">
							<el-cascader :disabled="true" clearable :props="partyUser_manager_address_prop"
								@change="partyUser_managet_getPartyUserNativePlace"
								v-model="partyUser_manager_updatePartyUserForm.homeAddress_pca"
								separator="/"
								placeholder="可搜索地点" :options="partyUser_manager_address_pca" 
								filterable >
							</el-cascader>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="详细地址：" prop="homeAddressDetail">
							<el-input :disabled="true" clearable v-model="partyUser_manager_updatePartyUserForm.homeAddressDetail" placeholder="家庭住址详细街道/乡镇"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="现居住址：" prop="presentAddress_pca">
							<el-cascader clearable :props="partyUser_manager_address_prop"
								v-model="partyUser_manager_updatePartyUserForm.presentAddress_pca"
								separator="/"
								placeholder="可搜索地点" :options="partyUser_manager_address_pca" 
								filterable >
							</el-cascader>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="详细地址" prop="presentAddressDetail">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.presentAddressDetail" placeholder="现居住住址详细街道/乡镇"></el-input>
						</el-form-item>
					</el-col>
				</el-row>
				<el-row :gutter="20">
					<el-col :span="6">
						<el-form-item label="积极份子：" prop="positiveUser">
							<el-select clearable v-model="partyUser_manager_updatePartyUserForm.positiveUser">
								<el-option label="是" :value="1"></el-option>
								<el-option label="否" :value="0"></el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="是否党员：" prop="isParty">
							<el-select v-model="partyUser_manager_updatePartyUserForm.isParty">
								<el-option label="否" :value="0"></el-option>
								<el-option label="是" :value="1"></el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="工作单位：" prop="workUnit">
							<el-input clearable v-model="partyUser_manager_updatePartyUserForm.workUnit" placeholder="请输工作单位"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="6">
						<el-form-item label="工作性质：" prop="workNature">
							<el-select clearable v-model="partyUser_manager_updatePartyUserForm.workNature" filterable placeholder="请选择工作性质">
								<el-option
									v-for="workNatureType in partyUser_manager_workNatureTypes"
									:key="workNatureType.name"
									:label="workNatureType.name"
									:value="workNatureType.workNatureId">
								</el-option>
							</el-select>
						</el-form-item>
					</el-col>
				</el-row>

				<el-row :gutter="20">
						<el-col :span="6">
							<el-form-item label="工作时间：" prop="joinWorkDate">
								<el-date-picker
									clearable
							    	v-model="partyUser_manager_updatePartyUserForm.joinWorkDate"
							    	type="date" 
							    	value-format="yyyy-MM-dd" 
							    	placeholder="选择开始工作时间">
							    </el-date-picker>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="聘任时长" prop="appointmentTimeLength">
								<el-input clearable v-model="partyUser_manager_updatePartyUserForm.appointmentTimeLength" placeholder="请输公司聘任时长"></el-input>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="一线情况：" prop="firstLineTypeName">
								<el-select clearable v-model="partyUser_manager_updatePartyUserForm.firstLineTypeName" filterable placeholder="请选择一线情况">
									<el-option
										v-for="firstLineType in partyUser_manager_firstLineTypes"
										:key="firstLineType.firstLineTypeName"
										:label="firstLineType.firstLineTypeName"
										:value="firstLineType.fltId">
									</el-option>
								</el-select>
							</el-form-item>
						</el-col>
					</el-row>
				
				<template v-if="partyUser_manager_updatePartyUserForm.isParty == 1">
					<el-row :gutter="20">
						<el-col :span="24"><span class="partyUserTitleFont">党员信息</span></el-col>
					</el-row>
					
					<el-row :gutter="20">
						<el-col :span="6">
							<el-form-item label="党员类型：" prop="type">
								<el-select clearable v-model="partyUser_manager_updatePartyUserForm.type">
									<el-option label="预备党员" :value="0"></el-option>
									<el-option label="正式党员" :value="1"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="党员状态：" prop="status">
								<el-select clearable v-model="partyUser_manager_updatePartyUserForm.status">
									<el-option label="停止党籍" :value="0"></el-option>
									<el-option label="正常" :value="1"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-tooltip class="item" effect="dark" content="正式党员批准时间" placement="top-start">
								<el-form-item label="入党时间：" prop="joinDateFormal">
									<el-date-picker
										clearable
								    	v-model="partyUser_manager_updatePartyUserForm.joinDateFormal"
								    	type="date" 
								    	value-format="yyyy-MM-dd" 
								    	placeholder="加入或批准入党时间">
								    </el-date-picker>
								</el-form-item>
							</el-tooltip>
						</el-col>
						<el-col :span="6">
							<el-tooltip class="item" effect="dark" content="预备党员批准时间" placement="top-start">
								<el-form-item label="入党时间：" prop="joinDateReserve">
									<el-date-picker
										clearable
								    	v-model="partyUser_manager_updatePartyUserForm.joinDateReserve"
								    	type="date" 
								    	value-format="yyyy-MM-dd" 
								    	placeholder="预备党员批准时间">
								    </el-date-picker>
								</el-form-item>
							</el-tooltip>
						</el-col>
					</el-row>

					<el-row :gutter="20">
						<el-col :span="6">
							<el-tooltip class="item" effect="dark" content="加入党支部方式" placement="top-start">
								<el-form-item label="加入方式：" prop="joinPartyBranchType">
									<el-select clearable v-model="partyUser_manager_updatePartyUserForm.joinPartyBranchType" filterable placeholder="请选择加入党支部方式">
										<el-option
											v-for="joinPartyBranchType in partyUser_manager_joinPartyBranchTypes"
											:key="joinPartyBranchType.joinType"
											:label="joinPartyBranchType.joinType"
											:value="joinPartyBranchType.jpbtId">
										</el-option>
									</el-select>
								</el-form-item>
							</el-tooltip>
						</el-col>
						<el-col :span="6">
							<el-form-item label="党务工作者：" prop="partyStaff">
								<el-select clearable v-model="partyUser_manager_updatePartyUserForm.partyStaff">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="党代表：" prop="partyRepresentative">
								<el-select clearable v-model="partyUser_manager_updatePartyUserForm.partyRepresentative">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="志愿者：" prop="volunteer">
								<el-select clearable v-model="partyUser_manager_updatePartyUserForm.volunteer">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
					</el-row>

					<el-row :gutter="20">
						<el-col :span="6">
							<el-form-item label="困难党员：" prop="difficultUser">
								<el-select clearable v-model="partyUser_manager_updatePartyUserForm.difficultUser">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="先进党员：" prop="advancedUser">
								<el-select clearable v-model="partyUser_manager_updatePartyUserForm.advancedUser">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="发展党员：" prop="developUser">
								<el-select clearable v-model="partyUser_manager_updatePartyUserForm.developUser">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="6">
							<el-form-item label="失联党员：" prop="missingUser">
								<el-select clearable v-model="partyUser_manager_updatePartyUserForm.missingUser">
									<el-option label="是" :value="1"></el-option>
									<el-option label="否" :value="0"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
					</el-row>

					<el-row v-if="false" :gutter="20">
						<el-col :span="24"><span class="partyUserTitleFont">个人简介</span></el-col>
					</el-row>

					<el-row v-if="false" :gutter="20">
						<el-col :span="24">
							<el-form-item label="简介：" prop="introduce">
								<el-input
								  	type="textarea"
								 	:autosize="{ minRows: 4}"
								 	placeholder="请输入内容"
									v-model="partyUser_manager_updatePartyUserForm.introduce">
								</el-input>
							</el-form-item>
						</el-col>
					</el-row>
				</template>

				<el-form-item>
					<el-button type="primary" @click="partyUser_manager_updatePartyUser()">更新信息</el-button>
				</el-form-item>
			</el-form>
		</el-dialog>

		<el-dialog @close="partyUser_manager_resetDeedsUserForm" title="人物事迹" :visible.sync="partyUser_manager_insertDeedsUserDialog">
			<el-form size="small" :model="partyUser_manager_deedsUserForm" status-icon :rules="partyUser_manager_deedsUserRules" 
				ref="partyUser_manager_deedsUserForm" label-width="100px">
				<el-row>
					<span style="color: red;">
						以下步骤至少填写一项
					</span>
				</el-row>
				<el-steps :active="stepNum">
				  	<el-step title="个人经历"></el-step>
				  	<el-step title="获得荣誉"></el-step>
				  	<el-step title="个人感言"></el-step>
				  	<el-step title="他人评价"></el-step>
				</el-steps>
				<el-row v-show="stepNum == 1">
					<el-form-item label="经历标题：" prop="deedsTitle_jl">
						<el-input 
							clearable 
							v-model="partyUser_manager_deedsUserForm.deedsTitle_jl"
							placeholder="请填写，没有请点击下一步"></el-input>
					</el-form-item>
					<el-form-item label="详细描述：" prop="deedsDetail_jl">
						<el-input
						  	type="textarea"
						 	:autosize="{ minRows: 4}"
						 	placeholder="请输入经历的详细细节，没有请点击下一步"
							v-model="partyUser_manager_deedsUserForm.deedsDetail_jl">
						</el-input>
					</el-form-item>
					<el-form-item label="经历剪影：" prop="imgs_jl">
						<el-upload
							class="shijiUpload"
						  	ref="upload_jl" 
						  	action=""
						  	:auto-upload="false"
						  	:multiple="true"
						  	list-type="picture-card">
						  	<div slot="tip" class="el-upload__tip">只能上传jpg/jpeg/png文件</div>
						</el-upload>
					</el-form-item>
				</el-row>
				<el-row v-show="stepNum == 2">
					<el-form-item label="获奖时间：" prop="occurrenceTime_ry">
						<el-date-picker
							clearable
							style="width: 100%;"
					    	v-model="partyUser_manager_deedsUserForm.occurrenceTime_ry"
					    	type="date" 
					    	value-format="yyyy-MM-dd" 
					    	placeholder="请选择时间">
					    </el-date-picker>
					</el-form-item>
					<el-form-item label="所获荣誉：" prop="deedsDetail_ry">
						<el-input
						  	type="textarea"
						 	:autosize="{ minRows: 4}"
						 	placeholder="请填写，没有请点击下一步"
							v-model="partyUser_manager_deedsUserForm.deedsDetail_ry">
						</el-input>
					</el-form-item>
					<el-form-item label="荣誉时刻：" prop="imgs_ry">
						<el-upload
							class="shijiUpload"
						  	ref="upload_ry"
						  	action=""
						  	:auto-upload="false"
						  	:multiple="true"
						  	list-type="picture-card">
						  	<div slot="tip" class="el-upload__tip">只能上传jpg/jpeg/png文件</div>
						</el-upload>
					</el-form-item>
				</el-row>
				<el-row v-show="stepNum == 3">
					<el-form-item label="标题：" prop="deedsTitle_gy">
						<el-input 
							clearable 
							v-model="partyUser_manager_deedsUserForm.deedsTitle_gy"
							placeholder="请填写，没有请点击下一步"></el-input>
					</el-form-item>
					<el-form-item label="个人感言：" prop="deedsDetail_gy">
						<el-input
						  	type="textarea"
						 	:autosize="{ minRows: 4}"
						 	placeholder="请输入个人感言的详细细节，没有请点击下一步"
							v-model="partyUser_manager_deedsUserForm.deedsDetail_gy">
						</el-input>
					</el-form-item>
					<el-form-item label="个人感言：" prop="imgs_gy">
						<el-upload
							class="shijiUpload"
						  	ref="upload_gy"
						  	action=""
						  	:auto-upload="false"
						  	:multiple="true"
						  	list-type="picture-card">
						  	<div slot="tip" class="el-upload__tip">只能上传jpg/jpeg/png文件</div>
						</el-upload>
					</el-form-item>
				</el-row>
				<el-row v-show="stepNum == 4">
					<el-form-item label="标题：" prop="deedsTitle_pj">
						<el-input 
							clearable 
							v-model="partyUser_manager_deedsUserForm.deedsTitle_pj"
							placeholder="请填写，没有请点击下一步"></el-input>
					</el-form-item>
					<el-form-item label="他人评价：" prop="deedsDetail_pj">
						<el-input
						  	type="textarea"
						 	:autosize="{ minRows: 4}"
						 	placeholder="请输入他人评价的详细细节，没有请点击下一步"
							v-model="partyUser_manager_deedsUserForm.deedsDetail_pj">
						</el-input>
					</el-form-item>
					<el-form-item label="他人评价：" prop="imgs_pj">
						<el-upload
							class="shijiUpload"
						  	ref="upload_pj"
						  	action=""
						  	:auto-upload="false"
						  	:multiple="true"
						  	list-type="picture-card">
						  	<div slot="tip" class="el-upload__tip">只能上传jpg/jpeg/png文件</div>
						</el-upload>
					</el-form-item>
				</el-row>
				<el-row>
					<el-button v-if="stepNum != 1" size="small" @click="deedsUserStepSet('s')">上一步</el-button>
					<el-button v-if="stepNum != 4" size="small" type="primary" @click="deedsUserStepSet('x')">下一步</el-button>
					<el-button v-if="stepNum == 4" size="small" type="primary" @click="partyUser_manager_insertDeedsUser">提交</el-button>
				</el-row>
			</el-form>
		</el-dialog>

		<el-dialog title="人物事迹" :visible.sync="bigShijiImgDialog" width="50%">
			<div style="margin-bottom: 15px; display:inline-block; text-align: center; width: 100%; box-shadow: 0 8px 15px rgba(0,0,0,0.55);">
				<img style="width: 100%" :src="getNewPath(bigShijiImgPaths)">
			</div>
		</el-dialog>

		<el-dialog @close="partyUser_manager_resetSupplyDeedsUserForm" title="补充事迹" :visible.sync="partyUser_manager_supplyDeedsUserDialog">
			<el-form size="small" :model="partyUser_manager_supplyDeedsUserForm" status-icon :rules="partyUser_manager_supplyDeedsUserRules" 
				ref="partyUser_manager_supplyDeedsUserForm" label-width="100px">
				<el-row>
					<el-form-item label="事迹类型：" prop="deedsType">
						<el-select style="width: 220px;" clearable v-model="partyUser_manager_supplyDeedsUserForm.deedsType" filterable placeholder="请选择，可搜索">
							<el-option
								v-for="item in partyUser_manager_supplyDeedsUserForm.deedsTypes"
								:key="item.id"
								:label="item.name"
								:value="item.id">
							</el-option>
						</el-select>
					</el-form-item>
				</el-row>
				<el-row  v-if="partyUser_manager_supplyDeedsUserForm.deedsType != 2">
					<el-form-item label="标题：" prop="deedsTitle">
						<el-input 
							style="width: 220px;" clearable 
							v-model="partyUser_manager_supplyDeedsUserForm.deedsTitle"
							placeholder="事迹的标题"></el-input>
					</el-form-item>
				</el-row>
				<el-row v-if="partyUser_manager_supplyDeedsUserForm.deedsType == 2">
					<el-form-item label="发生时间：" prop="occurrenceTime">
						<el-date-picker
							clearable
					    	v-model="partyUser_manager_supplyDeedsUserForm.occurrenceTime"
					    	type="date" 
					    	value-format="yyyy-MM-dd" 
					    	placeholder="请选择时间">
					    </el-date-picker>
					</el-form-item>
				</el-row>
				<el-row>
					<el-col :span="24">
						<el-form-item label="详细描述：" prop="deedsDetail">
							<el-input
							  	type="textarea"
							 	:autosize="{ minRows: 4}"
							 	placeholder="请输入内容"
								v-model="partyUser_manager_supplyDeedsUserForm.deedsDetail">
							</el-input>
						</el-form-item>
					</el-col>
				</el-row>
				<el-row>
					<el-form-item label="精彩时刻：" prop="imgs">
						<el-upload
							class="shijiUpload"
						  	ref="supplyImgUpload"
						  	action=""
						  	:auto-upload="false"
						  	:multiple="true"
						  	list-type="picture-card">
						  	<div slot="tip" class="el-upload__tip">只能上传jpg/jpeg/png文件</div>
						</el-upload>
					</el-form-item>
				</el-row>
				<el-row>
					<el-button size="small" type="primary" @click="insertSupplyDeedsUser">补充事迹</el-button>
				</el-row>
			</el-form>
		</el-dialog>

		<el-dialog @close="partyUser_manager_resetUpdateDeedsUserForm" title="修改事迹" :visible.sync="partyUser_manager_updateDeedsUserDialog">
			<el-form size="small" :model="partyUser_manager_updateDeedsUserForm" status-icon :rules="partyUser_manager_updateDeedsUserRules" 
				ref="partyUser_manager_updateDeedsUserForm" label-width="100px">
				<el-row>
					<el-form-item label="事迹类型：" prop="deedsTypeName">
						<el-input 
							:disabled="true"
							style="width: 220px;" clearable 
							v-model="partyUser_manager_updateDeedsUserForm.deedsTypeName"
							placeholder="事迹类型"></el-input>
					</el-form-item>
				</el-row>
				<el-row v-if="partyUser_manager_updateDeedsUserForm.deedsTypeId != 2">
					<el-form-item label="标题：" prop="deedsTitle">
						<el-input 
							style="width: 220px;" clearable 
							v-model="partyUser_manager_updateDeedsUserForm.deedsTitle"
							placeholder="事迹的标题"></el-input>
					</el-form-item>
				</el-row>
				<el-row v-if="partyUser_manager_updateDeedsUserForm.deedsTypeId == 2">
					<el-form-item label="发生时间：" prop="occurrenceTime">
						<el-date-picker
							clearable
					    	v-model="partyUser_manager_updateDeedsUserForm.occurrenceTime"
					    	type="date" 
					    	value-format="yyyy-MM-dd" 
					    	placeholder="请选择时间">
					    </el-date-picker>
					</el-form-item>
				</el-row>
				<el-row>
					<el-col :span="24">
						<el-form-item label="详细描述：" prop="deedsDetail">
							<el-input
							  	type="textarea"
							 	:autosize="{ minRows: 4}"
							 	placeholder="请输入内容"
								v-model="partyUser_manager_updateDeedsUserForm.deedsDetail">
							</el-input>
						</el-form-item>
					</el-col>
				</el-row>
				<el-row>
					<el-form-item label="精彩时刻：" prop="imgs">
						<el-upload
							class="shijiUpload"
						  	ref="updateImgUpload"
						  	action=""
						  	:file-list="partyUser_manager_updateDeedsUserForm.diMgs"
						  	:auto-upload="false"
						  	:on-remove="updateImgUploadRemoveHaveImg"
						  	:multiple="true"
						  	list-type="picture-card">
						  	<div slot="tip" class="el-upload__tip">只能上传jpg/jpeg/png文件</div>
						</el-upload>
					</el-form-item>
				</el-row>
				<el-row>
					<el-button size="small" type="primary" @click="updateSupplyDeedsUser">变更事迹</el-button>
				</el-row>
			</el-form>
		</el-dialog>
	</div>
</body>


<script type="text/javascript">
	var appInstince = new Vue({
		el: '#app',
		data: {
			partyUser_manager_jumpToUserDetailInfoArray: [],	/*点击卡片跳转到详细信息，用于保存值，赋值给rowkey以便展开信息*/
			dis_h_v: true,
			partyUser_manager_importPartyUserExcelErrorMsg: null,	/*导入党员校验错误信息*/
			partyUser_manager_joinOrgInfoForm: {
				orgInfoTreeOfJoinOrg: [],
				orgDutyTreesForOrgInfo: [],
				haveDutyForThisOrgInfo: [],	/*在这个组织中已经有的职责*/
				orgRltInfoId: null,
				orgRltUserId: null,
				joinTime: null
			},
			partyUser_manager_joinOrgInfoOrgDutyTreesForOrgInfoProps: {
				children: 'children',
	            label: function(_data, node){
	            	return _data.data.orgDutyName;
	            }
			},
			partyUser_manager_joinOrgInfoFormProps: {
				children: 'children',
	            label: function(_data, node){
	            	return _data.data.orgInfoName;
	            }
			},
			partyUser_manager_joinOrgInfoRules: {

			},
			partyUser_manager_insertPartyUserDialog: false,	/* 添加党员信息窗口 */
			partyUser_manager_updatePartyUserDialog: false,	/*修改党员信息窗口*/
			partyUser_manager_joinOrgInfoDialog: false,		/*加入组织信息窗口*/
			partyUser_manager_updatePartyUserIdPhotoDialog: false,	/*修改党员证件照*/
			partyUser_manager_importPartyUserExcelErrorMsgDialog: false,	/*导入党员显示错误校验信息*/
			partyUser_manager_pager: {	/*初始化分页信息*/
				pageNum: 1,		/* 当前页 */
				pageSize: 10,	/* 页面大小 */
				total: 0,
				list: []
			},
			partyUser_manager_queryPartyUserInfosCondition: {
				name: null,
				isParty: null,
				sex: null,
				orgInfoId: null
			},
			partyUser_manager_address_pca: pca,	/* 省市区三级联动数据 */
			partyUser_manager_address_prop: {	/* 地址prop */
				value: "name",
				label: "name",
				children: "children"
			},
			partyUser_manager_insertPartyUserForm: {	 /*添加党员信息绑定 */
				birthDate:null,
				nativePlace:null,
				academicDegree: null,
				education: null,
				isParty: 0
			},
			partyUser_manager_updatePartyUserForm: {	 /*修改党员信息绑定 */
				id: null,
				name: null,
				sex: null,
				nativePlace: null,
				birthDate:null,
				nation: null,
				idCard: null,
				mobilePhone: null,
				email: null,
				qq: null,
				wechat: null,
				education: null,
				academicDegree: null,
				enrolmentTime: null,
				graduationTime: null,
				graduationSchool: null,
				major: null,
				specialityLiterature: null,
				specialityMajor: null,
				marriageStatus: null,
				childrenStatus: null,
				homeAddress_pca: null,
				homeAddressDetail: null,
				presentAddress_pca: null,
				presentAddressDetail: null,
				type: null,
				status: null,
				joinDateFormal: null,
				joinDateReserve: null,
				workUnit: null,
				workNature: null,
				joinWorkDate: null,
				appointmentTimeLength: null,
				joinPartyBranchType: null,
				firstLineTypeName: null,
				partyStaff: null,
				partyRepresentative: null,
				volunteer: null,
				difficultUser: null,
				advancedUser: null,
				positiveUser: null,
				developUser: null,
				missingUser: null,
				introduce: null,
				idPhotoImg: [],	/*用户的当前头像*/
				isParty: 0,
				idPhoto: null
			},
			partyUser_manager_updatePartyUserRules: {	/*修改党员信息验证*/
				name: [
					{ required: true, message: '请输入身份姓名!', trigger: 'blur' },
					{ pattern: /^[\u4e00-\u9fa5.·]+$/, message: '请输入正确的姓名!'}	
				],
				mobilePhone: [
					{ required: true, message: '请输入手机号码!', trigger: 'blur' },
					{ pattern: /^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\d{8}$/, message: '请输入11位正确的手机号码!'}
				],
				email: [
					{ pattern: /^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$/, message: '邮箱格式不正确!'}
				],
				qq: [
					{ pattern: /^[1-9][0-9]{4,10}/, message: 'QQ号码不正确!'}
				],
				wechat: [
					{ pattern: /^[-_a-zA-Z0-9]{6,19}$/, message: '6至20长度，只能包含数字祖母下划线和减号!'}
				],
				education: [
					{ required: true, message: '请选择受教育水平!' }
				],
				enrolmentTime: [
					{ required: true, message: '请选择入学时间!' }
				],
				graduationTime: [
					{ required: true, message: '请选择毕业时间时间!' }
				],
				graduationSchool: [
					{ required: true, message: '请输入毕业学校!' }
				],
				major: [
					{ required: true, message: '请输入在校学习专业!' }
				],
				presentAddress_pca: [
					{ required: true, message: '请选择现住址的省市区!' }
				],
				presentAddressDetail: [
					{ required: true, message: '请输入现住址详细地址!' }
				],
				type: [
					{ required: true, message: '请选择党员类型!' }
				],
				status: [
					{ required: true, message: '请选择党员状态!' }
				]
			},	
			partyUser_manager_insertPartyUserRules: {	/* 添加党员信息校验 */
				name: [
					{ required: true, message: '请输入身份姓名!', trigger: 'blur' },
					{ pattern: /^[\u4e00-\u9fa5.·]+$/, message: '请输入正确的姓名!'}	
				],
				sex: [
					{ required: true, message: '请选择性别!' }
				],
				nation: [
					{ required: true, message: '请选择民族!' }
				],
				idCard: [
					{ required: true, message: '请输入15或18位身份证号码!', trigger: 'blur' },
					{ pattern: /^(^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$)|(^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])((\d{4})|\d{3}[Xx])$)$/, message: '请输入正确的身份证号码!'},
					{ 
		        		validator: function(rule, value, callback){
	        				var year = null;
							var month = null;
							var day = null;
							if (value.length == 15) {	/*15为身份证号码*/
								year = "19" + value.substring(6,8);
								month = value.substring(8,10);
								day = value.substring(10,12);
							} else if (value.length == 18) {	/*18为身份证号码*/
								year = value.substring(6,10);
								month = value.substring(10,12);
								day = value.substring(12,14);
							} 
							appInstince.partyUser_manager_insertPartyUserForm.birthDate = year + "-" + month + "-" + day;
							callback();
		        		},
		        		trigger: 'blur'
		        	},
		        	{ 	/* 重复身份证号码验证 */
		        		validator: function(rule, value, callback){
		        			setTimeout(function() {
		        				var url = "/base/userInfo/queryBaseUserInfos";
		        				var t = {
	        						idCard: value,
	        						pageNum: 1,
       								pageSize: 1,
		        				}
		        				$.post(url, t, function(data, status){
		        					if (data.code == 200) {
		        						if (data.data == undefined) {
			        						callback();
			        					} else {
			        						callback(new Error('该党员已经存在!'));
			        					}
		        					} else {
		        						alert("添加党员功能出错，不能添加");
		        						appInstince.partyUser_manager_resetInsertPartyUserForm();
		        					}
		        					
		        				})
	        		        }, 1);
		        		}
		        	}
				],
				mobilePhone: [
					{ required: true, message: '请输入手机号码!', trigger: 'blur' },
					{ pattern: /^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\d{8}$/, message: '请输入11位正确的手机号码!'}
				],
				email: [
					{ pattern: /^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$/, message: '邮箱格式不正确!'}
				],
				qq: [
					{ pattern: /^[1-9][0-9]{4,10}/, message: 'QQ号码不正确!'}
				],
				wechat: [
					{ pattern: /^[a-zA-Z]{1}[-_a-zA-Z0-9]{5,19}$/, message: '6至20长度，只能包含数字祖母下划线和减号!'}
				],
				education: [
					{ required: true, message: '请选择受教育水平!' }
				],
				enrolmentTime: [
					{ required: true, message: '请选择入学时间!' }
				],
				graduationTime: [
					{ required: true, message: '请选择毕业时间时间!' }
				],
				graduationSchool: [
					{ required: true, message: '请输入毕业学校!' }
				],
				major: [
					{ required: true, message: '请输入在校学习专业!' }
				],
				homeAddress_pca: [
					{ required: true, message: '请选择家庭住址的省市区!' }
				],
				homeAddressDetail: [
					{ required: true, message: '请输入家庭住址详细地址!' }
				],
				presentAddress_pca: [
					{ required: true, message: '请选择现住址的省市区!' }
				],
				presentAddressDetail: [
					{ required: true, message: '请输入现住址详细地址!' }
				],
				type: [
					{ required: true, message: '请选择党员类型!' }
				],
				status: [
					{ required: true, message: '请选择党员状态!' }
				]
			},
			partyUser_manager_nationTypes: [],	/* 民族 */
			partyUser_manager_educationLevels: [],	/* 教育水平 */
			partyUser_manager_academicDegreeLevels: [],	/* 学位水平 */
			//partyUser_manager_orgInfos: [],	/*公司信息*/
			partyUser_manager_firstLineTypes: [],	/*一线情况*/
			partyUser_manager_joinPartyBranchTypes: [],	/*加入党支部方式*/
			partyUser_manager_workNatureTypes: [],	/*工作性质*/
			selectOptions: {
				havePartyUserOrgs: []
			},
			partyUser_manager_uploadPartyUserIdPhotoTempFileName: "",
			signInAccountType: null,
			partyUser_manager_insertDeedsUserDialog: false,
			partyUser_manager_supplyDeedsUserDialog: false,
			partyUser_manager_updateDeedsUserDialog: false,
			bigShijiImgDialog: false,
			bigShijiImgPaths: "",
			stepNum: 1,
			partyUser_manager_supplyDeedsUserForm: {	//补充事迹
				deedsTypes: [],
				deedsType: null,
				deedsTitle: null,
				occurrenceTime: null,
				deedsDetail: null,
				item: null,
			},
			partyUser_manager_supplyDeedsUserRules: {
				deedsType: [
					{ required: true, message: '请选择补充事迹类型', trigger: 'blur' }
				],
				deedsTitle: [
					{ required: true, message: '请添加补充事迹标题', trigger: 'blur' }
				],
				occurrenceTime: [
					{ required: true, message: '请添加获得荣誉的时间', trigger: 'blur' }
				],
				deedsDetail: [
					{ required: true, message: '请填写补充事迹的内容', trigger: 'blur' }
				]
			},
			partyUser_manager_updateDeedsUserForm: {	//修改事迹
				deedsTypeName: null,
				deedsTitle: null,
				deedsTypeId: null,
				occurrenceTime: null,
				id: null,
				deedsDetail: null,
				diMgs: [],
				deleteDiMgs: ""
			},
			partyUser_manager_updateDeedsUserRules: {
				deedsTitle: [
					{ required: true, message: '请添加补充事迹标题', trigger: 'blur' }
				],
				occurrenceTime: [
					{ required: true, message: '请添加获得荣誉的时间', trigger: 'blur' }
				],
				deedsDetail: [
					{ required: true, message: '请填写补充事迹的内容', trigger: 'blur' }
				]
			},
			partyUser_manager_deedsUserForm: {
				deedsTypes: [],
				deedsType: null,
				deedsTitle_jl: null,
				deedsTitle_gy: null,
				deedsTitle_pj: null,
				deedsDetail_jl: null,
				deedsDetail_ry: null,
				deedsDetail_gy: null,
				deedsDetail_pj: null,
				occurrenceTime_ry: null,
				userId: null,

				imgs_jl: "",
				imgs_ry: "",
				imgs_gy: "",
				imgs_pj: "",
				completeCount: 0
			},
			partyUser_manager_deedsUserRules: {
				deedsTitle_jl: [
					{ 
		        		validator: function(rule, value, callback){
		        			if ((appInstince.partyUser_manager_deedsUserForm.deedsTitle_jl != "" &&
		        					appInstince.partyUser_manager_deedsUserForm.deedsTitle_jl != null)
		        				&& (appInstince.partyUser_manager_deedsUserForm.deedsDetail_jl == "" ||
		        					appInstince.partyUser_manager_deedsUserForm.deedsDetail_jl == null)) {
		        				callback(new Error('请填写经历的详细信息'));
	        		        } else {
	        		            callback();
	        		        }
		        		},
		        		trigger: 'blur'
		        	}
				],
				deedsDetail_jl: [
					{ 
		        		validator: function(rule, value, callback){
		        			if ((appInstince.partyUser_manager_deedsUserForm.deedsTitle_jl == "" ||
		        					appInstince.partyUser_manager_deedsUserForm.deedsTitle_jl == null)
		        				&& (appInstince.partyUser_manager_deedsUserForm.deedsDetail_jl != "" &&
		        					appInstince.partyUser_manager_deedsUserForm.deedsDetail_jl != null)) {
		        				callback(new Error('请填写经历的标题'));
	        		        } else {
	        		            callback();
	        		        }
		        		},
		        		trigger: 'blur'
		        	}
				],


				occurrenceTime_ry: [
					{ 
		        		validator: function(rule, value, callback){
		        			if ((appInstince.partyUser_manager_deedsUserForm.occurrenceTime_ry != "" &&
		        					appInstince.partyUser_manager_deedsUserForm.occurrenceTime_ry != null)
		        				&& (appInstince.partyUser_manager_deedsUserForm.deedsDetail_ry == "" ||
		        					appInstince.partyUser_manager_deedsUserForm.deedsDetail_ry == null)) {
		        				callback(new Error('请填写荣誉的详细信息'));
	        		        } else {
	        		            callback();
	        		        }
		        		},
		        		trigger: 'blur'
		        	}
				],
				deedsDetail_ry: [
					{ 
		        		validator: function(rule, value, callback){
		        			if ((appInstince.partyUser_manager_deedsUserForm.occurrenceTime_ry == "" ||
		        					appInstince.partyUser_manager_deedsUserForm.occurrenceTime_ry == null)
		        				&& (appInstince.partyUser_manager_deedsUserForm.deedsDetail_ry != "" &&
		        					appInstince.partyUser_manager_deedsUserForm.deedsDetail_ry != null)) {
		        				callback(new Error('请填写获得荣誉的时间'));
	        		        } else {
	        		            callback();
	        		        }
		        		},
		        		trigger: 'blur'
		        	}
				],


				deedsTitle_gy: [
					{ 
		        		validator: function(rule, value, callback){
		        			if ((appInstince.partyUser_manager_deedsUserForm.deedsTitle_gy != "" &&
		        					appInstince.partyUser_manager_deedsUserForm.deedsTitle_gy != null)
		        				&& (appInstince.partyUser_manager_deedsUserForm.deedsDetail_gy == "" ||
		        					appInstince.partyUser_manager_deedsUserForm.deedsDetail_gy == null)) {
		        				callback(new Error('请填写个人感言的详细信息'));
	        		        } else {
	        		            callback();
	        		        }
		        		},
		        		trigger: 'blur'
		        	}
				],
				deedsDetail_gy: [
					{ 
		        		validator: function(rule, value, callback){
		        			if ((appInstince.partyUser_manager_deedsUserForm.deedsTitle_gy == "" ||
		        					appInstince.partyUser_manager_deedsUserForm.deedsTitle_gy == null)
		        				&& (appInstince.partyUser_manager_deedsUserForm.deedsDetail_gy != "" &&
		        					appInstince.partyUser_manager_deedsUserForm.deedsDetail_gy != null)) {
		        				callback(new Error('请填写个人感言的标题'));
	        		        } else {
	        		            callback();
	        		        }
		        		},
		        		trigger: 'blur'
		        	}
				],


				deedsTitle_pj: [
					{ 
		        		validator: function(rule, value, callback){
		        			if ((appInstince.partyUser_manager_deedsUserForm.deedsTitle_pj != "" &&
		        					appInstince.partyUser_manager_deedsUserForm.deedsTitle_pj != null)
		        				&& (appInstince.partyUser_manager_deedsUserForm.deedsDetail_pj == "" ||
		        					appInstince.partyUser_manager_deedsUserForm.deedsDetail_pj == null)) {
		        				callback(new Error('请填写他人评价的详细信息'));
	        		        } else {
	        		            callback();
	        		        }
		        		},
		        		trigger: 'blur'
		        	}
				],
				deedsDetail_pj: [
					{ 
		        		validator: function(rule, value, callback){
		        			if ((appInstince.partyUser_manager_deedsUserForm.deedsTitle_pj == "" ||
		        					appInstince.partyUser_manager_deedsUserForm.deedsTitle_pj == null)
		        				&& (appInstince.partyUser_manager_deedsUserForm.deedsDetail_pj != "" &&
		        					appInstince.partyUser_manager_deedsUserForm.deedsDetail_pj != null)) {
		        				callback(new Error('请填写他人评价的标题'));
	        		        } else {
	        		            callback();
	        		        }
		        		},
		        		trigger: 'blur'
		        	}
				]
			},
			joinPartyOrg: {
				applyJoinPartyOrgDialog: false,	/*申请入党弹窗*/
				joinPartyOrgStepNum: 1,	//当前步骤条步骤，控制步骤条
				joinPartyOrgStepNumNow: 0,	//申请进度到第几步，来自数据库
				joinPartyOrgProcess: [],
				userInfo: {
					joinPartyUserInfo: null
				},	//当前用户信息
				joinPartyOrgLoading: false,

				getJoinPartyOrgStepInfoOver: false,	//该请求是否完成
				getJoinPartyOrgProcessOver: false,	//请求是否完成
				joinPartyOrgStepInfo: {
					stepStatus: null	//步骤需要这个变量，现初始化
				},	//当前步骤信息
				flag: {	//控制显示提交控件来控制提交哪些材料
					flagContent: false,
					flagFile: false
				},
				commonTips: null,	//公共提示信息
				applyJoinPartyOrgForm: {
					userId: null,
					orgInfoId: null,
					joinOrgType: null
				},
				applyJoinPartyOrgRules: {
					orgInfoId: [
						{ required: true, message: '请选择想要加入的组织', trigger: 'blur' }
					],
					joinOrgType: [
						{ required: true, message: '请选择加入党的方式', trigger: 'blur' }
					]
				},
				orgInfosSelect: [],
				joinOrgTypeSelects: []
			},
			zidonghuachengxu_videoVariable: {
				userInfo: null,
				joinOrgFile: []
			}
		},
		created: function () {
			this.getScreenHeightForPageSize();
		},
		mounted: function () {
			this.initHavePartyUserOrgSelect();	//已存在党员的组织
			this.partyUser_manager_queryPartyUserInfos();	/*查找党员信息*/
			this.partyUser_manager_queryNationType();	/*初始化民族下拉框*/
			this.partyUser_manager_queryEducationLevels(); /* 初始化学历水平下拉框 */
			this.partyUser_manager_queryAcademicDegreeLevels();	/* 初始化学位水平下拉框 */
			//this.partyUser_manager_queryOrgInfosNotPage();	/* 初始化公司信息下拉框 */
			this.partyUser_manager_queryWorkNatureTypes();	/*初始化工作性质下拉框*/
			this.partyUser_manager_queryJoinPartyBranchTypes();	/*初始化加入党支部方式下拉框*/
			this.partyUser_manager_queryFirstLineTypes();	/*初始化一线情况下拉框*/
			this.getSignInAccountType();
		},
		methods: {
			zidonghuachengxu_video() {	//为了录像
				var obj = this;
				setTimeout(() => {
					obj.$message({
						message:'开始入党申请',
						duration: 1000
					});
					obj.zidonghuachengxu_videoVariable.userInfo = obj.partyUser_manager_pager.list[0];
					setTimeout(() => {
						obj.openApplyJoinPartyOrgDialog(obj.zidonghuachengxu_videoVariable.userInfo);
						setTimeout(() => {
							obj.$message({
								message:'设置加入党组织',
								duration: 1000
							});
							obj.joinPartyOrg.applyJoinPartyOrgForm.orgInfoId = obj.joinPartyOrg.orgInfosSelect[2].orgInfoId;
							setTimeout(() => {
								obj.$message({
									message:'设置加入方式',
									duration: 1000
								});
								obj.joinPartyOrg.applyJoinPartyOrgForm.joinOrgType = obj.joinPartyOrg.joinOrgTypeSelects[3].jpbtId;
								setTimeout(() => {
									obj.$message({
										message:'设置入党申请书',
										duration: 1000
									});
									obj.zidonghuachengxu_videoVariable.joinOrgFile = obj.$refs.variableJoinOrgFile.uploadFiles;
									obj.$refs.upload_joinPartyOrg.uploadFiles = obj.zidonghuachengxu_videoVariable.joinOrgFile;
									setTimeout(() => {
										obj.$message({
											message:'提交入党申请',
											duration: 1000
										});
										obj.submitJoinPartyOrg();
									}, 1300);
								}, 1300);
							}, 1300);
						}, 1300);
					}, 1300);
				}, 1300);
			},
			validataUploadJoinPartyOrgFiles(joinFiles) {
				if (joinFiles.length != 0) {
					for (var i = 0; i < joinFiles.length; i++) {
						var joinFile = joinFiles[i];
						var fileFormat = joinFile.name.split(".");
						var fileSuffix = fileFormat[fileFormat.length - 1];	/* 拿到文件后缀 */
						if (fileSuffix == "doc" || fileSuffix == "docx") {
							continue; 
						}
						toast('格式错误',"只能上传doc或docx格式的文件，请检查选中的文件",'error');
						return false;
					}
				}
				return true;
			},
			submitJoinPartyOrg() {
				var obj = this;
				this.$refs["applyJoinPartyOrgForm"].validate( function(valid) {
					if (valid) {
						obj.joinPartyOrg.joinPartyOrgLoading = true;

						var joinFiles = obj.$refs.upload_joinPartyOrg.uploadFiles;
						// if (!obj.validataUploadJoinPartyOrgFiles(joinFiles)) {	//验证文件格式
						// 	obj.joinPartyOrg.joinPartyOrgLoading = false;
						// 	return;
						// }

						if (obj.joinPartyOrg.joinPartyOrgStepNum == 1 || obj.joinPartyOrg.joinPartyOrgStepNum == 5) {	//入党第一步必须提交入党申请书
							if (joinFiles == null || joinFiles.length == 0) {
								var msggggg = "";
								if (obj.joinPartyOrg.joinPartyOrgStepNum == 1) {
									msggggg = "请上传入党申请书";
								} else if (obj.joinPartyOrg.joinPartyOrgStepNum == 8) {
									msggggg = "请上传申请预备党员申请书";
								}
								toast('错误',msggggg ,'error');
								obj.joinPartyOrg.joinPartyOrgLoading = false;
								return;
							}
						}
						
						var joinFileUploadCount = 0;
						var joinFileCount = joinFiles == null ? 0 : joinFiles.length;
						var joinFileUploadUrl = "";
						if (joinFiles != null && joinFiles.length > 0) {	//上传材料
							for (var i = 0; i < joinFiles.length; i++) {
								var formData = new FormData();
								formData.append("file", joinFiles[i].raw);
								$.ajax({
				                   	url: "http://192.168.1.8:3000/upload",
				                   	data: formData,
				                   	type: "Post",
				                   	cache: false,//上传文件无需缓存
				                   	processData: false,//用于对data参数进行序列化处理 这里必须false
				                   	contentType: false, //必须
				                   	success: function (data) {
				                   		if (data != null && data != undefined) {
				                   			if (data.state == "SUCCESS") {
												var fileFormat = data.original.split(".");
												var fileSuffix = fileFormat[fileFormat.length - 1];	/* 拿到文件后缀 */
												joinFileUploadUrl += data.url + ",入党申请书-" + obj.joinPartyOrg.userInfo.name + "-" + obj.joinPartyOrg.userInfo.id + "."
													+ fileSuffix + ",";
												//上传完成，数量加一，与上传总图片数量比对，如果一致则全部上传完毕，开始事迹内容上传
												joinFileUploadCount++;
					                	   	} 
				                   		} 
				                   	},
				                   	error: function() {
										toast('错误','材料上传失败' ,'error');
										obj.joinPartyOrg.joinPartyOrgLoading = false;
				                   		return;
				                   	},
				                   	complete: function(XMLHttpRequest, textStatus) {
				                   		//覆盖默认函数，避免报错
				                   	}
				               })
							}
						}
						
						var timeCount = 0;
						var beginInsert = function() {
							if (timeCount > 10 * 1000) {
								toast('错误','上传材料超时' ,'error');
								obj.joinPartyOrg.joinPartyOrgLoading = false;
								return;
							}
							if (joinFileCount == joinFileUploadCount) {	//实际上传数量和要上传成功数量一致
								var url = "/join/user/insertJoinPartyOrgUsers";
								var t = {
									userId: obj.joinPartyOrg.applyJoinPartyOrgForm.userId,
									stepNum: obj.joinPartyOrg.joinPartyOrgStepNum,
									orgInfoId: obj.joinPartyOrg.applyJoinPartyOrgForm.orgInfoId,
									joinFileUploadUrl: joinFileUploadUrl,
									joinOrgType: obj.joinPartyOrg.applyJoinPartyOrgForm.joinOrgType
								}
								if (obj.joinPartyOrg.userInfo.joinPartyUserInfo != null) {
									t.joinId = obj.joinPartyOrg.userInfo.joinPartyUserInfo.id;
								}
								$.post(url, t, function(data, status){
									if (data.code == 200) {
										toast('提示',"操作成功",'success');
										obj.joinPartyOrg.joinPartyOrgLoading = false;
										obj.joinPartyOrg.applyJoinPartyOrgDialog = false;
										obj.partyUser_manager_queryPartyUserInfos();
									} else {
										toast('提示',"操作失败",'error');
										obj.joinPartyOrg.joinPartyOrgLoading = false;
									}
								})
							} else {
								timeCount += 50;
								setTimeout(beginInsert, 50);
							}
						}
						beginInsert();
					}
				});
			},
			resetApplyJoinPartyOrgDialog() {	//关闭入党弹窗重置数据
				var obj = this;
				if (obj.joinPartyOrg.joinPartyOrgStepInfo.stepStatus == null) {	//当没有步骤时，则添加当前步骤信息，此时在充值表单，防止表单未初始化而重置失败
					obj.$refs["applyJoinPartyOrgForm"].resetFields();
				}
				obj.joinPartyOrg.joinPartyOrgStepNum = 1;
				obj.joinPartyOrg.joinPartyOrgStepNumNow = 0;
				obj.joinPartyOrg.joinPartyOrgStepInfo = {
					stepStatus: null
				};
				obj.joinPartyOrg.userInfo = {
					joinPartyUserInfo: null
				};
				obj.joinPartyOrg.getJoinPartyOrgStepInfoOver = false;
				obj.joinPartyOrg.getJoinPartyOrgProcessOver = false;
				obj.joinPartyOrg.joinPartyOrgProcess = [];
				obj.joinPartyOrg.commonTips = null;
				obj.joinPartyOrg.joinPartyOrgLoading = false;
			},
			joinPartyOrgStepSet(step) {	//入党步骤条设置
				var obj = this;

				//重置公共提示信息
				obj.joinPartyOrg.commonTips = null;
				obj.joinPartyOrg.flag.flagFile = false;
				obj.joinPartyOrg.flag.flagContent = false;

				if (step == 's') {
					obj.joinPartyOrg.joinPartyOrgStepNum--;
				} else {					
					obj.joinPartyOrg.joinPartyOrgStepNum++;
				}

				obj.queryJoinPartyOrgSteps(obj.joinPartyOrg.joinPartyOrgStepNum);	//查询当前进行的步骤信息
				var timeCount = 0;
				var initSomeThings = function() {
					if (timeCount > 2000) {
						toast('错误','请求数据超时' ,'error');
						return;
					}
					//等待步骤条信息和当前步骤信息请求完成，设置步骤条显示状态
					if (obj.joinPartyOrg.getJoinPartyOrgProcessOver && obj.joinPartyOrg.getJoinPartyOrgStepInfoOver) {
						obj.joinPartyOrg.getJoinPartyOrgStepInfoOver = false;

						if (obj.joinPartyOrg.joinPartyOrgStepInfo.stepStatus != null) {
							if (obj.joinPartyOrg.joinPartyOrgProcess.length >= obj.joinPartyOrg.joinPartyOrgStepNumNow) {
								obj.joinPartyOrg.joinPartyOrgProcess[obj.joinPartyOrg.joinPartyOrgStepNum - 1].status = 
									obj.joinPartyOrg.joinPartyOrgStepInfo.stepStatus == "wait" ? "process" : obj.joinPartyOrg.joinPartyOrgStepInfo.stepStatus;
								obj.joinPartyOrg.applyJoinPartyOrgDialog = true;
							}
						} else {	//没有申请入党记录，开始申请入党
							obj.joinPartyOrg.joinPartyOrgProcess[obj.joinPartyOrg.joinPartyOrgStepNum - 1].status = "process";
							if (obj.joinPartyOrg.joinPartyOrgStepNum == 1) {
								url = "/org/ifmt/queryOrgInfosSelect";
								t = {
									
								}
								$.post(url, t, function(data, status){	//选择加入的党组织
									if (data.code == 200) {
										obj.joinPartyOrg.orgInfosSelect = data.data;
									} 
								})

								var url = "/jpbt/queryJoinPartyBranchTypes";
								var t = {
								}
								$.post(url, t, function(data, status){	//如何加入
									if (data.code == 200) {
										obj.joinPartyOrg.joinOrgTypeSelects = data.data;
									}

								})

								obj.joinPartyOrg.commonTips = "请上传入党申请书，组织要求上交纸质申请此处拍照上传";
								obj.joinPartyOrg.flag.flagFile = true;
							} else if (obj.joinPartyOrg.joinPartyOrgStepNum == 8) {
								obj.joinPartyOrg.commonTips = "请上传转正申请书，组织要求上交纸质申请此处拍照上传";
								obj.joinPartyOrg.flag.flagFile = true;
							}
							
							obj.joinPartyOrg.applyJoinPartyOrgDialog = true;
						}
					} else {
						timeCount += 50;
						setTimeout(initSomeThings, 50)
					}
				}
				initSomeThings();
			},
			openApplyJoinPartyOrgDialog(userInfo) {	//打开入党弹窗
				var obj = this;

				var url = "/join/process/queryJoinPartyOrgProcess";
				var t = {
					
				}
				$.post(url, t, function(data, status){
					if (data.code == 200) {
						obj.joinPartyOrg.joinPartyOrgProcess = data.data;

						if (obj.joinPartyOrg.joinPartyOrgProcess != null && obj.joinPartyOrg.joinPartyOrgProcess.length > 0) {
							for (var i = 0; i < obj.joinPartyOrg.joinPartyOrgProcess.length; i++) {	//增加status属性，以便给步骤条设置状态
								var _process = {id: null, name: null, nameEn: null, describes: null, status: 'wait'};
								if (userInfo.joinPartyUserInfo != null && i <= userInfo.joinPartyUserInfo.nowStep - 2) {
									_process.status = "success";
								}
								_process.id = obj.joinPartyOrg.joinPartyOrgProcess[i].id;
								_process.name = obj.joinPartyOrg.joinPartyOrgProcess[i].name;
								_process.nameEn = obj.joinPartyOrg.joinPartyOrgProcess[i].nameEn;
								_process.describes = obj.joinPartyOrg.joinPartyOrgProcess[i].describes;
								obj.joinPartyOrg.joinPartyOrgProcess[i] = _process;
							}
							obj.joinPartyOrg.getJoinPartyOrgProcessOver = true;
						} 
					} 
				})


				obj.joinPartyOrg.userInfo = userInfo;	//一定存在
				obj.joinPartyOrg.applyJoinPartyOrgForm.userId = obj.joinPartyOrg.userInfo.id;
				if (obj.joinPartyOrg.userInfo.joinPartyUserInfo != null) {
					obj.joinPartyOrg.joinPartyOrgStepNum = obj.joinPartyOrg.userInfo.joinPartyUserInfo.nowStep;	//设置当前步骤，默认1
					obj.joinPartyOrg.joinPartyOrgStepNumNow = obj.joinPartyOrg.userInfo.joinPartyUserInfo.nowStep;
				}

				//在joinPartyOrgStepSet方法中步骤会+1，为了查询当前步骤，步骤先-1
				obj.joinPartyOrg.joinPartyOrgStepNum--;
				obj.joinPartyOrgStepSet('x');
			},
			queryJoinPartyOrgSteps(stepNum) {	//查询步骤信息
				var obj = this;
				if (obj.joinPartyOrg.userInfo.joinPartyUserInfo == null) {
					obj.joinPartyOrg.getJoinPartyOrgStepInfoOver = true;
					obj.joinPartyOrg.joinPartyOrgStepInfo = {
						stepStatus: null	//步骤需要这个变量，现初始化
					}
					return;
				}
				url = "/join/step/queryJoinPartyOrgSteps";
				var t = {
					joinId: obj.joinPartyOrg.userInfo.joinPartyUserInfo.id,
					processId: stepNum
				}
				$.post(url, t, function(data, status){
					if (data.code == 200 && data.data != undefined && data.data != null) {
						obj.joinPartyOrg.joinPartyOrgStepInfo = data.data;
					} else {
						obj.joinPartyOrg.joinPartyOrgStepInfo = {
							stepStatus: null	//步骤需要这个变量，现初始化
						}
					}
					obj.joinPartyOrg.getJoinPartyOrgStepInfoOver = true;
				})
			},




			initHavePartyUserOrgSelect() {	//搜索条件框-有党员的组织
				var obj = this;
				var url = "/org/relation/queryHavePartyUserOrg";
				var t = {
					
				}
				$.post(url, t, function(data, status){
					if (data.code == 200) {
						obj.selectOptions.havePartyUserOrgs = data.data;
					} 
				})
			},
			updateSupplyDeedsUser() {
				var obj = this;
				this.$refs["partyUser_manager_updateDeedsUserForm"].validate( function(valid) {
					if (valid) {
						//处理图片
						var count = 0;
						var uploaded = 0;
						var uploadedUrl = "";
						var imgs = obj.$refs.updateImgUpload.uploadFiles;
						if (!obj.validataUploadShijiImg(imgs)) {
							return;
						}

						if (imgs.length > 0) {
							for (var i = 0; i < imgs.length; i++) {
								if(imgs[i].status == "success") {	//已有图片不用处理，删掉
									continue;
								}
								count++;
							}

							for (var i = 0; i < imgs.length; i++) {
								if(imgs[i].status == "success") {	//已有图片不用处理
									continue;
								}
								var formData = new FormData();
								formData.append("file", imgs[i].raw);
								$.ajax({
				                   	url: "http://192.168.1.8:3000/image",
				                   	data: formData,
				                   	type: "Post",
				                   	cache: false,//上传文件无需缓存
				                   	processData: false,//用于对data参数进行序列化处理 这里必须false
				                   	contentType: false, //必须
				                   	success: function (data) {
				                   		if (data != null && data != undefined) {
				                   			if (data.state == "SUCCESS") {
			                   					uploadedUrl += data.url + ",";
					                	   	} else {
					                		   	toast('错误','图片上传失败' ,'error');
				                   				return;
					                	   	}
				                   		} else {
				                   			toast('错误','图片上传失败' ,'error');
				                   			return;
				                   		}
				                   	},
				                   	error: function() {
				                   		toast('错误','图片上传失败' ,'error');
				                   		return;
				                   	},
				                   	complete: function(XMLHttpRequest, textStatus) {
				                   		//上传完成，数量加一，与上传总图片数量比对，如果一致则全部上传完毕，开始事迹内容上传
		                   				uploaded++;
				                   	}
				               })
							}
						}


						//提交后台
						var beginInsert = function() {
							if (count == uploaded) {	//实际上传数量和要上传图片数量一致，图片全部上传完成
								var url = "/user/duc/updateDeedsUser";
								var t = {
									id: obj.partyUser_manager_updateDeedsUserForm.id,
									deedsTitle: obj.partyUser_manager_updateDeedsUserForm.deedsTitle,
									occurrenceTime: obj.partyUser_manager_updateDeedsUserForm.occurrenceTime,
									deedsDetail: obj.partyUser_manager_updateDeedsUserForm.deedsDetail,
									imgs: uploadedUrl,
									deleteDiMgs: obj.partyUser_manager_updateDeedsUserForm.deleteDiMgs
								}
								$.post(url, t, function(data, status){
									if (data.code == 200) {
										toast('修改成功',data.msg,'success');
										obj.partyUser_manager_updateDeedsUserDialog = false;
										obj.partyUser_manager_queryPartyUserInfos();
									} 
								})
							} else {
								setTimeout(beginInsert, 50);
							}
						}
						beginInsert();
					}
				});
			},
			updateImgUploadRemoveHaveImg(file, fileList) {	//修改事迹变更图片时，记录已有但被删除的图片,这些图片提交后要被删除掉
				var obj = this;
				if (file.status == "success") {
					obj.partyUser_manager_updateDeedsUserForm.deleteDiMgs += file.id + ",";
				}
			},
			openUpdateDeedsUserDialog(it) {
				var obj = this;

				obj.partyUser_manager_updateDeedsUserForm.id = it.id;
				obj.partyUser_manager_updateDeedsUserForm.deedsTypeName = it.deedsTypeName;
				obj.partyUser_manager_updateDeedsUserForm.deedsTypeId = it.deedsTypeId;
				obj.partyUser_manager_updateDeedsUserForm.deedsTitle = it.deedsTitle;
				obj.partyUser_manager_updateDeedsUserForm.occurrenceTime = it.occurrenceTime;
				obj.partyUser_manager_updateDeedsUserForm.deedsDetail = it.deedsDetail;

				if (it.diMgs != null && it.diMgs.length > 0) {
					for (var i = 0; i < it.diMgs.length; i++) {
						var diMg = {url: null, id: null};
						diMg.url = "http://192.168.1.8:3000" + it.diMgs[i].paths;
						diMg.id = it.diMgs[i].id;
						obj.partyUser_manager_updateDeedsUserForm.diMgs.push(diMg);
					}
				}

				obj.partyUser_manager_updateDeedsUserDialog = true;
			},
			partyUser_manager_resetUpdateDeedsUserForm() {
				var obj = this;
				obj.$refs["partyUser_manager_updateDeedsUserForm"].resetFields();
				obj.partyUser_manager_updateDeedsUserForm.diMgs = [];
				obj.partyUser_manager_updateDeedsUserForm.deleteDiMgs = "";
			},
			deleteDeedsUser(du) {
				var obj = this;
				obj.$confirm(
					'删除这条事迹, 是否继续?', 
					'提示', 
					{
			          	confirmButtonText: '确定',
			          	cancelButtonText: '取消',
			          	type: 'warning'
		        	}
		        ).then(function(){
					var url = "/user/duc/deleteDeedsUser";
					var t = {
						id: du.id
					}
					$.post(url, t, function(data, status){
						if (data.code == 200) {
							toast('删除成功',data.msg,'success');
							obj.partyUser_manager_queryPartyUserInfos();
						} 
					})
		        }).catch(function(){
		        	obj.$message({
			            type: 'info',
			            message: '已取消删除'
			        });  
		        });
			},
			insertSupplyDeedsUser() {	//补充事迹
				var obj = this;
				this.$refs["partyUser_manager_supplyDeedsUserForm"].validate( function(valid) {
					if (valid) {
						//处理图片
						var count = 0;
						var uploaded = 0;
						var uploadedUrl = "";
						var imgs = obj.$refs.supplyImgUpload.uploadFiles;
						if (!obj.validataUploadShijiImg(imgs)) {
							return;
						}
						count += imgs.length;

						if (imgs.length > 0) {
							for (var i = 0; i < imgs.length; i++) {
								var formData = new FormData();
								formData.append("file", imgs[i].raw);
								$.ajax({
				                   	url: "http://192.168.1.8:3000/image",
				                   	data: formData,
				                   	type: "Post",
				                   	cache: false,//上传文件无需缓存
				                   	processData: false,//用于对data参数进行序列化处理 这里必须false
				                   	contentType: false, //必须
				                   	success: function (data) {
				                   		if (data != null && data != undefined) {
				                   			if (data.state == "SUCCESS") {
			                   					uploadedUrl += data.url + ",";
					                	   	} else {
					                		   	toast('错误','图片上传失败' ,'error');
				                   				return;
					                	   	}
				                   		} else {
				                   			toast('错误','图片上传失败' ,'error');
				                   			return;
				                   		}
				                   	},
				                   	error: function() {
				                   		toast('错误','图片上传失败' ,'error');
				                   		return;
				                   	},
				                   	complete: function(XMLHttpRequest, textStatus) {
				                   		//上传完成，数量加一，与上传总图片数量比对，如果一致则全部上传完毕，开始事迹内容上传
		                   				uploaded++;
				                   	}
				               })
							}
						}

						var beginInsert = function() {
							if (count == uploaded) {	//实际上传数量和要上传图片数量一致，图片全部上传完成
								var url = "/user/duc/insertSupplyDeedsUser";
								var t = {
									deedsType: obj.partyUser_manager_supplyDeedsUserForm.deedsType,
									deedsTitle: obj.partyUser_manager_supplyDeedsUserForm.deedsTitle,
									occurrenceTime: obj.partyUser_manager_supplyDeedsUserForm.occurrenceTime,
									deedsDetail: obj.partyUser_manager_supplyDeedsUserForm.deedsDetail,
									userId: obj.partyUser_manager_supplyDeedsUserForm.item.userId,
									similarId: obj.partyUser_manager_supplyDeedsUserForm.item.similarId,
									imgs: uploadedUrl
								}
								$.post(url, t, function(data, status){
									if (data.code == 200) {
										toast('添加成功',data.msg,'success');
										obj.partyUser_manager_supplyDeedsUserDialog = false;
										obj.partyUser_manager_queryPartyUserInfos();
									} 
								})
							} else {
								setTimeout(beginInsert, 50);
							}
						}
						beginInsert();
					}
				});
			},
			openPartyUser_manager_supplyDeedsUserDialog(item) {	//补充事迹表单
				var obj = this;

				var url = "/user/dtc/queryDeedsTypes";
				var t = {
				}
				$.post(url, t, function(data, status){
					if (data.code == 200) {
						if (data.data != undefined) {	
							obj.partyUser_manager_supplyDeedsUserForm.deedsTypes = data.data;
						}
					}

				})
				var _item = null;
				if (item.个人感言 != null && item.个人感言.length > 0) {
					_item = item.个人感言[0];
				} else if (item.个人经历 != null && item.个人经历.length > 0) {
					_item = item.个人经历[0];
				} else if (item.他人评价 != null && item.他人评价.length > 0) {
					_item = item.他人评价[0];
				} else if (item.获得荣誉 != null && item.获得荣誉.length > 0) {
					_item = item.获得荣誉[0];
				} 
				if (item != null) {
					obj.partyUser_manager_supplyDeedsUserForm.item = _item;
				} else {
					toast('错误',"获取事迹详情失败",'error');
				}
				
				
				obj.partyUser_manager_supplyDeedsUserDialog = true;
			},
			partyUser_manager_resetSupplyDeedsUserForm() {	//事迹补充表单重置
				var obj = this;
				obj.$refs["partyUser_manager_supplyDeedsUserForm"].resetFields();

				obj.$refs.supplyImgUpload.uploadFiles = [];
			},
			openBigShijiImgDialog(paths) {	//事迹放大图片弹窗
				var obj = this;
				obj.bigShijiImgPaths = paths;
				obj.bigShijiImgDialog = true;
			},
			validataUploadShijiImg(imgs) {	//事迹图片验证
				if (imgs.length != 0) {
					for (var i = 0; i < imgs.length; i++) {
						var img = imgs[i];
						if (img.status == "success") {	//现存图片不用验证
							continue;
						}
						var fileFormat = img.name.split(".");
						var fileSuffix = fileFormat[fileFormat.length - 1];	/* 拿到文件后缀 */
						if (fileSuffix == "jpg" || fileSuffix == "jpeg" || fileSuffix == "png") {
							continue; 
						}
						toast('格式错误',"只能上传jpg、jpeg或png格式的文件，请检查选中的文件",'error');
						return false;
					}
				}
				return true;
			},
			uploadShijiImg(fileList, type) {	//上传事迹图片
				var obj = this;
				if (fileList.length > 0) {
					for (var i = 0; i < fileList.length; i++) {
						var formData = new FormData();
						formData.append("file", fileList[i].raw);
						$.ajax({
		                   	url: "http://192.168.1.8:3000/image",
		                   	data: formData,
		                   	type: "Post",
		                   	cache: false,//上传文件无需缓存
		                   	processData: false,//用于对data参数进行序列化处理 这里必须false
		                   	contentType: false, //必须
		                   	success: function (data) {
		                   		if (data != null && data != undefined) {
		                   			if (data.state == "SUCCESS") {
		                   				if (type == 'jl') {
		                   					obj.partyUser_manager_deedsUserForm.imgs_jl += data.url + ",";
		                   				} else if (type == 'ry') {
		                   					obj.partyUser_manager_deedsUserForm.imgs_ry += data.url + ",";
		                   				} else if (type == 'gy') {
		                   					obj.partyUser_manager_deedsUserForm.imgs_gy += data.url + ",";
		                   				} else if (type == 'pj') {
		                   					obj.partyUser_manager_deedsUserForm.imgs_pj += data.url + ",";
		                   				}
			                	   	} else {
			                		   	return false;
			                	   	}
		                   		} else {
		                   			return false;
		                   		}
		                   	},
		                   	error: function() {
		                   		return false;
		                   	},
		                   	complete: function(XMLHttpRequest, textStatus) {
		                   		//上传完成，数量加一，与上传总图片数量比对，如果一致则全部上传完毕，开始事迹内容上传
                   				obj.partyUser_manager_deedsUserForm.completeCount++;
		                   	}
		               })
					}
				}
				return true;
			},
			deedsUserStepSet(step) {	//设置步骤条
				var obj = this;

				if (step == 's') {
					obj.stepNum--;
				} else {
					var imgs = new Array();
					if (obj.stepNum == 1) {
						imgs = obj.$refs.upload_jl.uploadFiles;
					} else if (obj.stepNum == 2) {
						imgs = obj.$refs.upload_ry.uploadFiles;
					} else if (obj.stepNum == 3) {
						imgs = obj.$refs.upload_gy.uploadFiles;
					} 
					if (!obj.validataUploadShijiImg(imgs)) {
						return;
					}

					
					obj.stepNum++;
				}
			},
			partyUser_manager_resetDeedsUserForm() {	//重置表单
				var obj = this;
				obj.$refs["partyUser_manager_deedsUserForm"].resetFields();
				obj.stepNum = 1;


				obj.$refs.upload_jl.uploadFiles = [];
				obj.$refs.upload_ry.uploadFiles = [];
				obj.$refs.upload_gy.uploadFiles = [];
				obj.$refs.upload_pj.uploadFiles = [];
			},
			partyUser_manager_insertDeedsUser() {	//添加事迹
				var obj = this;

				var imgs = obj.$refs.upload_pj.uploadFiles;
				if (!obj.validataUploadShijiImg(imgs)) {
					return;
				}
				



				this.$refs["partyUser_manager_deedsUserForm"].validate( function(valid) {
					if (valid) {
						if ((obj.partyUser_manager_deedsUserForm.deedsTitle_pj != null &&
							obj.partyUser_manager_deedsUserForm.deedsTitle_pj != "") ||
							(obj.partyUser_manager_deedsUserForm.deedsTitle_gy != null &&
							obj.partyUser_manager_deedsUserForm.deedsTitle_gy != "") ||
							(obj.partyUser_manager_deedsUserForm.deedsTitle_jl != null &&
							obj.partyUser_manager_deedsUserForm.deedsTitle_jl != "") ||
							obj.partyUser_manager_deedsUserForm.occurrenceTime_ry != null) {

							var count = 0;
							count += obj.$refs.upload_jl.uploadFiles.length;
							count += obj.$refs.upload_ry.uploadFiles.length;
							count += obj.$refs.upload_pj.uploadFiles.length;
							count += obj.$refs.upload_gy.uploadFiles.length;

							if(obj.partyUser_manager_deedsUserForm.deedsTitle_jl != null &&
									obj.partyUser_manager_deedsUserForm.deedsTitle_jl != "") {
								var fileList = obj.$refs.upload_jl.uploadFiles;	//开始经历图片上传
								if (!obj.uploadShijiImg(fileList, 'jl')) {
									toast('错误','图片上传失败' ,'error');
									return;
								}
							}
							if(obj.partyUser_manager_deedsUserForm.occurrenceTime_ry != null &&
									obj.partyUser_manager_deedsUserForm.occurrenceTime_ry != "") {
								var fileList = obj.$refs.upload_ry.uploadFiles;	//开始经历图片上传
								if (!obj.uploadShijiImg(fileList, 'ry')) {
									toast('错误','图片上传失败' ,'error');
									return;
								}
							}
							if(obj.partyUser_manager_deedsUserForm.deedsTitle_gy != null &&
									obj.partyUser_manager_deedsUserForm.deedsTitle_gy != "") {
								var fileList = obj.$refs.upload_gy.uploadFiles;	//开始经历图片上传
								if (!obj.uploadShijiImg(fileList, 'gy')) {
									toast('错误','图片上传失败' ,'error');
									return;
								}
							}
							if(obj.partyUser_manager_deedsUserForm.deedsTitle_pj != null &&
									obj.partyUser_manager_deedsUserForm.deedsTitle_pj != "") {
								var fileList = obj.$refs.upload_pj.uploadFiles;	//开始经历图片上传
								if (!obj.uploadShijiImg(fileList, 'pj')) {
									toast('错误','图片上传失败' ,'error');
									return;
								}
							}


							var beginInsert = function() {
								if (count == obj.partyUser_manager_deedsUserForm.completeCount) {	//实际上传数量和要上传图片数量一致，图片全部上传完成
									var url = "/user/duc/insertDeedsUser";
									var t = {
										userId: obj.partyUser_manager_deedsUserForm.userId,
										deedsTitle_jl: obj.partyUser_manager_deedsUserForm.deedsTitle_jl,
										deedsTitle_gy: obj.partyUser_manager_deedsUserForm.deedsTitle_gy,
										deedsTitle_pj: obj.partyUser_manager_deedsUserForm.deedsTitle_pj,
										deedsDetail_jl: obj.partyUser_manager_deedsUserForm.deedsDetail_jl,
										deedsDetail_ry: obj.partyUser_manager_deedsUserForm.deedsDetail_ry,
										deedsDetail_gy: obj.partyUser_manager_deedsUserForm.deedsDetail_gy,
										deedsDetail_pj: obj.partyUser_manager_deedsUserForm.deedsDetail_pj,
										occurrenceTime_ry: obj.partyUser_manager_deedsUserForm.occurrenceTime_ry,
										imgs_jl: obj.partyUser_manager_deedsUserForm.imgs_jl,
										imgs_ry: obj.partyUser_manager_deedsUserForm.imgs_ry,
										imgs_gy: obj.partyUser_manager_deedsUserForm.imgs_gy,
										imgs_pj: obj.partyUser_manager_deedsUserForm.imgs_pj
									}
									$.post(url, t, function(data, status){
										if (data.code == 200) {
											toast('添加成功',data.msg,'success');
											obj.partyUser_manager_resetDeedsUserForm();
											obj.partyUser_manager_insertDeedsUserDialog = false;
											obj.partyUser_manager_queryPartyUserInfos();
										}

									})
								} else {
									setTimeout(beginInsert, 50);
								}
							}
							beginInsert();

							
						} else {
							toast('提示','至少填写一项' ,'error');
						}
					} else {
						toast('提示','部分项未填，请填写后在提交' ,'error');
					}
				});
			},
			partyUser_manager_openDeedsUserDialog(row) {	//打开添加事迹弹窗
				var obj = this;
				obj.partyUser_manager_deedsUserForm.userId = row.id;
				obj.partyUser_manager_insertDeedsUserDialog = true;
			},
			getSignInAccountType() {	/*得到该登录用户的类型*/
				var obj = this;

				var url = "/siat/getSignInAccountType";
				var t = {
				}
				$.post(url, t, function(data, status){
					if (data.code == 200) {
						if (data.data != undefined) {	
							obj.signInAccountType = data.data;
						}
					}

				})
			},
			getScreenHeightForPageSize() {	/*根据屏幕分辨率个性化每页数据记录数*/
				var obj = this;
				var height = window.innerHeight;
				obj.partyUser_manager_pager.pageSize = parseInt((height - 100)/50);
			},
			partyUser_manager_initPager() {	/* 初始化页面数据 */
				var obj = this;
				obj.partyUser_manager_pager.pageNum = 1;
				obj.partyUser_manager_pager.total = 0;
				obj.partyUser_manager_pager.list = new Array();
			},
			partyUser_manager_queryPartyUserInfos() {	/* 查询党员信息 */
				var obj = this;
				var url = "/party/user/queryPartyUserInfos";
				var t = {
					pageNum: obj.partyUser_manager_pager.pageNum,
					pageSize: obj.partyUser_manager_pager.pageSize,
					name: obj.partyUser_manager_queryPartyUserInfosCondition.name,
					isParty: obj.partyUser_manager_queryPartyUserInfosCondition.isParty,
					sex: obj.partyUser_manager_queryPartyUserInfosCondition.sex,
					orgInfoId: obj.partyUser_manager_queryPartyUserInfosCondition.orgInfoId
				}
				$.post(url, t, function(data, status){
					if (data.code == 200) {
						if (data.data == undefined) {	
							obj.partyUser_manager_initPager();/* 没有查询到数据时，初始化页面信息，使页面正常显示 */
						} else {
							obj.partyUser_manager_pager = data.data;
						}
					} 

				})
			},
			partyUser_manager_pagerCurrentChange() {	/*分页查询*/
				var obj = this;
				obj.partyUser_manager_queryPartyUserInfos();
			},
			getPath(row) {	/* 得到党员用户id并返回请求路径 */
				/*给予一个随机数，保证每次请求的参数都不一样，防止从缓存里取值，用于证件照的更新*/
				return "http://192.168.1.8:3000" + row.idPhoto;
			},
			getNewPath(path) {
				return "http://192.168.1.8:3000" + path;
			},
			partyUser_manager_queryNationType() {	/* 查询民族信息 */
				var obj = this;
				var url = "/nation/queryNationType";
				var t = {
				}
				$.post(url, t, function(data, status){
					if (data.code == 200) {
						obj.partyUser_manager_nationTypes = data.data;
					}

				})
			},
			partyUser_manager_queryEducationLevels() {	/* 查询教育水平信息 */
				var obj = this;
				var url = "/eduLe/queryEducationLevels";
				var t = {
				}
				$.post(url, t, function(data, status){
					if (data.code == 200) {
						obj.partyUser_manager_educationLevels = data.data;
					}

				})
			},
			partyUser_manager_queryAcademicDegreeLevels() {	/* 查询学位水平信息 */
				var obj = this;
				var url = "/acaDeLe/queryAcademicDegreeLevels";
				var t = {
					//adDAid: obj.partyUser_manager_insertPartyUserForm.education
				}
				$.post(url, t, function(data, status){
					if (data.code == 200) {
						obj.partyUser_manager_academicDegreeLevels = data.data;
					}

				})
			},
			partyUser_manager_queryWorkNatureTypes() {	/* 查询工作性质 */
				var obj = this;
				var url = "/wnt/queryWorkNatureTypes";
				var t = {
				}
				$.post(url, t, function(data, status){
					if (data.code == 200) {
						obj.partyUser_manager_workNatureTypes = data.data;
					}

				})
			},
			partyUser_manager_queryJoinPartyBranchTypes() {	/* 查询加入党支部方式 */
				var obj = this;
				var url = "/jpbt/queryJoinPartyBranchTypes";
				var t = {
				}
				$.post(url, t, function(data, status){
					if (data.code == 200) {
						obj.partyUser_manager_joinPartyBranchTypes = data.data;
					}

				})
			},
			partyUser_manager_queryFirstLineTypes() {	/* 查询一线情况 */
				var obj = this;
				var url = "/firty/queryFirstLineTypes";
				var t = {
				}
				$.post(url, t, function(data, status){
					if (data.code == 200) {
						obj.partyUser_manager_firstLineTypes = data.data;
					}

				})
			},
			partyUser_managet_getPartyUserBirthDay(){	/*根据身份证号码计算出生日*/
				var obj = this;
				var partyUserIdCard = obj.partyUser_manager_insertPartyUserForm.idCard;
				var year = null;
				var month = null;
				var day = null;
				if (partyUserIdCard.length == 15) {	/*15为身份证号码*/
					year = parseInt("19" + partyUserIdCard.substring(6,8));
					month = parseInt(partyUserIdCard.substring(8,10)) - 1;
					day = parseInt(partyUserIdCard.substring(10,12));
				} else if (partyUserIdCard.length == 18) {	/*18为身份证号码*/
					year = parseInt(partyUserIdCard.substring(6,10));
					month = parseInt(partyUserIdCard.substring(10,12)) - 1;
					day = parseInt(partyUserIdCard.substring(12,14));
				} 
				obj.partyUser_manager_insertPartyUserForm.birthDate = year == null ? null : new Date(year, month, day);
			},
			partyUser_managet_getPartyUserNativePlace() {	/*根据家庭地址计算出籍贯*/
				var obj = this;
				if (obj.partyUser_manager_insertPartyUserForm.homeAddress_pca != undefined) {
					obj.partyUser_manager_insertPartyUserForm.nativePlace = 
						obj.partyUser_manager_insertPartyUserForm.homeAddress_pca[0] + obj.partyUser_manager_insertPartyUserForm.homeAddress_pca[1];
				} else {
					obj.partyUser_manager_insertPartyUserForm.nativePlace = null;
				}
			},
			partyUser_manager_validatePartyUserIdPhoto(thisFile) {	/*校验上传的图片*/
				var fileFormat = thisFile.name.split(".");
				var fileSuffix = fileFormat[fileFormat.length - 1];	/* 拿到文件后缀 */
				var thisFileSize = thisFile.size / 1024;
				if (fileSuffix == "jpg" || fileSuffix == "jpeg" || fileSuffix == "png") {
					if(thisFileSize <= 500) {
						return true;
					}
					toast('图片太大',"图片大小为 " + thisFileSize + " kb,超出范围，只能上传500kb内的照片",'error');
					return false;
				}
				toast('格式错误',"只能上传图片文件（jpg、jpeg或png格式）",'error');
				return false;
			},
			partyUser_manager_updatePartyUserIdPhoto() {	/*修改证件照*/
				var obj = this;
				var fileList = obj.$refs.updatePartyUserIdPhoto.uploadFiles;
				if (fileList.length != 1) {
					toast('错误',"请选择图片",'error');
				} else if (fileList.length == 1) {
					var formData = new FormData();
					formData.append("file", fileList[0].raw);
					$.ajax({
	                   url: "http://192.168.1.8:3000/image",
	                   data: formData,
	                   type: "Post",
	                   cache: false,//上传文件无需缓存
	                   processData: false,//用于对data参数进行序列化处理 这里必须false
	                   contentType: false, //必须
	                   success: function (data) {
	                   		if (data != null && data != undefined) {
	                   			if (data.state == "SUCCESS") {
	                   				var url = "/party/user/updatePartyUserIdPhoto";
	                   				var t = {
										id: obj.partyUser_manager_updatePartyUserForm.id,
										filePath: data.url
									}
									$.post(url, t, function(data, status){	//同步到数据库
										if (data.code == 200) {
				                		   	toast('成功',data.msg,'success');	/*获取临时文件名，方便添加党员时读取图片*/
				                		   	obj.partyUser_manager_updatePartyUserIdPhotoDialog = false;
				                		   	obj.$refs.updatePartyUserIdPhoto.fileList = [];
				                		   	obj.partyUser_manager_updatePartyUserForm.idPhoto = t.filePath;
				                		   	obj.getPath(obj.partyUser_manager_updatePartyUserForm);
				                	   	} else if (data.code == 500) {
				                		   	toast('错误',"修改失败",'error');
				                	   	}
									})
		                	   	} else {
		                		   	toast('错误',"修改失败",'error');
		                	   	}
	                   		} else {
	                   			toast('错误',"修改失败",'error');
	                   		}
	                   	},
	                   	error: function() {
	                   		toast('错误',"修改失败",'error');
	                   	},
	                   	complete: function(XMLHttpRequest, textStatus) {}
	                })
				}
			},
			partyUser_manager_resetInsertPartyUserForm() {	/*重置添加党员信息表单*/
				var obj = this;
				obj.$refs["partyUser_manager_insertPartyUserForm"].resetFields();

				obj.$refs.insertPartyUserIdPhoto.uploadFiles = [];
			},
			partyUser_manager_openInsertPartyUserDialog() {	/* 打开添加党员信息弹窗 */
				var obj = this;
				obj.partyUser_manager_insertPartyUserDialog = true;
			},
			partyUser_manager_openUpdatePartyUserDialog(row) {	/* 打开修改党员信息弹窗 */
				var obj = this;
				obj.partyUser_manager_updatePartyUserForm.idPhotoImg = [{url: obj.getPath(row)}];
				obj.partyUser_manager_updatePartyUserForm.idPhoto = row.idPhoto;
				obj.partyUser_manager_updatePartyUserForm.id = row.id;
				obj.partyUser_manager_updatePartyUserForm.name = row.name;
				obj.partyUser_manager_updatePartyUserForm.sex = row.sex;
				obj.partyUser_manager_updatePartyUserForm.nativePlace = row.nativePlace;
				obj.partyUser_manager_updatePartyUserForm.birthDate = row.birthDate;
				obj.partyUser_manager_updatePartyUserForm.nation = row.nationId;
				obj.partyUser_manager_updatePartyUserForm.idCard = row.idCard;
				obj.partyUser_manager_updatePartyUserForm.mobilePhone = row.mobilePhone;
				obj.partyUser_manager_updatePartyUserForm.email = row.email;
				obj.partyUser_manager_updatePartyUserForm.qq = row.qq;
				obj.partyUser_manager_updatePartyUserForm.wechat = row.wechat;
				obj.partyUser_manager_updatePartyUserForm.education = row.educationId;
				obj.partyUser_manager_updatePartyUserForm.academicDegree = row.academicDegreeId;
				obj.partyUser_manager_updatePartyUserForm.enrolmentTime = row.enrolmentTime;
				obj.partyUser_manager_updatePartyUserForm.graduationTime = row.graduationTime;
				obj.partyUser_manager_updatePartyUserForm.graduationSchool = row.graduationSchool;
				obj.partyUser_manager_updatePartyUserForm.major = row.major;
				obj.partyUser_manager_updatePartyUserForm.specialityLiterature = row.specialityLiterature;
				obj.partyUser_manager_updatePartyUserForm.specialityMajor = row.specialityMajor;
				obj.partyUser_manager_updatePartyUserForm.marriageStatus = row.marriageStatus;
				obj.partyUser_manager_updatePartyUserForm.childrenStatus = row.childrenStatus;
				obj.partyUser_manager_updatePartyUserForm.homeAddress_pca = [row.homeAddressProvince, row.homeAddressCity, row.homeAddressArea];
				obj.partyUser_manager_updatePartyUserForm.homeAddressDetail = row.homeAddressDetail;
				obj.partyUser_manager_updatePartyUserForm.presentAddress_pca = [row.presentAddressProvince, row.presentAddressCity, row.presentAddressArea];
				obj.partyUser_manager_updatePartyUserForm.presentAddressDetail = row.presentAddressDetail;
				obj.partyUser_manager_updatePartyUserForm.type = row.type;
				obj.partyUser_manager_updatePartyUserForm.status = row.status;
				obj.partyUser_manager_updatePartyUserForm.joinDateFormal = row.joinDateFormal;
				obj.partyUser_manager_updatePartyUserForm.joinDateReserve = row.joinDateReserve;
				obj.partyUser_manager_updatePartyUserForm.workUnit = row.workUnit;
				obj.partyUser_manager_updatePartyUserForm.workNature = row.workNatureId;
				obj.partyUser_manager_updatePartyUserForm.joinWorkDate = row.joinWorkDate;
				obj.partyUser_manager_updatePartyUserForm.appointmentTimeLength = row.appointmentTimeLength;
				obj.partyUser_manager_updatePartyUserForm.joinPartyBranchType = row.joinPartyBranchTypeId;
				obj.partyUser_manager_updatePartyUserForm.firstLineTypeName = row.firstLineTypeNameId;
				obj.partyUser_manager_updatePartyUserForm.partyStaff = row.partyStaff;
				obj.partyUser_manager_updatePartyUserForm.partyRepresentative = row.partyRepresentative;
				obj.partyUser_manager_updatePartyUserForm.volunteer = row.volunteer;
				obj.partyUser_manager_updatePartyUserForm.difficultUser = row.difficultUser;
				obj.partyUser_manager_updatePartyUserForm.advancedUser = row.advancedUser;
				obj.partyUser_manager_updatePartyUserForm.positiveUser = row.positiveUser;
				obj.partyUser_manager_updatePartyUserForm.developUser = row.developUser;
				obj.partyUser_manager_updatePartyUserForm.missingUser = row.missingUser;
				obj.partyUser_manager_updatePartyUserForm.introduce = row.introduce;
				obj.partyUser_manager_updatePartyUserForm.isParty = row.isParty;
				obj.partyUser_manager_updatePartyUserDialog = true;
			},
			partyUser_manager_insertPartyUser() {	/* 添加用户 */
				var obj = this;

				var file = obj.$refs.insertPartyUserIdPhoto.uploadFiles;
				if (file.length > 0) {
					var formData = new FormData();
					formData.append("file", file[0].raw);
					$.ajax({
	                   url: "http://192.168.1.8:3000/image",
	                   data: formData,
	                   type: "Post",
	                   cache: false,//上传文件无需缓存
	                   processData: false,//用于对data参数进行序列化处理 这里必须false
	                   contentType: false, //必须
	                   success: function (data) {
	                   		if (data != null && data != undefined) {
	                   			if (data.state == "SUCCESS") {
	                   				obj.partyUser_manager_uploadPartyUserIdPhotoTempFileName = data.url;	/*获取临时文件名，方便添加党员时读取图片*/
		                	   	} else {
		                		   	toast('错误',"服务器出错，停止党员注册",'error');
		                	   	}
	                   		} else {
	                   			toast('错误',"服务器出错，停止党员注册",'error');
	                   		}
	                   	},
	                   	error: function() {},
	                   	complete: function(XMLHttpRequest, textStatus) {}
	                })
				}
				



				this.$refs["partyUser_manager_insertPartyUserForm"].validate( function(valid) {
					if (valid) {
						var url = "/party/user/insertPartyUserInfo";
						if (obj.partyUser_manager_insertPartyUserForm.homeAddress_pca != null && 
							obj.partyUser_manager_insertPartyUserForm.homeAddress_pca != undefined &&
							obj.partyUser_manager_insertPartyUserForm.homeAddress_pca.length == 3) {
							obj.partyUser_manager_insertPartyUserForm.homeAddressProvince = obj.partyUser_manager_insertPartyUserForm.homeAddress_pca[0];
							obj.partyUser_manager_insertPartyUserForm.homeAddressCity = obj.partyUser_manager_insertPartyUserForm.homeAddress_pca[1];
							obj.partyUser_manager_insertPartyUserForm.homeAddressArea = obj.partyUser_manager_insertPartyUserForm.homeAddress_pca[2];
						}
						if (obj.partyUser_manager_insertPartyUserForm.presentAddress_pca != null && 
							obj.partyUser_manager_insertPartyUserForm.presentAddress_pca != undefined &&
							obj.partyUser_manager_insertPartyUserForm.presentAddress_pca.length == 3) {
							obj.partyUser_manager_insertPartyUserForm.presentAddressProvince = obj.partyUser_manager_insertPartyUserForm.presentAddress_pca[0];
							obj.partyUser_manager_insertPartyUserForm.presentAddressCity = obj.partyUser_manager_insertPartyUserForm.presentAddress_pca[1];
							obj.partyUser_manager_insertPartyUserForm.presentAddressArea = obj.partyUser_manager_insertPartyUserForm.presentAddress_pca[2];
						}
						if (obj.partyUser_manager_uploadPartyUserIdPhotoTempFileName != "" && obj.partyUser_manager_uploadPartyUserIdPhotoTempFileName != undefined) {
							obj.partyUser_manager_insertPartyUserForm.partyUserIdPhotoTempFileName = obj.partyUser_manager_uploadPartyUserIdPhotoTempFileName;
						}
						var t = obj.partyUser_manager_insertPartyUserForm;
						$.post(url, t, function(data, status){
							if (data.code == 200) {	/*添加成功*/
								toast('添加成功',data.msg,'success');
								obj.partyUser_manager_insertPartyUserDialog = false;
								obj.partyUser_manager_queryPartyUserInfos();
								obj.partyUser_manager_resetInsertPartyUserForm();
							}

						})
					} else {
						console.log('error submit!!');
		                return false;
					}
				});
			},
			partyUser_manager_updatePartyUser() {	/*修改党员信息*/
				var obj = this;
				this.$refs["partyUser_manager_updatePartyUserForm"].validate( function(valid) {
					if (valid) {
						var url = "/party/user/updatePartyUserInfo";
						if (obj.partyUser_manager_updatePartyUserForm.presentAddress_pca != null && 
							obj.partyUser_manager_updatePartyUserForm.presentAddress_pca != undefined &&
							obj.partyUser_manager_updatePartyUserForm.presentAddress_pca.length == 3) {
							obj.partyUser_manager_updatePartyUserForm.presentAddressProvince = obj.partyUser_manager_updatePartyUserForm.presentAddress_pca[0];
							obj.partyUser_manager_updatePartyUserForm.presentAddressCity = obj.partyUser_manager_updatePartyUserForm.presentAddress_pca[1];
							obj.partyUser_manager_updatePartyUserForm.presentAddressArea = obj.partyUser_manager_updatePartyUserForm.presentAddress_pca[2];
						}
						var t = obj.partyUser_manager_updatePartyUserForm;
						$.post(url, t, function(data, status){
							if (data.code == 200) {	/*添加成功*/
								toast('更新成功',data.msg,'success');
								obj.partyUser_manager_updatePartyUserDialog = false;
								obj.partyUser_manager_queryPartyUserInfos();
							} else {
								toast('更新失败',data.msg,'error');
							}

						})
					} else {
						console.log('error submit!!');
		                return false;
					}
				});
			},
			partyUser_manager_exportPartyUserInfo(row) {	/*导出党员信息*/
				window.location = "/party/user/excel/exportPartyUserInfosExcel?partyUserId=" + row.id;
			},
			partyUser_manager_deletePartyUserInfo(row) {	/*删除党员信息*/
				var obj = this;
				obj.$confirm(
					'删除 ' + row.name + ' 的党员信息, 是否继续?', 
					'提示', 
					{
			          	confirmButtonText: '确定',
			          	cancelButtonText: '取消',
			          	type: 'warning'
		        	}
		        ).then(function(){
	        		var url = "/party/user/deletePartyUserInfo";
					var t = {
						baseUserId: row.id
					}
					$.post(url, t, function(data, status){
						if (data.code == 200) {
							toast('删除成功',data.msg,'success');
							obj.partyUser_manager_queryPartyUserInfos();
						}
						
					})
		        }).catch(function(){
		        	obj.$message({
			            type: 'info',
			            message: '已取消删除'
			        });  
		        });
			},
			partyUser_manager_exportPartyUserInfosExcelExample() {	/*下载批量导入党员的excel模板*/
				window.location = "/party/user/excel/exportPartyUserInfosExcelExample";
			},
			partyUser_manager_validatePartyUserInfosExcel(thisFile) {	/*上传前excel校验*/
				var fileFormat = thisFile.name.split(".");
				if (fileFormat == null || fileFormat == undefined) {
					toast('格式错误',"只能上传excel文档（xlsx、xls）",'error');
					return false;
				}
				var fileSuffix = fileFormat[fileFormat.length - 1];	/* 拿到文件后缀 */
				if (fileSuffix == "xlsx" || fileSuffix == "xls") {
					return true;
				} else {
					toast('格式错误',"只能上传excel文档（xlsx、xls）",'error');
					return false;
				}
			},
			partyUser_manager_importPartyUserInfosExcel(thisImport) {	/*开始党员批量导入*/
				var obj = this;
				var formData = new FormData();
				formData.append("file", thisImport.file);
				$.ajax({
                   url: "/party/user/excel/importPartyUserInfosExcel",
                   data: formData,
                   type: "Post",
                   dataType: "json",
                   cache: false,//上传文件无需缓存
                   processData: false,//用于对data参数进行序列化处理 这里必须false
                   contentType: false, //必须
                   success: function (data) {
                	   if (data.code == 200) {
                		   toast('导入成功',data.msg,'success');
                		   obj.partyUser_manager_importPartyUserExcelErrorMsg = null;
                		   obj.partyUser_manager_queryPartyUserInfos();
                	   } else if (data.code == 500) {
                		   toast('导入失败',data.msg,'error');
                		   obj.partyUser_manager_importPartyUserExcelErrorMsg = data.data;
                		   //window.location = "/party/user/excel/downloadValidataMsg";	/*导入失败下载错误信息*/
                		   obj.partyUser_manager_importPartyUserExcelErrorMsgDialog = true;
                	   }
                   },
               })
			},
			partyUser_manager_openJoinOrgInfoDialog(row) {	/*打开加入组织的窗口*/
				var obj = this;

				obj.partyUser_manager_joinOrgInfoForm.orgRltUserId = row.id;

				var url = "/org/ifmt/queryOrgInfosToTree";
				var t = {
				}
				$.post(url, t, function(datas, status){
					if (datas.code == 200) {
						obj.partyUser_manager_joinOrgInfoForm.orgInfoTreeOfJoinOrg = [
							data = {
								data: {		/* 给根目录设置一个顶级节点，用于查询全部数据 */
									orgInfoId: -1,
									orgInfoName: "所有组织"
								},
								children: datas.data
							}
						];
					}
					
				})

				obj.partyUser_manager_joinOrgInfoDialog = true;
			},
			partyUser_manager_setOrgInfoIdAndQueryOrgDuty(data) {	/*设置组织id*/
				var obj = this;
				obj.partyUser_manager_joinOrgInfoForm.haveDutyForThisOrgInfo = [];

				obj.partyUser_manager_joinOrgInfoForm.orgRltInfoId = data.data.orgInfoId;

				var url = "/org/relation/queryOrgRelationNewsNotPage";
				var t = {
					orgRltInfoId: obj.partyUser_manager_joinOrgInfoForm.orgRltInfoId,
					orgRltUserId: obj.partyUser_manager_joinOrgInfoForm.orgRltUserId
				}
				$.post(url, t, function(datas, status){	/*查询该用户在次组织已有的职责*/
					if (datas.code == 200) {
						if (datas.data != undefined) {
							for (var i = 0; i < datas.data.length; i++) {
								obj.partyUser_manager_joinOrgInfoForm.haveDutyForThisOrgInfo.push(datas.data[i].orgDutyId);
							}
						} else {
							obj.partyUser_manager_joinOrgInfoForm.haveDutyForThisOrgInfo = [];
						}
					}
					
				})

				
				url = "/org/duty/queryOrgDutyTreeForOrgInfo";
				t = {
					orgDutyOrgInfoId: obj.partyUser_manager_joinOrgInfoForm.orgRltInfoId
				}
				$.post(url, t, function(datas, status){
					if (datas.code == 200) {
						if (datas.data != undefined) {
							obj.partyUser_manager_joinOrgInfoForm.orgDutyTreesForOrgInfo = datas.data;
							obj.forPartyUser_manager_queryOrgDutyForOrgInfoClickTreeToAddId(obj.partyUser_manager_joinOrgInfoForm.orgDutyTreesForOrgInfo);
						} else {
							obj.partyUser_manager_joinOrgInfoForm.orgDutyTreesForOrgInfo = [];
						}
					}
					
				})
			},
			forPartyUser_manager_queryOrgDutyForOrgInfoClickTreeToAddId(menuTrees){	/* 向树里添加id属性，方便设置node-key */
				var obj = this;
				if(menuTrees != null) {
					for (var i = 0; i < menuTrees.length; i++) {
						var menuTree = menuTrees[i];
						menuTree.id = menuTree.data.orgDutyId;
						if (obj.partyUser_manager_joinOrgInfoForm.haveDutyForThisOrgInfo != null && 
							obj.partyUser_manager_joinOrgInfoForm.haveDutyForThisOrgInfo.length != 0) {
							for (var j = 0; j < obj.partyUser_manager_joinOrgInfoForm.haveDutyForThisOrgInfo.length; j++) {
								if(menuTree.id == obj.partyUser_manager_joinOrgInfoForm.haveDutyForThisOrgInfo[j]) {
									menuTree.disabled = true;
								}
							}
						}
						
						obj.forPartyUser_manager_queryOrgDutyForOrgInfoClickTreeToAddId(menuTree.children);
					}
				}
			},
			partyUser_manager_resetJoinOrgInfoForm() {	/*重置加入职责表单*/
				var obj = this;
				obj.$refs.partyUser_manager_joinOrgInfoForm.resetFields();
				obj.partyUser_manager_joinOrgInfoForm.orgDutyTreesForOrgInfo = [];
				obj.partyUser_manager_joinOrgInfoForm.joinTime == null;
			},
			partyUser_manager_joinOrgInfo() {	/*加入组织*/
				var obj = this;					
				var url = "/org/relation/insertOrgRelation";
				
				var checkedKeys = [];
				checkedKeys = obj.$refs.partyUser_manager_joinOrgInfoTree.getCheckedKeys(false);
				if (checkedKeys.length == 0) {
					toast('错误',"请选择该用户在此组织担任的职责",'error');
					return;
				}
				var t = {
					orgRltUserId: obj.partyUser_manager_joinOrgInfoForm.orgRltUserId,
					orgRltInfoId: obj.partyUser_manager_joinOrgInfoForm.orgRltInfoId,
					orgRltDutys: checkedKeys,
					orgRltJoinTime: obj.partyUser_manager_joinOrgInfoForm.joinTime == null ||
						obj.partyUser_manager_joinOrgInfoForm.joinTime == "" ? null : new Date(obj.partyUser_manager_joinOrgInfoForm.joinTime)
				}
				$.post(url, t, function(datas, status){
					if (datas.code == 200) {
						toast('成功',datas.msg,'success');
						obj.partyUser_manager_joinOrgInfoDialog = false;
					}
					
				})
			},
			partyUser_manager_openUpdatePartyUserIdPhoto() {
				var obj = this;
				obj.partyUser_manager_updatePartyUserIdPhotoDialog = true;
			},
			partyUser_manager_showImportPartyUserExcelErrorMsgDialog() {
				var obj = this;
				obj.partyUser_manager_importPartyUserExcelErrorMsgDialog = true;
			},
			partyUser_manager_jumpToUserDetailInfo(item){
				var obj = this;
				obj.dis_h_v = true;
				obj.partyUser_manager_jumpToUserDetailInfoArray = [item.id];
			},
			getSexImg(item) {
				if (item.sex == "男"){
					return "/view/pm/img/man.jpg?t=" + Math.random();
				} else {
					return "/view/pm/img/women.jpg?t=" + Math.random();
				}
			},
			openPartyUserLL(row, width, height) {
				if (width == 192 && height == 108) {
					window.open ('/view/pm/tp/001/index.jsp?id='+row.id, 'newwindow', 'height='+ height, 'width='+ width);
				} else if (width == 108 && height == 192) {
					window.open ('/view/pm/tp/002/index.jsp?id='+row.id, 'newwindow', 'height='+ height, 'width='+ width);
				}
				
			}
		}
	});


	window.onFocus = function () {
		window.location.reload();
	}
</script>
</html>