require([
    "dojo/_base/array",
    "dojo/aspect",
    "dojo/dom",
    "dojo/dom-construct",
    "dojo/dom-style",
    "dojo/json",
    "dojo/on",
    "dojo/parser",
    "dojo/ready",
    "dojo/store/Memory",
    "dojo/string",
    "dijit/Dialog",
    "dijit/form/Button",
    "dijit/form/CheckBox",
    "dijit/form/ComboBox",
    "dijit/form/MultiSelect",
    "dijit/form/NumberTextBox",
    "dijit/form/Select",
    "dijit/form/ValidationTextBox",
    "dijit/tree/ObjectStoreModel",
    "dojox/json/query",
    "dojo/domReady!"], function (array, aspect, dom, domConstruct, domStyle, json, on, parser, ready, Memory, string, Dialog, Button, CheckBox, ComboBox, MultiSelect, NumberTextBox, Select, ValidationTextBox, ObjectStoreModel, query) {
    ready(function () {
        on(tree, "click", function (item, node, event) {
            if (tabContainer.selectedChildWidget == tabFields)
                setFields(project, this, tabFields, item);
            else(tabContainer.selectedChildWidget == tabRaw)
            setRaw(project, tabRaw, item);
        });
        on(tabFields, "show", function () {
            if (tree.selectedItems != null && tree.selectedItems.length > 0)
                setFields(project, tree, this, tree.selectedItems[0]);
        });
        on(tabRaw, "show", function () {
            if (tree.selectedItems != null && tree.selectedItems.length > 0)
                setRaw(project, this, tree.selectedItems[0]);
            setRaw(project, this, tree.selectedItems[0]);
        });
        dom.byId("loading").style.display = "none";
    });
    window.build = function (project) {
        var recBuild = function (obj, store, path_id, path, pid, id) {
            if (typeof(id) == "undefined")
                store.push({"id": path_id, "type": "project", "name": obj["name"]});
            else if (id == "envJtee")
                store.push({"id": path_id, "type": "envJtee", "parent": path, "name": "J2EE Environment"});
            else if (id == "envAndroid")
                store.push({"id": path_id, "type": "envAndroid", "parent": path, "name": "Android Environment"});
            else if (id == "modules")
                store.push({"id": path_id, "type": "modules", "parent": path, "name": "Modules"});
            else if (pid == "modules")
                store.push({"id": path_id, "type": "module", "parent": path, "name": obj.description});
            else if (id == "fields")
                store.push({"id": path_id, "type": "fields", "parent": path, "name": "Fields"});
            else if (id == "unique")
                store.push({"id": path_id, "type": "unique", "parent": path, "name": "Unique"});
            if (typeof(obj) == "object")
                for (var p in obj)
                    if (obj.constructor == Object)
                        recBuild(obj[p], store, path_id + "." + p, path_id, id, p);
                    else if (obj.constructor == Array)
                        recBuild(obj[p], store, path_id + "[" + p + "]", path_id, id, p);
        };
        var store = new Array();
        recBuild(project, store, "$");
        return store;
    };
    window.setFields = function (project, tree, pane, item) {
        var parent = function (path) {
            var to1 = path.lastIndexOf("[");
            var to2 = path.lastIndexOf(".");
            var to = to1 > to2 ? to1 : to2;
            return path.substring(0, to);
        };
        var textBox = function (obj, id) {
            var tb = new ValidationTextBox({value: typeof(obj[id]) == "object" ? json.stringify(obj[id]) : obj[id]});
            domStyle.set(tb.domNode, "width", "auto");
            on(tb, "change", function () {
                obj[id] = typeof(obj[id]) == "object" ? json.parse(this.get("value")) : this.get("value");
            });
            return tb;
        };
        var textBoxTreeNode = function (obj, id, path) {
            var tb = textBox(obj, id);
            aspect.after(tb, "onChange", function () {
                tree.getNodesByItem(path)[0].set("label", this.get("value"));
            });
            return tb;
        };
        var textBoxPackage = function (obj, id) {
            var tb = textBox(obj, id);
            tb.set("regExp", "([a-z_]{1}[a-z0-9_]*(\.[a-z_]{1}[a-z0-9_]*)*)");
            tb.set("invalidMessage", "Invalid Package Name");
            return tb;
        };
        var textBoxWebApp = function (obj, id) {
            var tb = textBox(obj, id);
            tb.set("regExp", "^[a-z0-9_-\s]+");
            tb.set("invalidMessage", "Invalid Application Name");
            return tb;
        };
        var textBoxClass = function (obj, id) {
            var tb = textBox(obj, id);
            tb.set("regExp", "[A-Za-z_$]+[a-zA-Z0-9_$]*");
            tb.set("invalidMessage", "Invalid Class Name");
            return tb;
        };
        var textBoxColumnId = function (obj, id) {
            var tb = textBox(obj, id);
            aspect.before(tb, "onChange", function () {
                this.set("value", this.value.toUpperCase().trim());
            });
            return tb;
        };
        var numberBox = function (obj, id) {
            var tb = new NumberTextBox({value: obj[id]});
            domStyle.set(tb.domNode, "width", "auto");
            on(tb, "change", function () {
                obj[id] = this.get("value");
            });
            return tb;
        };
        var checkBox = function (obj, id) {
            var cb = new CheckBox({checked: obj[id]});
            on(cb, "change", function () {
                obj[id] = this.get("checked");
            });
            return cb;
        };
        var checkBoxSerial = function (obj, id, jtype) {
            var cb = checkBox(obj, id);
            if (jtype == "String") {
                cb.set("disabled", true);
            }
            return cb;
        };
        var selectBox = function (obj, id, opt) {
            var cb = new Select({options: opt});
            domStyle.set(cb.domNode, "width", "auto");
            on(cb, "change", function () {
                obj[id] = this.value;
            });
            return cb;
        };
        var multiBox = function (obj, id, opt) {
            var mb = new MultiSelect();
            for (var o in opt) {
                var option = domConstruct.place(domConstruct.toDom(string.substitute("<option value='${a}'>${b}</option>", {
                    a: opt[o].value,
                    b: opt[o].label
                })), mb.containerNode);
                if (opt[o].selected)
                    option.selected = "selected";
            }
            domStyle.set(mb.domNode, "width", "auto");
            on(mb, "change", function () {
                obj[id] = this.value;
            });
            return mb;
        };
        var multiBoxScope = function (fields, special) {
            var opt = new Array();
            for (var f in fields)
                opt.push({
                    value: fields[f].databaseColumn,
                    label: fields[f].description,
                    selected: array.indexOf(special.scope, fields[f].databaseColumn) != -1
                });
            return multiBox(special, "scope", opt);
        };
        var comboBox = function (obj, id, st) {
            var cb = new ComboBox({value: obj[id], store: st, searchAttr: "value"});
            domStyle.set(cb.domNode, "width", "auto");
            on(cb, "change", function () {
                obj[id] = this.value;
            });
            return cb;
        };
        var dialog = function (title) {
            var dg = new Dialog({title: title});
            domStyle.set(dg.domNode, "width", "300px");
            return dg;
        };
        var line = function () {
            var tr = domConstruct.toDom("<tr></tr>");
            return tr;
        };
        var lineProperty = function (label, widget) {
            var tr = line();
            var td1 = domConstruct.place(domConstruct.toDom("<td></td>"), tr);
            domStyle.set(td1, "width", "25%");
            var td2 = domConstruct.place(domConstruct.toDom("<td></td>"), tr);
            domStyle.set(td2, "width", "auto");
            domConstruct.place(domConstruct.toDom(string.substitute("<label>${a}</label>", {a: label})), td1);
            widget.placeAt(td2);
            if (widget.constructor == dijit.form.ValidationTextBox)
                domStyle.set(widget.domNode, "width", "100%");
            return tr;
        };
        var lineFieldHead = function () {
            var tr = line();
            var td1 = domConstruct.place(domConstruct.toDom(string.substitute("<td>${a}</td>", {a: "DB Column"})), tr);
            domStyle.set(td1, "width", "10%");
            var td2 = domConstruct.place(domConstruct.toDom(string.substitute("<td>${a}</td>", {a: "Description"})), tr);
            domStyle.set(td2, "width", "10%");
            var td3 = domConstruct.place(domConstruct.toDom(string.substitute("<td>${a}</td>", {a: "Java Type"})), tr);
            domStyle.set(td3, "width", "15%");
            var td4 = domConstruct.place(domConstruct.toDom(string.substitute("<td>${a}</td>", {a: "Dojo Type"})), tr);
            domStyle.set(td4, "width", "15%");
            var td5 = domConstruct.place(domConstruct.toDom(string.substitute("<td>${a}</td>", {a: "Format"})), tr);
            domStyle.set(td5, "width", "20%");
            var td6 = domConstruct.place(domConstruct.toDom(string.substitute("<td>${a}</td>", {a: "Length"})), tr);
            domStyle.set(td6, "width", "10%");
            var td7 = domConstruct.place(domConstruct.toDom(string.substitute("<td>${a}</td>", {a: "Special"})), tr);
            domStyle.set(td7, "width", "10%");
            var td7 = domConstruct.place(domConstruct.toDom(string.substitute("<td>${a}</td>", {a: "Instru"})), tr);
            domStyle.set(td7, "width", "10%");
            return tr;
        };
        var lineField = function (obj, path) {
            var tr = line();
            var td1 = domConstruct.place(domConstruct.toDom("<td></td>"), tr);
            var tbColumnId = textBoxColumnId(obj, "databaseColumn").placeAt(td1);
            var td2 = domConstruct.place(domConstruct.toDom("<td></td>"), tr);
            var tbDescription = textBox(obj, "description").placeAt(td2);
            var td3 = domConstruct.place(domConstruct.toDom("<td></td>"), tr);
            var cbJavaType = selectBox(obj, "javaType", [{
                value: "String",
                label: "java.lang.String",
                selected: obj.javaType == "String"
            }, {value: "Integer", label: "java.lang.Integer", selected: obj.javaType == "Integer"}, {
                value: "Double",
                label: "java.lang.Double",
                selected: obj.javaType == "Double"
            }, {
                value: "java.util.Date",
                label: "java.util.Date",
                selected: obj.javaType == "java.util.Date"
            }]).placeAt(td3);
            var td4 = domConstruct.place(domConstruct.toDom("<td></td>"), tr);
            var cbDojoType = selectBox(obj, "dojoType", []).placeAt(td4);
            var td5 = domConstruct.place(domConstruct.toDom("<td></td>"), tr);
            var cbFormat = comboBox(obj, "format", new Memory({data: []})).placeAt(td5);
            var td6 = domConstruct.place(domConstruct.toDom("<td></td>"), tr);
            var tbLength = numberBox(obj, "length").placeAt(td6);
            var td7 = domConstruct.place(domConstruct.toDom("<td></td>"), tr);
            var cbSpecial = selectBox(obj.special, "type", []).placeAt(td7);
            var td8 = domConstruct.place(domConstruct.toDom("<td></td>"), tr);
            var btEdit = new Button({label: "Edit"}).placeAt(td8);
            var dgSpecial = dialog("Special Instruction");
            on(btEdit, "click", function (event) {
                domConstruct.place(tableSpecial(project, obj.special, path + ".special"), dgSpecial.containerNode, "only");
                dgSpecial.show();
            });
            aspect.after(cbSpecial, "onChange", function () {
                if (cbSpecial.get("value") == "key") {
                    btEdit.set("disabled", false);
                    for (var p in obj.special) {
                        if (p != "type" && p != "serial")
                            delete obj.special[p];
                    }
                }
                else if (cbSpecial.get("value") == "next") {
                    btEdit.set("disabled", false);
                    for (var p in obj.special) {
                        if (p != "type" && p != "step" && p != "scope")
                            delete obj.special[p];
                    }
                }
                else {
                    btEdit.set("disabled", true);
                    for (var p in obj.special) {
                        if (p != "type")
                            delete obj.special[p];
                    }
                }
            });
            aspect.after(cbDojoType, "onChange", function () {
                if (cbDojoType.get("value") == "DateTextBox") {
                    cbFormat.set("store", new Memory({data: [{value: "yyyy-MM-dd"}, {value: "MM/dd/yyyy"}]}));
                    cbFormat.set("value", obj.format);
                }
                else if (cbDojoType.get("value") == ".DateTimeTextBox") {
                    cbFormat.set("store", new Memory({data: [{value: "yyyy-MM-dd hh24:mm:ss"}, {value: "MM/dd/yyyy hh24:mm:ss"}]}));
                    cbFormat.set("value", obj.format);
                }
                else {
                    cbFormat.set("store", new Memory({data: [{value: ""}]}));
                    cbFormat.set("value", obj.format);
                }
            });
            aspect.after(cbJavaType, "onChange", function () {
                if (cbJavaType.get("value") == "String") {
                    cbDojoType.set("options", [{value: "TextBox", label: "TextBox"}, {
                        value: "Textarea",
                        label: "Textarea"
                    }, {value: "Select", label: "Select"}]);
                    cbDojoType.set("value", obj.dojoType);
                    cbDojoType.onChange();
                    cbSpecial.set("options", [{
                        value: "none",
                        label: "None",
                        selected: obj.special.type == "none"
                    }, {value: "key", label: "Key", selected: obj.special.type == "key"}, {
                        value: "password",
                        label: "Password",
                        selected: obj.special.type == "password"
                    }, {value: "view", label: "View", selected: obj.special.type == "view"}]);
                    cbSpecial.set("value", obj.special.type);
                    cbSpecial.onChange();
                    tbLength.set("disabled", false);
                }
                else if (cbJavaType.get("value") == "Integer") {
                    cbDojoType.set("options", [{value: "NumberTextBox", label: "NumberTextBox"}, {
                        value: "Select",
                        label: "Select"
                    }]);
                    cbDojoType.set("value", obj.dojoType);
                    cbDojoType.onChange();
                    cbSpecial.set("options", [{
                        value: "none",
                        label: "None",
                        selected: obj.special.type == "none"
                    }, {value: "key", label: "Key", selected: obj.special.type == "key"}, {
                        value: "next",
                        label: "Next",
                        selected: obj.special.type == "next"
                    }, {value: "view", label: "View", selected: obj.special.type == "view"}]);
                    cbSpecial.set("value", obj.special.type);
                    cbSpecial.onChange();
                    tbLength.set("disabled", false);
                }
                else if (cbJavaType.get("value") == "Double") {
                    cbDojoType.set("options", [{value: "NumberTextBox", label: "NumberTextBox"}, {
                        value: "Select",
                        label: "Select"
                    }]);
                    cbDojoType.set("value", obj.dojoType);
                    cbDojoType.onChange();
                    cbSpecial.set("options", [{
                        value: "none",
                        label: "None",
                        selected: obj.special.type == "none"
                    }, {value: "view", label: "View", selected: obj.special.type == "view"}]);
                    cbSpecial.set("value", obj.special.type);
                    cbSpecial.onChange();
                    tbLength.set("disabled", false);
                }
                else if (cbJavaType.get("value") == "java.util.Date") {
                    cbDojoType.set("options", [{value: "DateTextBox", label: "DateTextBox"}, {
                        value: ".DateTimeTextBox",
                        label: "DateTimeTextBox"
                    }]);
                    cbDojoType.set("value", obj.dojoType);
                    cbDojoType.onChange();
                    cbSpecial.set("options", [{
                        value: "none",
                        label: "None",
                        selected: obj.special.type == "none"
                    }, {value: "created", label: "Created", selected: obj.special.type == "created"}, {
                        value: "update",
                        label: "Updated",
                        selected: obj.special.type == "updated"
                    }, {value: "view", label: "View", selected: obj.special.type == "view"}]);
                    cbSpecial.set("value", obj.special.type);
                    cbSpecial.onChange();
                    tbLength.set("disabled", true);
                    tbLength.set("value", 0);
                }
            });
            cbJavaType.set("value", obj.javaType);
            cbJavaType.onChange();
            return tr;
        };
        var table = function () {
            var tbl = domConstruct.toDom("<table class='data'></table>");
            domStyle.set(tbl, "width", "100%");
            return tbl;
        };
        var tableProject = function (obj, path) {
            var tbl = table();
            domConstruct.place(lineProperty("Project Name", textBoxTreeNode(obj, "name", path)), tbl);
            return tbl;
        };
        var tableEnvJtee = function (obj) {
            var tbl = table();
            domConstruct.place(lineProperty("Database Type", selectBox(obj, "databaseType", [{
                value: "oracle",
                label: "Oracle",
                selected: obj.dojoType == "oracle"
            }, {value: "mysql", label: "MySQL", selected: obj.dojoType == "mysql"}, {
                value: "postgresql",
                label: "PostgreSQL",
                selected: obj.dojoType == "postgresql"
            }])), tbl);
            domConstruct.place(lineProperty("Application", textBoxWebApp(obj, "app")), tbl);
            domConstruct.place(lineProperty("Package Bean", textBoxPackage(obj, "packageBean")), tbl);
            domConstruct.place(lineProperty("Package Mask", textBoxPackage(obj, "packageMask")), tbl);
            domConstruct.place(lineProperty("Package Mapper", textBoxPackage(obj, "packageMapper")), tbl);
            domConstruct.place(lineProperty("Package Listener", textBoxPackage(obj, "packageListener")), tbl);
            domConstruct.place(lineProperty("Package Controller", textBoxPackage(obj, "packageController")), tbl);
            domConstruct.place(lineProperty("Package Controller Attachment", textBoxPackage(obj, "packageControllerAttachment")), tbl);
            return tbl;
        };
        var tableEnvAndroid = function (obj) {
            var tbl = table();
            domConstruct.place(lineProperty("Package Bean", textBoxPackage(obj, "packageBean")), tbl);
            domConstruct.place(lineProperty("Package Mask", textBoxPackage(obj, "packageMask")), tbl);
            domConstruct.place(lineProperty("Package Stub", textBoxPackage(obj, "packageStub")), tbl);
            return tbl;
        };
        var tableModule = function (obj, path) {
            var tbl = table();
            domConstruct.place(lineProperty("Description", textBoxTreeNode(obj, "description", path)), tbl);
            domConstruct.place(lineProperty("Database Table", textBox(obj, "databaseTable")), tbl);
            domConstruct.place(lineProperty("Database View", textBox(obj, "databaseView")), tbl);
            domConstruct.place(lineProperty("J2EE Bean Alias", textBoxClass(obj, "jteeBeanAlias")), tbl);
            domConstruct.place(lineProperty("J2EE Mask Alias", textBoxClass(obj, "jteeMaskAlias")), tbl);
            domConstruct.place(lineProperty("J2EE Mapper Alias", textBoxClass(obj, "jteeMapperAlias")), tbl);
            domConstruct.place(lineProperty("J2EE Listener Alias", textBoxClass(obj, "jteeListenerAlias")), tbl);
            domConstruct.place(lineProperty("J2EE Controller Alias", textBoxClass(obj, "jteeControllerAlias")), tbl);
            domConstruct.place(lineProperty("J2EE Controller Path", textBox(obj, "jteeControllerPath")), tbl);
            domConstruct.place(lineProperty("J2EE AttachmentController Alias", textBoxClass(obj, "jteeAttachmentControllerAlias")), tbl);
            domConstruct.place(lineProperty("J2EE AttachmentController Path", textBox(obj, "jteeAttachmentControllerPath")), tbl);
            domConstruct.place(lineProperty("Android Bean Alias", textBoxClass(obj, "androidBeanAlias")), tbl);
            domConstruct.place(lineProperty("Android Mask Alias", textBoxClass(obj, "androidMaskAlias")), tbl);
            domConstruct.place(lineProperty("Android Stub Alias", textBoxClass(obj, "androidStubAlias")), tbl);
            return tbl;
        };
        var tableFields = function (obj, path) {
            var tbl = table();
            var th = domConstruct.place(domConstruct.toDom("<thead></thead>"), tbl);
            var tr0 = domConstruct.place(lineFieldHead(), th);
            var trs = domConstruct.place(domConstruct.toDom("<tbody></tbody>"), tbl);
            for (var f in obj)
                domConstruct.place(lineField(obj[f], path + "[" + f + "]"), trs);
            return tbl;
        };
        var tableSpecial = function (project, obj, path) {
            var tbl = table();
            if (obj.type == "key")
                domConstruct.place(lineProperty("Serial", checkBoxSerial(obj, "serial", query(parent(path), project).javaType)), tbl);
            else if (obj.type == "next") {
                domConstruct.place(lineProperty("Step", numberBox(obj, "step")), tbl);
                domConstruct.place(lineProperty("Scope", multiBoxScope(query(parent(parent(path)), project), obj)), tbl);
            }
            return tbl;
        };
        if (item.type == "project") {
            domConstruct.place(tableProject(query(item.id, project), item.id), pane.domNode, "only");
        }
        else if (item.type == "envJtee") {
            domConstruct.place(tableEnvJtee(query(item.id, project)), pane.domNode, "only");
        }
        else if (item.type == "envAndroid") {
            domConstruct.place(tableEnvAndroid(query(item.id, project)), pane.domNode, "only");
        }
        else if (item.type == "module") {
            domConstruct.place(tableModule(query(item.id, project), item.id), pane.domNode, "only");
        }
        else if (item.type == "fields") {
            domConstruct.place(tableFields(query(item.id, project), item.id), pane.domNode, "only");
        }
        else {
            domConstruct.place(domConstruct.toDom("<table></table>"), pane.domNode, "only");
        }
    };
    window.setRaw = function (project, pane, item) {
        var pre = domConstruct.place(domConstruct.toDom("<pre></pre>"), pane.domNode, "only");
        pre.innerHTML = json.stringify(query(item.id, project), undefined, 4)
    };
    window.project = json.parse('{"name":"MyProject","envJtee":{"databaseType":"postgresql","app":"myapp","packageBean":"mypack.bean","packageMask":"mypack.mask","packageMapper":"mypack.mapper","packageListener":"mypack.listener","packageController":"mypack.controller","packageControllerAttachment":"mypack.controller"},"envAndroid":{"packageBean":"mypack.bean","packageMask":"mypack.mask","packageStub":"mypack.stub"},"modules":[{"description":"語言","databaseTable":"public.F1010","databaseView":"public.F1010","jteeBeanAlias":"Language","jteeMaskAlias":"LanguageMask","jteeMapperAlias":"LanguageMapper","jteeListenerAlias":"LanguageListener","jteeControllerAlias":"LanguageListener","jteeControllerPath":"/api/language","jteeAttachmentControllerAlias":"LanguageAttachmentController","jteeAttachmentControllerPath":"/api/language_attachment","androidBeanAlias":"Language","androidMaskAlias":"LanguageMask","androidStubAlias":"LanguageStub","fields":[{"databaseColumn":"LSID","description":"語言編碼","javaType":"String","dojoType":"dijit/form/TextBox","format":"","length":16,"special":{"type":"key","serial":false}},{"databaseColumn":"LSNAME","description":"語言名稱","javaType":"java.util.Date","dojoType":"DateTimeTextBox","format":"yyyy/MM/dd","length":0,"special":{"type":"next","scope":["TAAA","TABB"],"step":1}}],"unique":[["LSID"],["LSID","LSNAME"]]}]}');
    window.treeStore = new Memory({
        data: build(project), getChildren: function (object) {
            return this.query({parent: object.id});
        }
    });
    window.treeModel = new ObjectStoreModel({store: treeStore, query: {id: '$'}});
});