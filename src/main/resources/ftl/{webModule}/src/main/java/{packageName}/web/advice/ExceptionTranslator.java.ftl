<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.constant.ErrorCode")/>
<@call this.addImport("${this.commonPackage}.exception.BusinessException")/>
<@call this.addImport("${this.commonPackage}.pojo.vo.ReplyVO")/>
<@call this.addImport("${this.commonPackage}.util.JsonUtil")/>
<@call this.addImport("${this.commonPackage}.util.MessageSourceUtil")/>
<@call this.addImport("org.apache.commons.collections4.CollectionUtils")/>
<@call this.addImport("org.slf4j.Logger")/>
<@call this.addImport("org.slf4j.LoggerFactory")/>
<@call this.addImport("org.springframework.core.annotation.AnnotationUtils")/>
<@call this.addImport("org.springframework.dao.ConcurrencyFailureException")/>
<@call this.addImport("org.springframework.dao.DuplicateKeyException")/>
<@call this.addImport("org.springframework.http.HttpStatus")/>
<@call this.addImport("org.springframework.http.ResponseEntity")/>
<@call this.addImport("org.springframework.http.converter.HttpMessageNotReadableException")/>
<@call this.addImport("org.springframework.validation.BindException")/>
<@call this.addImport("org.springframework.validation.BindingResult")/>
<@call this.addImport("org.springframework.validation.ObjectError")/>
<@call this.addImport("org.springframework.web.HttpRequestMethodNotSupportedException")/>
<@call this.addImport("org.springframework.web.bind.MethodArgumentNotValidException")/>
<@call this.addImport("org.springframework.web.bind.annotation.ControllerAdvice")/>
<@call this.addImport("org.springframework.web.bind.annotation.ExceptionHandler")/>
<@call this.addImport("org.springframework.web.bind.annotation.ResponseBody")/>
<@call this.addImport("org.springframework.web.bind.annotation.ResponseStatus")/>
<@call this.addImport("javax.validation.ConstraintViolationException")/>
<@call this.addImport("java.util.List")/>
<@call this.addImport("java.util.stream.Collectors")/>

<@call this.printClassCom("异常信息展示")/>
@ControllerAdvice
public class ExceptionTranslator {

    private final static Logger LOGGER = LoggerFactory.getLogger(ExceptionTranslator.class);


    /**
     * 自定义参数校验失败
     *
     * @param ex
     * @return
     */
    @ExceptionHandler(ConstraintViolationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ResponseBody
    public ReplyVO processValidationError(ConstraintViolationException ex) {
        ReplyVO replyVO = new ReplyVO();
        replyVO.setCode(ErrorCode.ERR_VALIDATION.getValue());
        replyVO.setMessage(ex.getMessage());
        return replyVO;
    }

    /**
     * body参数校验失败
     *
     * @param ex
     * @return
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ResponseBody
    public ReplyVO processValidationError(MethodArgumentNotValidException ex) {
        BindingResult result = ex.getBindingResult();
        return processBindingResult(result);
    }

    /**
     * param参数校验失败
     *
     * @param ex
     * @return
     */
    @ExceptionHandler(BindException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ResponseBody
    public ReplyVO processValidationError(BindException ex) {
        BindingResult result = ex.getBindingResult();
        return processBindingResult(result);
    }

    private ReplyVO processBindingResult(BindingResult result) {
        List<ObjectError> errors = result.getAllErrors();
        ReplyVO replyVO = new ReplyVO();
        replyVO.setCode(ErrorCode.ERR_VALIDATION.getValue());
        replyVO.setMessage(ErrorCode.ERR_VALIDATION.getDesc());
        if (CollectionUtils.isNotEmpty(errors)) {
            List<String> errorMsgs = errors.stream()
                    .map(error -> error.getDefaultMessage())
                    .collect(Collectors.toList());
            LOGGER.warn(JsonUtil.toJSONString(errorMsgs));
            String message = errorMsgs.stream()
                    .collect(Collectors.joining(";"));
            replyVO.setMessage(message);
        }
        return replyVO;
    }


    /**
     * http method有误
     *
     * @param exception
     * @return
     */
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    @ResponseBody
    @ResponseStatus(HttpStatus.METHOD_NOT_ALLOWED)
    public ReplyVO processMethodNotSupportedException(HttpRequestMethodNotSupportedException exception) {
        return ReplyVO.fail(ErrorCode.METHOD_NOT_SUPPORTED);
    }

    /**
     * 未传requestbody
     *
     * @param exception
     * @return
     */
    @ExceptionHandler(HttpMessageNotReadableException.class)
    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ReplyVO processHttpMessageNotReadableException(HttpMessageNotReadableException exception) {
        return ReplyVO.fail("HttpMessageNotReadableException");
    }

    /**
     * 线程异常
     *
     * @param ex
     * @return
     */
    @ExceptionHandler(ConcurrencyFailureException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    @ResponseBody
    public ReplyVO processConcurencyError(ConcurrencyFailureException ex) {
        return ReplyVO.fail(ErrorCode.CONCURRENCY_FAILURE);
    }


    /**
     * 唯一键重复
     *
     * @param ex
     * @return
     */
    @ExceptionHandler(DuplicateKeyException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    @ResponseBody
    public ReplyVO processDuplicateKeyException(DuplicateKeyException ex) {
        return ReplyVO.fail(ErrorCode.DUPLICATE_KEY);
    }

    /**
     * 自定义异常捕获
     *
     * @param ex
     * @return
     */
    @ExceptionHandler(BusinessException.class)
    @ResponseBody
    public ResponseEntity<ReplyVO> processBusinessException(BusinessException ex) {
        LOGGER.error("业务异常", ex);
        ErrorCode code = ex.getErrorCode();
        ResponseEntity.BodyBuilder builder = ResponseEntity.status(Integer.parseInt(code.getValue()));
        ReplyVO replyVO = new ReplyVO(code.getValue(), ex.getMessage());
        return builder.body(replyVO);
    }


    /**
     * 普通异常捕获
     *
     * @param ex
     * @return
     */
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public ResponseEntity<ReplyVO> processRuntimeException(Exception ex) {
        LOGGER.error("系统内部错误", ex);
        ResponseEntity.BodyBuilder builder;
        ReplyVO replyVO;
        ResponseStatus responseStatus = AnnotationUtils.findAnnotation(ex.getClass(), ResponseStatus.class);
        if (responseStatus != null) {
            builder = ResponseEntity.status(responseStatus.value());
            replyVO = new ReplyVO(responseStatus.value().value() + "", MessageSourceUtil.getMessage(responseStatus.reason()));
        } else {
            builder = ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR);
            replyVO = ReplyVO.fail(ErrorCode.INTERNAL_SERVER_ERROR);
        }
        return builder.body(replyVO);
    }


}
</#assign>
<#--开始渲染代码-->
package ${this.packageName}.web.advice;

<@call this.printImport()/>

${code}
