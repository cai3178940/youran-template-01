<#include "/abstracted/common.ftl">
server:
    servlet:
        context-path: /
        encoding:
            # 强制指定响应头content-type是utf-8编码
            force: true
    port: 8080
spring:
    application:
        name: ${this.originProjectName}
    profiles:
        active: local

springfox:
    documentation:
        enabled: false
<#if this.hasLabel("knife4j")>
knife4j:
    enable: false
</#if>


