<cf_templatecss>
<cfif isdefined("url.RHEid") and len(trim(url.RHEid)) and not isdefined("form.RHEid")>
	<cfset form.RHEid = url.RHEid>
</cfif>
<cfif isdefined("url.RHSAid") and len(trim(url.RHSAid)) and not isdefined("form.RHSAid")>
	<cfset form.RHSAid = url.RHSAid>
</cfif>
<!---- ////////////////////////// INSERCION DE CORTE ///////////////////----->
<cfif isdefined("form.btn_guardar")>	
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select RHCid, RHMPPid,RHTTid,RHPPid
		from RHSituacionActual
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">	
	</cfquery>
	<cfif rsDatos.RecordCount NEQ 0>
		<!---Validar que no exista ya la combinacion de Categoria (RHCid), Tabla Salarial (RHTTid), Puesto (RHMPPid)
			 en las fechas seleccionadas para el nuevo corte------>
		<cfquery name="rsValidaFechas" datasource="#session.DSN#">
			select count(1) as Registros
			from RHSituacionActual
			where (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhastaplaza)#"> between fdesdeplaza and fhastaplaza
                or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesdeplaza)#"> between fdesdeplaza and fhastaplaza)
                <cfif not isdefined('url.solicitudPlaza')>
                	and RHPPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHPPid#">
                </cfif>
                <cfif isdefined('url.RHSPid')>
                	and RHSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHSPid#">
                </cfif>
				<cfif len(trim(rsDatos.RHCid))>
					and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHCid#">
				</cfif>
				<cfif len(trim(rsDatos.RHTTid))>
					and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHTTid#">
				</cfif>
				<cfif len(trim(rsDatos.RHMPPid))>
					and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHMPPid#">
				</cfif>
			  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
	</cfif>
	<cfif isdefined("rsValidaFechas") and rsValidaFechas.RecordCount NEQ 0 and rsValidaFechas.Registros NEQ 0>
		<script type="text/javascript" language="javascript1.2">
			alert("Las fechas del corte se traslapan con otros registros ya existentes.");
			window.close();
		</script>
	<cfelse>
		<cfif isdefined("form.RHSAid") and len(trim(form.RHSAid))>
			<cftransaction>				
				<!----Inserta el encabezado----->
				<cfquery name="rsInserta" datasource="#session.DSN#">
					insert into RHSituacionActual(RHEid, 
												RHPPid, 
												Ecodigo, 
												RHTTid, 
												RHMPPid, 
												RHCid, 
												RHSPid, 
												fdesdeplaza, 
												fhastaplaza, 
												RHMPnegociado, 
												CFid, 
												RHSAocupada, 
												<!----RHMPestadoplaza, Inserta el Default 'A' (Activa)---->
												BMfecha, 
												BMUsucodigo
												)	
						select 	RHEid,
								RHPPid,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								RHTTid,
								RHMPPid,
								RHCid,
								RHSPid,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesdeplaza)#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhastaplaza)#">,
								RHMPnegociado,
								CFid,
								RHSAocupada,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						from RHSituacionActual		
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">	
					<cf_dbidentity1 datasource="#session.DSN#">															
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInserta">
				<cfif isdefined("rsInserta.identity") and len(trim(rsInserta.identity))>
					<!----Inserta el detalle---->				
					<cfquery name="rsDetalle" datasource="#session.DSN#">
						insert into RHCSituacionActual(RHSAid, 
													CSid, 
													Ecodigo, 
													Cantidad, 
													Monto,
													CFformato, 
													BMfecha, 
													BMUsucodigo)					
						select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInserta.identity#">,
								sta.CSid,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								sta.Cantidad,
								sta.Monto,
								sta.CFformato,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">								
						from RHCSituacionActual sta
						where  sta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and sta.RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSAid#">		
					</cfquery>
				</cfif>	
			</cftransaction>
		</cfif>
	</cfif>	
	<script type="text/javascript" language="javascript1.2">
		window.close();
	</script>	
</cfif>

<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->	
</script>	

<cfoutput>
<form name="form1" action="" method="post">	
    <input type="hidden" name="RHSAid" value="<cfif isdefined("form.RHSAid") and len(trim(form.RHSAid))>#form.RHSAid#</cfif>">
	<table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="5%" align="center"><strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Agregar Corte</strong></td>
		</tr>
		<tr>
			<td colspan="5" align="center">
				<table width="95%" align="center">
					<tr><td><hr /></td></tr>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
      	<tr><td>&nbsp;</td></tr>
      	<tr>
			<td width="1%">&nbsp;</td>
			<td align="right" nowrap="nowrap" width="26%"><strong>Fecha Incial:&nbsp;</strong></td>
			<td width="26%"><cf_sifcalendario conexion="#session.DSN#" form="form1" name="fdesdeplaza"></td>
			<td align="right" nowrap="nowrap" width="11%"><strong>Fecha Final:&nbsp;</strong></td>
		  <td width="36%"><cf_sifcalendario conexion="#session.DSN#" form="form1" name="fhastaplaza"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
      	<tr>
        	<td colspan="5" align="center">
				<table cellpadding="0" cellspacing="0">
          			<tr>
              			<td><input type="submit" name="btn_guardar" value="Guardar" /></td>
            			<td width="5%">&nbsp;</td>
						<td><input type="button" name="btn_cerrar" value="Cerrar" onclick="javascript: window.close();" /></td>
          			</tr>
        		</table>
			</td>
      	</tr>
    </table>
</form>
</cfoutput>
<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.fdesdeplaza.description="Fecha final";				
	objForm.fhastaplaza.description="Fecha inicial";	

	objForm.fdesdeplaza.required = true;
	objForm.fhastaplaza.required = true;	
</script>
