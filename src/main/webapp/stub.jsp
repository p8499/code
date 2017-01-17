<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/>package ${model['controller']['androidPackage']};

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;
import com.p8499.base.StubBase;
import com.p8499.base.Response;
import ${model['bean']['androidPackage']}.${model['bean']['alias']};
import ${model['bean']['androidMaskPackage']}.${model['bean']['maskAlias']};

public class ${model['controller']['stub']} extends StubBase
{	public static Response get(String server,String cookie,${model['bean']['key']['javaType']} ${model['bean']['key']['id']},${model['bean']['maskAlias']} mask) throws IOException,JSONException
	{	if(mask==null)
			return request(server+"${model['controller']['path']}/"+${model['bean']['key']['id']},"GET",new String[]{"Cookie","Content-Type"},new Object[]{cookie,"application/json"},null,null,null);
		else
			return request(server+"${model['controller']['path']}/"+${model['bean']['key']['id']},"GET",new String[]{"Cookie","Content-Type"},new Object[]{cookie,"application/json"},new String[]{"mask"},new Object[]{stringify(mask)},null);
	}
	public static Response add(String server,String cookie,${model['bean']['alias']} obj) throws IOException,JSONException
	{	return request(server+"${model['controller']['path']}/"<c:if test="${!model['bean']['key']['auto']}">+obj.get${cd:upperFirst(model['bean']['key']['id'])}()</c:if>,"POST",new String[]{"Cookie","Content-Type"},new Object[]{cookie,"application/json"},null,null,stringify(obj).getBytes("UTF-8"));
	}
	public static Response update(String server,String cookie,${model['bean']['alias']} obj,${model['bean']['maskAlias']} mask) throws IOException,JSONException
	{	if(mask==null)
			return request(server+"${model['controller']['path']}/"+obj.get${cd:upperFirst(model['bean']['key']['id'])}(),"PUT",new String[]{"Cookie","Content-Type"},new Object[]{cookie,"application/json"},null,null,stringify(obj).getBytes("UTF-8"));
		else
			return request(server+"${model['controller']['path']}/"+obj.get${cd:upperFirst(model['bean']['key']['id'])}(),"PUT",new String[]{"Cookie","Content-Type"},new Object[]{cookie,"application/json"},new String[]{"mask"},new Object[]{stringify(mask)},stringify(obj).getBytes("UTF-8"));
	}
	public static Response delete(String server,String cookie,${model['bean']['key']['javaType']} ${model['bean']['key']['id']}) throws IOException
	{	return request(server+"${model['controller']['path']}/"+${model['bean']['key']['id']},"DELETE",new String[]{"Cookie","Content-Type"},new Object[]{cookie,"application/json"},null,null,null);
	}
	public static Response query(String server,String cookie,String filter,String orderBy,int start,int stop,${model['bean']['maskAlias']} mask) throws IOException,JSONException
	{	if(mask==null)
			return request(server+"${model['controller']['path']}/","GET",new String[]{"Cookie","Content-Type","Range"},new Object[]{cookie,"application/json","items="+start+"-"+stop},new String[]{"filter","orderBy"},new Object[]{filter,orderBy},null);
		else
			return request(server+"${model['controller']['path']}/","GET",new String[]{"Cookie","Content-Type","Range"},new Object[]{cookie,"application/json","items="+start+"-"+stop},new String[]{"filter","orderBy","mask"},new Object[]{filter,orderBy,stringify(mask)},null);
	}
	public static Response count(String server,String cookie,String filter) throws IOException,JSONException
	{
		return request(server+"${model['controller']['path']}/","GET",new String[]{"Cookie","Content-Type","Range"},new Object[]{cookie,"application/json","items=0--1"},new String[]{"filter","orderBy","mask"},new Object[]{filter,null,stringify(new ${model['bean']['maskAlias']}().set${cd:upperFirst(model['bean']['key']['id'])}(true))},null);
	}
	public static ${model['bean']['alias']} parse(String str) throws JSONException
	{	JSONTokener tokener=new JSONTokener(str);
		JSONObject json=(JSONObject)tokener.nextValue();
		${model['bean']['alias']} obj=jsonToObject(json);
		return obj;
	}
	public static ArrayList${cd:format1("<%s>",cd:upperFirst(model['bean']['alias']))} parseList(String str) throws JSONException
	{	JSONTokener tokener=new JSONTokener(str);
		JSONArray jsons=(JSONArray)tokener.nextValue();
		ArrayList${cd:format1("<%s>",cd:upperFirst(model['bean']['alias']))} objs=new ArrayList${cd:format1("<%s>",cd:upperFirst(model['bean']['alias']))}();
		for(int i=0;i${"<"}jsons.length();i++)
		{	JSONObject json=jsons.getJSONObject(i);
			${model['bean']['alias']} obj=jsonToObject(json);
			objs.add(obj);
		}
		return objs;
	}
	public static String stringify(${cd:upperFirst(model['bean']['alias'])} obj) throws JSONException
	{	return objectToJson(obj).toString();
	}
	public static String stringify(${model['bean']['maskAlias']} obj) throws JSONException
	{	return objectToJson(obj).toString();
	}
	public static String stringifyList(List${cd:format1("<%s>",cd:upperFirst(model['bean']['alias']))} objs) throws JSONException
	{	JSONArray jsons=new JSONArray();
		for(int i=0;i${"<"}objs.size();i++)
			jsons.put(objectToJson(objs.get(i)));
		return jsons.toString();
	}
	protected static ${cd:upperFirst(model['bean']['alias'])} jsonToObject(JSONObject json) throws JSONException
	{	${cd:upperFirst(model['bean']['alias'])} obj=new ${cd:upperFirst(model['bean']['alias'])}();
<c:forEach items="${cd:union(model['bean']['key'],model['bean']['field'])}" var="kf"><c:set var="javaType" value="${cd:upperFirst(kf['javaType'])}"/>		if(json.has("${kf['id']}"))
			obj.set${cd:upperFirst(kf['id'])}(json.get<c:choose><c:when test="${javaType=='Integer'}">Int</c:when><c:otherwise>${javaType}</c:otherwise></c:choose>("${kf['id']}"));
</c:forEach>		return obj;
	}
	protected static JSONObject objectToJson(${cd:upperFirst(model['bean']['alias'])} obj) throws JSONException
	{	JSONObject json=new JSONObject();
<c:forEach items="${cd:union(model['bean']['key'],model['bean']['field'])}" var="kf">		if(obj.get${cd:upperFirst(kf['id'])}()!=null)
			json.put("${kf['id']}",obj.get${cd:upperFirst(kf['id'])}());
</c:forEach>		return json;
	}
	protected static JSONObject objectToJson(${model['bean']['maskAlias']} obj) throws JSONException
	{	JSONObject json=new JSONObject();
<c:forEach items="${cd:union(model['bean']['key'],model['bean']['field'])}" var="kf">		if(obj.get${cd:upperFirst(kf['id'])}())
			json.put("${kf['id']}",obj.get${cd:upperFirst(kf['id'])}());
</c:forEach>		return json;
	}
}
