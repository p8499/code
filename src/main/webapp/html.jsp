<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %><%@ page import="java.util.*" %><%@ page trimDirectiveWhitespaces="false"%><%@ page isELIgnored="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%@ taglib uri="/WEB-INF/cd.tld" prefix="cd"%><c:set scope="request" var="model" value="${applicationScope[param['model']]}"/><c:set var="ids" value="${cd:draw(cd:union(model['bean']['key'],model['bean']['field']),'id')}"/><c:set var="fieldIds" value="${cd:draw(model['bean']['field'],'id')}"/><!DOCTYPE html>
<html><c:set var="pagMsg" value="${'${2}-${3}/${0}, ${1}'}"></c:set>
	<head>
		<meta charset="utf-8">
		<title>${model['bean']['name']}</title>
		<style type="text/css">
			@import "${model['html']['dojoBase']}/dijit/themes/claro/claro.css";
			@import "${model['html']['dojoBase']}/dijit/themes/claro/document.css";
			@import "${model['html']['dojoBase']}/gridx/resources/claro/Gridx.css";
			@import "${model['html']['dojoBase']}/lang/widget/style/MessageArea.css";
			@import "${model['html']['css']}";
		</style>
	</head>
	<body class="claro">
		<div id="loading"><div id="loadingMsg">Loading...</div></div>
		<div id="msgArea" data-dojo-type="lang/widget/MessageArea" data-dojo-id="msgArea" data-dojo-props="messages:msgArea_messages"></div>
		<button id="queryButton" data-dojo-type="dijit/form/Button" data-dojo-id="queryButton" data-dojo-props="iconClass:'dijitIcon dijitIconSearch'" type="button" disabled="disabled">
			查詢
			<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
				grid.model.clearCache();
				grid.body.refresh();
			</script>
		</button>
		<button id="addButton" data-dojo-type="dijit/form/Button" data-dojo-id="addButton" data-dojo-props="iconClass:'dijitIcon dijitIconFile'" type="button" disabled="disabled">
			新增
			<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
				f_prepareAdd();
			</script>
		</button>
		<button id="updateButton" data-dojo-type="dijit/form/Button" data-dojo-id="updateButton" data-dojo-props="iconClass:'dijitIcon dijitIconEdit'" type="button" disabled="disabled">
			修改
			<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
				f_prepareUpdate(grid.select.row.getSelected()[0]);
			</script>
		</button>
		<button id="deleteButton" data-dojo-type="dijit/form/Button" data-dojo-id="deleteButton" data-dojo-props="iconClass:'dijitIcon dijitIconDelete'" type="button" disabled="disabled">
			刪除
			<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
				f_checkDelete(grid.select.row.getSelected());
			</script>
		</button>
<c:forEach items="${model['mapper']['referencing']}" var="referencing">		<button id="${cd:lower(referencing['foreignModel']['bean']['alias'])}Link" data-dojo-type="dijit/form/Button" data-dojo-id="${cd:lower(referencing['foreignModel']['bean']['alias'])}Link" data-dojo-props="iconClass:'dijitIcon dijitIconFolderClosed'" type="button" disabled="disabled">
			${referencing['foreignModel']['bean']['name']}
			<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
				window.location="${referencing['foreignModel']['html']['html']}?"${cd:join(cd:format2('+"%s="+grid.row(grid.select.row.getSelected()).data().%s',referencing['foreign'],referencing['domestic']),'')};
			</script>
		</button>
</c:forEach><c:forEach items="${model['mapper']['referenced']}" var="referenced"><c:forEach items="${referenced['foreign']}" var="foreign">		<button id="${cd:lower(foreign['foreignModel']['bean']['alias'])}Link" data-dojo-type="dijit/form/Button" data-dojo-id="${cd:lower(foreign['foreignModel']['bean']['alias'])}Link" data-dojo-props="iconClass:'dijitIcon dijitIconFolderOpen'" type="button" disabled="disabled">
			${foreign['foreignModel']['bean']['name']}
			<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
				window.location="${foreign['foreignModel']['html']['html']}?"${cd:join(cd:format2('+"%s="+grid.row(grid.select.row.getSelected()).data().%s',foreign['foreign'],referenced['domestic']),'')};
			</script>
		</button>
