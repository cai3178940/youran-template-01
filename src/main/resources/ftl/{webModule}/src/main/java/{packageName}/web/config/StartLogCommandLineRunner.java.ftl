<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.packageName}.web.util.IpUtil")/>
<@call this.addImport("org.apache.commons.lang3.ArrayUtils")/>
<@call this.addImport("org.slf4j.Logger")/>
<@call this.addImport("org.slf4j.LoggerFactory")/>
<@call this.addImport("org.springframework.boot.CommandLineRunner")/>
<@call this.addImport("org.springframework.core.Ordered")/>
<@call this.addImport("org.springframework.core.env.Environment")/>
<@call this.addImport("org.springframework.stereotype.Component")/>
<@call this.addImport("org.springframework.beans.factory.annotation.Value")/>
<@call this.addImport("java.util.Arrays")/>
<@call this.addImport("java.util.stream.Collectors")/>
<@call this.printClassCom("打印启动日志")/>
@Component
public class StartLogCommandLineRunner implements CommandLineRunner,Ordered {

    private static final Logger LOG = LoggerFactory.getLogger(StartLogCommandLineRunner.class);

    private final Environment env;

    @Value("${r'$'}{springfox.documentation.enabled:true}")
    private boolean swaggerEnabled;

    public StartLogCommandLineRunner(Environment env){
        this.env = env;
    }

    @Override
    public void run(String... args) throws Exception {
        String port = env.getProperty("server.port","8080");
        String contextPath = env.getProperty("server.servlet.context-path","/");
        String applicationName = env.getProperty("spring.application.name","");
        String profiles = "";
        if(ArrayUtils.isNotEmpty(env.getActiveProfiles())) {
            profiles = Arrays.stream(env.getActiveProfiles()).collect(Collectors.joining(","));
        }
        StringBuilder sb = new StringBuilder();
        sb.append("\n----------------------------------------------------------\n")
            .append("\t应用【").append(applicationName).append("】已经启动！\n")
            .append("\t激活profile:\t").append(profiles).append("\n")
            .append("\t访问路径:\n")
            .append("\t本地: \thttp://localhost:").append(port).append(contextPath).append("\n")
            .append("\t外部: \thttp://").append(IpUtil.getLocalIp()).append(":").append(port).append(contextPath).append("\n");
        if (swaggerEnabled) {
            sb.append("\t文档:\thttp://").append(IpUtil.getLocalIp()).append(":").append(port).append(contextPath).append("swagger-ui/index.html");
        }
        sb.append("\n----------------------------------------------------------");
        LOG.info(sb.toString());

    }

    @Override
    public int getOrder() {
        return Ordered.LOWEST_PRECEDENCE;
    }
}
</#assign>
<#--开始渲染代码-->
package ${this.packageName}.web.config;

<@call this.printImport()/>

${code}
