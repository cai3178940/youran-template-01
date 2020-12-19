<#include "/abstracted/common.ftl">
<#include "/abstracted/usingExcel.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.convert.MyCustomDateEditor")/>
<@call this.addImport("${this.commonPackage}.convert.MyCustomLocalDateEditor")/>
<@call this.addImport("${this.commonPackage}.convert.MyCustomLocalDateTimeEditor")/>
<@call this.addImport("org.springframework.web.bind.WebDataBinder")/>
<@call this.addImport("org.springframework.web.bind.annotation.InitBinder")/>
<@call this.addImport("java.util.Date")/>
<@call this.addImport("java.time.LocalDate")/>
<@call this.addImport("java.time.LocalDateTime")/>
<@call this.printClassCom("抽象controller")/>
public abstract class AbstractController {

    <#if usingExcel>
    public static final String XLSX_CONTENT_TYPE = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
    </#if>

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(Date.class, new MyCustomDateEditor());
        binder.registerCustomEditor(LocalDate.class, new MyCustomLocalDateEditor());
        binder.registerCustomEditor(LocalDateTime.class, new MyCustomLocalDateTimeEditor());
    }

    <#if usingExcel>
        <@call this.addImport("com.alibaba.excel.EasyExcel")/>
        <@call this.addImport("com.alibaba.excel.ExcelWriter")/>
        <@call this.addImport("com.alibaba.excel.write.builder.ExcelWriterBuilder")/>
        <@call this.addImport("com.alibaba.excel.write.handler.WriteHandler")/>
        <@call this.addImport("com.alibaba.excel.write.metadata.WriteSheet")/>
    /**
     * 下载excel导入模板
     *
     * @param response      http响应对象
     * @param excelDTOClass excelDTO类
     * @param examples      模板中的示例
     * @param templateName  模板文件名
     * @param description   模板头部描述信息
     * @param handlers      excel自定义写入处理器
     * @param <T>           excelDTO的实际类型
     * @throws Exception
     */
    <@call this.addImport("${this.packageName}.pojo.dto.AbstractExcelDTO")/>
    <@call this.addImport("javax.servlet.http.HttpServletResponse")/>
    <@call this.addImport("java.util.List")/>
    protected <T extends AbstractExcelDTO> void downloadExcelTemplate(HttpServletResponse response,
                                                                      Class<T> excelDTOClass,
                                                                      List<T> examples,
                                                                      String templateName,
                                                                      String[] description,
                                                                      WriteHandler[] handlers) throws Exception {
        // xlsx文件后缀必须用该类型
        response.setContentType(XLSX_CONTENT_TYPE);
        <@call this.addImport("java.nio.charset.StandardCharsets")/>
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        <@call this.addImport("java.net.URLEncoder")/>
        String fileName = URLEncoder.encode(templateName, StandardCharsets.UTF_8.name());
        // 下载文件的文件名
        response.setHeader("Content-disposition", "attachment;filename=" + fileName + ".xlsx");
        ExcelWriterBuilder builder = EasyExcel.write(response.getOutputStream());
        if (handlers != null) {
            for (WriteHandler handler : handlers) {
                // 注册自定义写入处理器
                builder.registerWriteHandler(handler);
            }
        }
        ExcelWriter excelWriter = builder
                // 第一行是标题，第二行是说明
                <@call this.addImport("${this.packageName}.excel.handler.TitleDescriptionWriteHandler")/>
                .registerWriteHandler(new TitleDescriptionWriteHandler(templateName, description, excelDTOClass))
                // 自定义模板单元格样式
                <@call this.addImport("${this.packageName}.excel.handler.TemplateCellStyleStrategy")/>
                .registerWriteHandler(new TemplateCellStyleStrategy())
                .build();
        WriteSheet writeSheet = EasyExcel.writerSheet(0, "Sheet1")
                .head(excelDTOClass)
                // 从第三行开始写表头
                .relativeHeadRowIndex(2)
                .build();
        excelWriter.write(examples, writeSheet);
        excelWriter.finish();
    }

    /**
     * 解析导入的excel文件
     *
     * @param file  导入文件
     * @param clazz excelDTO类
     * @param <T>   excelDTO的实际类型
     * @return 解析出的excelDTO列表
     * @throws Exception
     */
    <@call this.addImport("org.springframework.web.multipart.MultipartFile")/>
    protected <T extends AbstractExcelDTO> List<T> parseExcel(MultipartFile file,
                                                              Class<T> clazz) throws Exception {
        <@call this.addImport("${this.packageName}.excel.listener.SyncReadExcelListener")/>
        SyncReadExcelListener<T> listener = new SyncReadExcelListener();
        EasyExcel.read(file.getInputStream())
                .head(clazz)
                .sheet()
                // 从第四行开始读取
                .headRowNumber(3)
                .registerReadListener(listener)
                .doRead();
        return listener.getList();
    }

    /**
     * 导出excel
     *
     * @param response     http响应对象
     * @param excelVOClass excelVO类
     * @param list         列表数据
     * @param exportName   导出文件名
     * @param <T>          excelVO的实际类型
     * @throws Exception
     */
    <@call this.addImport("${this.commonPackage}.pojo.vo.AbstractVO")/>
    protected <T extends AbstractVO> void exportExcel(HttpServletResponse response,
                                                      Class<T> excelVOClass,
                                                      List<T> list,
                                                      String exportName) throws Exception {
        // xlsx文件后缀必须用该类型
        response.setContentType(XLSX_CONTENT_TYPE);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        String fileName = URLEncoder.encode(exportName, StandardCharsets.UTF_8.name());
        response.setHeader("Content-disposition", "attachment;filename=" + fileName + ".xlsx");
        EasyExcel.write(response.getOutputStream(), excelVOClass)
                .sheet()
                .doWrite(list);
    }

    </#if>

}
</#assign>
<#--开始渲染代码-->
<@call this.printPackageAndImport(this.packageName + ".web")/>

${code}
