<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("org.junit.jupiter.api.BeforeEach")/>
<@call this.addImport("org.springframework.beans.factory.annotation.Autowired")/>
<@call this.addImport("org.springframework.beans.factory.annotation.Value")/>
<@call this.addImport("org.springframework.boot.test.context.SpringBootTest")/>
<@call this.printClassCom("单元测试抽象类")/>
@SpringBootTest(classes = ${this.projectNameUpper}App.class)
public class AbstractTest {

    @Autowired(required = false)
    protected H2Flusher h2Flusher;

    @Value("${r'$'}{spring.datasource.url}")
    private String jdbcUrl;

    @BeforeEach
    public void setUp() throws Exception {
        if (!jdbcUrl.startsWith("jdbc:h2:mem:")) {
            return;
        }
        if (h2Flusher == null) {
            throw new RuntimeException("请使用H2内存数据库作为数据源");
        }
        // 每次执行单元测试之前都要刷新数据库
        h2Flusher.flushDB();
    }


}
</#assign>
<#--开始渲染代码-->
package ${this.packageName};

<@call this.printImport()/>

${code}
