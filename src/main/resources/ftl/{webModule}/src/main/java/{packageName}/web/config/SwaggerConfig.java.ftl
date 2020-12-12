<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("org.springframework.boot.autoconfigure.condition.ConditionalOnProperty")/>
<@call this.addImport("org.springframework.context.annotation.Configuration")/>
<@call this.addImport("org.springframework.context.annotation.Bean")/>
<@call this.addImport("springfox.documentation.builders.PathSelectors")/>
<@call this.addImport("springfox.documentation.spi.DocumentationType")/>
<@call this.addImport("springfox.documentation.spring.web.plugins.Docket")/>
<@call this.printClassCom("swagger配置")/>
@Configuration
@ConditionalOnProperty(
        value = "springfox.documentation.enabled",
        havingValue = "true",
        matchIfMissing = true
)
public class SwaggerConfig {

    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.OAS_30)
                .select()
                .paths(PathSelectors.ant("/api/**"))
                .build();
    }


}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.packageName + ".web.config")/>

${code}
