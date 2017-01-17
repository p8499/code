<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/>package ${model['controller']['package']};
<c:forEach items="${cd:union(model['bean']['field'],model['bean']['key'])}" var="field"><c:choose><c:when test="${field['special']['type']=='owner'}"><c:set var="owner" value="${field}"/></c:when><c:when test="${field['special']['type']=='updated'}"><c:set var="updated" value="${field}"/></c:when></c:choose></c:forEach>
import java.io.IOException;
import java.net.HttpURLConnection;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.fasterxml.jackson.databind.ObjectMapper;
import ${model['bean']['package']}.${model['bean']['alias']};
import ${model['mapper']['package']}.${model['mapper']['alias']};
import ${model['bean']['maskPackage']}.${model['bean']['maskAlias']};
import com.p8499.mvc.MD5Encryptor;
import com.p8499.mvc.MaskControllerBase;
import com.p8499.mvc.Reserved;
import com.p8499.mvc.database.BeanListener;
import com.p8499.mvc.database.BeanMapper;
import com.p8499.mvc.database.ToolMapper;
import com.p8499.mvc.database.Update;

@RestController
@RequestMapping(value="${model['controller']['maskPath']}",produces="application/json;charset=UTF-8")
public class ${model['controller']['maskAlias']} extends MaskControllerBase<${model['bean']['alias']},${model['bean']['maskAlias']},${model['bean']['key']['javaType']}>
{	@RequestMapping(value="/{${model['bean']['key']['id']}}",method=RequestMethod.GET)
	public String getWithMask(HttpSession session,HttpServletRequest request,HttpServletResponse response,@PathVariable ${model['bean']['key']['javaType']} ${model['bean']['key']['id']},@RequestParam("mask")String mask) throws IOException
	{	if(getUser(session)==null)
			return finish("",response,HttpURLConnection.HTTP_UNAUTHORIZED);
<c:choose><c:when test="${model['controller']['auth']['individual']}">		boolean ${model['controller']['auth']['name']}_ra=checkSecurity(session,"${model['controller']['auth']['name']}_ra"),${model['controller']['auth']['name']}_ri=checkSecurity(session,"${model['controller']['auth']['name']}_ri");
		if(!${model['controller']['auth']['name']}_ra&&!${model['controller']['auth']['name']}_ri)
</c:when><c:otherwise>		boolean ${model['controller']['auth']['name']}_ra=checkSecurity(session,"${model['controller']['auth']['name']}_ra");
		if(!${model['controller']['auth']['name']}_ra)
</c:otherwise></c:choose>			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
		${model['bean']['alias']} result=((${model['mapper']['alias']})bMapper).getWithMask(${model['bean']['key']['id']},(${model['bean']['maskAlias']})jackson.readValue(mask,${model['bean']['maskAlias']}.class));
<c:if test="${model['controller']['auth']['individual']}">		if(!${model['controller']['auth']['name']}_ra&&!result.get${cd:upperFirst(owner['id'])}().equals(getUser(session)))
			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
</c:if>		return finish(result==null?"":result,response,result==null?HttpURLConnection.HTTP_NOT_FOUND:HttpURLConnection.HTTP_OK);
	}
	@RequestMapping(value="/{${model['bean']['key']['id']}}",method=RequestMethod.PUT)
	public String updateWithMask(HttpSession session,HttpServletRequest request,HttpServletResponse response,@RequestBody @Validated({Update.class}) ${model['bean']['alias']} bean,BindingResult result,@RequestParam("mask")String mask) throws IOException
	{	${model['bean']['maskAlias']} maskObj=(${model['bean']['maskAlias']})jackson.readValue(mask,${model['bean']['maskAlias']}.class);
		if(${cd:join(cd:format2('maskObj.get%s()&&result.getFieldErrorCount(\"%s\")>0',cd:upperFirst(ids),ids),'||')})
			return finish(result.toString(),response,HttpURLConnection.HTTP_BAD_REQUEST);
		if(getUser(session)==null)
			return finish("",response,HttpURLConnection.HTTP_UNAUTHORIZED);
<c:choose><c:when test="${model['controller']['auth']['individual']}">		boolean ${model['controller']['auth']['name']}_wa=checkSecurity(session,"${model['controller']['auth']['name']}_wa"),${model['controller']['auth']['name']}_wi=checkSecurity(session,"${model['controller']['auth']['name']}_wi");
		if(!${model['controller']['auth']['name']}_wa&&!${model['controller']['auth']['name']}_wi)
</c:when><c:otherwise>		boolean ${model['controller']['auth']['name']}_wa=checkSecurity(session,"${model['controller']['auth']['name']}_wa");
		if(!${model['controller']['auth']['name']}_wa)
</c:otherwise></c:choose>			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
		if(reserved.isReserved("${model['controller']['auth']['name']}K"+bean.get${cd:upperFirst(model['bean']['key']['id'])}())&&!reserved.isReservedBy("${model['controller']['auth']['name']}K"+bean.get${cd:upperFirst(model['bean']['key']['id'])}(),session.getId()))
			return finish("",response,423);
<c:if test="${model['controller']['auth']['individual']}">		${model['bean']['alias']} origBean=((${model['mapper']['alias']})bMapper).get(bean.get${cd:upperFirst(model['bean']['key']['id'])}());
		if(!${model['controller']['auth']['name']}_wa&&!origBean.get${cd:upperFirst(owner['id'])}().equals(getUser(session)))
			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
		if(!${model['controller']['auth']['name']}_wa)
			bean.set${cd:upperFirst(owner['id'])}(getUser(session));
</c:if><c:forEach items="${model['bean']['field']}" var="field"><c:choose><c:when test="${field['special']['type']=='created'}">		bean.set${cd:upperFirst(field['id'])}(origBean.get${cd:upperFirst(field['id'])}());
</c:when><c:when test="${field['special']['type']=='updated'}"><c:choose><c:when test="${field['dojoType']=='dijit/form/DateTextBox'}">		bean.set${cd:upperFirst(field['id'])}(new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));</c:when><c:when test="${field['dojoType']=='dijit/form/TimeTextBox'}">		bean.set${cd:upperFirst(field['id'])}(new java.text.SimpleDateFormat("HH:mm:ss").format(new java.util.Date()));</c:when></c:choose>
</c:when></c:choose></c:forEach>		getListener().beforeUpdateWithMask(bean,maskObj);
		((${model['mapper']['alias']})bMapper).updateWithMask(bean,maskObj);
		getListener().afterUpdateWithMask(bean,maskObj);
		return finish("",response,HttpURLConnection.HTTP_OK);
	}
	@RequestMapping(method=RequestMethod.GET)
	public String queryWithMask(HttpSession session,HttpServletRequest request,HttpServletResponse response,@RequestParam(required=false) String filter,@RequestParam(required=false) String orderBy,@RequestHeader(required=false,name="Range",defaultValue="items=0-9") String range,@RequestParam("mask")String mask) throws IOException
	{	if(getUser(session)==null)
			return finish("",response,HttpURLConnection.HTTP_UNAUTHORIZED);
<c:choose><c:when test="${model['controller']['auth']['individual']}">		boolean ${model['controller']['auth']['name']}_ra=checkSecurity(session,"${model['controller']['auth']['name']}_ra"),${model['controller']['auth']['name']}_ri=checkSecurity(session,"${model['controller']['auth']['name']}_ri");
		if(!${model['controller']['auth']['name']}_ra&&!${model['controller']['auth']['name']}_ri)
</c:when><c:otherwise>		boolean ${model['controller']['auth']['name']}_ra=checkSecurity(session,"${model['controller']['auth']['name']}_ra");
		if(!${model['controller']['auth']['name']}_ra)
</c:otherwise></c:choose>			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
<c:if test="${model['controller']['auth']['individual']}">		if(!${model['controller']['auth']['name']}_ra)
			return finish(queryRange(response,filter,orderBy,range,"${owner['id']}",getUser(session),(${model['bean']['maskAlias']})jackson.readValue(mask,${model['bean']['maskAlias']}.class)),response,HttpURLConnection.HTTP_OK);
</c:if>		return finish(queryRange(response,filter,orderBy,range,(${model['bean']['maskAlias']})jackson.readValue(mask,${model['bean']['maskAlias']}.class)),response,HttpURLConnection.HTTP_OK);
	}
	@Resource(name="jackson")
	public void setJackson(ObjectMapper jackson)
	{	super.setJackson(jackson);
	}
	@Resource(name="md5Encryptor")
	public void setEncryptor(MD5Encryptor encryptor)
	{	super.setEncryptor(encryptor);
	}
	@Resource(name="appMapper")
	public void settMapper(ToolMapper tMapper)
	{	super.settMapper(tMapper);
	}
	@Resource(name="${model['controller']['mapperBean']}")
	public void setbMapper(BeanMapper<${model['bean']['alias']},${model['bean']['key']['javaType']}> bMapper)
	{	super.setbMapper(bMapper);
	}
	@Resource(name="reserved")
	public void setReserved(Reserved reserved)
	{	super.setReserved(reserved);
	}
	@Resource(name="${model['controller']['listenerBean']}")
	public void setListener(BeanListener<${model['bean']['alias']},${model['bean']['maskAlias']},${model['bean']['key']['javaType']}> listener)
	{	super.setListener(listener);
	}
}