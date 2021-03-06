<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<script src="https://cdn.bootcss.com/element-ui/2.4.11/index.js"></script>
<link href="https://cdn.bootcss.com/element-ui/2.4.11/theme-chalk/index.css" rel="stylesheet">
<!--theme-->
<link id="theme-css" href="/theme/color-<shiro:principal property="theme"/>.css" rel="stylesheet">
<link href="${urls.getForLookupPath('/assets/css/element-ui-patch.css')}" rel="stylesheet">
<link href="${urls.getForLookupPath('/assets/css/common.css')}" rel="stylesheet">
<link href="${urls.getForLookupPath('/assets/css/module-main.css')}" rel="stylesheet">
<link href="${urls.getForLookupPath('/assets/css/activity-group.css')}" rel="stylesheet">

