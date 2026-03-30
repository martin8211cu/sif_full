<!--- Se define el Modo --->
<cfif (not isDefined("Form.btnNuevo")) and (isDefined("Form.MODO")) and (Form.MODO eq "CAMBIO")>
	<cfset MODO = "CAMBIO">
<cfelse>
	<cfset MODO = "ALTA">
</cfif>

<!--- Consultas --->
<cfif MODO EQ "CAMBIO">
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select 	a.CRMEid, b.CRMEnombre as CRMEnombre1, b.CRMEapellido1 as CRMEapellido11, b.CRMEapellido2 as CRMEapellido21,
				a.CRMEidrel, c.CRMEnombre as CRMEnombre2, c.CRMEapellido1 as CRMEapellido12, c.CRMEapellido2 as CRMEapellido22,
				a.CRMEidres, d.CRMEnombre as CRMEnombre3, d.CRMEapellido1 as CRMEapellido13, d.CRMEapellido2 as CRMEapellido23,
				a.CRMTEVid, a.CRMEVid2, convert(varchar,a.CRMEVfecha,103) as CRMEVfecha, a.CRMEVdescripcion
		from 	CRMEventos a, CRMEntidad b, CRMEntidad c, CRMEntidad d
		where 	a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.CRMEVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRMEVid#">
			and a.CRMEid = b.CRMEid
			and a.CRMEidrel *= c.CRMEid
			and a.CRMEidres *= d.CRMEid
	</cfquery>
</cfif>
<cfquery name="rsTipoEvento" datasource="#Session.DSN#">
	select a.CRMTEVid, a.CRMTEVdescripcion
	from CRMTipoEvento a
	where 	a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<!--- JavaScript --->
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<!--- Se define el Form --->
<link href="../../css/crm.css" rel="stylesheet" type="text/css">

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">   
    <form action="Eventos.cfm" method="post" name="formFiltrar">
	  <input name="btnfiltrar" type="hidden" value="Filtrar">
	  <tr> 
      	
      <td nowrap colspan="6" class="messages" align="center"> 
        <div align="right"><a href="#" onClick="javascript: document.formFiltrar.submit();"><strong>Filtrar</strong></a></div></td></tr>
 	</form>
    <form action="Eventos-sql.cfm" method="post" name="form1">
      <cfif MODO EQ "CAMBIO">
        <input name="CRMEVid" type="hidden" value="<cfoutput>#Form.CRMEVid#</cfoutput>">
      </cfif>
      <tr> 
        <td nowrap class="messages">Entidad :&nbsp;</td>
        <td nowrap class="messages">
			<cfif MODO EQ "CAMBIO">
				<cfquery name="rsCRMEid" dbtype="query">select CRMEid as CRMEid, CRMEnombre1 as CRMEnombre, CRMEapellido11 as CRMEapellido1, CRMEapellido21 as CRMEapellido2 from rsForm</cfquery>
				<cf_crmEntidad CRMEid="CRMEid" CRMnombre="CRMEiddesc" query="#rsCRMEid#">
			<cfelse>
				<cf_crmEntidad CRMEid="CRMEid" CRMnombre="CRMEiddesc">
			</cfif>
		</td>
        <td nowrap class="messages">Entidad Relacionada :</td>
        <td nowrap class="messages">
			<cfif MODO EQ "CAMBIO">
				<cfquery name="rsCRMEidrel" dbtype="query">select CRMEidrel as CRMEid, CRMEnombre2 as CRMEnombre, CRMEapellido12 as CRMEapellido1, CRMEapellido22 as CRMEapellido2 from rsForm</cfquery>
				<cf_crmEntidad CRMEid="CRMEidrel" CRMnombre="CRMEidreldesc" query="#rsCRMEidrel#">
			<cfelse>
				<cf_crmEntidad CRMEid="CRMEidrel" CRMnombre="CRMEidreldesc">	
			</cfif>
		</td>
        <td nowrap class="messages">Entidad Responsable :</td>
        <td nowrap class="messages">
			<cfif MODO EQ "CAMBIO">
				<cfquery name="rsCRMEid" dbtype="query">select CRMEidres as CRMEid, CRMEnombre3 as CRMEnombre, CRMEapellido13 as CRMEapellido1, CRMEapellido23 as CRMEapellido2 from rsForm</cfquery>
				<cf_crmEntidad CRMEid="CRMEidres" CRMnombre="CRMEidresdesc" query="#rsCRMEid#">
			<cfelse>
				<cf_crmEntidad CRMEid="CRMEidres" CRMnombre="CRMEidresdesc">
			</cfif>
		</td>
      </tr>
	  <tr>
		<td nowrap class="messages">Tipo de Evento :</td>
        <td nowrap class="messages">
			<select name="CRMTEVid">
				<cfoutput query="rsTipoEvento">
					<option value="#CRMTEVid#" <cfif (MODO EQ "CAMBIO") and (CRMTEVid eq rsForm.CRMTEVid)>selected</cfif>>#CRMTEVdescripcion#</option>
				</cfoutput>
			</select>
		</td>
		<td nowrap class="messages">Fecha :</td>
        <td nowrap class="messages">
			<cfif MODO EQ "CAMBIO">
				<cf_sifcalendario name="CRMEVfecha" value="#rsForm.CRMEVfecha#">
			<cfelse>
				<cf_sifcalendario name="CRMEVfecha">
			</cfif>
		</td>
		<td nowrap class="messages">&nbsp;</td>
        <td nowrap class="messages">&nbsp;</td>
	  </tr>
	  <tr>
		<td nowrap class="messages" colspan="6">Descripción :</td>
	  </tr>
	  <tr>
		<td nowrap class="messages" colspan="6"><textarea name="CRMEVdescripcion" cols="120" rows="4"><cfif MODO EQ "CAMBIO"><cfoutput>#rsForm.CRMEVdescripcion#</cfoutput></cfif></textarea></td>
	  </tr>
      <tr> 
        <td nowrap colspan="6" class="messages" align="center">&nbsp; </td>
      </tr>
      <tr> 
        <td nowrap colspan="6" class="messages" align="center"><cfinclude template="../../portlets/pBotones.cfm"></td>
      </tr>
    </form>
</table>

<!--- Se definen las validaciones por Qforms--->
<script language="JavaScript" type="text/javascript">
	//Validaciones del Encabezado Registro de Nomina.
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	//Especificación de las validaciones.
	objForm.CRMEid.required = true;
	objForm.CRMEid.description = "Entidad";
	//objForm.CRMEidrel.required = true;
	//objForm.CRMEidrel.description = "Entidad Relacionada";
	//objForm.CRMEidres.required = true;
	//objForm.CRMEidres.description = "Entidad Responsable";
	objForm.CRMTEVid.required = true;
	objForm.CRMTEVid.description = "Tipo de Evento";
	objForm.CRMEVfecha.required = true;
	objForm.CRMEVfecha.description = "Fecha";
</script>