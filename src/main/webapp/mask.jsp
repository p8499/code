<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/>package ${model['bean']['maskPackage']};

import com.p8499.mvc.database.Mask;

public class ${model['bean']['maskAlias']} implements Mask
{<c:forEach items="${ids}" var="id">	protected boolean ${id}=false;
</c:forEach>
	public ${model['bean']['maskAlias']}(<c:forEach items="${ids}" var="id" varStatus="status">boolean ${id}<c:if test="${!status.last}">,</c:if></c:forEach>)
	{<c:forEach items="${ids}" var="id" varStatus="status"><c:if test="${!status.first}">	</c:if>	this.${id}=${id};
</c:forEach>	}
	public ${model['bean']['maskAlias']}()
	{	
	}
	@Override
	public ${model['bean']['maskAlias']} all(boolean b)
	{<c:forEach items="${ids}" var="id" varStatus="status"><c:if test="${!status.first}">	</c:if>	this.${id}=b;
</c:forEach>	return this;
	}
<c:forEach items="${ids}" var="id" varStatus="status">	public boolean get${cd:upperFirst(id)}()
	{	return ${id};
	}
	public ${model['bean']['maskAlias']} set${cd:upperFirst(id)}(boolean ${id})
	{	this.${id}=${id};
		return this;
	}
</c:forEach>}