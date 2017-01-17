<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/>package ${model['bean']['listenerPackage']};

import org.springframework.stereotype.Component;
import com.p8499.mvc.BeanListener;
import com.p8499.mvc.database.Bean;
import com.p8499.mvc.database.Mask;
import ${model['bean']['package']}.${model['bean']['alias']};
import ${model['bean']['maskPackage']}.${model['bean']['maskAlias']};

@Component("${model['controller']['listenerBean']}")
public class ${model['bean']['listenerAlias']} extends BeanListener<${model['bean']['alias']},${model['bean']['maskAlias']}>
{	@Override
	public Class<? extends Bean> getBeanClass()
	{	return ${model['bean']['alias']}.class;
	}
	@Override
	public Class<? extends Mask> getMaskClass()
	{	return ${model['bean']['maskAlias']}.class;
	}
}
