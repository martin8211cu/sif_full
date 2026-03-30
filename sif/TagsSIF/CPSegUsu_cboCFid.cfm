<cfset def = QueryNew("CFid")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.query" 		default="#def#" type="query"> 	<!--- consulta por defecto --->
<cfparam name="Attributes.name" 		default="CFid" type="string"> 	<!--- Nombre del código de la moneda --->
<cfparam name="Attributes.onChange" 	default="" type="string"> 		<!--- funciones javascript en el evento onchange --->
<cfparam name="Attributes.tabindex" 	default="" type="string"> 		<!--- número del tabindex --->
<cfparam name="Attributes.value" 		default="" type="string"> 		<!--- número del tabindex --->
<cfparam name="Attributes.disabled" 	default="no" type="boolean"> 	<!--- Lista de estados permitidos  --->
<cfparam name="Attributes.Consultar" 	default="no" type="boolean"> 	<!--- incluir la opcion -1=(Todos...)  --->
<cfparam name="Attributes.Formulacion" 	default="no" type="boolean"> 	<!--- incluir la opcion -1=(Todos...)  --->
<cfparam name="Attributes.Todas" 		default="S" type="String"> 		<!--- S=Todas mis cuentas, N=No incluir Todos, B=Blanco  --->
<cfparam name="Attributes.Estado" 		default="T" type="String"> 		<!--- Estado del centro funcional: Todos ("T"), Activo ("A"), Inactivo ("I") --->

<cfparam name="Attributes.indice" 		default="" type="String"> 	


<cfif isdefined('Session.Ecodigo')>
	<cfparam name="Attributes.Ecodigo" default="#Session.Ecodigo#" type="String"> <!--- Empresa --->
<cfelse>
	<cfparam name="Attributes.Ecodigo" default="" type="String"> <!--- Empresa --->
</cfif>

<cfif Len(Trim(Attributes.Ecodigo)) EQ 0>
	<cfabort>
</cfif>
 

<cfquery name="rsCFuncional" datasource="#Session.DSN#">
	select 	c.CFid, 
			c.CFcodigo, 
			c.CFdescripcion
	  from 	CFuncional c
	  		inner join CPSeguridadUsuario s
				 on s.CFid = c.CFid
				and s.Usucodigo = #session.Usucodigo#
	 where 	
     	c.Ecodigo = #Session.Ecodigo#
        <cfif Attributes.Estado EQ 'A'>
        	And c.CFestado = 1
        <cfelseif Attributes.Estado EQ 'I'>
        	And c.CFestado = 0
        </cfif>
	 order by c.CFcodigo
</cfquery>


<cfsavecontent variable="textoQuery">
	<cfoutput>
	<cfif (Attributes.Consultar or Attributes.Formulacion)>
		<cfif Attributes.Todas EQ "S">
			(Select -100 as CFid, '' as CFcodigo, '(Todas las cuentas permitidas...)' as CFdescripcion)
			UNION ALL

		<cfelseif Attributes.Todas EQ "B">
			(Select -1 as CFid, '' as CFcodigo, '' as CFdescripcion)
			UNION ALL
		</cfif>
	</cfif>

	  (select 	c.CFid as CFid, 
			c.CFcodigo, 
			c.CFdescripcion
	  from 	CFuncional c
	  		inner join CPSeguridadUsuario s
				 on s.CFid = c.CFid
				and s.Usucodigo = #session.Usucodigo#
	 where 	
     	c.Ecodigo = #Session.Ecodigo#
        <cfif Attributes.Estado EQ 'A'>
        	And c.CFestado = 1
        <cfelseif Attributes.Estado EQ 'I'>
        	And c.CFestado = 0
        </cfif>
        )
	 order by CFcodigo		
	</cfoutput>
</cfsavecontent>

<!--- <cf_dump var="#textoQuery#"> --->

<cfif isdefined("Attributes.value") and (Attributes.value NEQ "")>
	<cfif Attributes.value EQ -100>
		<cfset datoActual = queryNew("CFid,CFcodigo,CFdescripcion")>
		<cfset queryAddRow(datoActual, 1)>
		<cfset querySetCell(datoActual, "CFid", '-100', 1)>
		<cfset querySetCell(datoActual, "CFdescripcion", '(Todas las cuentas permitidas...)', 1)>


	<cfelseif Attributes.value EQ -1>
		<cfset datoActual = queryNew("CFid,CFcodigo,CFdescripcion")>
		<cfset queryAddRow(datoActual, 1)>
		<cfset querySetCell(datoActual, "CFid", '-1', 1)>



	<cfelse>
		<cfquery name="datoActual" datasource="#session.dsn#">
			select 	c.CFid, 
				c.CFcodigo, 
				c.CFdescripcion
		  	from 	CFuncional c
		  		inner join CPSeguridadUsuario s
					 on s.CFid = c.CFid
					and s.Usucodigo = #session.Usucodigo#
		 	where 	
	     	c.Ecodigo = #Session.Ecodigo#
	        and c.CFid = #Attributes.value#
	        <cfif Attributes.Estado EQ 'A'>
	        	And c.CFestado = 1
	        <cfelseif Attributes.Estado EQ 'I'>
	        	And c.CFestado = 0
	       	</cfif>
		</cfquery>	
	</cfif>
	
