<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/>package ${model['bean']['package']};

import com.fasterxml.jackson.annotation.JsonInclude;
import com.p8499.mvc.database.Add;
import com.p8499.mvc.database.Bean;
import com.p8499.mvc.database.Update;
import javax.validation.constraints.NotNull;
<c:if test="${model['bean']['key']['auto']}">import javax.validation.constraints.Null;
</c:if><c:if test="${!empty cd:sem('String',model['bean']['field'],'javaType')}">import javax.validation.constraints.Size;
</c:if>@JsonInclude((JsonInclude.Include.NON_NULL))
public class ${model['bean']['alias']} implements Bean
{	public static final String TABLE="${model['mapper']['table']}";
	public static final String VIEW="${model['mapper']['view']}";
	public static final String NAME="${model['bean']['alias']}";
<c:forEach items="${ids}" var="id">	public static final String FIELD_${cd:upper(id)}="${cd:upper(id)}";
</c:forEach><c:forEach items="${cd:union(model['bean']['key'],model['bean']['field'])}" var="kf"><c:forEach items="${kf['in']}" var="in">	public static final ${kf['javaType']} ${cd:upper(kf['id'])}_${cd:upper(in['desc'])}=${in['value']};
</c:forEach></c:forEach><c:forEach items="${cd:union(model['bean']['key'],model['bean']['field'])}" var="kf">	protected ${kf['javaType']} ${kf['id']}=null;
</c:forEach>
	public ${model['bean']['alias']}(${cd:join(cd:format2('%s %s',cd:draw(cd:sem(ids,cd:union(model['bean']['key'],model['bean']['field']),'id'),'javaType'),ids),',')})
	{<c:forEach items="${ids}" var="id" varStatus="status"><c:if test="${!status.first}">	</c:if>	this.${id}=${id};
</c:forEach>	}
	public ${model['bean']['alias']}()
	{	
	}
	@Override
	public String name()
	{	return NAME;
	}
	@Override
	public ${model['bean']['alias']} clone()
	{
		return new ${model['bean']['alias']}(${cd:join(ids,',')});
	}
<c:choose><c:when test="${model['bean']['key']['auto']}">	@Null(groups={Add.class})
	@NotNull(groups={Update.class})
</c:when><c:otherwise>	@NotNull(groups={Add.class,Update.class})
	//@SomeConstraint(groups={Add.class,Update.class})
</c:otherwise></c:choose>	public ${model['bean']['key']['javaType']} get${cd:upperFirst(model['bean']['key']['id'])}()
	{	return ${model['bean']['key']['id']};
	}
	public ${model['bean']['alias']} set${cd:upperFirst(model['bean']['key']['id'])}(${model['bean']['key']['javaType']} ${model['bean']['key']['id']})
	{	this.${model['bean']['key']['id']}=${model['bean']['key']['id']};
		return this;
	}
	
<c:forEach items="${model['bean']['field']}" var="field" varStatus="status"><c:choose><c:when test="${field['special']['type']=='created'||field['special']['type']=='updated'||field['special']['type']=='virtual'}"></c:when><c:when test="${field['special']['type']=='next'}">	@NotNull(groups={Update.class})
</c:when><c:otherwise>	@NotNull(groups={Add.class,Update.class})
</c:otherwise></c:choose><c:if test="${field['javaType']=='String'}">	@Size(max=${field['length']})
</c:if>	//@SomeConstraint(groups={Add.class,Update.class})
	public ${field['javaType']} get${cd:upperFirst(field['id'])}()
	{	return ${field['id']};
	}
	public ${model['bean']['alias']} set${cd:upperFirst(field['id'])}(${field['javaType']} ${field['id']})
	{	this.${field['id']}=${field['id']};
		return this;
	}<c:choose><c:when test="${!status.last}">
	
</c:when><c:otherwise>
</c:otherwise></c:choose></c:forEach>}