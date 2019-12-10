<#include "/abstracted/common.ftl">
spring:
    datasource:
        url: jdbc:mysql://localhost:3306/${this.originProjectName}?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&failOverReadOnly=false&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=Asia/Shanghai
        username: root
        password: root
swagger:
    enabled: true
