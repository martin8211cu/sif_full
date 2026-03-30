<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">

<cfif isdefined("Form.CPOid") and Len(Trim(Form.CPOid))>
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>

<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select a.CPOid, a.Oorigen, o.Odescripcion, a.CPOdesde, a.CPOhasta, a.ts_rversion
		  from CPOrigenesControlAbierto a, Origenes o
		 where a.Ecodigo  = #Session.Ecodigo#
		   and a.CPOid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPOid#">
	</cfquery>
<cfelse>
	<cfset rsForm.CPOid=-1>
	<cfset rsForm.Oorigen=-1>
	<cfset rsForm.Odescripcion="">
	<cfset rsForm.CPOdesde = now()>
	<cfset rsForm.CPOhasta = "">
	<cfset rsForm.ts_rversion = "">
</cfif>
<cfquery name="rsOrigenes" datasource="#Session.DSN#">
	select Oorigen, Odescripcion
	  from Origenes
	<cfif modo EQ 'CAMBIO'>
	 where Oorigen  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oorigen#">
	</cfif>
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td valign="top" width="40%">
	  <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
		  <cfinvokeargument name="tabla" value="CPOrigenesControlAbierto a, Origenes o"/>
		  <cfinvokeargument name="columnas" value="a.CPOid, a.Oorigen, o.Odescripcion, a.CPOdesde, a.CPOhasta"/>
		  <cfinvokeargument name="desplegar" value="Oorigen, Odescripcion, CPODesde, CPOhasta"/>
		  <cfinvokeargument name="etiquetas" value="Código, Módulo Origen, Desde, Hasta"/>
		  <cfinvokeargument name="formatos" value="V, V, D, D"/>
		  <cfinvokeargument name="align" value="left, left, center, center"/>
		  <cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# 
		  										and a.Oorigen=o.Oorigen
												and a.CPOborrado = 0
		  										 order by a.CPOdesde"/>
		  <cfinvokeargument name="ajustar" value="N"/>
		  <cfinvokeargument name="checkboxes" value="N"/>
		  <cfinvokeargument name="keys" value="Oorigen"/>
		  <cfinvokeargument name="irA" value="CPOrigenesControlAbierto-.cfm"/>
	  </cfinvoke>
	</td>
	<td valign="top" width="60%">
		<cfoutput>
		<form method="post" name="form1" action="CPOrigenesControlAbierto-sql.cfm">
		  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr>
			  <td align="right" nowrap>M&oacute;dulo Origen:</td>
			  <td>
			  	<input type="hidden" name="CPOid" id="CPOid" value="#rsForm.CPOid#">
			  	<select name="Oorigen">
				<cfloop query="rsOrigenes">
			    	<option value="#rsOrigenes.Oorigen#" <cfif modo EQ 'CAMBIO'> selected</cfif>>#rsOrigenes.Oorigen# - #rsOrigenes.Odescripcion#</option>
				</cfloop>
			    </select>
			  </td>
		    </tr>
			<tr>
			  <td nowrap align="right">Control Abierto Desde:</td>
			  <td>
		          <cf_sifcalendario name="CPOdesde" form="form1" value="#LSDateFormat(rsForm.CPOdesde,"DD/MM/YYYY")#"> 
			  </td>
			</tr>
			<tr>
			  <td align="right">Control Abierto Hasta:</td>
			  <td>
		          <cf_sifcalendario name="CPOhasta" form="form1" value="#LSDateFormat(rsForm.CPOhasta,"DD/MM/YYYY")#"> 
			  </td>
			</tr>
			<tr>
			  <td colspan="2" align="center" nowrap>
				<cfset ts = "">
				<cfif modo NEQ "ALTA">
				  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts">
				  </cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modo EQ "CAMBIO"><cfoutput>#ts#</cfoutput></cfif>">
				<cfset request.pBotones.NoCambio = true>
			  	<cfinclude template="/sif/portlets/pBotones.cfm">
			  </td>
			</tr>
		  </table>
		</form>
		</cfoutput>
	</td>
  </tr>
</table> 

<script language="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.Oorigen.required = true;
	objForm.Oorigen.description = "Módulo Origen";
	objForm.CPOdesde.required = true;
	objForm.CPOdesde.description = "Desde";
	objForm.CPOhasta.required = false;
	objForm.CPOhasta.description = "Hasta";
</script>
