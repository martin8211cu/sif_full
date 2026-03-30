<cfif isdefined("Form.PRJTid") and Len(Trim(Form.PRJTid))>
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>

<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsProyectoTipo" datasource="#Session.DSN#">
		select PRJTid, PRJTdescripcion, ts_rversion
		from PRJTiposProyectos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and PRJTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJTid#">
	</cfquery>
</cfif>

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
		  <cfinvokeargument name="tabla" value="PRJTiposProyectos a"/>
		  <cfinvokeargument name="columnas" value="a.PRJTid, a.PRJTdescripcion"/>
		  <cfinvokeargument name="desplegar" value="PRJTdescripcion"/>
		  <cfinvokeargument name="etiquetas" value="Tipo de Proyecto"/>
		  <cfinvokeargument name="formatos" value="V"/>
		  <cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
		  										 order by a.PRJTdescripcion"/>
		  <cfinvokeargument name="align" value="left"/>
		  <cfinvokeargument name="ajustar" value="N"/>
		  <cfinvokeargument name="checkboxes" value="N"/>
		  <cfinvokeargument name="keys" value="PRJTid"/>
		  <cfinvokeargument name="irA" value="ProyectosTipo.cfm"/>
	  </cfinvoke>
	</td>
	<td valign="top" width="60%">
		<cfoutput>
		<form method="post" name="form1" action="ProyectosTipo-sql.cfm">
		  <cfif modo EQ "CAMBIO">
		  	<input type="hidden" name="PRJTid" value="#Form.PRJTid#">
		  </cfif>
		  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr>
              <td align="right" nowrap>Descripci&oacute;n:</td>
              <td><input name="PRJTdescripcion" type="text" id="PRJTdescripcion" size="40" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsProyectoTipo.PRJTdescripcion#</cfif>"></td>
		    </tr>
			<tr>
			  <td align="right" nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
		    </tr>
			<tr>
			  <td colspan="2" align="center" nowrap>
				<cfset ts = "">
				<cfif modo NEQ "ALTA">
				  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsProyectoTipo.ts_rversion#" returnvariable="ts">
				  </cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modo EQ "CAMBIO"><cfoutput>#ts#</cfoutput></cfif>">
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
	
	objForm.PRJTdescripcion.required = true;
	objForm.PRJTdescripcion.description = "Descripción";
	
</script>
