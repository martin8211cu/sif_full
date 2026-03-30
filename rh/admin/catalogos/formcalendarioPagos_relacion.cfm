<!--- Definición del Modo --->
<cfset modo ="CAMBIO">

<!--- Consultas --->
<cfquery name="rsTipoNomina" datasource="#Session.DSN#">
	select 
		Tcodigo,
		Tdescripcion,
		Ttipopago as CodTipoPago,
		case
			when Ttipopago=0 then 'Semanal'
			when Ttipopago=1 then 'Bisemanal'
			when Ttipopago=2 then 'Quincenal'
			when Ttipopago=3 then 'Mensual'
		end Ttipopago
	from TiposNomina
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Tcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
</cfquery>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsCalenPago" datasource="#Session.DSN#">
		select 	CPid,
				CPdesde,
				CPhasta,
				CPfpago,
				rtrim(CPcodigo) as CPcodigo,
				CPperiodo,
				CPdescripcion,
				CPtipo,
				CPmes,
				CPnorenta,
				CPnocargasley,
				CPnocargas
		from CalendarioPagos
		where CPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	</cfquery>
	
	<!--- Conceptos de Pago --->
	<cfquery name="rsConceptos" datasource="#Session.DSN#">
		select a.CPid, b.CIid, c.CIcodigo, c.CIdescripcion
		from CalendarioPagos a, CCalendario b, CIncidentes c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
		  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">
		  and a.CPid = b.CPid
		  and b.CIid = c.CIid																									
	</cfquery>

	<!--- Tipos de Deducción --->
	<cfquery name="rsTiposDeduccion" datasource="#Session.DSN#">
		select a.CPid, b.TDid, c.TDdescripcion 
		from CalendarioPagos a, TDCalendario b, TDeduccion c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
		  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">
		  and a.CPid = b.CPid
		  and b.TDid = c.TDid																							
	</cfquery>											
												
</cfif>

<!-----
<cfquery name="rsNumCalenPago" datasource="#Session.DSN#">
	<cfif isdefined('rsTipoNomina') and rsTipoNomina.CodTipoPago EQ 2>	<!--- Quincenal ---->
		Select convert(varchar,dateAdd(dd,1,CPhasta),103) as PChasta--convert(varchar,CPhasta,103) as PChasta
	<cfelseif isdefined('rsTipoNomina') and (rsTipoNomina.CodTipoPago EQ 0 or rsTipoNomina.CodTipoPago EQ 1 or rsTipoNomina.CodTipoPago EQ 3)>	<!--- Mensual --->	
		Select convert(varchar,dateAdd(dd,1,CPhasta),103) as PChasta
	</cfif>	
	from CalendarioPagos
	where CPid = (select Max(CPid) 
				from CalendarioPagos 
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Tcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">	
			)
</cfquery>
---->

<cfquery name="rsCPcodigos" datasource="#Session.DSN#">
	select rtrim(CPcodigo) as CPcodigo from CalendarioPagos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Tcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
</cfquery>

<!---============= TRADUCCION ==================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Eliminar_elemento"
	Default="Eliminar elemento"
	returnvariable="LB_Eliminar_elemento"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_Tipos_de_Deducciones"
	Default="Lista de Tipos de Deducciones"
	returnvariable="LB_Lista_de_Tipos_de_Deducciones"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Debe_seleccionar_un_tipo_de_deduccion_para_excluir"
	Default="Debe seleccionar un tipo de deducción para excluir"
	returnvariable="LB_SeleccionExcluir"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desea_borrar_este_tipo_de_Deduccion_del_calendario"
	Default="Desea borrar este tipo de Deducción del calendario"
	returnvariable="LB_BorrarDeduccion"/>



<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="JavaScript1.2" type="text/javascript">
	//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<cf_templatecss>

<table width="100%" border="0" cellspacing="0" cellpadding="3">

