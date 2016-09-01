<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/>package ${model['mapper']['package']};

import java.util.List;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
<c:if test="${model['bean']['key']['auto']}">import org.apache.ibatis.annotations.Options;
</c:if>import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Component;
import com.p8499.mvc.database.BeanMapper;
import com.p8499.mvc.database.Mask;
import ${model['bean']['package']}.${model['bean']['alias']};

@Component("${model['controller']['mapperBean']}")
public interface ${model['mapper']['alias']} extends BeanMapper<${model['bean']['alias']},${model['bean']['key']['javaType']}>
{	@Override
	@Select("SELECT COUNT(*)>0 FROM ${model['mapper']['view']} WHERE ${fn:toUpperCase(model['bean']['key']['id'])}=${String.format('#{%s}',model['bean']['key']['id'])}")
	public boolean exists(@Param("${model['bean']['key']['id']}")${model['bean']['key']['javaType']} ${model['bean']['key']['id']});
	
	@Override
	@Select("SELECT ${cd:join(cd:upper(ids),',')} FROM ${model['mapper']['view']} WHERE ${fn:toUpperCase(model['bean']['key']['id'])}=${String.format('#{%s}',model['bean']['key']['id'])}")
	public ${model['bean']['alias']} get(@Param("${model['bean']['key']['id']}")${model['bean']['key']['javaType']} ${model['bean']['key']['id']});
	
	@Override
	@Select("<script>"
		+ "<if test='${cd:join(cd:format1('mask.%s',ids),' or ')}'>"
		+ "<trim prefix='SELECT' suffixOverrides=','>"
<c:forEach items="${ids}" var="id">		+ "<if test='mask.${id}'>${cd:upper(id)}, </if>"
</c:forEach>		+ "</trim>"
		+ "FROM ${model['mapper']['view']} WHERE ${fn:toUpperCase(model['bean']['key']['id'])}=${String.format('#{%s}',model['bean']['key']['id'])}"
		+ "</if>"
		+ "</script>")
	public ${model['bean']['alias']} getWithMask(@Param("${model['bean']['key']['id']}")${model['bean']['key']['javaType']} ${model['bean']['key']['id']},@Param("mask")Mask mask);
	
	@Override
<c:choose><c:when test="${model['bean']['key']['auto']}">	@Insert("INSERT INTO ${model['mapper']['table']} (${cd:join(cd:upper(fieldIds),',')}) VALUES (${cd:join(cd:format1('#{bean.%s}',fieldIds),',')})")
	@Options(useGeneratedKeys=true,keyProperty="bean.${model['bean']['key']['id']}")
</c:when><c:otherwise>	@Insert("INSERT INTO ${model['mapper']['table']} (${cd:join(cd:upper(ids),',')}) VALUES (${cd:join(cd:format1('#{bean.%s}',ids),',')})")
</c:otherwise></c:choose>	public void add(@Param("bean")${model['bean']['alias']} bean);
	
	@Override
	@Update("UPDATE ${model['mapper']['table']} SET ${cd:join(cd:format2('%s=#{bean.%s}',cd:upper(fieldIds),fieldIds),',')} WHERE ${fn:toUpperCase(model['bean']['key']['id'])}=${String.format('#{bean.%s}',model['bean']['key']['id'])}")
	public void update(@Param("bean")${model['bean']['alias']} bean);
	
	@Override
	@Update("<script>"
		+ "<if test='${cd:join(cd:format1('mask.%s',fieldIds),' or ')}'>"
		+ "UPDATE ${model['mapper']['table']} "
		+ "<set>"
<c:forEach items="${fieldIds}" var="id">		+ "<if test='mask.${id}'>${cd:upper(id)}=${String.format('#{bean.%s}',id)}, </if>"
</c:forEach>		+ "</set>"
		+ "WHERE ${fn:toUpperCase(model['bean']['key']['id'])}=${String.format('#{bean.%s}',model['bean']['key']['id'])}"
		+ "</if>"
		+ "</script>")
	public void updateWithMask(@Param("bean")${model['bean']['alias']} bean,@Param("mask")Mask mask);
	
	@Override
	@Delete("DELETE FROM ${model['mapper']['table']} WHERE ${fn:toUpperCase(model['bean']['key']['id'])}=${String.format('#{%s}',model['bean']['key']['id'])}")
	public boolean delete(@Param("${model['bean']['key']['id']}")${model['bean']['key']['javaType']} ${model['bean']['key']['id']});
	
	@Override
	@Select("<script>"
		+ "SELECT ${cd:join(cd:upper(ids),',')} FROM ${model['mapper']['view']} "
		+ "<if test='filter!=null'>WHERE ${'${filter}'} </if>"
		+ "<if test='order!=null'>ORDER BY ${'${order}'} </if>"
		+ "LIMIT ${'#{count}'} OFFSET ${'#{start}'}"
		+ "</script>")
	public List<${model['bean']['alias']}> query(@Param("filter")String filter,@Param("order")String order,@Param("start")long start,@Param("count")long count);
	
	@Override
	@Select("<script>"
		+ "<trim prefix='SELECT' suffixOverrides=','>"
<c:forEach items="${ids}" var="id">		+ "<if test='mask.${id}'>${cd:upper(id)}, </if>"
</c:forEach>		+ "</trim>"
		+ "FROM ${model['mapper']['view']} "
		+ "<if test='filter!=null'>WHERE ${'${filter}'} </if>"
		+ "<if test='order!=null'>ORDER BY ${'${order}'} </if>"
		+ "LIMIT ${'#{count}'} OFFSET ${'#{start}'}"
		+ "</script>")
	public List<${model['bean']['alias']}> queryWithMask(@Param("filter")String filter,@Param("order")String order,@Param("start")long start,@Param("count")long count,@Param("mask")Mask mask);
	
