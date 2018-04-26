<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page contentType="text/html;charset=UTF-8"%>

<link href="${Content}/cms/core/articleindex.css" rel="stylesheet" type="text/css" />
<style>
    .largemsg { margin-top: 15px; }
    .cat > div { display: inline-block; }
    #catfm { width: 705px; }
    #catfm h2 { font-size: 26px; line-height: 50px; padding-left: 20px; }
    .catformtbl { width: 100%; }
    .catformtbl .cmsbtn { display: inline-block; }
    .catformtbl td { border-bottom: solid 2px #fff; }
	.catformtbl td.label { background: #666; text-align: right; padding: 8px 15px 8px 0; font-size: 14px; color: #fff; width: 30%; }
    .catformtbl td.field { background: #cecece; padding: 8px 0 8px 15px; font-size: 11px; }
    .catformtbl td.field input { width: 95%; }
    .catformtbl td.btn { text-align: center; padding: 15px 0; }
    .catformtbl td.btn .cmsbtn { margin-right: 10px; }
    #catlist .cat { padding: 12px 8px 12px 8px; font-size: 14px; }
    #catlist .cat:nth-child(odd) { background: #fafafa; }
    #catlist .cat:nth-child(even) { background: #eee; }
    #catlist .cat:hover { background: #c2c2c2; }
    #catlist .cat .handle { display: inline-block; cursor: move; padding: 0 10px; }
</style>
<script src="${Script}/cms/catadmin.js" type="text/javascript"></script>
<div id="admintopheader" class="cmspgw hlgradbg" style="">
    <div id="leftuserfnbar" class="leftblock">
        <div id="newbtn" onclick="newcat();">New</div>
    </div>
</div>
<c:if test="${ not empty categories }">
    <div id="catlist">
    	<c:forEach items="${categories}" var="category" >
            <div id="cat-${category.id}" kind="${category.kind}" catid="${category.id}" class="cat" name_en="${category.nameEN}" name_tc="${category.nameTC}" name_sc="${category.nameSC}">
                <span class='handle'>&#9776;</span>
                <div class="cmsbtn" onclick="editcat(${category.id});">Edit</div>
                <div class="cmsbtn" onclick="delcat(${category.id});">Delete</div>
                <div class="label">${category.nameEN}</div>
            </div>
    	</c:forEach>        
    </div>
</c:if>
<c:if test="${ empty categories }">
    <div class='largemsg cmspgw'>No category exists</div>
</c:if>

<div id="layerpool" style="display:none;">
    <!-- CATEGORY FORM -->
    <div class="catform">
        <h2>Category Form</h2>
        <table class="catformtbl" cellpadding="0" cellspacing="0">
            <tr>
                <td class="label">英文名: </td>
                <td class="field"><input type="text" name="nameEN" /></td>
            </tr>
            <tr>
                <td class="label">繁體名: </td>
                <td class="field"><input type="text" name="nameTC" /></td>
            </tr>
<!--             <tr>
                <td class="label">類別: </td>
                <td class="field"><input type="text" name="kind" /></td>
            </tr> -->
            <tr>
                <td class="btn" colspan="2">
                    <div class="cmsbtn" onclick="submitcat();">Save</div>
                    <div class="cmsbtn" onclick="closecat();">Cancel</div>
                </td>
            </tr>
        </table>
    </div>
</div>