</c:forEach></c:forEach>		<div id="grid" data-dojo-type="gridx/Grid" data-dojo-id="grid" data-dojo-props="
			cacheClass:'gridx/core/model/cache/Async',
			structure:grid_structure,
			store:grid_store,
			autoWidth:true,
			autoHeight:true,
			modules:[
				'gridx/modules/HScroller',
				'gridx/modules/VScroller',
				'gridx/modules/ColumnResizer',
				'gridx/modules/RowHeader',
				'gridx/modules/select/Row',
				'gridx/modules/IndirectSelect',
				'gridx/modules/Filter',
				{moduleClass:'gridx/modules/filter/FilterBar',closeButton:false},
				'gridx/modules/filter/QuickFilter',
				'gridx/modules/NestedSort',
				'gridx/modules/Pagination',
				'gridx/modules/pagination/PaginationBar'],
			paginationBarMessage:'${pagMsg} Selected',
			sortInitialOrder:[<c:forEach items="${model['html']['sort']}" var="sort" varStatus="status">{colId:'${sort['id']}',<c:choose><c:when test="${sort['order']=='asc'}">descending:false</c:when><c:when test="${sort['order']=='desc'}">descending:true</c:when></c:choose>}<c:if test="${!status.last}">,</c:if></c:forEach>],
			filterServerMode:true,
			filterSetupQuery:grid_filterSetupQuery">
		</div>
		<div id="addDialog" title="新增" data-dojo-type="dijit/Dialog" data-dojo-id="addDialog" data-dojo-props="closable:false">
			<form id="addForm" data-dojo-type="dijit/form/Form" data-dojo-id="addForm">
				<div class="dijitDialogPaneContentArea">
					<div id="msgAreaAdd" data-dojo-type="lang/widget/MessageArea" data-dojo-id="msgAreaAdd" data-dojo-props="messages:msgAreaAdd_messages"></div>
					<table>
<c:if test="${!model['bean']['key']['auto']}">						<tr><c:set var="_referencing" value="${cd:seml(model['bean']['key']['id'],model['mapper']['referencing'],'domestic')}"/>
							<td><label for="${model['bean']['key']['id']}">${model['bean']['key']['name']}</label></td>
							<td>
