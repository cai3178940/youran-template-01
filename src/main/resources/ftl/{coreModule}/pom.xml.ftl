<#include "/abstracted/common.ftl">
<#include "/abstracted/usingExcel.ftl">
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>${this.originProjectName}</artifactId>
        <groupId>${this.groupId}</groupId>
        <version>1.0.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>${this.originProjectName}-core</artifactId>
    <packaging>jar</packaging>

    <dependencies>
        <dependency>
            <groupId>${r'$'}{project.groupId}</groupId>
            <artifactId>${this.originProjectName}-common</artifactId>
        </dependency>
        <!-- mapstruct提供属性映射功能 -->
        <dependency>
            <groupId>org.mapstruct</groupId>
            <artifactId>mapstruct</artifactId>
        </dependency>
    <#if this.projectFeature.lombokEnabled>
        <!-- 用注解简化pojo类 https://projectlombok.org/ -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <scope>provided</scope>
        </dependency>
    </#if>
    <#if usingExcel>
        <!-- excel导入导出工具 https://github.com/alibaba/easyexcel -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>easyexcel</artifactId>
        </dependency>
    </#if>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.5.1</version>
                <configuration>
                    <source>${r'$'}{java.version}</source>
                    <target>${r'$'}{java.version}</target>
                    <annotationProcessorPaths>
                        <!-- 提供编译期生成mapper实现类 -->
                        <path>
                            <groupId>org.mapstruct</groupId>
                            <artifactId>mapstruct-processor</artifactId>
                            <version>${r'$'}{org.mapstruct.version}</version>
                        </path>
                        <!-- 编译期生成pojo的getter-setter -->
                        <path>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                            <version>${r'$'}{lombok.version}</version>
                        </path>
                    </annotationProcessorPaths>
                </configuration>
            </plugin>
        </plugins>
    </build>

</project>
