<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/>package ${model['bean']['androidPackage']};

import android.os.Parcel;
import android.os.Parcelable;
import ${model['bean']['androidMaskPackage']}.${model['bean']['maskAlias']};

public class ${model['bean']['alias']} implements Parcelable
{	public static final String TABLE="${model['mapper']['table']}";
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
	public ${model['bean']['alias']} clone()
	{
		return new ${model['bean']['alias']}(${cd:join(ids,',')});
	}
	public ${model['bean']['alias']}(Parcel in)
	{	this.${model['bean']['key']['id']}=in.read<c:choose><c:when test="${model['bean']['key']['javaType']=='Integer'}">Int</c:when><c:when test="${model['bean']['key']['javaType']=='String'}">String</c:when><c:when test="${model['bean']['key']['javaType']=='Double'}">Double</c:when></c:choose>();
<c:forEach items="${model['bean']['field']}" var="field">		this.${field['id']}=in.read<c:choose><c:when test="${field['javaType']=='Integer'}">Int</c:when><c:when test="${field['javaType']=='String'}">String</c:when><c:when test="${field['javaType']=='Double'}">Double</c:when></c:choose>();
</c:forEach>	}
	
	public ${model['bean']['key']['javaType']} get${cd:upperFirst(model['bean']['key']['id'])}()
	{	return ${model['bean']['key']['id']};
	}
	public ${model['bean']['alias']} set${cd:upperFirst(model['bean']['key']['id'])}(${model['bean']['key']['javaType']} ${model['bean']['key']['id']})
	{	this.${model['bean']['key']['id']}=${model['bean']['key']['id']};
		return this;
	}
	
<c:forEach items="${model['bean']['field']}" var="field" varStatus="status">	public ${field['javaType']} get${cd:upperFirst(field['id'])}()
	{	return ${field['id']};
	}
	public ${model['bean']['alias']} set${cd:upperFirst(field['id'])}(${field['javaType']} ${field['id']})
	{	this.${field['id']}=${field['id']};
		return this;
	}
	
</c:forEach>	@Override
	public int describeContents()
	{	return 0;
	}
	@Override
	public void writeToParcel(Parcel dest,int flags)
	{	dest.write<c:choose><c:when test="${model['bean']['key']['javaType']=='Integer'}">Int</c:when><c:when test="${model['bean']['key']['javaType']=='String'}">String</c:when><c:when test="${model['bean']['key']['javaType']=='Double'}">Double</c:when></c:choose>(${model['bean']['key']['id']});
<c:forEach items="${model['bean']['field']}" var="field">		dest.write<c:choose><c:when test="${field['javaType']=='Integer'}">Int</c:when><c:when test="${field['javaType']=='String'}">String</c:when><c:when test="${field['javaType']=='Double'}">Double</c:when></c:choose>(${field['id']});
</c:forEach>	}
	
	@Override
	public boolean equals(Object obj)
	{	return (obj instanceof ${model['bean']['alias']})?equals((${model['bean']['alias']})obj,new ${model['bean']['maskAlias']}().all(true)):false;
	}
	public boolean equals(${model['bean']['alias']} bean,${model['bean']['maskAlias']} mask)
	{	if(mask==null)
			mask=new ${model['bean']['maskAlias']}().all(true);
<c:forEach items="${ids}" var="id">		if(mask.get${cd:upperFirst(id)}()&&!(get${cd:upperFirst(id)}()==null&&bean.get${cd:upperFirst(id)}()==null||get${cd:upperFirst(id)}()!=null&&bean.get${cd:upperFirst(id)}()!=null&&get${cd:upperFirst(id)}().equals(bean.get${cd:upperFirst(id)}())))
			return false;
</c:forEach>		return true;
	}
	
	public static final ${model['bean']['alias']}.Creator<${model['bean']['alias']}> CREATOR=new Creator<${model['bean']['alias']}>()
    {   @Override
        public ${model['bean']['alias']}[] newArray(int size)
        {   return new ${model['bean']['alias']}[size];
        }
        @Override
        public ${model['bean']['alias']} createFromParcel(Parcel in)
        {   return new ${model['bean']['alias']}(in);
        }
    };
}