<cfinvoke key="LB_Antes_de_borrar_el_tipo_de_accion_debe_eliminar_los_permisos" default="Antes de borrar el tipo de acci&oacute;n debe eliminar los permisos. " returnvariable="LB_ErrorTipoAccSP" component="sif.Componentes.Translate" method="Translate"/>	

<cfparam name="action" default="TipoAccionSP.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
			<!--- Caso 1: Agregar Tipo de Accion --->
			<cfif isdefined("form.Alta")>
				<cfquery name="Insert" datasource="#session.DSN#">
					insert into RHTipoAccion ( 
						Ecodigo, 	
						RHTcodigo, 
						RHTdesc, 	
						RHTpaga, 
						RHTpfijo, 	
						RHTpmax, 
						RHTcomportam, 
						RHTposterior, 
						RHTautogestion, 
						RHTindefinido, 
						RHTcempresa, 
						RHTctiponomina, 
						RHTcregimenv, 
						RHTcoficina, 
						RHTcdepto,
						RHTcplaza, 
						RHTcpuesto, 
						RHTccomp, 
						RHTcsalariofijo,
						RHTcjornada,
						RHTvisible,
						RHTidtramite,
						RHTnorenta,
						RHTnocargas, 
						RHTnodeducciones, 
						RHTcuentac,
						CIncidente1,
						CIncidente2, 
						RHTnoretroactiva,
						RHTcantdiascont, 
						RHTccatpaso, 
						RHTliquidatotal, 
						RHTnocargasley,
						RHTdatoinforme, 
						RHTpension, 
						RHTnoveriplaza, 
						RHTalerta, 
						RHTdiasalerta,
						RHTtiponomb,
						RHTafectafantig,
						RHTafectafvac,
						RHTespecial,
						BMUsucodigo)
						values ( 
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#form.RHTcodigo#"  cfsqltype="cf_sql_char">,
						<cfqueryparam value="#form.RHTdesc#"    cfsqltype="cf_sql_varchar">,
						0,
						0,
						0,
						<cfqueryparam value="#form.RHTcomportam#" cfsqltype="cf_sql_integer">,
						0,
						<cfif isdefined("form.RHTautogestion")>1<cfelse>0</cfif>,
						0,
						0,
						0,
						0,
						0,
						0,
						0,
						0,
						0,
						0,
						0,
						<cfif isdefined("form.RHTvisible")>1<cfelse>0</cfif>,
						<cfif isdefined("form.RHTidtramite") and form.RHTidtramite NEQ 'N'>
							<cfqueryparam value="#form.RHTidtramite#" cfsqltype="cf_sql_numeric">		
						<cfelse>
							null	
						</cfif>,	
						0,
						0,
						0,
						null,
						null,	
						null,	
						0,
						0,
						0,
						0,
						0,
						null,	
						0,
						0,
						0,
						null,	
						null,	
						null,	
						null,	
						1,
						<cfif isdefined("session.usucodigo")><!---se agrega para conocer el usuario que creo el tipo de accion--->
							<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
					 	<cfelse>null</cfif>	
						)
				</cfquery>  

			<!--- Caso 2: Modificar Tipo de Accion --->	
			<cfelseif isdefined("form.Cambio")>
				<cfquery name="Update" datasource="#session.DSN#">
					update RHTipoAccion
					set RHTcodigo 		= <cfqueryparam value="#form.RHTcodigo#"  cfsqltype="cf_sql_char">, 
						RHTdesc 		= <cfqueryparam value="#form.RHTdesc#"    cfsqltype="cf_sql_varchar">, 
						RHTautogestion  = <cfif isdefined("form.RHTautogestion")>1<cfelse>0</cfif>,
						RHTvisible      = <cfif isdefined("form.RHTvisible")>1<cfelse>0</cfif>,
						RHTccatpaso     = <cfif isdefined("form.RHTccatpaso")>1<cfelse>0</cfif>
						<cfif isdefined("form.RHTidtramite") and form.RHTidtramite NEQ 'N'>
							,RHTidtramite = <cfqueryparam value="#form.RHTidtramite#" cfsqltype="cf_sql_numeric">		
						<cfelse>
							,RHTidtramite = NULL
						</cfif>
						,RHTcuentac      = null
						,BMUsucodigo=<cfif isdefined("session.usucodigo")><!---se agrega para conocer el usuario que creo el tipo de accion--->
										<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
									  <cfelse>null</cfif>	
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHTid = <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric">
				</cfquery>	  
				  <cfset modo = 'CAMBIO'>

			<!--- Caso 3: Eliminar Tipo de Accion --->
			<cfelseif isdefined("form.Baja")>
				<cftry>
					<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="RHTipoAccion">		
						<cfinvokeargument name="condicion" value="Ecodigo=#session.Ecodigo# and RHTid = #form.RHTid#">
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="necesitaTransaccion" value="false">
					</cfinvoke>
						
					<cfquery name="Delete2" datasource="#session.DSN#">
						delete from RHTipoAccion
						where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and RHTid =  <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric">
					 </cfquery> 
				 	<cfcatch type="any">
						<cf_throw message="#LB_ErrorTipoAccSP#" errorcode="132">
					</cfcatch>
					
				</cftry>
			</cfif>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="RHTid" type="hidden" value="#form.RHTid#"></cfif>
	
	<cfif not isdefined("form.Nuevo")>
		<input name="pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
		<input name="pagenum" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#<cfelse>0</cfif>">
	<cfelse>
		<input type="hidden" name="nuevo" value="nuevo">
	</cfif>

</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>