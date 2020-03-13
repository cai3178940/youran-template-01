<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("【${this.title}】参数示例")/>
public class ${this.className}Example {

<#list this.fields as id,field>
    <#--字段名转下划线大写-->
    <#assign jfieldNameSnakeCase = CommonTemplateFunction.camelCaseToSnakeCase(field.jfieldName,true)>
    public static final String N_${jfieldNameSnakeCase} = "${field.fetchComment()?replace('\"','\\"')?replace('\n','\\n')}";
    public static final String E_${jfieldNameSnakeCase} = "${field.fieldExample?replace('\"','\\"')?replace('\n','\\n')}";
</#list>
}
</#assign>
<#--开始渲染代码-->
package ${examplePackageName};

<@call this.printImport()/>

${code}