<c:choose><c:when test="${model['bean']['key']['dojoType']=='dijit/form/TextBox'||model['bean']['key']['dojoType']=='dijit/form/NumberTextBox'||model['bean']['key']['dojoType']=='dijit/form/Textarea'}">								<input id="add_${model['bean']['key']['id']}" name="${model['bean']['key']['id']}" type="text" data-dojo-type="${model['bean']['key']['dojoType']}" data-dojo-id="add_${model['bean']['key']['id']}" required="required" <c:if test="${model['bean']['key']['scale']>0}">constraints="{pattern:'${cd:rept('0',model['bean']['key']['length']-model['bean']['key']['scale']-1)}.${cd:rept('0',model['bean']['key']['scale'])}'}" </c:if>maxlength="${model['bean']['key']['length']}"/>
</c:when><c:when test="${model['bean']['key']['dojoType']=='dijit/form/DateTextBox'}">								<input id="add_${model['bean']['key']['id']}" name="${model['bean']['key']['id']}" type="text" data-dojo-type="${model['bean']['key']['dojoType']}" data-dojo-props="constraints:{datePattern:'yyyy-MM-dd'}" data-dojo-id="add_${model['bean']['key']['id']}" required="required" maxlength="${model['bean']['key']['length']}" <c:if test="${model['bean']['key']['special']['type']=='created'||model['bean']['key']['special']['type']=='updated'}">readonly="readonly"</c:if>/>
</c:when><c:when test="${model['bean']['key']['dojoType']=='dijit/form/TimeTextBox'}">								<input id="add_${model['bean']['key']['id']}" name="${model['bean']['key']['id']}" type="text" data-dojo-type="${model['bean']['key']['dojoType']}" data-dojo-props="constraints:{timePattern:'HH:mm:ss'}" data-dojo-id="add_${model['bean']['key']['id']}" required="required" maxlength="${model['bean']['key']['length']}" <c:if test="${model['bean']['key']['special']['type']=='created'||model['bean']['key']['special']['type']=='updated'}">readonly="readonly"</c:if>/>
</c:when><c:when test="${model['bean']['key']['dojoType']=='dijit/form/Select'}">								<select id="add_${model['bean']['key']['id']}" name="${model['bean']['key']['id']}" data-dojo-type="${model['bean']['key']['dojoType']}" data-dojo-id="add_${model['bean']['key']['id']}" required="required">
<c:forEach items="${model['bean']['key']['in']}" var="in">									<option value="${in['value']}" <c:if test="${in['value']==model['bean']['key']['default']}">selected="selected"</c:if>>${in['desc']}</option>
</c:forEach>								</select>
</c:when><c:otherwise>
</c:otherwise></c:choose>							</td>
<c:if test="${!empty _referencing}">							<td><a id="add_${model['bean']['key']['id']}Assist" class="assist" href="#" onclick="f_assistBegin([${cd:join(cd:format1('add_%s',_referencing['domestic']),',')}],[${cd:join(cd:format1('\'%s\'',_referencing['foreign']),',')}],${_referencing['alias']}Dialog,${_referencing['alias']}Grid)" onmouseover="this.style.background='url(img/assistmo.gif)'" onmouseout="this.style.background='url(img/assist.gif)'"></a></td>
</c:if><c:if test="${model['bean']['key']['special']['type']=='password'}"><td><a class="encrypt" href="#" onclick="f_encrypt(add_${model['bean']['key']['id']})" onmouseover="this.style.background='url(img/encryptmo.bmp)'" onmouseout="this.style.background='url(img/encrypt.bmp)'"></a></td>
</c:if>						</tr>
</c:if><c:forEach items="${model['bean']['field']}" var="field"><c:if test="${field['special']['type']!='virtual'}">						<tr><c:set var="_referencing" value="${cd:seml(field['id'],model['mapper']['referencing'],'domestic')}"/>
							<td><label for="${field['id']}">${field['name']}</label></td>
							<td>
