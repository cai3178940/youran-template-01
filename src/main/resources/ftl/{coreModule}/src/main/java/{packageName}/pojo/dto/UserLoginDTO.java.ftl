<#include "/abstracted/common.ftl">
<#include "/abstracted/lombokEnabled.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.printClassCom("用户登录请求体")/>
<#if lombokEnabled>
    <@call this.addImport("lombok.Data")/>
@Data
</#if>
public class UserLoginDTO {

    private String username;

    private String password;

<#if !lombokEnabled>
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
</#if>

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.packageName + ".pojo.dto")/>

${code}
