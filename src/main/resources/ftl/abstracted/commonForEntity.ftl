<#include "/abstracted/common.ftl">
<#-- 带模块名的包路径 -->
<#if this.module?hasContent>
    <#assign daoPackageName = this.packageName+".dao."+this.module>
    <#assign dtoPackageName = this.packageName+".pojo.dto."+this.module>
    <#assign examplePackageName = this.packageName+".pojo.example."+this.module>
    <#assign mapperPackageName = this.packageName+".pojo.mapper."+this.module>
    <#assign poPackageName = this.packageName+".pojo.po."+this.module>
    <#assign qoPackageName = this.packageName+".pojo.qo."+this.module>
    <#assign voPackageName = this.packageName+".pojo.vo."+this.module>
    <#assign servicePackageName = this.packageName+".service."+this.module>
    <#assign apiPackageName = this.packageName+".web.api."+this.module>
    <#assign restPackageName = this.packageName+".web.rest."+this.module>
    <#assign helpPackageName = this.packageName+".help."+this.module>
    <#assign apiPath = this.packageName+".help."+this.module>
<#else>
    <#assign daoPackageName = this.packageName+".dao">
    <#assign dtoPackageName = this.packageName+".pojo.dto">
    <#assign examplePackageName = this.packageName+".pojo.example">
    <#assign mapperPackageName = this.packageName+".pojo.mapper">
    <#assign poPackageName = this.packageName+".pojo.po">
    <#assign qoPackageName = this.packageName+".pojo.qo">
    <#assign voPackageName = this.packageName+".pojo.vo">
    <#assign servicePackageName = this.packageName+".service">
    <#assign apiPackageName = this.packageName+".web.api">
    <#assign restPackageName = this.packageName+".web.rest">
    <#assign helpPackageName = this.packageName+".help">
</#if>