<c:choose><c:when test="${field['dojoType']=='dijit/form/TextBox'||field['dojoType']=='dijit/form/NumberTextBox'||field['dojoType']=='dijit/form/Textarea'}">								<input id="add_${field['id']}" name="${field['id']}" type="text" data-dojo-type="${field['dojoType']}" data-dojo-id="add_${field['id']}" <c:if test="${field['special']['type']!='next'&&field['special']['type']!='cache'}">required="required" </c:if><c:if test="${field['scale']>0}">constraints="{pattern:'${cd:rept('0',field['length']-field['scale']-1)}.${cd:rept('0',field['scale'])}'}" </c:if>maxlength="${field['length']}"/>
</c:when><c:when test="${field['dojoType']=='dijit/form/DateTextBox'}">								<input id="add_${field['id']}" name="${field['id']}" type="text" data-dojo-type="${field['dojoType']}" data-dojo-props="constraints:{datePattern:'yyyy-MM-dd'}" data-dojo-id="add_${field['id']}" <c:if test="${field['special']['type']!='cache'}">required="required" </c:if>maxlength="${field['length']}" <c:if test="${field['special']['type']=='created'||field['special']['type']=='updated'}">readonly="readonly"</c:if>/>
</c:when><c:when test="${field['dojoType']=='dijit/form/TimeTextBox'}">								<input id="add_${field['id']}" name="${field['id']}" type="text" data-dojo-type="${field['dojoType']}" data-dojo-props="constraints:{timePattern:'HH:mm:ss'}" data-dojo-id="add_${field['id']}" <c:if test="${field['special']['type']!='cache'}">required="required" </c:if>maxlength="${field['length']}" <c:if test="${field['special']['type']=='created'||field['special']['type']=='updated'}">readonly="readonly"</c:if>/>
</c:when><c:when test="${field['dojoType']=='dijit/form/Select'}">								<select id="add_${field['id']}" name="${field['id']}" data-dojo-type="${field['dojoType']}" data-dojo-id="add_${field['id']}" <c:if test="${field['special']['type']!='cache'}">required="required"</c:if>">
<c:forEach items="${field['in']}" var="in">									<option value="${in['value']}" <c:if test="${in['value']==field['default']}">selected="selected"</c:if>>${in['desc']}</option>
</c:forEach>								</select>
</c:when><c:otherwise>
</c:otherwise></c:choose>							</td>
<c:if test="${!empty _referencing}">							<td><a id="add_${field['id']}Assist" class="assist" href="#" onclick="f_assistBegin([${cd:join(cd:format1('add_%s',_referencing['domestic']),',')}],[${cd:join(cd:format1('\'%s\'',_referencing['foreign']),',')}],${_referencing['alias']}Dialog,${_referencing['alias']}Grid)" onmouseover="this.style.background='url(img/assistmo.gif)'" onmouseout="this.style.background='url(img/assist.gif)'"></a></td>
</c:if><c:if test="${field['special']['type']=='password'}"><td><a class="encrypt" href="#" onclick="f_encrypt(add_${field['id']})" onmouseover="this.style.background='url(img/encryptmo.bmp)'" onmouseout="this.style.background='url(img/encrypt.bmp)'"></a></td>
</c:if>						</tr>
</c:if></c:forEach>					</table>
				</div>
				<div class="dijitDialogPaneActionBar">
					<button id="addSubmit" type="submit" data-dojo-type="dijit/form/Button" data-dojo-id="addSubmit" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconSave'">確定</button>
					<button id="addCancel" type="button" data-dojo-type="dijit/form/Button" data-dojo-id="addCancel" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconCancel'">
						取消
						<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
							addDialog.hide();
						</script>
					</button>
				</div>
				<script type="dojo/on" data-dojo-event="submit" data-dojo-args="evt">
					evt.preventDefault();
					if(this.validate()){f_checkAdd().then(f_processAdd);}
				</script>
			</form>
		</div>
		<div id="updateDialog" title="修改" data-dojo-type="dijit/Dialog" data-dojo-id="updateDialog" data-dojo-props="closable:false">
			<form id="updateForm" data-dojo-type="dijit/form/Form" data-dojo-id="updateForm">
				<div class="dijitDialogPaneContentArea">
					<div id="msgAreaUpdate" data-dojo-type="lang/widget/MessageArea" data-dojo-id="msgAreaUpdate" data-dojo-props="messages:msgAreaUpdate_messages"></div>
					<table>
						<tr><c:set var="_referencing" value="${cd:seml(model['bean']['key']['id'],model['mapper']['referencing'],'domestic')}"/>
							<td><label for="${model['bean']['key']['id']}">${model['bean']['key']['name']}</label></td>
							<td><input id="update_${model['bean']['key']['id']}" name="${model['bean']['key']['id']}" type="text" data-dojo-type="${model['bean']['key']['dojoType']}" data-dojo-id="update_${model['bean']['key']['id']}" required="required" <c:if test="${model['bean']['key']['scale']>0}">constraints="{pattern:'${cd:rept('0',model['bean']['key']['length']-model['bean']['key']['scale']-1)}.${cd:rept('0',model['bean']['key']['scale'])}'}" </c:if>maxlength="${model['bean']['key']['length']}" readonly="readonly"/></td>
						</tr>
<c:forEach items="${model['bean']['field']}" var="field"><c:if test="${field['special']['type']!='virtual'}">						<tr><c:set var="_referencing" value="${cd:seml(field['id'],model['mapper']['referencing'],'domestic')}"/>
							<td><label for="${field['id']}">${field['name']}</label></td>
							<td>