<!--- ********************** --->
	<tr>
		<td align="center">
			<table border="0" cellpadding="0" cellspacing="0" width="95%">
	
				<tr>
					<td valign="top">
						
						<!--- Tipos de Deducción --->
						<cfquery name="rsTiposDeduccionEX" datasource="#Session.DSN#">
							select a.CPid, b.TDid, c.TDdescripcion 
							from CalendarioPagos a, RHExcluirDeduccion b, TDeduccion c
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
							  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
							  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">
							  and a.CPid = b.CPid
							  and b.TDid = c.TDid																							
						</cfquery>											
						
						<!--- Tipos de Deducciones para excluir --->
						<form name="formCalendarioPago" id="formCalendarioPago" method="post" action="SQLcalendarioPagos.cfm" enctype="multipart/form-data" >
							<input type="hidden" name="Tcodigo" id="Tcodigo" value="<cfif isdefined('form.Tcodigo')><cfoutput>#form.Tcodigo#</cfoutput></cfif>">
							<input type="hidden" name="CPid" id="CPid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsCalenPago.CPid#</cfoutput></cfif>">
							<input type="hidden" name="relacion" >
							<input type="hidden" name="btnBorrarDeduccionEx" value="" >
	
						<table width="100%" border="0" cellpadding="1" cellspacing="1">
								<tr>
									<td width="40%" valign="top">
										<!--- Lista --->
										<table border="0" width="100%" cellpadding="0" cellspacing="0">
											<tr><td class="tituloListas" colspan="2"><cf_translate key="LB_Deduccion">Deducci&oacute;n</cf_translate></td></tr>
											
											<cfif rsTiposDeduccionEx.RecordCount gt 0 >
												<cfoutput query="rsTiposDeduccionEx">
												<tr <cfif rsTiposDeduccionEx.CurrentRow MOD 2> class="listaPar"<cfelse>class="listaNon"</cfif>>
													<td valign="top"><a href="" onClick="return false;" title="#rsTiposDeduccionEx.TDdescripcion#"><cfif Len(Trim(rsTiposDeduccionEx.TDdescripcion)) LT 20>#rsTiposDeduccionEx.TDdescripcion#<cfelse>#Mid(rsTiposDeduccionEx.TDdescripcion,1,18)#...</cfif></a></td>
													<td valign="top">
														<input name="btnBorrarTipoDeduccionEx" type="image" alt="#LB_Eliminar_elemento#" 
														onClick="javascript: return BorrarTipoDeduccionEx(#TDid#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16">
													</td>
													
												</tr>
												</cfoutput>
											<cfelse>
												<tr><td nowrap align="center"><b>-<cf_translate key="LB_No_hay_registros">No hay registros</cf_translate>-</b></td></tr>
											</cfif>
											<input type="hidden" name="exTDid_" value="">
										</table>
										
									</td>
	
									<td align="center" nowrap valign="top">
										<table width="100%" cellpadding="1" cellspacing="0">
											<TR><TD align="center">
												<input type="text" name="exTDdescripcion" value="" id="exTDdescripcion" readonly size="50" maxlength="50" tabindex="-1">
												<a href="javascript: doConlisTipoDeduccionEx();" tabindex="-1" >
												<img src="/cfmx/rh/imagenes/Description.gif" width="18" height="14" border="0" alt="<cfoutput>#LB_Lista_de_Tipos_de_Deducciones#</cfoutput>"></a>
												<input type="hidden" name="exTDid" value="">
											</TD></TR>	
											<tr><td align="center" valign="top"><input type="submit" name="btnAgregarTipoDeduccionEx" value="<cfoutput>#BTN_Agregar#</cfoutput>" onClick="javascript: return validaTipoDeduccionEx();"></td></tr>									
										</table>
										</td>
										
								</tr>
								<tr>
								</tr>									
							</table>
						</form>
					</td>
				</tr>
			</table>	
		</td>
	</tr>			
</table>


<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisTipoDeduccion() {
		popUpWindow("/cfmx/rh/Utiles/ConlisTipoDeduccion.cfm?form=formCalendarioPago&id=TDid&desc=TDdescripcion",250,200,400,350);
	}
	
	function doConlisTipoDeduccionEx() {
		popUpWindow("/cfmx/rh/Utiles/ConlisTipoDeduccion.cfm?form=formCalendarioPago&id=exTDid&desc=exTDdescripcion",250,200,400,350);
	}

	function validaTipoDeduccionEx() {
		if (trim(document.formCalendarioPago.exTDdescripcion.value) == "") 
		{
			<cfoutput>alert('#LB_SeleccionExcluir#')</cfoutput>;
			return false;
		}
		return true;
	}

	function BorrarTipoDeduccionEx(id){
		if (<cfoutput>confirm("#LB_BorrarDeduccion#")</cfoutput>) {	
			var f = document.formCalendarioPago;
			f.btnBorrarDeduccionEx.value = "BORRAR";
			f.exTDid_.value = id;
			f.submit();
		}
		return false;
	}		

</script>