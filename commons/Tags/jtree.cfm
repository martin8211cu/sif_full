<!---
	usar asi:

		var data = [
	    <cfset data= ' {
					        "key": "1",
					        "label": "id 1",
					        "values": [
					            { "key": "2","label": "nombre 2" },
					            { "key": "2","label": "nombre 2" },
					            { "key": "3","label": "nombre 3" },
					            { "key": "4","label": "nombre 4" },
					            { "key": "5","label": "nombre 5" }
					        ]
					    } ,
					   '/> 

	<cf_jtree data="#data#">

--->
<cfparam name="Attributes.data" type="String">
<cfparam name="Attributes.dataDefault" type="String" default="">
<cfparam name="Attributes.contraer" type="boolean" default="false">
<cfparam name="Attributes.expandir" type="boolean" default="false">
<cfparam name="Attributes.checkall" type="boolean" default="false">
<cfparam name="Attributes.UnCheckAll" type="boolean" default="false">
<cfparam name="Attributes.initExpandir" type="boolean" default="true"><!---- indica si inicia expandido o no---->
<cfparam name="Attributes.formatoJSON" 	type="boolean" default="true"><!---- Se guarda en formato ajax---->
 
<cfif ThisTag.ExecutionMode Is 'Start'>
<cfif not isDefined("resquest.useJtree")>
	<cfset resquest.useJtree=true>
	<style type="text/css">.listTree{margin-bottom:18px}.listTree ul{margin:0;-webkit-margin-after: 0em;}.listTree li{list-style-type:none}.listTree>ul>li{background-color:#eee;border-width:1px 1px 0;border-style:solid;border-color:#ddd}.listTree>ul>li:first-child{border-width:1px 1px 0;border-top-left-radius:3px;border-top-right-radius:3px}.listTree>ul>li:last-child{border-width:1px;border-bottom-left-radius:3px;border-bottom-right-radius:3px}.listTree>ul>li:last-child>ul>li:last-child{border-bottom-left-radius:3px;border-bottom-right-radius:3px}.listTree span{display:inline-block;width:100%;padding:0px}.listTree>ul>li>span{}.listTree>ul>li>ul>li{background-color:#fff;border-width:1px 0 0;border-style:solid;border-color:#ddd;padding-left:10px}.listTree>ul>li>ul>li:first-child,.listTree>ul>li>ul>li:last-child{border-width:1px 0 0}.listTree i{float:right;margin-right:15px}
	</style>
	<script src="/cfmx/jquery/librerias/underscore-min.js"></script>
	<script type="text/javascript" src="/cfmx/commons/js/jtree.js"></script>
</cfif>	
 	 <cfif Attributes.checkall>
    <a id="jtreeCheckAll"><i class="fa fa-check-square-o" ></i>Todos</a>
    </cfif>
    <cfif Attributes.UnCheckAll>
    <a id="jtreeUnCheckAll"><i class="fa fa-square-o"></i> Ninguno</a>
    </cfif>
    <cfif Attributes.expandir>
    	<a id="jtreeExpandAll"><i class="fa fa-plus-square-o"></i> Expandir</a>	
    </cfif>
    <cfif Attributes.contraer>
    	<a id="jtreeCollapseAll"><i class="fa fa-minus-square-o"></i> Contraer</a>	
    </cfif>
    <div class="listTree"></div>
    <cfif attributes.formatoJSON>
    	<input type="hidden" name="jtreeJsonFormat" id="jtreeJsonFormat">
    <cfelse>
    	<input type="hidden" name="jtreeListaItem" id="jtreeListaItem" value="0">
    </cfif>
    
<script type="text/javascript">
	var data = [];
	var dataDefaultSelected = [];
	<cfif len(trim(attributes.data)) and mid(attributes.data, 1, 1) eq '['><!--- si lo envian dentro de un array---->
		var data = <cfoutput>#attributes.data#</cfoutput>;
	<cfelseif len(trim(attributes.data))>	
		var data = [<cfoutput>#attributes.data#</cfoutput>];
	</cfif>
	<cfif len(trim(attributes.dataDefault)) and mid(attributes.dataDefault, 1, 1) eq '['><!--- si lo envian dentro de un array---->
		var dataDefaultSelected = <cfoutput>#attributes.dataDefault#</cfoutput>;
	<cfelseif len(trim(attributes.dataDefault))>	
		var dataDefaultSelected = [<cfoutput>#attributes.dataDefault#</cfoutput>];
	</cfif>

	$(document).on('click', '#jtreeCheckAll', function(e) {
	    $('.listTree').listTree('selectAll');setValuesCheckedTree();
	}).on('click', '#jtreeUnCheckAll', function(e) {
	    $('.listTree').listTree('deselectAll');setValuesCheckedTree();
	}).on('click', '#jtreeExpandAll', function(e) {
	    $('.listTree').listTree('expandAll'); 
	}).on('click', '#jtreeCollapseAll', function(e) {
	    $('.listTree').listTree('collapseAll');
	}).on('click', '.listTree input', function(e) {
	    setValuesCheckedTree();
	});
	$('.listTree').listTree(data, { "startCollapsed":<cfif attributes.initExpandir>false<cfelse>true</cfif>, "selected": dataDefaultSelected });
	function setValuesCheckedTree(){<cfif attributes.formatoJSON>$('#jtreeJsonFormat').val(JSON.stringify($('.listTree').data('listTree').selected));<cfelse>var e='0';try{$.each( ($('.listTree').data('listTree').selected)[0].values,function(x,y){e+=','+y.key;})}catch(err){}$("#jtreeListaItem").val(e);</cfif>}
	<cfif len(trim(attributes.dataDefault))>
		setValuesCheckedTree();
	</cfif>
</script>
</cfif>

