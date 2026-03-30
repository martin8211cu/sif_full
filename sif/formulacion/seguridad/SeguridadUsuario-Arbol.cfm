<link href="xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="/cfmx/sif/js/xtree/xtree.js"></script>

<cfparam name="url.CFid" default="-1">
<cfif not len(trim(url.CFid))>
	<cfset url.CFid = "-1">
</cfif>

<cfquery datasource="#session.dsn#" name="rsCentroFuncional">
	select CFid,CFpath
	from CFuncional
	where Ecodigo = #Session.Ecodigo#
	and CFid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	order by CFpath
</cfquery>
<cfif isdefined('SEG.ADM') and SEG.ADM eq 'true'>
		<cfquery datasource="#session.dsn#" name="rsResponsable">
		select CFid
		from CFuncional
		where Ecodigo = #Session.Ecodigo#
		and CFidresp is null
		order by CFpath
	</cfquery>
<cfelse>
	<cfquery datasource="#session.dsn#" name="rsResponsable">
		select CFid
		from CFuncional
		where Ecodigo = #Session.Ecodigo#
		and CFuresponsable = #session.usucodigo#
		order by CFpath
	</cfquery>
</cfif>
<cfset cfids = valuelist(rsResponsable.CFid)>
<cfif rsResponsable.RecordCount eq 0>
	<cfset cfids = "-1">
</cfif>
<cfloop query="rsResponsable">
	<cfset fnGetCFs(rsResponsable.CFid)>
</cfloop>

<cfquery datasource="#session.dsn#" name="rsPadre">
	select 
		c.CFid, 
		c.CFcodigo as codigo, 
		c.CFdescripcion as descripcion, 
		1 as nivel,  
		(
			select count(1) from CFuncional c2
			where c2.CFidresp = c.CFid
			and c2.Ecodigo = c.Ecodigo
		) as  hijos
	from CFuncional c
	where c.Ecodigo = #Session.Ecodigo#
	and c.CFid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#cfids#">)
	order by CFpath
</cfquery>

<cfset cfs = "">
<cfset path = "">
<cfloop query="rsPadre">
	<cfset path &= "#CFid#,">
	<cfset cfs = "#fnGetHijos(CFid,false)#">
</cfloop>
<cfif len(trim(cfs)) gt 0>
	<cfset cfs = mid(cfs,1,len(cfs)-1)>
</cfif>
<table border="0" width="100%"  cellspacing="0" cellpadding="0"><tr>
	<td>
		<fieldset><legend>Búsqueda de Centros Funcionales</legend>
			<cfquery datasource="#session.dsn#" name="rsCFs">
				select 
					c.CFid, 
					c.CFcodigo as codigo, 
					c.CFdescripcion as descripcion
				from CFuncional c
				where c.Ecodigo = #Session.Ecodigo#
				<cfif isdefined('url.filtro_codigo') and len(trim(url.filtro_codigo)) gt 0>
				and lower(CFcodigo) like lower('%#trim(url.filtro_codigo)#%')
				</cfif>
				<cfif isdefined('url.filtro_descripcion') and len(trim(url.filtro_descripcion)) gt 0>
				and lower(CFdescripcion) like lower('%#trim(url.filtro_descripcion)#%')
				</cfif>
				<cfif rsPadre.RecordCount GT 0>
				and CFid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#cfs#">)
				<cfelse>
				and CFid = -1 
				</cfif>
				<cfif (not isdefined('url.filtro_codigo') or (isdefined('url.filtro_codigo') and len(trim(url.filtro_codigo)) eq 0)) and ((isdefined('url.filtro_descripcion') and len(trim(url.filtro_descripcion)) eq 0) or not isdefined('url.filtro_descripcion'))>
					and 0!=0
				</cfif>
				order by CFcodigo
			</cfquery>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsCFs#" 
				conexion="#session.dsn#"
				desplegar="codigo,descripcion"
				etiquetas="Código,Descripción"
				formatos="S,S"
				mostrar_filtro="true"
				align="left,left"
				checkboxes="N"
				formName="formCFs"
				form_method="get"
				ira="#currentpage#"
				keys="CFid">
			</cfinvoke>
		</fieldset>
		<br>
	</td>
