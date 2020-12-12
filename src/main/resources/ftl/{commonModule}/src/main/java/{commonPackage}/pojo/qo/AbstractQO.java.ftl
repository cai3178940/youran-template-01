<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.util.JsonUtil")/>
<@call this.addImport("java.io.Serializable")/>
<@call this.printClassCom("数据查询参数对象超类")/>
public abstract class AbstractQO implements Serializable {

    private static final long serialVersionUID = -2460649808778841614L;

    @Override
    public String toString() {
        return JsonUtil.toJSONString(this);
    }

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.commonPackage + ".pojo.qo")/>

${code}
