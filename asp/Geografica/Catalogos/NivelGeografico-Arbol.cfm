<cfparam name="metodo" default="post">
<cfparam name="actionArbol" default="NivelGeografico.cfm">
<cfparam name="Request.jsTree" default="false">
<cfif Request.jsTree EQ false>
	<cfset Request.jsTree = true>
	<link href="xtree/xtree.css" rel="stylesheet" type="text/css">
	<script language="JavaScript" src="/cfmx/sif/js/xtree/xtree.js"></script>
</cfif>

<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetNiveles" returnvariable="rsNiveles">
	<cfinvokeargument name="Ppais" 		value="#form.Ppais#">
	<cfinvokeargument name="getRaiz"    value="true">
</cfinvoke>
<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetNiveles" returnvariable="rsNivelesNoConfig">
	<cfinvokeargument name="Ppais" 		value="#form.Ppais#">
	<cfinvokeargument name="sinConfig"   value="true">
</cfinvoke>
<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td valign="top">
<fieldset><legend>Niveles Geográficos</legend>
<cfoutput>
	<script language="JavaScript" type="text/javascript">
		iconR = '/cfmx/sif/imagenes/TBP_0116.JPG';
		<cfset esp = "&nbsp;">
		tree= new WebFXTree("#esp#Nivel Geográfico",'','explorer',iconR,iconR);
		<cfloop query="rsNiveles">
			var Raiz = new WebFXTreeItem("#esp##rsNiveles.NGcodigo# - #rsNiveles.NGDescripcion#","javascript:fnSubmit('#rsNiveles.Ppais#',#rsNiveles.NGid#)",tree,iconR,iconR);
			<cfif isdefined('form.NGid') and len(trim(form.NGid)) and form.NGid eq rsNiveles.NGid>
				<cfset lvarNivelSel = true>
				lvarNivelSel = Raiz.id;
			</cfif>
			<cfif rsNiveles.cantSubNiveles gt 0>
				<cfset fnGetHijos(rsNiveles.Ppais,rsNiveles.NGid)>
			</cfif>
		</cfloop>
		document.write(tree);
		tree.collapseAll();
		tree.expand();
		<cfif rsNivelesNoConfig.recordcount gt 0>
			document.write('<br>');
			iconR = '/cfmx/sif/imagenes/TBP_0107.JPG';
			tree= new WebFXTree("#esp#No Configurados","",'explorer',iconR,iconR);
			<cfloop query="rsNivelesNoConfig">
				noConfig= new WebFXTreeItem("#esp##rsNivelesNoConfig.NGcodigo# - #rsNivelesNoConfig.NGDescripcion#","javascript:fnSubmit('#rsNivelesNoConfig.Ppais#',#rsNivelesNoConfig.NGid#)",tree,iconR,iconR);
				<cfif isdefined('form.NGid') and len(trim(form.NGid)) and form.NGid eq rsNivelesNoConfig.NGid>
					<cfset lvarNivelSel = true>
					lvarNivelSel = noConfig.id;
				</cfif>
			</cfloop>
			document.write(tree);
			tree.collapseAll();
			tree.expand();
		</cfif>
		
		 function fnSubmit(Ppais,NGid){
		 	document.formArbol.NGid.value = NGid;
			document.formArbol.Ppais.value = Ppais;
			document.formArbol.submit();
		 }
		<cfif isdefined('lvarNivelSel')>
			webFXTreeHandler.expand(document.getElementById(lvarNivelSel)); 
			div = document.getElementById(lvarNivelSel);
			div.style.backgroundColor = '##CCCCCC';
			var expandir =  new Array();
			getIdPadreSuperior(0,lvarNivelSel);
			expandir.reverse();
			for (i=0;i<expandir.length-1;i++)
				webFXTreeHandler.expand(document.getElementById(expandir[i])); 
		function getIdPadreSuperior(i,idHijo){
			expandir[i]= idHijo.replace('-cont','');
			hijo = document.getElementById(idHijo);
			if(!hijo)
				return -1;
			padre = hijo.parentNode;
			if(padre.id == "webfx-tree-object-2-cont"){//Este es el padre absoluto
				return idHijo.replace('-cont',''); 
			}
			else
				return getIdPadreSuperior(++i,padre.id);
		}
		</cfif>
	</script>

</fieldset>
<form name="formArbol" method="#metodo#" action="#actionArbol#">
	<input type="hidden" id="NGid" name="NGid"value="">
	<input type="hidden" id="Ppais" name="Ppais"value="">
</form>
</td></tr></table>
</cfoutput>
<cffunction name="fnGetHijos" access="private" output="true">
  	<cfargument name='Ppais'	type='string' 	required='true'>
	<cfargument name='NGid'		type='numeric' 	required='true'>
	
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetNiveles" returnvariable="rsSubNiveles">
		<cfinvokeargument name="Ppais" 		value="#Arguments.Ppais#">
		<cfinvokeargument name="NGidPadre"    value="#Arguments.NGid#">
	</cfinvoke>
	
	<cfloop query="rsSubNiveles">
		SubNivel = new WebFXTreeItem("#esp##rsSubNiveles.NGcodigo# - #rsSubNiveles.NGDescripcion#","javascript:fnSubmit('#rsSubNiveles.Ppais#',#rsSubNiveles.NGid#)",Raiz,iconR,iconR);
		Raiz = SubNivel;
		<cfif isdefined('form.NGid') and len(trim(form.NGid)) and form.NGid eq rsSubNiveles.NGid>
			<cfset lvarNivelSel = true>
			lvarNivelSel = Raiz.id;
		</cfif>
		<cfif rsSubNiveles.cantSubNiveles gt 0>
			<cfset fnGetHijos(rsSubNiveles.Ppais,rsSubNiveles.NGid)>
		</cfif>
	</cfloop>
</cffunction>