function $UEA(uaa,x) { return (x in uaa)?uaa[x]:""; }

function getUEattrs(attrstr) {
	var attra = new Array();
	var reta = new Array();
	if ($.trim(attrstr)!="") {
		attra = attrstr.split(',');
		for (var i=0; i<attra.length; i++) {
			var a = attra[i].split(':');
			switch (a[0]) {
				case "tool": reta["tool"] = a[1]; break;
				case "styleset": reta["styleset"]=a[1]; break;
			    case "css": reta["css"] = "/Content/cms/" + a[1] + ".css"; break;
			}			
		}
	}	
	return reta;
}

function getUEtool(uaa) {
	var t = $UEA(uaa,"tool");
	if (t=="") { t="default"; }
	var toolsets = new Array();
	toolsets["mini"] =  [	['bold', 'italic', 'underline', 'superscript','link','unlink','attachment','|', 
							'removeformat', 'pasteplain', 'source', 'undo', 'redo', 'fullscreen']
						];
	toolsets["default"] = [ 
		['bold', 'italic', 'underline', 'superscript','link','unlink','|',  //'customstyle',--use own plugin
		 'justifyleft','justifyright','justifycenter','justifyjustify','|', 		 
		 'horizontal','insertorderedlist', 'insertunorderedlist','|',
		 'imagenone','imageleft','imageright','imagecenter','insertimage','|', //,'simpleupload'--single im		 
		  /*], [*/ 
		  'insertrow','insertcol','deleterow','deletecol','mergecells','splittocells','deletetable','|',
		  'removeformat', 'source', 'undo', 'redo', 'fullscreen', //'pasteplain',
		 ]
	];		
	return toolsets[t];	
}

function getUEstyle(uaa) {
	var s = $UEA(uaa,"styleset");
	if (s=="") { s="default"; }
	var stysets = new Array();
	stysets["default"] = [ 
		{
			tag: 'h1',
			text: 'Header 1',
			classes: '',
			style: 'color: #176548; line-height: normal; margin-bottom: 1%;text-align: left;',
		},
		{
			tag: 'h2',
			text: 'Header 2',
			classes: '',
			style: 'color: #176548; line-height: normal; margin-bottom: 1%;text-align: left;',
		},
		{
			tag: 'span',
			text: 'Small font',
			classes: 'font-s',
			style: '',
		},
		{
			tag: 'span',
			text: 'Green font',
			classes: 'txt-green',
			style: '',
		},
	];	
	return stysets[s];
}

