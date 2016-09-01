<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/>require([
	"dojo/_base/array",
	"dojo/Deferred",
	"dojo/dom",
	"dojo/dom-form",
	"dojo/i18n!nls/Message.js",
	"dojo/io-query",
	"dojo/json",
	"dojo/parser",
	"dojo/promise/all",
	"dojo/ready",
	"dojo/request/xhr",
	"dojo/store/JsonRest",
	"dijit/registry",
	"lang/MultiKeyMap",
	"gridx/core/model/cache/Async",
	"gridx/modules/HScroller",
	"gridx/modules/VScroller",
	"gridx/modules/ColumnResizer",
	"gridx/modules/RowHeader",
	"gridx/modules/select/Row",
	"gridx/modules/IndirectSelect",
	"gridx/modules/Filter",
	"gridx/modules/filter/FilterBar",
	"gridx/modules/filter/QuickFilter",
	"gridx/modules/NestedSort",
	"gridx/modules/Pagination",
	"gridx/modules/pagination/PaginationBar",
	"dojo/domReady!"],function(array,Deferred,dom,domForm,Message,ioQuery,json,parser,all,ready,xhr,JsonRest,registry,MultiKeyMap)
{	parent.f_setTitle();
	msgArea_messages=new MultiKeyMap();
	msgAreaAdd_messages=new MultiKeyMap();
	msgAreaUpdate_messages=new MultiKeyMap();
	msgAreaDelete_messages=new MultiKeyMap();
	msgAreaPrepare_messages=new MultiKeyMap();
	grid_store=new JsonRest({target:"${model['html']['controllerBase']}${model['controller']['path']}",idProperty:"${model['bean']['key']['id']}",sortParam:"orderBy"});
	grid_structure=[
		{id:"${model['bean']['key']['id']}",field:"${model['bean']['key']['id']}",name:"${model['bean']['key']['name']}",width:"${cd:length(model['bean']['key']['length'])}px"},
<c:forEach items="${model['bean']['field']}" var="field" varStatus="status">		{id:"${field['id']}",field:"${field['id']}",name:"${field['name']}",width:"${cd:length(field['length'])}px"}<c:choose><c:when test="${!status.last}">,</c:when><c:otherwise>];</c:otherwise></c:choose>
</c:forEach>	grid_filterSetupQuery=function(expr)
	{	return {"filter":expr==null?null:json.stringify(expr)};
	};
<c:forEach items="${model['mapper']['referencing']}" var="referencing">	${referencing['alias']}Grid_store=new JsonRest({target:"${referencing['foreignModel']['html']['controllerBase']}${referencing['foreignModel']['controller']['path']}",idProperty:"${referencing['foreignModel']['bean']['key']['id']}",sortParam:"orderBy"});
	${referencing['alias']}Grid_structure=[
		{id:"${referencing['foreignModel']['bean']['key']['id']}",field:"${referencing['foreignModel']['bean']['key']['id']}",name:"${referencing['foreignModel']['bean']['key']['name']}",width:"${cd:length(referencing['foreignModel']['bean']['key']['length'])}px"},
<c:forEach items="${referencing['foreignModel']['bean']['field']}" var="field" varStatus="status">		{id:"${field['id']}",field:"${field['id']}",name:"${field['name']}",width:"${cd:length(field['length'])}px"}<c:choose><c:when test="${!status.last}">,</c:when><c:otherwise>];</c:otherwise></c:choose>
</c:forEach>	${referencing['alias']}Grid_filterSetupQuery=function(expr)
	{	return {"filter":expr==null?null:json.stringify(expr)};
	};
</c:forEach>	this.f_prepareAdd=function()
	{	msgAreaAdd_messages.removeAll({group:"add"});
		msgAreaAdd.refresh();
<c:if test="${!model['bean']['key']['auto']}"><c:choose><c:when test="${model['controller']['auth']['individual']&&model['bean']['key']['special']['type']=='owner'}">		if(!wa)
		{	add_${model['bean']['key']['id']}.set("value",parent.user);
			add_${model['bean']['key']['id']}.set("readonly","readonly");
			dom.byId("add_${model['bean']['key']['id']}Assist").style.display="none";
		}
		else
			add_${model['bean']['key']['id']}.set("value","");
</c:when><c:when test="${model['bean']['key']['special']['type']=='created'||model['bean']['key']['special']['type']=='updated'}">		if(this.interval_add_${model['bean']['key']['id']}!=null)
			clearInterval(interval_add_${model['bean']['key']['id']});
		this.interval_add_${model['bean']['key']['id']}=setInterval(function(){add_${model['bean']['key']['id']}.set("value",new Date());},1000);
</c:when><c:otherwise>		add_${model['bean']['key']['id']}.set("value","");
</c:otherwise></c:choose></c:if><c:forEach items="${model['bean']['field']}" var="field"><c:choose><c:when test="${model['controller']['auth']['individual']&&field['special']['type']=='owner'}">		if(!wa)
		{	add_${field['id']}.set("value",parent.user);
			add_${field['id']}.set("readonly","readonly");
			dom.byId("add_${field['id']}Assist").style.display="none";
		}
		else
			add_${field['id']}.set("value","${field['default']}");
</c:when><c:when test="${field['special']['type']=='created'||field['special']['type']=='updated'}">		if(this.interval_add_${field['id']}!=null)
			clearInterval(interval_add_${field['id']});
		this.interval_add_${field['id']}=setInterval(function(){add_${field['id']}.set("value",new Date());},1000);
</c:when><c:otherwise>		add_${field['id']}.set("value","${field['default']}");
</c:otherwise></c:choose></c:forEach>		addDialog.show();
	};
	this.f_checkAdd=function()
	{	var deferred=new Deferred();
		xhr.post("${model['html']['controllerBase']}${model['controller']['checkPath']}"<c:if test="${!model['bean']['key']['auto']}">+"/"+add_${model['bean']['key']['id']}.get("value")</c:if>,{data:domForm.toJson("addForm"),handleAs:"json",headers:{'Content-Type': 'application/json'}}).then(function(data)
		{	deferred.resolve(data);
		},function(data)
		{	msgAreaAdd_messages.removeAll({group:"add"});
			var d=data.response.data,status=data.response.status;
			msgAreaAdd_messages.put({group:"add",level:"error"},{msg:Message[status],targetNode:d==null?null:dom.byId("add_"+d[0])});
			msgAreaAdd.refresh();
			deferred.reject(data);
		});
		return deferred.promise;
	};
	this.f_processAdd=function()
	{	var obj=domForm.toObject("addForm");
<c:forEach items="${model['bean']['field']}" var="field"><c:if test="${field['dojoType']=='dijit/form/TimeTextBox'}">		obj.${field['id']}=obj.${field['id']}.substr(1);
</c:if></c:forEach>		grid.store.add(obj,{incremental:${!model['bean']['key']['auto']}}).then(function()
		{	addDialog.hide();
		},function(data)
		{	msgAreaAdd_messages.removeAll({group:"add"});
			var d=data.response.data,status=data.response.status;
			msgAreaAdd_messages.put({group:"add",level:"error"},{msg:Message[status],targetNode:d==null?null:dom.byId("add_"+d[0])});
			msgAreaAdd.refresh();
		});
	};
	this.f_prepareUpdate=function(id)
	{	var deferred=new Deferred();
		msgAreaUpdate_messages.removeAll({});
		msgAreaUpdate.refresh();
		all([grid.store.get(id),xhr("${model['html']['controllerBase']}${model['controller']['base']}/lock",{query:{obj:"${model['controller']['auth']['name']}",id:id},handleAs:"json"})]).then(function(data)
		{	<c:choose><c:when test="${field['dojoType']=='dijit/form/TimeTextBox'}">update_${model['bean']['key']['id']}.set("value","T"+data[0].${model['bean']['key']['id']});</c:when><c:otherwise>update_${model['bean']['key']['id']}.set("value",data[0].${model['bean']['key']['id']});</c:otherwise></c:choose>
<c:forEach items="${model['bean']['field']}" var="field"><c:choose><c:when test="${field['dojoType']=='dijit/form/TimeTextBox'}">			update_${field['id']}.set("value","T"+data[0].${field['id']});</c:when><c:otherwise>			update_${field['id']}.set("value",data[0].${field['id']});</c:otherwise></c:choose>
<c:choose><c:when test="${model['controller']['auth']['individual']&&field['special']['type']=='owner'}">			if(!wa)
			{	update_${field['id']}.set("readonly","readonly");
				dom.byId("update_${field['id']}Assist").style.display="none";
			}
</c:when><c:when test="${field['special']['type']=='updated'}">			if(this.interval_update_${field['id']}!=null)
				clearInterval(interval_update_${field['id']});
			this.interval_update_${field['id']}=setInterval(function(){update_${field['id']}.set("value",new Date());},1000);
</c:when></c:choose></c:forEach>			updateDialog.show();
			deferred.resolve(data);
		},function(data)
		{	msgAreaPrepare_messages.removeAll({group:"update"});
			var d=data.response.data,status=data.response.status;
			msgAreaPrepare_messages.put({group:"update",level:"error"},{msg:Message[status],targetNode:null});
			msgAreaPrepare.refresh();
			prepareDialog.show();
			deferred.reject(data);
		});
		return deferred.promise;
	};
	this.f_cancelUpdate=function()
	{	var deferred=new Deferred();
		xhr("${model['html']['controllerBase']}${model['controller']['base']}/unlock",{query:{obj:"${model['controller']['auth']['name']}",id:update_${model['bean']['key']['id']}.get("value")},handleAs:"json"}).then(function(data)
		{	updateDialog.hide();
			deferred.resolve(data);
		},function(data)
		{	updateDialog.hide();
			deferred.reject(data);
		});
		return deferred.promise;
	}
	this.f_checkUpdate=function()
	{	var deferred=new Deferred();
		xhr.put("${model['html']['controllerBase']}${model['controller']['checkPath']}"+"/"+update_${model['bean']['key']['id']}.get("value"),{data:domForm.toJson("updateForm"),handleAs:"json",headers:{'Content-Type': 'application/json'}}).then(function(data)
		{	deferred.resolve(data);
		},function(data)
		{	msgAreaUpdate_messages.removeAll({group:"update"});
			var d=data.response.data,status=data.response.status;
			msgAreaUpdate_messages.put({group:"update",level:"error"},{msg:Message[status],targetNode:d==null?null:dom.byId("update_"+d[0])});
			msgAreaUpdate.refresh();
			deferred.reject(data);
		});
		return deferred.promise;
	};
	this.f_processUpdate=function()
	{	var deferred=new Deferred();
		var obj=domForm.toObject("updateForm");
<c:forEach items="${model['bean']['field']}" var="field"><c:if test="${field['dojoType']=='dijit/form/TimeTextBox'}">		obj.${field['id']}=obj.${field['id']}.substr(1);
</c:if></c:forEach>		all([grid.store.put(obj),xhr("${model['html']['controllerBase']}${model['controller']['base']}/unlock",{query:{obj:"${model['controller']['auth']['name']}",id:update_${model['bean']['key']['id']}.get("value")},handleAs:"json"})]).then(function(data)
		{	updateDialog.hide();
			deferred.resolve(data);
		},function(data)
		{	msgAreaUpdate_messages.removeAll({group:"update"});
			var d=data.response.data,status=data.response.status;
			msgAreaUpdate_messages.put({group:"update",level:"error"},{msg:Message[status],targetNode:d==null?null:dom.byId("update_"+d[0])});
			msgAreaUpdate.refresh();
			deferred.reject(data);
		});
	};
	this.f_checkDelete=function(ids)
	{	var deferredRec=new Deferred();
		var deferred=new Deferred();
		msgAreaDelete_messages.removeAll({group:"delete"});
		_f_recCheckDelete(deferredRec,ids,0);
		deferredRec.promise.then(function()
		{	msgAreaDelete.refresh();
			deleteTip.innerHTML=grid.select.row.getSelected().length;
			if(msgAreaDelete_messages.countAll({group:"delete",level:"error"})>0)
			{	excludeButton.setAttribute('disabled',false);
				deleteSubmitButton.setAttribute('disabled',true);
			}
			else
			{	excludeButton.setAttribute('disabled',true);
				deleteSubmitButton.setAttribute('disabled',false);
			}
			deleteDialog.show();
			deferred.resolve(null);
		});
		return deferred.promise;
	}
	this.f_processDelete=function()
	{	var deferreds=new Array();
		array.forEach(grid.select.row.getSelected(),function(item,i)
		{	deferreds.push(grid.store.remove(item));
		});
		all(deferreds).then(function()
		{	deleteDialog.hide();
		});
		f_setControls(0x0001);
	}
	ready(function()
	{	grid.connect(grid.select.row,"onSelected",function(row)
		{	window.f_setControls(0x0011);
		});
		grid.connect(grid.select.row,"onDeselected",function(row)
		{	window.f_setControls(0x0011);
		});
<c:forEach items="${model['mapper']['referencing']}" var="referencing">		${referencing['alias']}Grid.connect(${referencing['alias']}Grid.select.row,"onSelected",function(row)
		{	f_assistEnd(${referencing['alias']}Dialog,${referencing['alias']}Grid,row);
		});
</c:forEach>		f_auth().then(function()
		{	f_setControls(0x1111);
			if(ra)
				;
<c:if test="${model['controller']['auth']['individual']}">			else if(!ra&&ri)
				msgArea_messages.put({group:"global",level:"information",msgId:"ri"},{msg:"讀個人記錄"});
</c:if>			else
				msgArea_messages.put({group:"global",level:"information",msgId:"rn"},{msg:"無權讀"});
			if(wa)
				;
<c:if test="${model['controller']['auth']['individual']}">			else if(!wa&&wi)
				msgArea_messages.put({group:"global",level:"information",msgId:"wi"},{msg:"寫個人記錄"});
</c:if>			else
				msgArea_messages.put({group:"global",level:"information",msgId:"wn"},{msg:"無權寫"});
			msgArea.refresh();
		});
		f_filterSearch();
		dom.byId("loading").style.display="none";
	});
	this.f_assistBegin=function(inputs,foreigns,assistDialog,assistGrid)
	{	var deferred=new Deferred();
		assistGrid.forInputs=inputs;
		assistGrid.foreigns=foreigns;
		assistGrid.select.row.clear();
		var filter={op:"and",data:[]};
		array.forEach(inputs,function(item,i)
		{	var val=inputs[i].get("value");
			filter.data.push({op:"equal",data:[{op:"string",data:foreigns[i],isCol:true},{op:"string",data:typeof(val)=="string"?val:isNaN(val)?0:val}]});
		});
		assistGrid.store.query({filter:json.stringify(filter)},{headers:{"Content-Type":"application/x-www-form-urlencoded"}}).then(function(data)
		{	if(data.length>0)
			{	var row=assistGrid.row(data[0][assistGrid.store.idProperty]<c:if test="${model['bean']['key']['javaType']!=String}">.toString()</c:if>);
				var pagination=assistGrid.pagination;
				pagination.gotoPage(pagination.pageOfIndex(row.index()));
				row.select();
			}
			assistDialog.show();
			deferred.resolve(data);
		},function(data)
		{	deferred.reject(data);
		});
		return deferred.promise;
	};
	this.f_assistEnd=function(assistDialog,assistGrid,row)
	{	array.forEach(assistGrid.forInputs,function(item,i)
		{	item.set("value",assistGrid.row(row.id).data()[assistGrid.foreigns[i]]);
		});
		assistDialog.hide();
	};
	this.f_encrypt=function(password)
	{	xhr("${model['html']['controllerBase']}${model['controller']['base']}/encrypt",{query:{plain:password.get("value")},handleAs:"json"}).then(function(data)
		{	password.set("value",data);
		});
	};
	this.f_deselect=function(messages)
	{	var idsExclude=array.map(messages.keySet(),function(key){return key.msgId;});
		array.forEach(idsExclude,function(item,i){grid.row(item).deselect()});
	};
	this.f_setControls=function(code)
	{	select=grid.select.row.getSelected().length;
		if(code&0x0001==0x0001)
			if(<c:choose><c:when test="${model['controller']['auth']['individual']}">wa||wi</c:when><c:otherwise>wa</c:otherwise></c:choose>)
				addButton.setAttribute('disabled',false);
			else
				addButton.setAttribute('disabled',true);
		if(code&0x0010==0x0010)
		{	if(<c:choose><c:when test="${model['controller']['auth']['individual']}">(wa||wi)</c:when><c:otherwise>wa</c:otherwise></c:choose>&&select==1)
				updateButton.setAttribute('disabled',false);
			else
				updateButton.setAttribute('disabled',true);
<c:forEach items="${model['mapper']['referencing']}" var="referencing">			if((ra${cd:lower(referencing['foreignModel']['bean']['alias'])}||ri${cd:lower(referencing['foreignModel']['bean']['alias'])})&&select==1)
				${cd:lower(referencing['foreignModel']['bean']['alias'])}Link.setAttribute('disabled',false);
			else
				${cd:lower(referencing['foreignModel']['bean']['alias'])}Link.setAttribute('disabled',true);
</c:forEach><c:forEach items="${model['mapper']['referenced']}" var="referenced"><c:forEach items="${referenced['foreign']}" var="foreign">			if((ra${cd:lower(foreign['foreignModel']['bean']['alias'])}||ri${cd:lower(foreign['foreignModel']['bean']['alias'])})&&select==1)
				${cd:lower(foreign['foreignModel']['bean']['alias'])}Link.setAttribute('disabled',false);
			else
				${cd:lower(foreign['foreignModel']['bean']['alias'])}Link.setAttribute('disabled',true);
</c:forEach></c:forEach>		}
		if(code&0x0100==0x0100)
			if(<c:choose><c:when test="${model['controller']['auth']['individual']}">(wa||wi)</c:when><c:otherwise>wa</c:otherwise></c:choose>&&select>0)
				deleteButton.setAttribute('disabled',false);
			else
				deleteButton.setAttribute('disabled',true);
		if(code&0x1000==0x1000)
			if(<c:choose><c:when test="${model['controller']['auth']['individual']}">ra||ri</c:when><c:otherwise>ra</c:otherwise></c:choose>)
				queryButton.setAttribute('disabled',false);
			else
				queryButton.setAttribute('disabled',true);
	};
	this.f_auth=function()
	{	this.ra=this.wa=false;
<c:if test="${model['controller']['auth']['individual']}">		this.ri=this.wi=false;
</c:if><c:forEach items="${model['mapper']['referencing']}" var="referencing">		this.ra${cd:lower(referencing['foreignModel']['bean']['alias'])}=this.ri${cd:lower(referencing['foreignModel']['bean']['alias'])}=false;
</c:forEach><c:forEach items="${model['mapper']['referenced']}" var="referenced"><c:forEach items="${referenced['foreign']}" var="foreign">		this.ra${cd:lower(foreign['foreignModel']['bean']['alias'])}=this.ri${cd:lower(foreign['foreignModel']['bean']['alias'])}=false;
</c:forEach></c:forEach>		var dra=new Deferred(),dwa=new Deferred(),d=new Deferred(),d0=new Deferred();
<c:if test="${model['controller']['auth']['individual']}">		var dri=new Deferred(),dwi=new Deferred();
</c:if><c:forEach items="${model['mapper']['referencing']}" var="referencing">		var dra${cd:lower(referencing['foreignModel']['bean']['alias'])}=new Deferred(),dri${cd:lower(referencing['foreignModel']['bean']['alias'])}=new Deferred();
</c:forEach><c:forEach items="${model['mapper']['referenced']}" var="referenced"><c:forEach items="${referenced['foreign']}" var="foreign">		var dra${cd:lower(foreign['foreignModel']['bean']['alias'])}=new Deferred(),dri${cd:lower(foreign['foreignModel']['bean']['alias'])}=new Deferred();
</c:forEach></c:forEach>		var fra=function(){xhr("${model['html']['controllerBase']}${model['controller']['base']}/security",{query:{auth:"${model['controller']['auth']['name']}_ra"},handleAs:"json"}).then(function(){this.ra=true;dra.resolve();},function(){dra.resolve();});return dra.promise;};
		var fwa=function(){xhr("${model['html']['controllerBase']}${model['controller']['base']}/security",{query:{auth:"${model['controller']['auth']['name']}_wa"},handleAs:"json"}).then(function(){this.wa=true;dwa.resolve();},function(){dwa.resolve();});return dwa.promise;};
<c:if test="${model['controller']['auth']['individual']}">		var fri=function(){xhr("${model['html']['controllerBase']}${model['controller']['base']}/security",{query:{auth:"${model['controller']['auth']['name']}_ri"},handleAs:"json"}).then(function(){this.ri=true;dri.resolve();},function(){dri.resolve();});return dri.promise;};
		var fwi=function(){xhr("${model['html']['controllerBase']}${model['controller']['base']}/security",{query:{auth:"${model['controller']['auth']['name']}_wi"},handleAs:"json"}).then(function(){this.wi=true;dwi.resolve();},function(){dwi.resolve();});return dwi.promise;};
</c:if><c:forEach items="${model['mapper']['referencing']}" var="referencing">		var fra${cd:lower(referencing['foreignModel']['bean']['alias'])}=function(){xhr("${model['html']['controllerBase']}/api/base/security",{query:{auth:"${referencing['foreignModel']['controller']['auth']['name']}_ra"},handleAs:"json"}).then(function(){this.ra${cd:lower(referencing['foreignModel']['bean']['alias'])}=true;dra${cd:lower(referencing['foreignModel']['bean']['alias'])}.resolve();},function(){dra${cd:lower(referencing['foreignModel']['bean']['alias'])}.resolve();});return dra${cd:lower(referencing['foreignModel']['bean']['alias'])}.promise;};
		var fri${cd:lower(referencing['foreignModel']['bean']['alias'])}=function(){xhr("${model['html']['controllerBase']}/api/base/security",{query:{auth:"${referencing['foreignModel']['controller']['auth']['name']}_ri"},handleAs:"json"}).then(function(){this.ri${cd:lower(referencing['foreignModel']['bean']['alias'])}=true;dri${cd:lower(referencing['foreignModel']['bean']['alias'])}.resolve();},function(){dri${cd:lower(referencing['foreignModel']['bean']['alias'])}.resolve();});return dri${cd:lower(referencing['foreignModel']['bean']['alias'])}.promise;};
</c:forEach><c:forEach items="${model['mapper']['referenced']}" var="referenced"><c:forEach items="${referenced['foreign']}" var="foreign">		var fra${cd:lower(foreign['foreignModel']['bean']['alias'])}=function(){xhr("${model['html']['controllerBase']}/api/base/security",{query:{auth:"${foreign['foreignModel']['controller']['auth']['name']}_ra"},handleAs:"json"}).then(function(){this.ra${cd:lower(foreign['foreignModel']['bean']['alias'])}=true;dra${cd:lower(foreign['foreignModel']['bean']['alias'])}.resolve();},function(){dra${cd:lower(foreign['foreignModel']['bean']['alias'])}.resolve();});return dra${cd:lower(foreign['foreignModel']['bean']['alias'])}.promise;};
		var fri${cd:lower(foreign['foreignModel']['bean']['alias'])}=function(){xhr("${model['html']['controllerBase']}/api/base/security",{query:{auth:"${foreign['foreignModel']['controller']['auth']['name']}_ri"},handleAs:"json"}).then(function(){this.ri${cd:lower(foreign['foreignModel']['bean']['alias'])}=true;dri${cd:lower(foreign['foreignModel']['bean']['alias'])}.resolve();},function(){dri${cd:lower(foreign['foreignModel']['bean']['alias'])}.resolve();});return dri${cd:lower(foreign['foreignModel']['bean']['alias'])}.promise;};
</c:forEach></c:forEach><c:choose><c:when test="${model['controller']['auth']['individual']}">		d0.promise<c:forEach items="${model['mapper']['referencing']}" var="referencing">.then(fra${cd:lower(referencing['foreignModel']['bean']['alias'])}).then(function(){if(!ra${cd:lower(referencing['foreignModel']['bean']['alias'])})return fri${cd:lower(referencing['foreignModel']['bean']['alias'])}();})</c:forEach><c:forEach items="${model['mapper']['referenced']}" var="referenced"><c:forEach items="${referenced['foreign']}" var="foreign">.then(fra${cd:lower(foreign['foreignModel']['bean']['alias'])}).then(function(){if(!ra${cd:lower(foreign['foreignModel']['bean']['alias'])})return fri${cd:lower(foreign['foreignModel']['bean']['alias'])}();})</c:forEach></c:forEach>.then(fra).then(function(){if(!ra)return fri();}).then(fwa).then(function(){if(!wa)return fwi();}).then(function(){d.resolve();});
</c:when><c:otherwise>		d0.promise<c:forEach items="${model['mapper']['referencing']}" var="referencing">.then(fra${cd:lower(referencing['foreignModel']['bean']['alias'])}).then(function(){if(!ra${cd:lower(referencing['foreignModel']['bean']['alias'])})return fri${cd:lower(referencing['foreignModel']['bean']['alias'])}();})</c:forEach><c:forEach items="${model['mapper']['referenced']}" var="referenced"><c:forEach items="${referenced['foreign']}" var="foreign">.then(fra${cd:lower(foreign['foreignModel']['bean']['alias'])}).then(function(){if(!ra${cd:lower(foreign['foreignModel']['bean']['alias'])})return fri${cd:lower(foreign['foreignModel']['bean']['alias'])}();})</c:forEach></c:forEach>.then(fra).then(fwa).then(function(){d.resolve();});
</c:otherwise></c:choose>		d0.resolve();
		return d;
	}
	this.f_filterSearch=function()
	{	var search=window.location.search;
		if(search!="")
		{	var searchObj=ioQuery.queryToObject(search.substring(search.indexOf("?")+1,search.length));
			var filterObj={type:"all",conditions:[]};
			for(var prop in searchObj)
			{	filterObj.conditions.push({colId:prop,condition:"equal",value:searchObj[prop],type:"Text"});
			}
			grid.filterBar.applyFilter(filterObj);
		}
	};
	this._f_recCheckDelete=function(deferred,items,i)
	{	if(items.length>i)
		{	xhr.del("${model['html']['controllerBase']}${model['controller']['checkPath']}"+"/"+items[i],{handleAs:"json"}).then(function(data)
			{	_f_recCheckDelete(deferred,items,i+1);
			},function(data)
			{	var d=data.response.data,status=data.response.status;
				msgAreaDelete_messages.put({group:"delete",level:"error",msgId:items[i]},{msg:Message[status]+"："+${cd:join(cd:format1('grid.row(items[i]).data().%s',model['bean']['desc']),'+" "+')},targetNode:null});
				_f_recCheckDelete(deferred,items,i+1);
			});
		}
		else
		{	deferred.resolve(null);
		}
	};
});