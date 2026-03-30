<cfoutput>

<cfif rsform.TESOPid NEQ "">
	<table border="0" width="50%" align="center" summary="Tabla de entrada">
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td colspan="5">
				<cfset LvarEncabezadoOP = true>
				<cfset LvarCuentaDbOP = true>
				<cfinclude template="../detalleOPs.cfm">
				<BR>
                
                <cfinclude template="/sif/Utiles/sifConcat.cfm">
				<cfquery name="listaB" datasource="#session.DSN#">
					select 
							cfb.TESCFBfecha,
							cfb.TESCFDnumFormulario, 
							cfl.TESCFLUdescripcion, 
							cfe.TESCFEdescripcion, 
							Pnombre#_Cat# ' '#_Cat# Papellido1#_Cat#' '#_Cat#Papellido2 as custodio,
							cfb.TESCFBobservacion
					from TEScontrolFormulariosB cfb 
					 
					left outer join TESCFlugares cfl
					  on cfb.TESCFLUid = cfl.TESCFLUid
					
					left outer join TESCFestados cfe
					  on cfb.TESCFEid = cfe.TESCFEid
					
					left outer join Usuario u
					  on cfb.UsucodigoCustodio = u.Usucodigo
					
					left outer join DatosPersonales dp
					  on u.datos_personales = dp.datos_personales
					  
					where cfb.TESCFDnumFormulario=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFDnumFormulario#">
					  <!--- and cfb.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	 --->
					  and cfb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
					  and cfb.TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TESMPcodigo#">
					order by TESCFBfecha desc
				</cfquery>
				<cf_web_portlet_start border="true" titulo="Bitácora del Cheque" skin="#Session.Preferences.Skin#">
					<table align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
						<tr>
							<td>
								<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
									query="#listaB#"
									desplegar="TESCFBfecha, TESCFLUdescripcion, TESCFEdescripcion, custodio, TESCFBobservacion"
									etiquetas=" Fecha de Movimiento, Custodiado en, Razón, Custodio, Observación"
									formatos="DT,S,S,S,S"
									align="center,left,left,left,Left"
									ajustar="N,N,N,N,S"
									form_method="post"
									showEmptyListMsg="yes"
									showLink = "no"
									incluyeForm = "no"
									pageindex="123"
								/>
							</td>
						</tr>
					</table>
	<cf_web_portlet_end>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</cfif>
</cfoutput>
