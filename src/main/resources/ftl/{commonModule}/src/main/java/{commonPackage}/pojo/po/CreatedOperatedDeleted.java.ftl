<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("逻辑删除+创建人&创建时间+操作人&操作时间")/>
public interface CreatedOperatedDeleted extends Created, Operated, Deleted {
}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".pojo.po")/>

${code}