<c:choose><c:when test="${field['dojoType']=='dijit/form/TextBox'||field['dojoType']=='dijit/form/NumberTextBox'||field['dojoType']=='dijit/form/Textarea'}">								<input id="update_${field['id']}" name="${field['id']}" type="text" data-dojo-type="${field['dojoType']}" data-dojo-id="update_${field['id']}" <c:if test="${field['special']['type']!='cache'}">required="required" </c:if><c:if test="${field['scale']>0}">constraints="{pattern:'${cd:rept('0',field['length']-field['scale']-1)}.${cd:rept('0',field['scale'])}'}" </c:if>maxlength="${field['length']}"/>
</c:when><c:when test="${field['dojoType']=='dijit/form/DateTextBox'}">								<input id="update_${field['id']}" name="${field['id']}" type="text" data-dojo-type="${field['dojoType']}" data-dojo-props="constraints:{datePattern:'yyyy-MM-dd'}" data-dojo-id="update_${field['id']}" <c:if test="${field['special']['type']!='cache'}">required="required" </c:if>maxlength="${field['length']}" <c:if test="${field['special']['type']=='created'||field['special']['type']=='updated'}">readonly="readonly"</c:if>/>
</c:when><c:when test="${field['dojoType']=='dijit/form/TimeTextBox'}">								<input id="update_${field['id']}" name="${field['id']}" type="text" data-dojo-type="${field['dojoType']}" data-dojo-props="constraints:{timePattern:'HH:mm:ss'}" data-dojo-id="update_${field['id']}" <c:if test="${field['special']['type']!='cache'}">required="required" </c:if>maxlength="${field['length']}" <c:if test="${field['special']['type']=='created'||field['special']['type']=='updated'}">readonly="readonly"</c:if>/>
</c:when><c:when test="${field['dojoType']=='dijit/form/Select'}">								<select id="update_${field['id']}" name="${field['id']}" data-dojo-type="${field['dojoType']}" data-dojo-id="update_${field['id']}" <c:if test="${field['special']['type']!='cache'}">required="required"</c:if>>
<c:forEach items="${field['in']}" var="in">									<option value="${in['value']}" <c:if test="${in['value']==field['default']}">selected="selected"</c:if>>${in['desc']}</option>
</c:forEach>								</select>
</c:when><c:otherwise>
</c:otherwise></c:choose>							</td>
<c:if test="${!empty _referencing}">							<td><a id="update_${field['id']}Assist" class="assist" href="#" onclick="f_assistBegin([${cd:join(cd:format1('update_%s',_referencing['domestic']),',')}],[${cd:join(cd:format1('\'%s\'',_referencing['foreign']),',')}],${_referencing['alias']}Dialog,${_referencing['alias']}Grid)" onmouseover="this.style.background='url(img/assistmo.gif)'" onmouseout="this.style.background='url(img/assist.gif)'"></a></td>
</c:if><c:if test="${field['special']['type']=='password'}"><td><a class="encrypt" href="#" onclick="f_encrypt(update_${field['id']})" onmouseover="this.style.background='url(img/encryptmo.bmp)'" onmouseout="this.style.background='url(img/encrypt.bmp)'"></a></td>
</c:if>						</tr>
</c:if></c:forEach>					</table>
				</div>
				<div class="dijitDialogPaneActionBar">
					<button id="updateSubmit" type="submit" data-dojo-type="dijit/form/Button" data-dojo-id="updateSubmit" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconSave'">確定</button>
					<button id="updateCancel" type="button" data-dojo-type="dijit/form/Button" data-dojo-id="updateCancel" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconCancel'">
						取消
						<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
							f_cancelUpdate();
						</script>
					</button>
				</div>
				<script type="dojo/on" data-dojo-event="submit" data-dojo-args="evt">
					evt.preventDefault();
					if(this.validate()){f_checkUpdate().then(f_processUpdate);}
				</script>
			</form>
		</div>
		<div id="deleteDialog" title="刪除" data-dojo-type="dijit/Dialog" data-dojo-id="deleteDialog" data-dojo-props="closable:false">
			<div class="dijitDialogPaneContentArea">
				<div id="msgAreaDelete" data-dojo-type="lang/widget/MessageArea" data-dojo-id="msgAreaDelete" data-dojo-props="messages:msgAreaDelete_messages"></div>
				確定刪除<span id="deleteTip"></span>條記錄？
			</div>
			<div class="dijitDialogPaneActionBar">
				<button id="excludeButton" type="button" data-dojo-type="dijit/form/Button" data-dojo-id="excludeButton" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconUndo'">
					排除
					<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
						f_deselect(msgAreaDelete_messages);
						f_checkDelete(grid.select.row.getSelected());
					</script>
				</button>
				<button id="deleteSubmitButton" type="button" data-dojo-type="dijit/form/Button" data-dojo-id="deleteSubmitButton" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconSave'">
					確定
					<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
						f_processDelete();
					</script>
				</button>
				<button id="deleteCancel" type="button" data-dojo-type="dijit/form/Button" data-dojo-id="deleteCancel" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconCancel'">
					取消
					<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
						deleteDialog.hide();
					</script>
				</button>
			</div>
		</div>
		<div id="prepareDialog" title="準備" data-dojo-type="dijit/Dialog" data-dojo-id="prepareDialog" data-dojo-props="closable:false">
			<div class="dijitDialogPaneContentArea">
				<div id="msgAreaPrepare" data-dojo-type="lang/widget/MessageArea" data-dojo-id="msgAreaPrepare" data-dojo-props="messages:msgAreaPrepare_messages"></div>
			</div>
			<div class="dijitDialogPaneActionBar">
				<button id="retryUpdateButton" data-dojo-type="dijit/form/Button" data-dojo-id="retryUpdateButton" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconRedo'" type="button">
					重試
					<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
						prepareDialog.hide();f_prepareUpdate(grid.select.row.getSelected()[0]);
					</script>
				</button>
				<button id="prepareCancel" type="button" data-dojo-type="dijit/form/Button" data-dojo-id="prepareCancel" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconCancel'">
					取消
					<script type="dojo/on" data-dojo-event="click" data-dojo-args="evt">
						prepareDialog.hide();
					</script>
				</button>
			</div>
		</div>