</tr>
<tr>
	<td>
	<fieldset><legend>Centros Funcionales Responsable</legend>
	<table border="0" width="100%"  cellspacing="0" cellpadding="0" class="AreaFiltro"><tr><td>
	<cfoutput>
	<script language="JavaScript" type="text/javascript">
		var icon = '/cfmx/sif/js/xtree/images/blank.png';
		var tree= new WebFXTree("Centros Funcionales",'','explorer',icon,icon);
		<cfset CFcorrecto = false>
		<cfloop query="rsPadre">
			<cfif hijos>
				var LvarSIS = new WebFXTreeItem("#codigo# - #descripcion#","#CurrentPage#?CFid=#CFid#",tree,'/cfmx/sif/imagenes/usuario04_T.gif','/cfmx/sif/imagenes/usuario04_T.gif');
				<cfif isdefined('form.CFid') and len(trim(form.CFid)) and form.CFid eq CFid>
					var idExpandir = LvarSIS.id;
					<cfset CFcorrecto = true>
				</cfif>
				<cfif listfind(rsCentroFuncional.CFpath, trim(rsPadre.codigo),'/')> 
					<cfset fnHijos =  fnGetHijos(CFid)>
				</cfif>
			<cfelse>
				var LvarSIS = new WebFXTreeItem("#codigo# - #descripcion#","#CurrentPage#?CFid=#CFid#",tree,'/cfmx/sif/imagenes/usuario01_T.gif','/cfmx/sif/imagenes/usuario01_T.gif');
				<cfif isdefined('form.CFid') and len(trim(form.CFid)) and form.CFid eq CFid>
					var idExpandir = LvarSIS.id;
					<cfset CFcorrecto = true>
				</cfif>
			</cfif>
		</cfloop>
		document.write(tree);
		tree.collapseAll();
		tree.expand();
		<cfif isdefined('form.CFid') and len(trim(form.CFid)) and form.CFid eq CFid and CFcorrecto>
		webFXTreeHandler.expand(document.getElementById(idExpandir)); 
		div = document.getElementById(idExpandir);
		div.style.backgroundColor = '##CCCCCC';
		var expandir =  new Array();
		getIdPadreSuperior(0,idExpandir);
		expandir.reverse();
		for (i=0;i<expandir.length-1;i++)
			webFXTreeHandler.expand(document.getElementById(expandir[i])); 
		
		function getIdPadreSuperior(i,idHijo){
			expandir[i]= idHijo.replace('-cont','');
			hijo = document.getElementById(idHijo);
			padre = hijo.parentNode;
			if(padre.id == "webfx-tree-object-2-cont"){//Este es el padre absoluto
				return idHijo.replace('-cont',''); 
			}
			else
				return getIdPadreSuperior(++i,padre.id);
		}
		</cfif>
	</script>
	</cfoutput>
	</td></tr></table></fieldset>
	</td>
</tr>
</table>
<cffunction name="fnGetHijos" returntype="string" access="private">
  	<cfargument name='idPadre'		type='numeric' 	required='true'>
	<cfargument name='pintar'		type='boolean' 	required='no' default="true">
				
   	<cfquery datasource="#session.dsn#" name="Arguments.rsSQL">
		select c.CFid, c.CFcodigo as codigo, c.CFdescripcion as descripcion, c.CFnivel as nivel,  
		(select count(1) from CFuncional c2
		  where c2.CFidresp = c.CFid and c2.Ecodigo = c.Ecodigo
		) as hijos
		from CFuncional c
		where c.Ecodigo = #Session.Ecodigo# and c.CFidresp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idPadre#">
		order by c.CFpath
	</cfquery>
	
	<cfparam name="path" default="">
	<cfloop query="Arguments.rsSQL">
		<cfset path &= "#Arguments.rsSQL.CFid#,">
		<cfif hijos>
			<cfif Arguments.pintar>
				<cfoutput>
				var treeTemp = LvarSIS;
				var LvarMOD = new WebFXTreeItem("#Arguments.rsSQL.codigo# - #Arguments.rsSQL.descripcion#","#CurrentPage#?CFid=#CFid#",LvarSIS,"/cfmx/sif/imagenes/usuario04_T.gif","/cfmx/sif/imagenes/usuario04_T.gif");
				<cfif isdefined('form.CFid') and len(trim(form.CFid)) and form.CFid eq Arguments.rsSQL.CFid>
				var idExpandir = LvarMOD.id;
					<cfset CFcorrecto = true>
				</cfif>
				LvarSIS = LvarMOD;
				<cfif listfind(rsCentroFuncional.CFpath,trim(Arguments.rsSQL.codigo),'/')> 
					<cfset path &= fnGetHijos(Arguments.rsSQL.CFid,arguments.pintar)>
				</cfif>
				LvarSIS = treeTemp;
				</cfoutput>
			<cfelseif listfind(rsCentroFuncional.CFpath,trim(Arguments.rsSQL.codigo),'/')>
				<cfset path &= fnGetHijos(Arguments.rsSQL.CFid,arguments.pintar)>
			</cfif>
		<cfelse>
			<cfif Arguments.pintar>
				<cfoutput>
				var LvarMOD = new WebFXTreeItem("#Arguments.rsSQL.codigo# - #Arguments.rsSQL.descripcion#","#CurrentPage#?CFid=#CFid#",LvarSIS,"/cfmx/sif/imagenes/usuario01_T.gif","/cfmx/sif/imagenes/usuario01_T.gif");
				<cfif isdefined('form.CFid') and len(trim(form.CFid)) and form.CFid eq Arguments.rsSQL.CFid>
				var idExpandir = LvarMOD.id;
					<cfset CFcorrecto = true>
				</cfif>
				</cfoutput>
			</cfif>
		</cfif>
	</cfloop>
	<cfreturn path>
</cffunction>

<!--- Obtiene los centros funcional hijos del centro funcional asginado al responsable, ademas elimina los CFs que estan en las lista
	de CFs asignadas q estan como hijos de un CF asignado.--->
<cffunction name="fnGetCFs" returntype="void" access="private">
  	<cfargument name='CFid'		type='numeric' 			required='true'>
	
   	<cfquery datasource="#session.dsn#" name="Arguments.rsSQL">
		select c.CFid,
			c.CFnivel as nivel,  
			(
				select count(1) from CFuncional c2
				where c2.CFidresp = c.CFid
				and c2.Ecodigo = c.Ecodigo
			) as  hijos
		from CFuncional c
		where c.Ecodigo = #Session.Ecodigo#
		  and c.CFidresp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
		order by c.CFpath
	</cfquery>
	
	<cfloop query="Arguments.rsSQL">
		<cfset i = listfind(cfids,Arguments.rsSQL.CFid)>
		<cfif i gt 0>
			<cfset cfids = listdeleteat(cfids,i)>
		</cfif>
		<cfif Arguments.rsSQL.hijos>
			<cfset fnGetCFs(Arguments.rsSQL.CFid)>
		</cfif>
	</cfloop>
</cffunction>