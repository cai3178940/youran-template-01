<#include "/abstracted/common.ftl">
spring:
    datasource:
        url: jdbc:mysql://localhost:3306/${this.originProjectName}?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&failOverReadOnly=false&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=Asia/Shanghai
        username: root
        password: root
springfox:
    documentation:
        enabled: true
<#if this.hasLabel("knife4j")>
knife4j:
    enable: true
</#if>

logging:
    level:
        ${this.packageName}: debug
