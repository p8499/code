<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/>package ${model['bean']['listenerPackage']};

import org.springframework.stereotype.Component;
import com.p8499.mvc.database.BeanListener;
import com.p8499.mvc.database.Cache;
import ${model['bean']['package']}.${model['bean']['alias']};
import ${model['bean']['maskPackage']}.${model['bean']['maskAlias']};

@Component("${model['controller']['listenerBean']}")
public class ${model['bean']['listenerAlias']} extends BeanListener<${model['bean']['alias']},${model['bean']['maskAlias']},${model['bean']['key']['javaType']}>
{	@Override
	public void afterUpdate(${model['bean']['alias']} bean)
	{	${model['bean']['maskAlias']} mask=new ${model['bean']['maskAlias']}();
		mask<c:forEach items="${ids}" var="id" varStatus="status">.set${cd:upperFirst(id)}(true)</c:forEach>;
		afterUpdateWithMask(bean,mask);
	}
	@Override
	public void afterDelete(${model['bean']['key']['javaType']} ${model['bean']['key']['id']})
	{	for(Cache cache:afterDeleteList)
		{	cache.put("${model['bean']['alias']}",<c:choose><c:when test="${model['bean']['key']['javaType']=='String'}">${model['bean']['key']['id']}</c:when><c:otherwise>${model['bean']['key']['id']}.toString()</c:otherwise></c:choose>,ACTION_AFTERDELETE);
		}
	}
	@Override
	public void beforeUpdate(${model['bean']['alias']} bean)
	{	${model['bean']['maskAlias']} mask=new ${model['bean']['maskAlias']}();
		mask<c:forEach items="${ids}" var="id" varStatus="status">.set${cd:upperFirst(id)}(true)</c:forEach>;
		beforeUpdateWithMask(bean,mask);
	}
	@Override
	public void beforeDelete(${model['bean']['key']['javaType']} ${model['bean']['key']['id']})
	{	for(Cache cache:beforeDeleteList)
		{	cache.put("${model['bean']['alias']}",<c:choose><c:when test="${model['bean']['key']['javaType']=='String'}">${model['bean']['key']['id']}</c:when><c:otherwise>${model['bean']['key']['id']}.toString()</c:otherwise></c:choose>,ACTION_BEFOREDELETE);
		}
	}
}
