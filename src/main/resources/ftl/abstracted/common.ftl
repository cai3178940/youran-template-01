<#-- 调用函数，如果存在输出则打印 -->
<#macro call func><#if func??>${func}</#if></#macro>

<#-- 将当前model赋值给this变量 -->
<#assign this = .data_model>
