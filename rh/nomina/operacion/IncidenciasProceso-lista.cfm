<table width="90%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
			<cfquery name="rsLista" datasource="#Session.DSN#">								
				select 	x.Iid, 
						x.CIdescripcion, 
						x.Ifecha, 	
						x.Ivalor,
						x.Imonto,	
						x.NombreEmp,
						x.Icpespecial,
						x.proceso_aprobacion
					from(	
						select 	a.Iid, 
								b.CIdescripcion, 
								a.Ifecha, 
								case b.CItipo  	when 0 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' hora(s)' ) }
												when 1 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' día(s)' ) }
												else <cf_dbfunction name="to_char" args="Ivalor"> end as Ivalor,
								case b.CItipo  	when 3 then <cf_dbfunction name="to_char" args="Imonto"> 
								else '_'  end as Imonto,	
								{fn concat({fn concat({fn concat({ fn concat( c.DEnombre, ' ') }, c.DEapellido1)}, ' ')}, c.DEapellido2) }  as NombreEmp,
								case when a.Icpespecial = 0 
									then '<img src="/cfmx/rh/imagenes/unchecked.gif">'
									else '<img src="/cfmx/rh/imagenes/checked.gif">' 
								end as Icpespecial,
								
								case when a.Iestadoaprobacion is null then 'Sin tramite'
								else 'Tramitada' end as proceso_aprobacion 
								
							
						from  Incidencias a, CIncidentes b, DatosEmpleado c
						where #preservesinglequotes(filtro)#
							and not exists (select 1 
											from RCalculoNomina x, IncidenciasCalculo z
											where RCestado <> 0
											  and z.RCNid = x.RCNid
											  and z.Iid = a.Iid
											)
							
							<cfif rol EQ 2><!--- incidencias desde otros procesos e incidencias en proceso aprobadas--->
								and coalesce(a.Iestadoaprobacion,2) = 2
								and coalesce(a.Iingresadopor,2) in (#I_ingresadopor#)
								and coalesce(a.Iestado,1) = 1 <!--- --->
								
							<cfelseif listFindNocase('0,1',rol,',')>
								and a.Iestadoaprobacion in (<cfqueryparam value="#I_estadoAprobacion#" cfsqltype="cf_sql_integer" list="yes">)
								and a.Iingresadopor in (<cfqueryparam value="#I_ingresadopor#" cfsqltype="cf_sql_integer" list="yes">)
								and a.Iestado in (<cfqueryparam value="#I_estado#" cfsqltype="cf_sql_integer" list="yes">) 
								and a.Usucodigo = #session.Usucodigo#
								<cfif rol EQ 0>
									and a.DEid = #UserDEid#
								</cfif>
							</cfif>
							
						  <cfif menu EQ 'NOMINA'>
						  
							 UNION
							<!----Incidencias tipo calculo que se pueden mostrar por el bit CInomostrar en 0....---->	
							select 	a.Iid, 
									b.CIdescripcion, 
									a.Ifecha, 
									case b.CItipo  	when 0 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' hora(s)' ) }
													when 1 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' día(s)' ) }
													else <cf_dbfunction name="to_char" args="Ivalor"> end as Ivalor,
									case b.CItipo  	when 3 then <cf_dbfunction name="to_char" args="Imonto"> 
										else '_'  end as Imonto,	
									{fn concat({fn concat({fn concat({ fn concat( c.DEnombre, ' ') }, c.DEapellido1)}, ' ')}, c.DEapellido2) }  as NombreEmp,
									case when a.Icpespecial = 0 
										then '<img src="/cfmx/rh/imagenes/unchecked.gif">'
										else '<img src="/cfmx/rh/imagenes/checked.gif">' 
									end as Icpespecial,
									'Sin tramite' as proceso_aprobacion
								
							from  Incidencias a, CIncidentes b, DatosEmpleado c
							where a.CIid = b.CIid 
								and a.DEid = c.DEid
								and b.CItipo = 3
								and coalesce(b.CInomostrar,0) = 0
								#preservesinglequotes(filtro2)#
								and not exists (select 1 
												from RCalculoNomina x, IncidenciasCalculo z
												where RCestado <> 0
												  and z.RCNid = x.RCNid
												  and z.Iid = a.Iid
												)
								
							</cfif>
							) x
						order by x.Ifecha
				
			</cfquery>	
			
			<cfinvoke component="sif.Componentes.Translate"
			 method="Translate"
			 key="LB_NoSeEncontraronRegistros"
			 default="No se encontraron Registros "
			 returnvariable="LB_NoSeEncontraronRegistros"/> 
			 
			 <cfset botonesList='Eliminar'>
			 <cfif reqAprobacion and  reqAprobacionJefe and rol NEQ 2> <!---solo si requiere aprobacion del jefe y si no esta siendo consultado desde la pantalla de administración.--->
		  		<cfset botonesList='Eliminar,EnviarAprobar'>
			</cfif>

			<form name="lista" method="get" action="IncidenciasProceso.cfm">
				
				<cfif rol EQ 2 and reqAprobacion> 
					<cfset desplegar = "Ifecha, CIdescripcion, NombreEmp, Ivalor,Imonto,Icpespecial,proceso_aprobacion">
					<cfset etiquetas = "#vFecha#, #vConcepto#, #vEmpleado#, #vCantidadMonto#,#vMontoCalculado#, #vIcpespecial#,Tipo">
					<cfset formatos = "D,V,V,V,V,V,S">
					<cfset align = "center, left, left, right,right, center,left">
				<cfelse>
					<cfset desplegar = "Ifecha, CIdescripcion, NombreEmp, Ivalor,Imonto,Icpespecial">
					<cfset etiquetas = "#vFecha#, #vConcepto#, #vEmpleado#, #vCantidadMonto#,#vMontoCalculado#, #vIcpespecial#">
					<cfset formatos = "D,V,V,V,V,V">
					<cfset align = "center, left, left, right,right, center">
				</cfif>
				
				<cfinvoke component="rh.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="#desplegar#"/>
					<cfinvokeargument name="etiquetas" value="#etiquetas#"/>
					<cfinvokeargument name="formatos" value="#formatos#"/>
					<cfinvokeargument name="align" value="#align#"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="IncidenciasProceso.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="EmptyListMsg" value="#LB_NoSeEncontraronRegistros#"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="maxRows" value="2"/>
					<cfif rsLista.recordcount gt 0 >
						<cfinvokeargument name="botones" value="#botonesList#"/>
					</cfif>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="checkall" value="S"/>
					<cfinvokeargument name="form_method" value="get"/>
					<cfinvokeargument name="incluyeform" value="false"/>
					<cfinvokeargument name="keys" value="Iid"/>	
								
				</cfinvoke>
				<cfoutput>
				<input type="hidden" name="Iingresadopor" value="#rol#" />
			  	<input type="hidden" name="Iestadoaprobacion" value="0" />
			  	<input type="hidden" name="usuCF" value="#session.Usucodigo#" />
			  	<input type="hidden" name="Ijustificacion" value="" />
				
				<!---filtros--->
				
				<cfif isdefined("url.DEid1")>
					<input type="hidden" name="DEid1" value="#url.DEid1#"  />
				</cfif>
				<cfif isdefined("url.usuario")>
					<input type="hidden" name="usuario" value="#url.usuario#"  />
				</cfif>
				<cfif isdefined("url.Ffecha")>
					<input type="hidden" name="Ffecha" value="#url.Ffecha#"  />
				</cfif>
				<cfif isdefined("url.CIid_f")>
					<input type="hidden" name="CIid_f" value="#url.CIid_f#"  />
				</cfif>
				<cfif isdefined("url.DEid")>

					<input type="hidden" name="DEid" value="#url.DEid#"  />
				</cfif>
				<cfif isdefined("url.FIcespecial_f")>
					<input type="hidden" name="FIcespecial_f" value="#url.FIcespecial_f#"  />
				</cfif>
				<cfif isdefined("url.CFid_f")>
					<input type="hidden" name="CFid_f" value="#url.CFid_f#"  />
				</cfif>
				<cfif isdefined("url.IfechaRebajo_f")>
					<input type="hidden" name="IfechaRebajo_f" value="#url.IfechaRebajo_f#"  />
				</cfif>
				</cfoutput>
			</form>
					
		</td>
	</tr>
</table>