<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Pais" 
Default="Pa&iacute;s"
returnvariable="LB_Pais"/>

<cfparam name="form.PageNum" default="1">

<cfset modocambio = false>

<cfif isdefined("form.ZEid") and len(trim(form.ZEid))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 	ZEid,
			CEcodigo,
			Ppais,
			ZEcodigo,
			ZEdescripcion,
			BMUsucodigo,
			ts_rversion,
			null as ts
		from ZonasEconomicas
		where ZEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ZEid#">
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts"/>
	<cfif rsForm.recordcount>
		<cfset modocambio = true>
	</cfif>
</cfif>
<!--- Consultas Generales --->
<cfquery name="rsPais" datasource="#session.dsn#">
	select Ppais, Pnombre from Pais order by Pnombre
</cfquery>
<cfoutput>
<form action="ZonaEco-SQL.cfm" method="post" name="form1">
	
	<input type="hidden" name="PageNum" value="#form.PageNum#">

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td><strong>#LB_Pais#&nbsp;:&nbsp;</strong></td>
		<td><select name="Ppais"><cfloop query="rsPais"><option value="#Ppais#" <cfif isdefined("rsform.ZEid") and rsform.Ppais eq rsPais.Ppais>selected</cfif>>#Pnombre#</option></cfloop></select></td>
	</tr><tr>
		<td><strong>#LB_CODIGO#&nbsp;:&nbsp;</strong></td>
		<td><input name="ZEcodigo" type="text" value="<cfif isdefined("rsform.ZEcodigo")>#rsform.ZEcodigo#</cfif>" maxlength="5"></td>
	</tr><tr>
		<td><strong>#LB_DESCRIPCION#&nbsp;:&nbsp;</strong></td>
		<td><input name="ZEdescripcion" type="text" value="<cfif isdefined("rsform.ZEdescripcion")>#rsform.ZEdescripcion#</cfif>" maxlength="40"></td>
	</tr>
	</table>
	<input type="hidden" name="ZEid" value="<cfif isdefined("rsform.ZEid")>#rsform.ZEid#</cfif>">
	<input type="hidden" name="ts" value="<cfif isdefined("ts")>#ts#</cfif>">
	<br>
	<cf_botones modocambio = "#modocambio#" genero = "F" nameEnc = "Zona">
	<br>
</form>

<cfif (modocambio)>
	<cfinclude template="ZonaEco-MINIMO.cfm">
</cfif>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_Pais"
Default="País"
returnvariable="MSG_Pais"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_Codigo"
Default="Código"
returnvariable="MSG_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_Descripcion"
Default="Descripción"
returnvariable="MSG_Descripcion"/>



	<cf_qforms form="form1" objForm="objForm1">
	<script language="javascript" type="text/javascript">
	
        <!--//
            objForm1.Ppais.description="<cfoutput>#MSG_Pais#</cfoutput>";
            objForm1.ZEcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";
            objForm1.ZEdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
			
			function habilitarValidacion(){
                if (window.norequerirMontoMinimo) norequerirMontoMinimo();
                objForm1.required("Ppais,ZEcodigo,ZEdescripcion");
            }	
            function deshabilitarValidacion(){
                if (window.norequerirMontoMinimo) norequerirMontoMinimo();
                objForm1.required("Ppais,ZEcodigo,ZEdescripcion",false);
            }
        //-->
    </script>
    
            
</cfoutput>