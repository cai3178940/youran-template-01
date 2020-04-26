<#-- 调用函数，如果存在输出则打印 -->
<#macro call func><#if func??>${func}</#if></#macro>
<#-- 仅调用函数，不打印 -->
<#macro justCall func></#macro>

<#-- 将当前model赋值给this变量 -->
<#assign this = .dataModel>

<#-- 首个单词转小写 -->
<#function lowerFirstWord value>
    <#return "${CommonTemplateFunction.lowerFirstWord(value)}" >
</#function>

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

<#-- 生成getter setter -->
<#function genGetterSetter type name override=false indent=1>
    <#local code = "">
    <#local cap = name?capFirst>
    <#local uncap = name?uncapFirst>
    <#local indentPrefix = "">
    <#list 1..indent as t>
        <#local indentPrefix += "    ">
    </#list>
    <#if override>
        <#local code += indentPrefix + "@Override\n">
    </#if>
    <#local code += indentPrefix + "public " + type + " get" + cap + "() {\n">
    <#local code += indentPrefix + "    return this." + uncap + ";\n">
    <#local code += indentPrefix + "}\n\n">
    <#if override>
        <#local code += indentPrefix + "@Override\n">
    </#if>
    <#local code += indentPrefix + "public void set" + cap + "(" + type + " " + uncap + ") {\n">
    <#local code += indentPrefix + "    this." + uncap + " = " + uncap + ";\n">
    <#local code += indentPrefix + "}\n\n">
    <#return code >
</#function>

<#-- 渲染API路径 -->
<#function  renderApiPath entity suffix>
    <@call this.addImport("${this.packageName}.web.constant.WebConst")/>
    <#if entity.module?hasContent>
        <#return "WebConst.ModulePath.${entity.module?upperCase} + \"/${lowerFirstWord(entity.className)}${suffix}\"" >
    <#else>
        <#return "WebConst.API_PATH + \"/${lowerFirstWord(entity.className)}${suffix}\"" >
    </#if>
</#function>
<#-- 渲染API路径 -->
<#function  renderApiPathForChart chart suffix>
    <@call this.addImport("${this.packageName}.web.constant.WebConst")/>
    <#if chart.module?hasContent>
        <#return "WebConst.ModulePath.${chart.module?upperCase} + \"/${lowerFirstWord(chart.chartName)}${suffix}\"" >
    <#else>
        <#return "WebConst.API_PATH + \"/${lowerFirstWord(chart.chartName)}${suffix}\"" >
    </#if>
</#function>
