<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Filtrar" default = "Filtrar" returnvariable="BTN_Filtrar" xmlfile = "RepReintegro_filtro.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NumTransaccion" default = "N&uacute;m. Transacci&oacute;n" returnvariable="LB_NumTransaccion" xmlfile = "RepReintegro_filtro.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default = "Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile = "RepReintegro_filtro.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CajaChica" default = "Caja Chica" returnvariable="LB_CajaChica" xmlfile = "RepReintegro_filtro.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile = "RepReintegro_filtro.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Monto" default = "Monto" returnvariable="LB_Monto" xmlfile = "RepReintegro_filtro.xml">


<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfparam name="form.CCHid" default="">
<cfif isdefined ("url.CCHid") and len(trim(url.CCHid))>
	<cfset form.CCHid= #url.CCHid#>
</cfif>

<cfquery  name="rsCajaChica" datasource="#session.dsn#">
	select 
			CCHid,
			CCHdescripcion,
			CCHcodigo
	from CCHica
	where Ecodigo=#session.Ecodigo#
	and CCHestado='ACTIVA'
</cfquery>

<cfparam name="rsCustodio.DEid" default="">
<cfif GvarPorResponsable>
    <cfquery name="rsCustodio" datasource="#session.dsn#">
        select llave as DEid
          from UsuarioReferencia
         where Usucodigo= #session.Usucodigo#
           and Ecodigo	= #session.EcodigoSDC#
           and STabla	= 'DatosEmpleado'
    </cfquery>
    <cfif rsCustodio.DEid EQ "">
        <cfthrow message="El Usuario '#session.usulogin#' no está registrado como Empleado">
    </cfif>
</cfif>


<table width="100%" border="0" cellspacing="6">
	<tr>
		<td width="50%" valign="top">
        <cfoutput>
		<form name="form1" method="post" action="RepReintegros#LvarCFM#.cfm" style="margin: '0' ">
			<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td nowrap align="right"><strong><cf_translate key = LB_Fecha xmlfile = "RepReintegro_filtro.xml">Fecha</cf_translate>:</strong></td>
					<td colspan="2">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td nowrap valign="middle">
									<cfif isdefined ('form.TESSPfechaPago_I')>
										<cf_sifcalendario form="form1" value="#form.TESSPfechaPago_I#" name="TESSPfechaPago_I" tabindex="1">											  					  	
									<cfelse>
										<cf_sifcalendario form="form1" value="" name="TESSPfechaPago_I" tabindex="1">
									</cfif>
								</td>
								<td nowrap align="right" valign="middle">
									<strong>&nbsp;<cf_translate key = LB_Hasta xmlfile = "RepReintegro_filtro.xml">Hasta</cf_translate>:</strong>
								</td>
								<td nowrap valign="middle">
									<cfif isdefined ('form.TESSPfechaPago_F')>
										<cf_sifcalendario form="form1" value="#form.TESSPfechaPago_F#" name="TESSPfechaPago_F" tabindex="1">									 						
									<cfelse>
										<cf_sifcalendario form="form1" value="" name="TESSPfechaPago_F" tabindex="1">
									</cfif>
								</td>						
							</tr>
						</table>
					</td>
				</tr>		
				<tr>
					<td nowrap align="right"><strong><cfoutput><cf_translate key = LB_NumTransaccion xmlfile = "RepReintegro_filtro.xml">Num.Transaccion</cf_translate>:</cfoutput></strong></td>
					<td nowrap>
						<input type="text" name="numTran" />
					</td>							
				<tr>
					<td align="right">
						<strong><cf_translate key = LB_Caja xmlfile = "RepReintegro_filtro.xml">Caja</cf_translate>:</strong>
					</td>
					<td>
						<cf_conlisCajas value="#form.CCHid#" Responsable=#rsCustodio.DEid#>
					</td>
				</tr>
				<tr>
					<td colspan="8" align="center">
							 <input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#" tabindex="2" />				   
					</td>
				</tr>
			</table>
			</form>
            </cfoutput>
	<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0 or isdefined ('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F)) gt 0 or isdefined ('form.TESSPfechaPago_I') and len(trim(TESSPfechaPago_I)) gt 0 or isdefined ('form.numTran') and len(trim(form.numTran))>
			<cfquery name="rsReintegro" datasource="#session.dsn#">
					select a.CCHcod,CCHTid,
							 a.CCHTdescripcion,
							 a.CCHTmonto,
							 a.BMfecha,
							 (select CCHdescripcion from CCHica where CCHid=a.CCHid) as transac
				from CCHTransaccionesProceso a
				where Ecodigo=#session.Ecodigo#
				and CCHTtipo ='REINTEGRO'
					<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0>
						and a.CCHid=#form.CCHid#
					</cfif>
					<cfif isdefined ('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F)) gt 0>
						and a.BMfecha <=#LSParseDateTime(form.TESSPfechaPago_F)#
					</cfif>
					<cfif isdefined ('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I)) gt 0>
						and a.BMfecha >=#LSParseDateTime(form.TESSPfechaPago_I)#
					</cfif>
					<cfif isdefined ('form.numTran') and len(trim(form.numTran)) gt 0>
						and CCHcod =#form.numTran#
					</cfif>
			</cfquery>
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#rsReintegro#"
		Cortes=""
		desplegar="CCHcod,CCHTdescripcion,transac,BMfecha,CCHTmonto"
		etiquetas="#LB_NumTransaccion#, #LB_Descripcion#, #LB_CajaChica#, #LB_Fecha#, #LB_Monto#"
		formatos="S,S,S,D,M"
		align="left,left,left,left,left"
		ira="RepReintegros#LvarCFM#.cfm"
		form_method="post"
		showEmptyListMsg="yes"
		keys="CCHTid"	
		MaxRows="18"
		navegacion="CCHid=#form.CCHid#"
		filtro_nuevo="#isdefined("form.btnFiltrar")#"
	/>		

	</cfif>
