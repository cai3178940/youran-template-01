<#include "/abstracted/common.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.pojo.vo.ReplyVO")/>
<@call this.addImport("${this.packageName}.pojo.dto.UserLoginDTO")/>
<@call this.addImport("${this.packageName}.pojo.vo.UserLoginVO")/>
<@call this.addImport("${this.packageName}.web.AbstractController")/>
<@call this.addImport("${this.packageName}.web.constant.WebConst")/>
<@call this.addImport("org.springframework.http.ResponseEntity")/>
<@call this.addImport("org.springframework.web.bind.annotation.GetMapping")/>
<@call this.addImport("org.springframework.web.bind.annotation.PostMapping")/>
<@call this.addImport("org.springframework.web.bind.annotation.RequestMapping")/>
<@call this.addImport("org.springframework.web.bind.annotation.RestController")/>
<@call this.addImport("java.util.Arrays")/>
<@call this.printClassCom("用户登录控制器","当前并没有真正实现用户登录功能，只是Mock登录接口而已")/>
@RestController
@RequestMapping(WebConst.API_PATH + "/_user")
public class UserLoginController extends AbstractController {

    @PostMapping(value = "/login")
    public ResponseEntity<ReplyVO<String>> login(UserLoginDTO userLoginDTO) {
        return ResponseEntity.ok(ReplyVO.success("this_is_token"));
    }

    @GetMapping(value = "/info")
    public ResponseEntity<ReplyVO<UserLoginVO>> info(String token) {
        UserLoginVO userLoginVO = new UserLoginVO();
        userLoginVO.setRoles(Arrays.asList("admin"));
        userLoginVO.setIntroduction("I am a super administrator");
        userLoginVO.setAvatar("https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif");
        userLoginVO.setName("admin");
        return ResponseEntity.ok(ReplyVO.success(userLoginVO));
    }

    @PostMapping(value = "/logout")
    public ResponseEntity<ReplyVO<Void>> logout() {
        return ResponseEntity.ok(ReplyVO.success());
    }

}

</#assign>
<#--开始渲染代码-->
package ${this.packageName}.web;

<@call this.printImport()/>

${code}
