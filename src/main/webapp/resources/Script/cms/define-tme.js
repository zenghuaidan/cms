//single bullet list icon instead of dropdown instead
function btnUL(editor) {
	editor.addButton('btnUL', {
		text: '',   //without text label
		icon: 'bullist',    //use original icon
        tooltip: 'Bullet list',     //tooltip, if you want
        className:"abc",
		onclick: function() {
			//call original plugin function
			tinymce.activeEditor.execCommand('InsertUnorderedList');        
		}
	});	
}

//custom plugin to create table to be compatible with xheditor
function AppTblHtml(d,r,c,w,tblc) {
  var tw=($.trim(w)=="")?"width:100%":"width:"+w+";";
  var ts=" style='"+tw+"'";
  var h="<table border='0' cellspacing='0' cellpadding='10' class='"+tblc+"' "+ts+">";
  if (d) { 
    h+="<tr class='top'>";
    for (var j=0; j<c; j++) {
      //var tdc=(j<c-1)?"border":"";
      h+="<th>&nbsp;</th>";      
    }
    h+="</tr>";
  }
  for (var i=0; i<r; i++) { 
    var ci=(d)?i+1:i;
    var trc=(ci%2)?"even":"odd";
    h+="<tr class='"+trc+"'>";
    for (var j=0; j<c; j++) {
      //var tdc=(j<c-1)?"border":"";
	  var tdc="";
      h+="<td class='"+tdc+"'>&nbsp;</td>";      
    }
    h+="</tr>";  
  }
  h+="</table>";
  return h;
}

function btnTable(editor) {
	editor.addButton('btnTable', {
		text: '',   //without text label
		icon: 'table',    //use original icon
		tooltip: 'Table',     //tooltip, if you want
		onclick: function() {
			//call original plugin function
			editor.windowManager.open({
				title: "Create Table",
				//url: '/cmsadmin/TinyMce/TableDialog',
				body: [
                    {type: 'textbox', name: 'nrows', label: 'Rows:', value:'2'},
					{type: 'textbox', name: 'ncols', label: 'Cols:', value:'2'},
					{type: 'textbox', name: 'tblw', label: 'Width:', value:'100%'},
					{type: 'checkbox', name: 'hashead', label: 'Header:',checked: true},
					{type: 'listbox', name: 'tblc', label: 'Class:', values : [
                        { text: 'General', value: 'gen' }, { text: 'Nude', value: 'nude' }
                    ], value : 'gen' /*Sets the default*/ },
                ],
				onsubmit: function(e) {
                    // Insert content when the window form is submitted
					var r=parseInt(e.data.nrows);
					var c=parseInt(e.data.ncols);
					var w=e.data.tblw;
					var hasheader=e.data.hashead;
                    editor.insertContent(AppTblHtml(hasheader,r,c,w,e.data.tblc));
                },
				width: 400,
				height: 230,
			});
		}
	});		
}

