<#include "/abstracted/common.ftl">
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>${this.originProjectName}</artifactId>
        <groupId>${this.groupId}</groupId>
    <#if this.hasLabel("flatten-maven-plugin")>
        <version>${r'$'}{revision}</version>
    <#else>
        <version>1.0.0-SNAPSHOT</version>
    </#if>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>${this.originProjectName}-web</artifactId>
    <packaging>war</packaging>

    <dependencies>

        <dependency>
            <groupId>${r'$'}{project.groupId}</groupId>
            <artifactId>${this.originProjectName}-core</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- spring-boot 单元测试-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <!-- 正式环境使用mysql数据库 -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <scope>runtime</scope>
        </dependency>
        <!-- 单元测试使用H2内存数据库 -->
        <dependency>
            <groupId>com.h2database</groupId>
            <artifactId>h2</artifactId>
            <scope>test</scope>
        </dependency>
        <!-- 单元测试中mysql脚本转H2 -->
        <dependency>
            <groupId>com.parmet</groupId>
            <artifactId>mysql2h2-parser</artifactId>
            <scope>test</scope>
        </dependency>
    <#if this.hasLabel("knife4j")>
        <!-- knife4j(swagger-ui) -->
        <dependency>
            <groupId>com.github.xiaoymin</groupId>
            <artifactId>knife4j-spring-boot-starter</artifactId>
        </dependency>
    <#else>
        <!-- swagger依赖 -->
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-boot-starter</artifactId>
        </dependency>
    </#if>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <source>${r'$'}{java.version}</source>
                    <target>${r'$'}{java.version}</target>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <configuration>
                    <skip>true</skip>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
