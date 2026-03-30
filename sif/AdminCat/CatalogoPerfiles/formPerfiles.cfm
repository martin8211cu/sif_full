<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

	<cfif isdefined("url.ADSPid") and Len(Trim(url.ADSPid))>
        <cfparam name="Form.ADSPid" default="#url.ADSPid#">
    </cfif>
    <cfif isdefined("form.ADSPid") and Len(Trim(form.ADSPid))>
        <cfparam name="Form.ADSPid" default="#form.ADSPid#">
    </cfif>

    <cfif isdefined("url.ADSPcodigo") and Len(Trim(url.ADSPcodigo))>
        <cfparam name="Form.ADSPcodigo" default="#url.ADSPcodigo#">
    </cfif>

    <cfif isdefined("form.ADSPcodigo") and Len(Trim(form.ADSPcodigo))>
        <cfparam name="Form.ADSPcodigo" default="#form.ADSPcodigo#">
    </cfif>

    <cfif isdefined("url.ADSPdescripcion") and Len(Trim(url.ADSPdescripcion))>
        <cfparam name="Form.ADSPdescripcion" default="#url.ADSPdescripcion#">
    </cfif>

    <cfif isdefined("form.ADSPdescripcion") and Len(Trim(form.ADSPdescripcion))>
        <cfparam name="Form.ADSPdescripcion" default="#form.ADSPdescripcion#">
    </cfif>


    <cfif isdefined("Form.Cambio")>
        <cfset modo="CAMBIO">
        <cfelse>
        <cfif not isdefined("Form.modo")>
            <cfset modo="ALTA">
            <cfelseif Form.modo EQ "CAMBIO">
            	<cfset modo="CAMBIO">
            <cfelse>
            	<cfset modo="ALTA">
        </cfif>
    </cfif>

    <cfif isdefined("url.ADSPid") and len(trim(url.ADSPid))>
        <cfset form.ADSPid = url.ADSPid>
        <cfset modo = "CAMBIO">
    </cfif>

    <cfquery name="rsTipoFormato" datasource="#Session.DSN#">
        select TFid, TFdescripcion,TFcfm
            from TFormatos
        Where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>

    <cfif modo neq "ALTA">
        <cfquery name="rsPerfiles" datasource="#Session.DSN#">
            select a.ADSPid, a.Ecodigo, a.ADSPcodigo, a.ADSPdescripcion
                from ADSEPerfil a
                where a.Ecodigo =
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and a.ADSPid =
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ADSPid#">
        </cfquery>
    </cfif>



<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<!--
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CODIGO"
			Default="C&oacute;digo"
			XmlFile="/sif/rh/generales.xml"
			returnvariable="LB_CODIGO"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_DESCRIPCION"
			Default="Descripci&oacute;n"
			returnvariable="LB_DESCRIPCION"/>
		</td>---->
		<td valign="top" width="60%">
			<form action="SQLPerfiles.cfm" method="post" name="form1">
                <table style="width:20%" cellpadding="0" cellspacing="0" border="0">
					<tr>
					  <cfoutput>
						<td width="23%" align="right" nowrap ><strong>#LB_CODIGO#:</strong>&nbsp;</td>
                        <td width="28%" align="left">
							<input name="ADSPcodigo" type="text" align="left" value="<cfif modo neq "ALTA">#rsPerfiles.ADSPcodigo#</cfif>" size="30" maxlength="30"<cfif modo neq 'ALTA'>disabled</cfif>>
						</td>
					 </tr>

                     <tr>
						<td class="fileLabel" align="right"><strong>#LB_DESCRIPCION#:&nbsp;</strong></td>
						<td>
							<input name="ADSPdescripcion" size="50" type="text" value="<cfif modo neq "ALTA">#rsPerfiles.ADSPdescripcion#</cfif>" maxlength="70">
                            <input type="hidden" name="ADSPid" value="<cfif modo neq "ALTA">#rsPerfiles.ADSPid#</cfif>">
						</td>
                     </tr>

                     <tr>
						<td colspan="5" align="center" nowrap>
							<cf_botones modo="#modo#">
						</td>
					  </tr>
    			</table>
   			</form>
 		</td>
		<cfif modo EQ "CAMBIO">
		<td rowspan="4" valign="top">
			<cfinclude template="formPerfilesModulos.cfm">
		</td>
		<cfelse>
		<td rowspan="4" valign="top">
			&nbsp;
		</td>
		</cfif>
	</tr>
	<tr>
		<td>&nbsp</td>
	</tr>
	<tr>
		<td>
        	<cfinclude template="PerfilesFiltro.cfm">
		</td>
	</tr>
	<tr>
		<td>
			<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
				tabla="ADSEPerfil"
				columnas="ADSPid,ADSPcodigo, ADSPdescripcion"
				desplegar="ADSPcodigo, ADSPdescripcion"
				etiquetas="Código, Descripción"
				formatos="S,S"
				filtro="Ecodigo=#session.Ecodigo# #filtro# order by ADSPcodigo"
				align="left,left,"
				checkboxes="N"
				keys="ADSPid"
				ira="Perfiles.cfm"
                      incluyeForm="true"
				navegacion="#navegacion#"
				PageIndex="10"
				>
			</cfinvoke>
		</td>
	</tr>
</table>
</cfoutput>

<script language="javascript1.2" type="text/javascript">

     qFormAPI.errorColor = "#FFFFCC";
     objForm = new qForm("form1");

     objForm.ADSPcodigo.description="Código";
     objForm.ADSPdescripcion.description="Descripción";

     function habilitarValidacion(){
         objForm.ADSPcodigo.required = true;
         objForm.ADSPdescripcion.required = true;
         objForm.allowsubmitonerror = false;
     }

     function deshabilitarValidacion(){
         objForm.ADSPcodigo.required = false;
         objForm.ADSPdescripcion.required = false;
         objForm.allowsubmitonerror = true;
     }


     //objForm.onValidate = validaPorcentaje;
     habilitarValidacion();

 </script>