//custom plugin to adjust table to be compatible with xheditor
/* Custom Table Utility Plugin Definition*/
var TblUtil = {
	tableProperty: function(editor) {
		var cell = editor.selection.getNode();
		var table = $(cell.offsetParent);
		editor.windowManager.open({
			title: "Table Property",
			//url: '/cmsadmin/TinyMce/TableDialog',
			body: [
				{type: 'textbox', name: 'tblw', label: 'Table Width:', value:table.css('width')},
			],
			onsubmit: function(e) {
				// Insert content when the window form is submitted
				table.css('width',e.data.tblw);				
			},
			width: 400,
			height: 80,
		});				
	},
	mergeRightCells: function(editor) {
		var cell = editor.selection.getNode();
		editor.windowManager.open({
			title: "Merge Right Cells",
			//url: '/cmsadmin/TinyMce/TableDialog',
			body: [
				{type: 'textbox', name: 'nmerge', label: 'Right Cells:', value:'1'},
			],
			onsubmit: function(e) {
				// Insert content when the window form is submitted
				var c=parseInt(e.data.nmerge)+1;
				var row = cell.parentNode;
				var cidx=cell.cellIndex;
				if (c>1) {
				  cell.colSpan=c;
				  for (var i=0; i<c-1; i++) row.deleteCell(cidx+1);
				  var cellc=(cidx==row.cells.length-1)?"":"border";
				  cell.className=cellc;
				}
			},
			width: 400,
			height: 80,
		});		
	},        
	insertCol : function(editor, offset) {
		var cell = editor.selection.getNode();
		var table = cell.offsetParent,
			index = cell.cellIndex + offset;
		for (var i = 0, len = table.rows.length; i < len; i++) {
			var newCell = table.rows[i].insertCell(index);
			newCell.innerHTML = '&nbsp;';
			if (i==0 && $(table.rows[i]).hasClass('top')) {
				$(newCell).replaceWith($("<th>&nbsp;</th>"));
			} 
		}
	},
	insertColLeft : function(editor) {
		TblUtil.insertCol(editor, 0);
	},
	insertColRight : function(cell) {
		TblUtil.insertCol(editor, 1);
	},
	insertRow: function(editor, offset) {
		var cell = editor.selection.getNode();
		//console.log(editor.selection.getNode());
		var row = cell.parentNode;
		var table = row.offsetParent;
		var newrowidx=row.rowIndex + offset;
		var newRow = table.insertRow(newrowidx);                  
		for (var i = 0, len = row.cells.length; i < len; i++) {
			var newCell = newRow.insertCell(i);
			if (i<len-1) newCell.className="border";
			newCell.innerHTML = '&nbsp;';
		}
		//fix below row color
		var hasheader = $(table.rows[0]).hasClass('top');
		var i = hasheader ? 1 : 0;
		for (; i<=table.rows.length; i++) {
		  rc=(i%2==0)?"even":"odd";
		  table.rows[i].className=rc;            
		}
	},
	insertRowAbove : function(editor) {
		TblUtil.insertRow(editor, 0);
	},
	insertRowBelow : function(editor) {
		TblUtil.insertRow(editor, 1);
	},
	deleteCol : function(editor) {
		var cell = editor.selection.getNode();
		var table = cell.offsetParent;
		for (var i = 0, len = table.rows.length; i < len; i++) {
			table.rows[i].deleteCell(cell.cellIndex);
		}
		if (table.rows.length == 0) {
			TblUtil.deleteTable(cell);
		}
	},
	deleteRow : function(editor) {
		var cell = editor.selection.getNode();
		var row = cell.parentNode;
		var table = row.offsetParent;
		var delrowidx=row.rowIndex;
		table.deleteRow(row.rowIndex);
		if (table.rows.length == 0) {
			TblUtil.deleteTable(cell);
		} else { //fix color
			var hasheader = $(table.rows[0]).hasClass('top');
			var i = hasheader ? 1 : 0;
		  for (; i<table.rows.length; i++) {
			rc=(i%2==0)?"even":"odd";
			table.rows[i].className=rc;            
		  }
		}
	},
	deleteTable : function(editor) {
		var cell = editor.selection.getNode();
		var table = cell.offsetParent;
		table.parentNode.removeChild(table);
	}
};

function btnTableEx(editor) {
	editor.addButton('btnTableEx', {
		type: 'menubutton',
		text: '',   //without text label
		icon: 'table',    //use original icon
		tooltip: 'Table Ex',     //tooltip, if you want
		menu: [
			//{ text: 'Table Property', onclick:function() { TblUtil.tableProperty(editor); } },
			{ text: 'Merge Right Cells', onclick:function() { TblUtil.mergeRightCells(editor); } },
			{ text: 'Insert Column On Left', onclick:function() { TblUtil.insertCol(editor, 0); } },
			{ text: 'Insert Column On Right', onclick:function() { TblUtil.insertCol(editor, 1); } },
			{ text: 'Insert Row Above', onclick:function() { TblUtil.insertRow(editor, 0); } },
			{ text: 'Insert Row Below', onclick:function() { TblUtil.insertRow(editor, 1); } },
			{ text: 'Delete Column', onclick:function() { TblUtil.deleteCol(editor); } },
			{ text: 'Delete Row', onclick:function() { TblUtil.deleteRow(editor); } },
			{ text: 'Delete Table', onclick:function() { TblUtil.deleteTable(editor); } },
		]
	});		
}

//set uploader 
function closeMceUp(fid) {
	$("#upframe,#mceupwarn").remove();
	$("#"+fid).show();
	$("#"+fid).closest(".mce-floatpanel").find(".mce-btn.mce-primary").show();
}
function setUpMgr(field_name, url, type, win) {
	var juin = $(win.document.getElementById(field_name));
	//juin.val('my browser value');
	juin.hide();
	var wtype = (type=="image")?"webimage":"webfile";
	var ifuhtm = "<iframe id='upframe' src='"+U$('/PageContentAdmin/TinyMceUpFrame')+"?wtype="+wtype+"&iname="+field_name+"' width='' height='' frameborder='0' scrolling='no'></iframe>";
	juin.after(ifuhtm);
	//hide ok and display warning
	var jftp = juin.closest(".mce-floatpanel").find(".mce-foot .mce-container-body");
	var warn = "<div id='mceupwarn' style='color:red; line-height:50px; padding-left:20px;'>";
	warn+="* You cannot proceed until file is uploaded *</div>";
	jftp.append(warn);
	jftp.find(".mce-btn.mce-primary").hide();
}

