<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/>package ${model['controller']['package']};
<c:forEach items="${cd:union(model['bean']['field'],model['bean']['key'])}" var="field"><c:choose><c:when test="${field['special']['type']=='owner'}"><c:set var="owner" value="${field}"/></c:when><c:when test="${field['special']['type']=='updated'}"><c:set var="updated" value="${field}"/></c:when></c:choose></c:forEach>
import java.net.HttpURLConnection;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.p8499.mvc.MD5Encryptor;
import com.p8499.mvc.Reserved;
import com.p8499.mvc.RestCheckControllerBase;
import com.p8499.mvc.database.Add;
import com.p8499.mvc.database.BeanMapper;
import com.p8499.mvc.database.ToolMapper;
import com.p8499.mvc.database.Update;
import ${model['bean']['package']}.${model['bean']['alias']};
import ${model['mapper']['package']}.${model['mapper']['alias']};

@RestController
@RequestMapping(value="${model['controller']['checkPath']}",produces="application/json;charset=UTF-8")
public class ${model['controller']['checkAlias']} extends RestCheckControllerBase<${model['bean']['alias']},${model['bean']['key']['javaType']}>
{	@RequestMapping(<c:if test="${!model['bean']['key']['auto']}">value="/{${model['bean']['key']['id']}}",</c:if>method=RequestMethod.POST)
	public String add(HttpSession session,HttpServletRequest request,HttpServletResponse response,@RequestBody @Validated({Add.class}) ${model['bean']['alias']} bean,BindingResult result) throws JsonProcessingException
	{	if(result.hasErrors())
			return finish(result.toString(),response,HttpURLConnection.HTTP_BAD_REQUEST);
		if(getUser(session)==null)
			return finish("",response,HttpURLConnection.HTTP_UNAUTHORIZED);
<c:choose><c:when test="${model['controller']['auth']['individual']}">		boolean ${model['controller']['auth']['name']}_wa=checkSecurity(session,"${model['controller']['auth']['name']}_wa"),${model['controller']['auth']['name']}_wi=checkSecurity(session,"${model['controller']['auth']['name']}_wi");
		if(!${model['controller']['auth']['name']}_wa&&!${model['controller']['auth']['name']}_wi)
</c:when><c:otherwise>		boolean ${model['controller']['auth']['name']}_wa=checkSecurity(session,"${model['controller']['auth']['name']}_wa");
		if(!${model['controller']['auth']['name']}_wa)
</c:otherwise></c:choose>			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
		if(<c:if test="${!model['bean']['key']['auto']}">((${model['mapper']['alias']})bMapper).exists(bean.get${cd:upperFirst(model['bean']['key']['id'])}())||</c:if>!((${model['mapper']['alias']})bMapper).unique(bean))
			return finish("",response,HttpURLConnection.HTTP_CONFLICT);
		List<%="<List<String>>"%> referencingErrors=referencing(bean);
		if(referencingErrors.size()>0)
			return finish(referencingErrors,response,HttpURLConnection.HTTP_NOT_ACCEPTABLE);
		return finish("",response,HttpURLConnection.HTTP_OK);
	}
	@RequestMapping(value="/{${model['bean']['key']['id']}}",method=RequestMethod.PUT)
	public String update(HttpSession session,HttpServletRequest request,HttpServletResponse response,@RequestBody @Validated({Update.class}) ${model['bean']['alias']} bean,BindingResult result) throws JsonProcessingException
	{	if(result.hasErrors())
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
		${model['bean']['alias']} origBean=((${model['mapper']['alias']})bMapper).get(bean.get${cd:upperFirst(model['bean']['key']['id'])}(),null);
		if(origBean==null)
			return finish("",response,HttpURLConnection.HTTP_NOT_FOUND);
<c:if test="${model['controller']['auth']['individual']}">		if(!${model['controller']['auth']['name']}_wa&&!origBean.get${cd:upperFirst(owner['id'])}().equals(getUser(session)))
			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
</c:if>		if(!((${model['mapper']['alias']})bMapper).unique(bean))
			return finish("",response,HttpURLConnection.HTTP_CONFLICT);
		List<%="<List<String>>"%> referencingErrors=referencing(bean);
		if(referencingErrors.size()>0)
			return finish(referencingErrors,response,HttpURLConnection.HTTP_NOT_ACCEPTABLE);
		List<%="<List<String>>"%> referencedErrors=referencedAndchanged(origBean,bean);
		if(referencedErrors.size()>0)
			return finish(referencedErrors,response,HttpURLConnection.HTTP_PRECON_FAILED);
		return finish("",response,HttpURLConnection.HTTP_OK);
	}
	@RequestMapping(value="/{${model['bean']['key']['id']}}",method=RequestMethod.DELETE)
	public String delete(HttpSession session,HttpServletRequest request,HttpServletResponse response,@PathVariable ${model['bean']['key']['javaType']} ${model['bean']['key']['id']}) throws JsonProcessingException
	{	if(getUser(session)==null)
			return finish("",response,HttpURLConnection.HTTP_UNAUTHORIZED);
<c:choose><c:when test="${model['controller']['auth']['individual']}">		boolean ${model['controller']['auth']['name']}_wa=checkSecurity(session,"${model['controller']['auth']['name']}_wa"),${model['controller']['auth']['name']}_wi=checkSecurity(session,"${model['controller']['auth']['name']}_wi");
		if(!${model['controller']['auth']['name']}_wa&&!${model['controller']['auth']['name']}_wi)
</c:when><c:otherwise>		boolean ${model['controller']['auth']['name']}_wa=checkSecurity(session,"${model['controller']['auth']['name']}_wa");
		if(!${model['controller']['auth']['name']}_wa)
</c:otherwise></c:choose>			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
		if(reserved.isReserved("${model['controller']['auth']['name']}K"+${model['bean']['key']['id']}))
			return finish("",response,423);
		${model['bean']['alias']} origBean=((${model['mapper']['alias']})bMapper).get(${model['bean']['key']['id']},null);
		if(origBean==null)
			return finish("",response,HttpURLConnection.HTTP_NO_CONTENT);
<c:if test="${model['controller']['auth']['individual']}">		if(!${model['controller']['auth']['name']}_wa&&!origBean.get${cd:upperFirst(owner['id'])}().equals(getUser(session)))
			return finish("",response,HttpURLConnection.HTTP_FORBIDDEN);
</c:if>		List<%="<List<String>>"%> referencedErrors=referenced(origBean);
		if(referencedErrors.size()>0)
			return finish(referencedErrors,response,HttpURLConnection.HTTP_PRECON_FAILED);
		return finish("",response,HttpURLConnection.HTTP_OK);
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
	private List<%="<List<String>>"%> referencing(${model['bean']['alias']} bean)
	{	List<%="<List<String>>"%> fields=new ArrayList<%="<List<String>>"%>();
<c:forEach items="${model['mapper']['referencing']}" var="referencing">		if(!((${model['mapper']['alias']})bMapper).referencing<c:forEach items="${referencing['domestic']}" var="domestic">${cd:upperFirst(domestic)}</c:forEach>(${cd:join(cd:format1('bean.get%s()',cd:upperFirst(referencing['domestic'])),',')}))
		{	fields.add(java.util.Arrays.asList(<c:forEach items="${referencing['domestic']}" var="domestic" varStatus="status"><c:choose><c:when test="${status.last}">"${domestic}"</c:when><c:otherwise>"${domestic}",</c:otherwise></c:choose></c:forEach>));
		}
</c:forEach>		return fields;
	}
	private List<%="<List<String>>"%> referencedAndchanged(${model['bean']['alias']} origBean,${model['bean']['alias']} bean)
	{	List<%="<List<String>>"%> fields=new ArrayList<%="<List<String>>"%>();
<c:forEach items="${model['mapper']['referenced']}" var="referenced">		if(<c:forEach items="${referenced['domestic']}" var="domestic" varStatus="status"><c:choose><c:when test="${status.last}">!origBean.get${cd:upperFirst(domestic)}().equals(bean.get${cd:upperFirst(domestic)}()))</c:when><c:otherwise>!origBean.get${cd:upperFirst(domestic)}().equals(bean.get${cd:upperFirst(domestic)}()))||</c:otherwise></c:choose></c:forEach>
			if(((${model['mapper']['alias']})bMapper).referenced<c:forEach items="${referenced['domestic']}" var="domestic">${cd:upperFirst(domestic)}</c:forEach>(<c:forEach items="${referenced['domestic']}" var="domestic" varStatus="status"><c:choose><c:when test="${status.last}">origBean.get${cd:upperFirst(domestic)}()</c:when><c:otherwise>origBean.get${cd:upperFirst(domestic)}(),</c:otherwise></c:choose></c:forEach>))
				fields.add(java.util.Arrays.asList(<c:forEach items="${referenced['domestic']}" var="domestic" varStatus="status"><c:choose><c:when test="${status.last}">"${domestic}"</c:when><c:otherwise>"${domestic}",</c:otherwise></c:choose></c:forEach>));
</c:forEach>		return fields;
	}
	private List<%="<List<String>>"%> referenced(${model['bean']['alias']} origBean)
	{	List<%="<List<String>>"%> fields=new ArrayList<%="<List<String>>"%>();
<c:forEach items="${model['mapper']['referenced']}" var="referenced">		if(((${model['mapper']['alias']})bMapper).referenced<c:forEach items="${referenced['domestic']}" var="domestic">${cd:upperFirst(domestic)}</c:forEach>(<c:forEach items="${referenced['domestic']}" var="domestic" varStatus="status"><c:choose><c:when test="${status.last}">origBean.get${cd:upperFirst(domestic)}()</c:when><c:otherwise>origBean.get${cd:upperFirst(domestic)}(),</c:otherwise></c:choose></c:forEach>))
			fields.add(java.util.Arrays.asList(<c:forEach items="${referenced['domestic']}" var="domestic" varStatus="status"><c:choose><c:when test="${status.last}">"${domestic}"</c:when><c:otherwise>"${domestic}",</c:otherwise></c:choose></c:forEach>));
</c:forEach>		return fields;
	}
}