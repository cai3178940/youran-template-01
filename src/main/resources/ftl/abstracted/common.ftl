<#-- 调用函数，如果存在输出则打印 -->
<#macro call func><#if func??>${func}</#if></#macro>
<#-- 仅调用函数，不打印 -->
<#macro justCall func></#macro>

<#-- 将当前model赋值给this变量 -->
<#assign this = .dataModel>

<#-- common模块名 -->
<#assign commonModule = this.projectNameSplit + "-common">
<#-- core模块名 -->
<#assign coreModule = this.projectNameSplit + "-core">
<#-- web模块名 -->
<#assign webModule = this.projectNameSplit + "-web">
<#-- common包路径 -->
<#assign commonPackagePath = this.commonPackage?replace(".", "/")>
<#-- 包路径 -->
<#assign packageNamePath = this.packageName?replace(".", "/")>


