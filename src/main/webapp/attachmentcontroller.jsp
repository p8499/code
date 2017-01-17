<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/>package ${model['controller']['package']};
<c:forEach items="${cd:union(model['bean']['field'],model['bean']['key'])}" var="field"><c:choose><c:when test="${field['special']['type']=='owner'}"><c:set var="owner" value="${field}"/></c:when><c:when test="${field['special']['type']=='updated'}"><c:set var="updated" value="${field}"/></c:when></c:choose></c:forEach>
import java.io.IOException;
import java.net.HttpURLConnection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import com.p8499.mvc.AttachmentControllerBase;
import ${model['bean']['package']}.${model['bean']['alias']};
<c:if test="${model['controller']['auth']['individual']}">import ${model['bean']['maskPackage']}.${model['bean']['maskAlias']};
import ${model['mapper']['package']}.${model['mapper']['alias']};
</c:if>
@Controller
@RequestMapping(value="${model['controller']['attachmentPath']}",produces="multipart/form-data")
public class ${model['controller']['attachmentAlias']} extends AttachmentControllerBase<${model['bean']['alias']},${model['bean']['key']['javaType']}>
{	@RequestMapping(value="/{${model['bean']['key']['id']}}",method=RequestMethod.GET)
	public String get(HttpSession session,HttpServletRequest request,HttpServletResponse response,@PathVariable ${model['bean']['key']['javaType']} ${model['bean']['key']['id']}) throws IOException
	{	if(getUser(session)==null)
			return finish("",response,HttpURLConnection.HTTP_UNAUTHORIZED);
<c:choose><c:when test="${model['controller']['auth']['individual']}">		boolean ${model['controller']['auth']['name']}_ra=checkSecurity(session,"${model['controller']['auth']['name']}_ra"),${model['controller']['auth']['name']}_ri=checkSecurity(session,"${model['controller']['auth']['name']}_ri");
		if(!${model['controller']['auth']['name']}_ra&&!${model['controller']['auth']['name']}_ri)
</c:when><c:otherwise>		boolean ${model['controller']['auth']['name']}_ra=checkSecurity(session,"${model['controller']['auth']['name']}_ra");
		if(!${model['controller']['auth']['name']}_ra)
</c:otherwise></c:choose>			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
<c:if test="${model['controller']['auth']['individual']}">		${model['bean']['maskAlias']} maskObj=new ${model['bean']['maskAlias']}().set${cd:upperFirst(owner['id'])}(true);
		${model['bean']['alias']} result=((${model['mapper']['alias']})bMapper).get(${model['bean']['key']['id']},maskObj);
		if(!${model['controller']['auth']['name']}_ra&&!result.get${cd:upperFirst(owner['id'])}().equals(getUser(session)))
			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
</c:if>		response.setContentType("multipart/form-data");
		response.setHeader("Content-Disposition","attachment;fileName=${model['bean']['alias']}"+"_"+${model['bean']['key']['id']}+".${model['controller']['attachmentType']}");
		boolean succ=AttachmentControllerBase.readFile(response,request.getServletContext().getRealPath(attachmentFolder),"${model['bean']['alias']}",<c:choose><c:when test="${model['bean']['key']['javaType']=='String'}">${model['bean']['key']['id']}</c:when><c:otherwise>${model['bean']['key']['id']}.toString()</c:otherwise></c:choose>,"${model['controller']['attachmentType']}");
		return finish("",response,succ?HttpURLConnection.HTTP_OK:HttpURLConnection.HTTP_BAD_REQUEST);
	}
	@RequestMapping(value="/{${model['bean']['key']['id']}}",method=RequestMethod.PUT)
	public String update(HttpSession session,HttpServletRequest request,HttpServletResponse response,@PathVariable ${model['bean']['key']['javaType']} ${model['bean']['key']['id']},@RequestParam MultipartFile file) throws IOException
	{	if(getUser(session)==null)
			return finish("",response,HttpURLConnection.HTTP_UNAUTHORIZED);
<c:choose><c:when test="${model['controller']['auth']['individual']}">		boolean ${model['controller']['auth']['name']}_wa=checkSecurity(session,"${model['controller']['auth']['name']}_wa"),${model['controller']['auth']['name']}_wi=checkSecurity(session,"${model['controller']['auth']['name']}_wi");
		if(!${model['controller']['auth']['name']}_wa&&!${model['controller']['auth']['name']}_wi)
</c:when><c:otherwise>		boolean ${model['controller']['auth']['name']}_wa=checkSecurity(session,"${model['controller']['auth']['name']}_wa");
		if(!${model['controller']['auth']['name']}_wa)
</c:otherwise></c:choose>			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
		if(reserved.isReserved("${model['controller']['auth']['name']}K"+${model['bean']['key']['id']})&&!reserved.isReservedBy("${model['controller']['auth']['name']}K"+${model['bean']['key']['id']},session.getId()))
			return finish("",response,423);
<c:if test="${model['controller']['auth']['individual']}">		${model['bean']['alias']} origBean=((${model['mapper']['alias']})bMapper).get(${model['bean']['key']['id']},null);
		if(!${model['controller']['auth']['name']}_wa&&!origBean.get${cd:upperFirst(owner['id'])}().equals(getUser(session)))
			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
</c:if>		boolean succ=AttachmentControllerBase.writeFile(file,request.getServletContext().getRealPath(attachmentFolder),"${model['bean']['alias']}",<c:choose><c:when test="${model['bean']['key']['javaType']=='String'}">${model['bean']['key']['id']}</c:when><c:otherwise>${model['bean']['key']['id']}.toString()</c:otherwise></c:choose>,"${model['controller']['attachmentType']}");
		return finish("",response,succ?HttpURLConnection.HTTP_OK:HttpURLConnection.HTTP_NOT_FOUND);
	}
	@RequestMapping(value="/{${model['bean']['key']['id']}}",method=RequestMethod.DELETE)
	public String delete(HttpSession session,HttpServletRequest request,HttpServletResponse response,@PathVariable ${model['bean']['key']['javaType']} ${model['bean']['key']['id']}) throws IOException
	{	if(getUser(session)==null)
			return finish("",response,HttpURLConnection.HTTP_UNAUTHORIZED);
<c:choose><c:when test="${model['controller']['auth']['individual']}">		boolean ${model['controller']['auth']['name']}_wa=checkSecurity(session,"${model['controller']['auth']['name']}_wa"),${model['controller']['auth']['name']}_wi=checkSecurity(session,"${model['controller']['auth']['name']}_wi");
		if(!${model['controller']['auth']['name']}_wa&&!${model['controller']['auth']['name']}_wi)
</c:when><c:otherwise>		boolean ${model['controller']['auth']['name']}_wa=checkSecurity(session,"${model['controller']['auth']['name']}_wa");
		if(!${model['controller']['auth']['name']}_wa)
</c:otherwise></c:choose>			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
		if(reserved.isReserved("${model['controller']['auth']['name']}K"+${model['bean']['key']['id']}))
			return finish("",response,423);
<c:if test="${model['controller']['auth']['individual']}">		${model['bean']['alias']} origBean=((${model['mapper']['alias']})bMapper).get(${model['bean']['key']['id']},null);
		if(!${model['controller']['auth']['name']}_wa&&!origBean.get${cd:upperFirst(owner['id'])}().equals(getUser(session)))
			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
</c:if>		boolean succ=AttachmentControllerBase.deleteFile(request.getServletContext().getRealPath(attachmentFolder),"${model['bean']['alias']}",<c:choose><c:when test="${model['bean']['key']['javaType']=='String'}">${model['bean']['key']['id']}</c:when><c:otherwise>${model['bean']['key']['id']}.toString()</c:otherwise></c:choose>,"${model['controller']['attachmentType']}");
		return finish("",response,succ?HttpURLConnection.HTTP_OK:HttpURLConnection.HTTP_NOT_FOUND);
	}
	@Value(value="${'${app.attachmentFolder}'}")
	private String attachmentFolder;
}