	@Override
	@Select("<script>"
		+ "SELECT COUNT(*) FROM ${model['mapper']['view']} "
		+ "<if test='filter!=null'>WHERE ${'${filter}'}</if> "
		+ "</script>")
	public long count(@Param("filter")String filter);
	
<c:forEach items="${model['bean']['field']}" var="field"><c:if test="${field['special']['type']=='next'}">	@Select("SELECT if(MAX(${field['id']}),null,0)+${field['special']['step']} FROM ${model['mapper']['view']}<c:if test="${!empty field['special']['scope']}"> WHERE ${cd:join(cd:format2('%s=#{%s}',field['special']['scope'],field['special']['scope']),' AND ')}</c:if>")
	public ${field['javaType']} next${cd:upperFirst(field['id'])}(${cd:join(cd:format3('@Param("%s")%s %s',field['special']['scope'],cd:draw(cd:sem(field['special']['scope'],cd:union(model['bean']['key'],model['bean']['field']),'id'),'javaType'),field['special']['scope']),',')});
	
</c:if></c:forEach>	@Override
<c:choose><c:when test="${!empty model['mapper']['unique']}">	@Select("<script>"
		+ "SELECT SUM(C)=0 FROM( "
<c:forEach items="${model['mapper']['unique']}" var="unique" varStatus="status">		+ "<c:if test="${!status.first}">UNION ALL </c:if>SELECT COUNT(*) C FROM ${model['mapper']['view']} WHERE ${cd:join(cd:format2('%s=#{bean.%s}',cd:upper(unique),unique),' AND ')}<if test='bean.${model['bean']['key']['id']}!=null'> AND ${fn:toUpperCase(model['bean']['key']['id'])}!=${cd:format1('#{bean.%s}',model['bean']['key']['id'])}</if> "
</c:forEach>		+ ") T"
		+ "</script>")
</c:when><c:otherwise>	@Select("SELECT 1")
</c:otherwise></c:choose>	public boolean unique(@Param("bean")${model['bean']['alias']} bean);
	
	@Override
<c:choose><c:when test="${!empty model['mapper']['referencing']}">	@Select("SELECT SUM(C)>0 FROM( "
<c:forEach items="${model['mapper']['referencing']}" var="referencing" varStatus="status">		+ "<c:if test="${!status.first}">UNION ALL </c:if>SELECT COUNT(*) C FROM ${referencing['foreignModel']['mapper']['view']} WHERE ${cd:join(cd:format2('%s=#{bean.%s}',cd:upper(referencing['foreign']),referencing['domestic']),' AND ')} "
</c:forEach>		+ ") T")
</c:when><c:otherwise>	@Select("SELECT 1")
</c:otherwise></c:choose>	public boolean referencing(@Param("bean")${model['bean']['alias']} bean);
	
<c:forEach items="${model['mapper']['referencing']}" var="referencing">	@Select("SELECT COUNT(*)>0 FROM ${referencing['foreignModel']['mapper']['view']} WHERE ${cd:join(cd:format2('%s=#{%s}',cd:upper(referencing['foreign']),referencing['domestic']),',')}")
	public boolean referencing${cd:join(cd:upperFirst(referencing['domestic']),'')}(${cd:join(cd:format3('@Param("%s")%s %s',referencing['domestic'],cd:draw(cd:sem(referencing['domestic'],cd:union(model['bean']['key'],model['bean']['field']),'id'),'javaType'),referencing['domestic']),',')});
	
</c:forEach>	@Override
<c:choose><c:when test="${!empty model['mapper']['referenced']}">	@Select("SELECT SUM(C)>0 FROM( "
<c:forEach items="${model['mapper']['referenced']}" var="referenced" varStatus="status0"><c:forEach items="${referenced['foreign']}" var="foreign" varStatus="status1">		+ "<c:if test="${!status0.first||!status1.first}">UNION ALL </c:if>SELECT COUNT(*) C FROM ${foreign['foreignModel']['mapper']['view']} WHERE ${cd:join(cd:format2('%s=#{bean.%s}',cd:upper(foreign['foreign']),referenced['domestic']),' AND ')} "
</c:forEach></c:forEach>		+ ") T")
</c:when><c:otherwise>	@Select("SELECT 1")
</c:otherwise></c:choose>	public boolean referenced(@Param("bean")${model['bean']['alias']} bean);
<c:choose><c:when test="${empty model['mapper']['referenced']}">}</c:when><c:otherwise>	
<c:forEach items="${model['mapper']['referenced']}" var="referenced" varStatus="status0">	@Select("SELECT SUM(C)>0 FROM( "
<c:forEach items="${referenced['foreign']}" var="foreign" varStatus="status1">		+ "<c:if test="${!status1.first}">UNION ALL </c:if>SELECT COUNT(*) C FROM ${foreign['foreignModel']['mapper']['view']} WHERE ${cd:join(cd:format2('%s=#{%s}',cd:upper(foreign['foreign']),referenced['domestic']),' AND ')} "
</c:forEach>		+ ") T")
	public boolean referenced${cd:join(cd:upperFirst(referenced['domestic']),'')}(${cd:join(cd:format3('@Param("%s")%s %s',referenced['domestic'],cd:draw(cd:sem(referenced['domestic'],cd:union(model['bean']['key'],model['bean']['field']),'id'),'javaType'),referenced['domestic']),',')});
<c:choose><c:when test="${status0.last}">}</c:when><c:otherwise>	
</c:otherwise></c:choose></c:forEach></c:otherwise></c:choose>