<c:forEach items="${model['mapper']['referencing']}" var="referencing">		<div id="${referencing['alias']}Dialog" class="assistDialog" title="選擇" data-dojo-type="dijit/Dialog" data-dojo-id="${referencing['alias']}Dialog" data-dojo-props="closable:true">
			<div id="${referencing['alias']}Grid" class="assistGrid" data-dojo-type="gridx/Grid" data-dojo-id="${referencing['alias']}Grid" data-dojo-props="
				cacheClass:'gridx/core/model/cache/Async',
				structure:${referencing['alias']}Grid_structure,
				store:${referencing['alias']}Grid_store,
				autoHeight:true,
				paginationBarSizes:[10],
				modules:[
					'gridx/modules/HScroller',
					'gridx/modules/VScroller',
					'gridx/modules/ColumnResizer',
					'gridx/modules/RowHeader',
					'gridx/modules/select/Row',
					'gridx/modules/IndirectSelect',
					'gridx/modules/Filter',
					{moduleClass:'gridx/modules/filter/FilterBar',closeButton:false},
					'gridx/modules/filter/QuickFilter',
					'gridx/modules/NestedSort',
					'gridx/modules/Pagination',
					'gridx/modules/pagination/PaginationBar'],
				paginationBarMessage:'${pagMsg} Selected',
				sortInitialOrder:[<c:forEach items="${referencing['foreignModel']['html']['sort']}" var="sort" varStatus="status">{colId:'${sort['id']}',<c:choose><c:when test="${sort['order']=='asc'}">descending:false</c:when><c:when test="${sort['order']=='desc'}">descending:true</c:when></c:choose>}<c:if test="${!status.last}">,</c:if></c:forEach>],
				filterServerMode:true,
				filterSetupQuery:${referencing['alias']}Grid_filterSetupQuery">
			</div>
		</div>
</c:forEach>		<script src="${model['html']['dojoBase']}/dojo/dojo.js" data-dojo-config="async:true,parseOnLoad:true"></script>
		<script src="${model['html']['js']}"></script>
	</body>
</html>