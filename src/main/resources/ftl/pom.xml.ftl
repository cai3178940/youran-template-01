<#include "/abstracted/common.ftl">
<#include "/abstracted/lombokEnabled.ftl">
<#include "/abstracted/usingExcel.ftl">
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.3.7.RELEASE</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
    <groupId>${this.groupId}</groupId>
    <artifactId>${this.originProjectName}</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>pom</packaging>

    <modules>
        <module>${this.originProjectName}-common</module>
        <module>${this.originProjectName}-core</module>
        <module>${this.originProjectName}-web</module>
    </modules>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
        <mybatis-spring-boot.version>2.1.3</mybatis-spring-boot.version>
        <commons-lang3.version>3.11</commons-lang3.version>
        <commons-io.version>2.8.0</commons-io.version>
        <commons-collections.version>4.4</commons-collections.version>
        <guava.version>30.0-jre</guava.version>
        <org.mapstruct.version>1.4.1.Final</org.mapstruct.version>
        <jsoup.version>1.13.1</jsoup.version>
        <h2.version>1.4.200</h2.version>
        <mysql2h2.version>0.2.1</mysql2h2.version>
    <#if this.hasLabel("knife4j")>
        <knife4j.version>3.0.2</knife4j.version>
    <#else>
        <springfox-boot-starter.version>3.0.0</springfox-boot-starter.version>
    </#if>
        <swagger-annotations.version>1.5.20</swagger-annotations.version>
    <#if lombokEnabled>
        <lombok.version>1.18.16</lombok.version>
    </#if>
    <#if usingExcel>
        <easyexcel.version>2.2.7</easyexcel.version>
    </#if>
    </properties>

    <dependencyManagement>
        <dependencies>

            <dependency>
                <groupId>${r'$'}{project.groupId}</groupId>
                <artifactId>${this.originProjectName}-common</artifactId>
                <version>${r'$'}{project.version}</version>
            </dependency>
            <dependency>
                <groupId>${r'$'}{project.groupId}</groupId>
                <artifactId>${this.originProjectName}-core</artifactId>
                <version>${r'$'}{project.version}</version>
            </dependency>
            <dependency>
                <groupId>${r'$'}{project.groupId}</groupId>
                <artifactId>${this.originProjectName}-web</artifactId>
                <version>${r'$'}{project.version}</version>
            </dependency>
            <!-- apache常用工具包 -->
            <dependency>
                <groupId>org.apache.commons</groupId>
                <artifactId>commons-lang3</artifactId>
                <version>${r'$'}{commons-lang3.version}</version>
            </dependency>
            <!-- apache io流工具包 -->
            <dependency>
                <groupId>commons-io</groupId>
                <artifactId>commons-io</artifactId>
                <version>${r'$'}{commons-io.version}</version>
            </dependency>
            <!-- apache集合工具包 -->
            <dependency>
                <groupId>org.apache.commons</groupId>
                <artifactId>commons-collections4</artifactId>
                <version>${r'$'}{commons-collections.version}</version>
            </dependency>
            <!-- guava工具包 -->
            <dependency>
                <groupId>com.google.guava</groupId>
                <artifactId>guava</artifactId>
                <version>${r'$'}{guava.version}</version>
            </dependency>
            <!-- 集成mybatis http://www.mybatis.org/spring-boot-starter/mybatis-spring-boot-autoconfigure/index.html -->
            <dependency>
                <groupId>org.mybatis.spring.boot</groupId>
                <artifactId>mybatis-spring-boot-starter</artifactId>
                <version>${r'$'}{mybatis-spring-boot.version}</version>
            </dependency>
            <!-- 单元测试使用H2内存数据库 -->
            <dependency>
                <groupId>com.h2database</groupId>
                <artifactId>h2</artifactId>
                <version>${r'$'}{h2.version}</version>
            </dependency>
            <!-- 单元测试使用mysql脚本转H2 -->
            <dependency>
                <groupId>com.parmet</groupId>
                <artifactId>mysql2h2-parser</artifactId>
                <version>${r'$'}{mysql2h2.version}</version>
            </dependency>
            <!-- mapstruct提供属性映射功能 http://mapstruct.org/ -->
            <dependency>
                <groupId>org.mapstruct</groupId>
                <artifactId>mapstruct</artifactId>
                <version>${r'$'}{org.mapstruct.version}</version>
            </dependency>
            <!-- swagger依赖 -->
            <dependency>
                <groupId>io.swagger</groupId>
                <artifactId>swagger-annotations</artifactId>
                <version>${r'$'}{swagger-annotations.version}</version>
            </dependency>
        <#if this.hasLabel("knife4j")>
            <!-- knife4j(swagger-ui) https://doc.xiaominfo.com/ -->
            <dependency>
                <groupId>com.github.xiaoymin</groupId>
                <artifactId>knife4j-spring-boot-starter</artifactId>
                <version>${r'$'}{knife4j.version}</version>
            </dependency>
        <#else>
            <dependency>
                <groupId>io.springfox</groupId>
                <artifactId>springfox-boot-starter</artifactId>
                <version>${r'$'}{springfox-boot-starter.version}</version>
            </dependency>
        </#if>
            <!-- jsoup HTML parser library（用于过滤XSS） https://jsoup.org/ -->
            <dependency>
                <groupId>org.jsoup</groupId>
                <artifactId>jsoup</artifactId>
                <version>${r'$'}{jsoup.version}</version>
            </dependency>
        <#if lombokEnabled>
            <!-- 用注解简化pojo类 https://projectlombok.org/ -->
            <dependency>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>${r'$'}{lombok.version}</version>
            </dependency>
        </#if>
        <#if usingExcel>
            <!-- excel导入导出工具 https://github.com/alibaba/easyexcel -->
            <dependency>
                <groupId>com.alibaba</groupId>
                <artifactId>easyexcel</artifactId>
                <version>${r'$'}{easyexcel.version}</version>
            </dependency>
        </#if>
        </dependencies>
    </dependencyManagement>

</project>