function setUEstyle(ueid,uaa,idx) {
	var s = getUEstyle(uaa);

	UE.registerUI('Stylebox',function(editor,uiName){		
		//render dropdown
		var items = [];
		for (var i=0; i<s.length; i++) {
			items.push({
				label: s[i].text,
				value: i,
				classes: s[i].classes,
				style: s[i].style,
				tag: s[i].tag,
				renderLabelHtml: function () {
					return "<"+this.tag+" class='"+this.classes+"' style='"+this.style+"'>"+(this.label || '')+"</"+this.tag+">";
				}				
			});
		}
		
		var stybox = new UE.ui.Combox({
			editor:editor,
			items:items,
			onselect:function (t, index) {
				var range = editor.selection.getRange();  
				range.select();  
				var sidx=parseInt(this.items[index].value);
				var txt = editor.selection.getText();
				var htm ="<"+s[sidx].tag+" class='"+s[sidx].classes+"' style='"+s[sidx].style+"'>"+txt+"</"+s[sidx].tag+">";
				editor.execCommand('inserthtml',htm);
			},
			title:uiName,
			initValue:uiName
		});
		
		//plugin status upon user action
		editor.addListener('selectionchange', function (type, causeByUi, uiReady) {			
			if (!uiReady) {
				var state = editor.queryCommandState(uiName);
				if (state == -1) {
					stybox.setDisabled(true);
				} else {
					stybox.setDisabled(false);
					var value = editor.queryCommandValue(uiName);
					if(!value){
						stybox.setValue(uiName);
						return;
					}
					//ie下从源码模式切换回来时，字体会带单引号，而且会有逗号
					value && (value = value.replace(/['"]/g, '').split(',')[0]);
					stybox.setValue(value);
				}
			}
		});		
		
		//return dropdown
		return stybox;
	},idx/* index of icon in toolbar*/,ueid);
}

function setUEtable(ueid,uaa,tblname,idx) {
	UE.registerUI(tblname,function(editor,uiName){

		var dialog = new UE.ui.Dialog({
			iframeUrl:U$("uEditor/TableDialog?name="+tblname),
			editor:editor,
			name:uiName,
			title:"New Table",
			cssRules:"width:400px;height:120px;",
			buttons:[
				{
					className:'edui-okbutton',
					label:'OK',
					onclick:function () {
						var htm=E$(dialog.id+"_iframe").contentWindow.getNewTblHtm();
						editor.execCommand('inserthtml',htm);
						dialog.close(true);
					}
				},
				{
					className:'edui-cancelbutton',
					label:'Cancel',
					onclick:function () {
						dialog.close(false);
					}
				}
			]
		});
			
		var icoalt=(uiName=="gen")?"GeneralTable":"NudeTable";
		var btn = new UE.ui.Button({
			//name:'dialogbutton' + uiName,
			//title:'dialogbutton' + uiName,
			name:icoalt,
			title:icoalt,
			cssRules :'background-position: -580px -20px;',
			onclick:function () {
				dialog.render();
				dialog.open();
			}
		});

		return btn;
	},idx/* index of icon in toolbar*/,ueid);
}

function setUEdoclink(ueid,uaa,idx) {
	UE.registerUI('doclnk',function(editor,uiName){

		var dialog = new UE.ui.Dialog({
			iframeUrl:U$("uEditor/FileLnkDialog"),
			editor:editor,
			name:uiName,
			title:"Document Link",
			cssRules:"width:400px;height:150px;",
			buttons:[
				{
					className:'edui-okbutton',
					label:'OK',
					onclick:function () {
						var atag=E$(dialog.id+"_iframe").contentWindow.getATag();
						if (atag=="") {
							alert('Please upload a file');
						} else { 														
							var range = editor.selection.getRange();  
							range.select();  
							var txt = editor.selection.getText();
							var htm = atag+txt+"</a>";
							editor.execCommand('inserthtml',htm);
							dialog.close(true);
						}												
					}
				},
				{
					className:'edui-cancelbutton',
					label:'Cancel',
					onclick:function () {
						dialog.close(false);
					}
				}
			]
		});
			
		var btn = new UE.ui.Button({
			//name:'dialogbutton' + uiName,
			//title:'dialogbutton' + uiName,
			name:"DocLink",
			title:"DocLink",
			cssRules :'background-position: -620px -40px;',
			onclick:function () {
				dialog.render();
				dialog.open();
			}
		});

		return btn;
	},idx/* index of icon in toolbar*/,ueid);	
}


function setupUEditorFields() {
  $(".uedfield script").each( function() {	
	var uid = $(this).attr('id');
	var uaa = getUEattrs($(this).attr("attrs"));	
	var xhew = $(this).width(); var xheh = $(this).height();	
	var css = $UEA(uaa,"css");
	if (css == "") { css = "/Content/cms/ueditorcss.css"; }
	//alert(uid);
		
	//define plugins base on toolset
	switch ($UEA(uaa,"tool")) {
		case "mini":
			setUEstyle(uid,uaa,0);
			setUEdoclink(uid,uaa,4);
		break;
		default:
			setUEtable(uid,uaa,'nude',23);
			setUEtable(uid,uaa,'gen',23);	
			setUEstyle(uid,uaa,0);
			setUEdoclink(uid,uaa,6);
		break;
	}
	
	var ue = UE.getEditor(uid, {
		toolbars: getUEtool(uaa),
		iframeCssUrl: css,
		insertorderedlist: {'default': '1,2,3...' },
		insertunorderedlist: { 'default':'● dot' },
		enableContextMenu: false,
		wordCount: false,
		retainOnlyLabelPasted: true,
		disabledTableInTable: false,
		initialFrameWidth: 950,
		initialFrameHeight: 250,
		//pasteplain:true,
		filterTxtRules:
			function() {
				function transP(node) {
					node.tagName = 'p';
					node.setStyle();
				}
				return {
					//直接删除及其字节点内容
					'-': 'script style object iframe embed input select',
					'p': {
						$: {}
					},
					'br': {
						$: {}
					},
					'div': {
						'$': {}
					},
					'li': {
						'$': {}
					},
					'caption': transP,
					'th': transP,
					'tr': transP,
					'h1': transP,
					'h2': transP,
					'h3': transP,
					'h4': transP,
					'h5': transP,
					'h6': transP,
					'td': function(node) {
						//没有内容的td直接删掉
						var txt = !! node.innerText();
						if (txt) {
							node.parentNode.insertAfter(UE.uNode.createText('    '), node);
						}
						node.parentNode.removeChild(node, node.innerText())
					}
				}
			}(),		
		//customstyle: getUEstyles(uaa),
		allowDivTransToP: false,
		addPInLi: false,
		removeLiStyle: true,
		disablePInList: true,
		enterTag:'',
	});
	
	
  });  
  
}
