<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("逻辑删除+创建人&创建时间+操作人&操作时间+版本号")/>
public interface CreatedOperatedDeletedVersion extends Created, Operated, Deleted, Version {
}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".pojo.po")/>

${code}