//video plugin
function btnYouTube(editor) {
	editor.addButton('btnYouTube', {
		text: '',   //without text label
		icon: 'media',    //use original icon
		tooltip: 'YouTube',     //tooltip, if you want
		onclick: function() {
			//call original plugin function
			editor.windowManager.open({
				title: "Insert YouTube",
				//url: '/cmsadmin/TinyMce/TableDialog',
				body: [
                    {type: 'textbox', name: 'vid', label: 'YouTube ID:', value:''}
                ],
				onsubmit: function(e) {
                    // Insert content when the window form is submitted
					var htm ='';
					htm+='<div class="videoWrapper">';
					htm+='	<iframe width="560" height="349" src="http://www.youtube.com/embed/'+e.data.vid+'?rel=0&amp;hd=1" frameborder="0" allowfullscreen=""/>';
					htm+='</div>';
                    editor.insertContent(htm);
                },
				width: 400,
				height: 80,
			});
		}
	});		
}

//video plugin
function btnArtistOrMember(editor) {
	editor.addButton('btnArtistOrMember', {
		text: 'Popup Artist or Member',
		title : 'Popup Artist or Member',
		tooltip: 'Popup Artist or Member',
		onclick: function() {
			//call original plugin function
			editor.windowManager.open({
				title: "Insert Artist or Member",
				//url: '/cmsadmin/TinyMce/TableDialog',
				body: [
                    {type: 'textbox', name: 'vid', label: 'Artist or Member ID:', value:''}
                ],
				onsubmit: function(e) {                    
					var selected_text = editor.selection.getContent();
					var return_text = "<span style='cursor:pointer' class='popup' data-target='#artist-" + e.data.vid + "'>" + selected_text + "</span>";
					editor.execCommand('mceInsertContent', 0, return_text);
                },
				width: 400,
				height: 80,
			});
		}		
	});
}

function setupRichEditorFields() {  
	//define toolsets
	var toolsets = new Array();
	toolsets["mini"] = 'undo redo | styleselect bold italic underline superscript subscript link unlink mailto btnUL numlist image | removeformat code';
	toolsets["default"] = 'undo redo | styleselect hr bold italic underline superscript subscript alignleft aligncenter alignright alignjustify link unlink mailto btnUL numlist';
	toolsets["default"] += ' | btnTable btnTableEx resptbl image btnYouTube | removeformat code';	 //jbimages
	//define stylesets
	var stylesetsa = new Array();
	stylesetsa["default"] = [  	{ title: 'H2 Title', block: 'h2' },
								{ title: 'H3 Title', block: 'h3' },
								{ title: 'Small font', inline: 'span', classes: 'font-s' },
								//{ title: 'Green color', inline: 'span', classes: 'txt-green' },
                                { title: 'Red color', inline: 'span', classes: 'txt-red' },
                                { title: 'Theme color', inline: 'span', classes: 'theme-txt' },
	];
	stylesetsa["pop"] = [  	{ title: 'Title', inline: 'span', classes: 'title' },
							//{ title: 'Text Blue', inline: 'span', classes: 'txtBlue' },
	];	
		
	//foreach editor
	$(".redfield textarea").each( function() {
		//get width & height
		var xhew = $(this).width(); var xheh = $(this).height();
		//define specific attrs
		var cssarr=[RU$('/resources/Content/cms/editorstyles.css')];
		var tool="default";  var styleset="default";	
		var attrstr = $(this).attr("attrs");
		if ($.trim(attrstr)!="") {var attra = attrstr.split(',');
			for (var i=0; i<attra.length; i++) {
				var a = attra[i].split(':');
				switch (a[0]) {
					case "tool": tool = a[1]; break;
					case "styleset": styleset=a[1]; break;
					case "theme": 
						theme = a[1]; 
						cssarr.push(RU$("/resources/Content/cms/editortheme_"+theme+".css"));
					break;
					case "pushcss": 
						pushcss = a[1]; 					
						cssarr.push(RU$("/resources/Content/cms/"+pushcss+".css"));
					break;
					case "css": 
						sgcss = a[1]; 					
						cssarr=[RU$("/resources/Content/cms/"+sgcss+".css")];
					break;
				}			
			}
		}	
	
		var taid = $(this).attr('id');
		tinymce.init({
			selector: 'textarea#'+taid,
			width: xhew, height: xheh,
			toolbar_items_size: 'small',
			menubar: false,
			forced_root_block: "",
			style_formats: stylesetsa[styleset],
			plugins: [
				'hr code fullscreen image link paste mailto resptbl', //table jbimages
			],
			toolbar: toolsets[tool], 
			relative_urls: false,
			convert_urls: false,
			content_css: cssarr,
			table_class_list: [
				{title: 'General', value: 'table'},
				{title: 'None', value: ''},
			],
			file_browser_callback: function(field_name, url, type, win) {
				setUpMgr(field_name, url, type, win);
			},
			setup: function(editor) {
				btnUL(editor);
				btnTable(editor);
				btnTableEx(editor);
				btnYouTube(editor);
				//btnArtistOrMember(editor);
				//btnInsMailto(editor);
			},
			paste_as_text: true,
			image_dimensions: false
		});
	});  
}