<cfelseif isdefined('Attributes.query') and (Attributes.query.recordCount gt 0) and (ListLen('Attributes.query.columnList') GT 0) and (#Attributes.query.CFid# NEQ -1)>

	<cfquery name="datoActual" datasource="#session.dsn#">
		select 	c.CFid, 
			c.CFcodigo, 
			c.CFdescripcion
	  	from 	CFuncional c
	  		inner join CPSeguridadUsuario s
				 on s.CFid = c.CFid
				and s.Usucodigo = #session.Usucodigo#
	 	where 	
     	c.Ecodigo = #Session.Ecodigo#
        and c.CFid = #Attributes.query.CFid#
        <cfif Attributes.Estado EQ 'A'>
        	And c.CFestado = 1
        <cfelseif Attributes.Estado EQ 'I'>
        	And c.CFestado = 0
        </cfif>
	</cfquery>	
</cfif>


<cfif not isdefined("session.CPSegUsu.#Attributes.name#") or session.CPSegUsu[Attributes.name] EQ "">
	<cfset session.CPSegUsu[Attributes.name] = rsCFuncional.CFid>
	<cfset form[Attributes.name] = rsCFuncional.CFid>
</cfif>
<cfif session.CPSegUsu[Attributes.name] EQ "-1">
	<cfif (Attributes.Consultar or Attributes.Formulacion)>
		<cfset session.CPSegUsu[Attributes.name] = -100>
		<cfset form[Attributes.name] = -100>
	</cfif>
</cfif>
<cfif Attributes.disabled>
	<cfset desactivado = "S">
<cfelse>
	<cfset desactivado = "N">

</cfif>

<cfif isDefined("datoActual") and datoActual.recordCount GT 0>
	<cf_conlisConfirm query="#textoQuery#" columnas="CFid, CFcodigo,CFdescripcion" nombreColumnasTabla= " , Codigo, Descripcion" mostrar="N,S,S" values="#trim(datoActual.CFid)#, #trim(datoActual.CFcodigo)#, #trim(datoActual.CFdescripcion)#"idCampos="#Attributes.name#, cboCodigo#Attributes.name#, cboDescripcion#Attributes.name#"  columnasAFiltrar="CFcodigo,CFdescripcion" tipoColumnasAFiltrar="char,varchar" formato ="" tamanoInputs="0,20%,70%"  botones="Cerrar" ShowButtons="false" importLibs="false" width="70%" height = "70%" disable="#desactivado#" indice ="#attributes.indice#">


<cfelse>
	<cf_conlisConfirm query="#textoQuery#" columnas="CFid, CFcodigo,CFdescripcion" nombreColumnasTabla= " , Codigo, Descripcion" mostrar="N,S,S" idCampos="#Attributes.name#, cboCodigo#Attributes.name#, cboDescripcion#Attributes.name#"  columnasAFiltrar="CFcodigo,CFdescripcion" tipoColumnasAFiltrar="char,varchar" formato ="" tamanoInputs="0,20%,70%"  botones="Cerrar" ShowButtons="false" importLibs="false" width="70%" height = "70%" disable="#desactivado#"  indice ="#attributes.indice#">


</cfif>


<script type="text/javascript">
	$(document).ready(function() {
	  $("#<cfoutput>#Attributes.name#</cfoutput>").change(function() {
	    <cfoutput> #Attributes.onChange#</cfoutput>
	  });
	});
</script>

<!--- 
<cfoutput>
	<select name="#Attributes.name#" 
		id="#Attributes.name#" 
		<cfif Attributes.disabled> disabled </cfif>
		<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
		<cfif Len(Trim(Attributes.onChange)) GT 0> onChange="javascript:#Attributes.onChange#"	</cfif>
	>
</cfoutput>
<cfif (Attributes.Consultar or Attributes.Formulacion)>
	<cfif Attributes.Todas EQ "S">
	<option value="-100">(Todas las cuentas permitidas...)</option>
	<cfelseif Attributes.Todas EQ "B">
	<option value=""></option>
	</cfif>
</cfif>
<cfoutput query="rsCFuncional"> 
	<option value="#rsCFuncional.CFid#"
	<cfif isdefined("Attributes.value") and Attributes.value NEQ "">
		<cfif trim(rsCFuncional.CFid) EQ trim(Attributes.value)>selected</cfif>
	<cfelseif isdefined('Attributes.query') and ListLen('sttributes.query.columnList') GT 0 and #Attributes.query.CFid# NEQ -1>
		<cfif rsCFuncional.CFid EQ Attributes.query.CFid >selected</cfif>
	</cfif>
	>						
		#rsCFuncional.CFcodigo# - #rsCFuncional.CFdescripcion#
	</option>
</cfoutput>
</select>
 --->