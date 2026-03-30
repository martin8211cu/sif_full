<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif isdefined("url.ERid") and not isdefined("form.ERid")>
	<cfset form.ERid = Url.ERid>
</cfif>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>

<cfoutput> 
<form name="form1" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
		<tr><td colspan="11" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td></tr>
		<tr><td colspan="11">&nbsp;</td></tr>
		<tr><td colspan="11" align="center"><b>Consulta Hist&oacute;rica de Reclamos de Compras</b></td></tr>
		<tr><td colspan="11" align="center"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td></tr>
		<cfif isdefined('form.EDRfecharecI') and len(trim(form.EDRfecharecI)) NEQ 0 or isdefined('form.EDRfecharecF') and len(trim(form.EDRfecharecF)) NEQ 0>
			<tr><td colspan="11" align="center"><b>Rango de fechas del Reclamo :</b> <cfif isdefined('form.EDRfecharecI') and len(trim(form.EDRfecharecI)) NEQ 0>Del #LSDateFormat(form.EDRfecharecI, 'dd/mm/yyyy')# &nbsp; </cfif> <cfif isdefined('form.EDRfecharecF') and len(trim(form.EDRfecharecF)) NEQ 0> al &nbsp;  #LSDateFormat(form.EDRfecharecF, 'dd/mm/yyyy')# &nbsp; </cfif></td></tr>
		</cfif>		
	</table>
</form>
</cfoutput> 	

<!--- ============================================================== --->
<!---  Creacion del filtro --->
<!--- ============================================================== --->
<cfset navegacion = "">

<cfif isdefined("form.SNcodigoI") and len(trim(form.SNcodigoI)) >
	<cfset navegacion = navegacion & "&SNcodigoI=#form.SNcodigoI#">
</cfif>

<cfif isdefined("form.SNcodigoF") and len(trim(form.SNcodigoF)) >
	<cfset navegacion = navegacion & "&SNcodigoF=#form.SNcodigoF#">
</cfif>

<!---
<cfif isdefined("form.EOidordenI") and len(trim(form.EOidordenI)) >
	<cfset navegacion = navegacion & "&EOidordenI=#form.EOidordenI#">
</cfif>

<cfif isdefined("form.EOidordenF") and len(trim(form.EOidordenF)) >
	<cfset navegacion = navegacion & "&EOidordenF=#form.EOidordenF#">
</cfif> 
--->

<cfif isdefined("form.EDRfecharecI") and len(trim(form.EDRfecharecI)) >
	<cfset navegacion = navegacion & "&EDRfecharecI=#form.EDRfecharecI#">
</cfif>

<cfif isdefined("form.EDRfecharecF") and len(trim(form.EDRfecharecF)) >
	<cfset navegacion = navegacion & "&EDRfecharecF=#form.EDRfecharecF#">
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsLista" datasource="#session.DSN#">
	select er.SNcodigo , rtrim(sn.SNidentificacion) as SNidentificacion,  
		SNidentificacion#_Cat#' - '#_Cat#SNnombre as SNnombre,
		er.ERid, er.Ecodigo, er.SNcodigo, er.EDRid, er.CMCid, er.EDRnumero, er.EDRfecharec, 
		er.Usucodigo, er.fechaalta, er.ERestado, er.ERobs
	from EReclamos er
		inner join SNegocios sn
		  on er.Ecodigo = sn.Ecodigo
		  and er.SNcodigo = sn.SNcodigo 	
		left outer join  HEDocumentosRecepcion hedr
		  on er.Ecodigo = hedr.Ecodigo
		  and er.EDRid  = hedr.EDRid 	
	where  er.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<cfif isdefined("Form.SNcodigoI") and form.SNcodigoI NEQ "" and isdefined("Form.SNcodigoF") and trim(form.SNcodigoF) NEQ "" >
		  and er.SNcodigo between <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoI#">  and <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoF#">
	<cfelseif isdefined("Form.SNcodigoI") and form.SNcodigoI NEQ "" and not isdefined("Form.SNcodigoF") and trim(form.SNcodigoF) EQ "">	
		and er.SNcodigo between <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoI#">  and <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoI#">
	<cfelseif isdefined("Form.SNcodigoI") and len(trim(form.SNcodigoI)) EQ 0 and isdefined("Form.SNcodigoF") and len(trim(form.SNcodigoF))>	
		and er.SNcodigo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoF#"> 
	</cfif>
	
	<!---<cfif isdefined("Form.EOidordenI") and form.EOidordenI NEQ "" and isdefined("Form.EOidordenF") and trim(form.EOidordenF) NEQ "" >
		 and hedr.EOidorden between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidordenI#">
		 and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidordenF#">
	<cfelseif isdefined("Form.EOidordenI") and form.EOidordenI NEQ "" and isdefined("Form.EOidordenF") and trim(form.EOidordenF) EQ "">	
		and hedr.EOidordenI between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidordenI#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidordenI#">
	<cfelseif not isdefined("Form.EOidordenI") and trim(form.EOidordenI) EQ "" and isdefined("Form.EOidordenF") and trim(form.EOidordenF) NEQ "">	
		 and hedr.EOidorden <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidordenF#">
	</cfif>--->
	
	
	<cfif isdefined("Form.EDRfecharecI") and trim(form.EDRfecharecI) neq "" and isdefined("Form.EDRfecharecF") and trim(form.EDRfecharecF) NEQ "">
		 and er.EDRfecharec between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.EDRfecharecI)#">
		 and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(Form.EDRfecharecF)))#">
	<cfelseif isdefined("Form.EDRfecharecI") and trim(form.EDRfecharecI) neq "" and isdefined("Form.EDRfecharecF") and trim(form.EDRfecharecF) EQ "">
		and er.EDRfecharec between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.EDRfecharecI)#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(Form.EDRfecharecI)))#">
	<cfelseif isdefined("Form.EDRfecharecI") and len(trim(form.EDRfecharecI)) EQ 0 and isdefined("Form.EDRfecharecF") and len(trim(form.EDRfecharecF))>	
		and er.EDRfecharec <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(Form.EDRfecharecF)))#">
	</cfif>

	order by sn.SNnombre desc
</cfquery>		

<!--- ============================================================== --->
<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="cortes" value="SNnombre"/>
	<cfinvokeargument name="desplegar" value="EDRnumero, EDRfecharec, ERobs"/>
	<cfinvokeargument name="etiquetas" value="N&uacute;mero, Fecha, Observaciones"/>
	<cfinvokeargument name="formatos" value="V, D, V"/>
	<cfinvokeargument name="align" value="left, left,left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="ReclamosHistDet-form.cfm"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys" value="ERid"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>