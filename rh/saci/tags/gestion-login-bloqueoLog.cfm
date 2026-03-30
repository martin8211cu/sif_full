<cfquery name="rsMotivo" datasource="#Attributes.Conexion#">
	select a.MBmotivo,a.MBdescripcion
	from ISBmotivoBloqueo a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.Ecodigo#">
	and a.MBmotivo not in(select x.MBmotivo from ISBbloqueoLogin x
						where x.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idlogin#">
						and x.BLQdesbloquear = 0)
	and a.MBconCompromiso = 1
	<cfif len(trim(Attributes.rol)) and Attributes.rol EQ "CLIENTE"><!---si es cliente solo permite hacer bloqueos por motivos validos para usuarios clientes--->
	and MBautogestion = 1
	</cfif>
	and a.Habilitado = 1
	and a.MBbloqueable = 1
</cfquery>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td style="text-align:justify">
			Bloquear o desbloquear el Login actual. 
		</td>
  	</tr>
  	
	<tr>
		<td align="center">
			<fieldset><legend>Agregar Bloqueo</legend>
				<cfif rsMotivo.RecordCount GT 0>
					<cf_web_portlet_start tipo="box">
						<table class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr>
								<td align="right" width="30%"><label><cf_traducir key="motivo">Motivo</cf_traducir></label></td>
								<td>
									<select name="MBmotivo#Attributes.sufijo#" tabindex="1">
										<cfloop query="rsMotivo">
										<option value="#rsMotivo.MBmotivo#">#rsMotivo.MBdescripcion#</option>	
										</cfloop>
									</select>
								</td>
							</tr>
						</table>
					<cf_web_portlet_end> 
					<table class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr>
							<td  align="center"colspan="2">
								<cf_botones names="Bloquear" values="Bloquear" tabindex="1">
							</td>
						</tr>
					</table>	
				<cfelse>
					<cf_web_portlet_start tipo="box">
						<table class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr>
								<td  align="center"colspan="2">---No hay motivos disponibles---</td>
							</tr>
						</table>
					<cf_web_portlet_end> 
				</cfif>
			</fieldset>
		</td>
	</tr>
	
	<tr>
		<td>
			<fieldset><legend>Lista de Bloqueos</legend>
				<cf_web_portlet_start tipo="box">
				<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr>
						<td>
							<cfinvoke 
							 component="sif.Componentes.pListas" 
							 method="pLista">
								<cfinvokeargument name="tabla" value="ISBbloqueoLogin a
																	inner join ISBmotivoBloqueo b 
																		on b.MBmotivo=a.MBmotivo
																		and b.Ecodigo=#Attributes.Ecodigo#
																		and b.Habilitado=1"/>
								<cfinvokeargument name="columnas" value="a.BLQid
																			,a.BLQdesde
																			,a.BLQdesbloquear
																			,a.MBmotivo
																			,b.MBdescripcion
																			,case b.MBdesbloqueable
																				when 1 then -1
																				when 0 then BLQid
																			end MBdesbloqueable "/> 
								<cfinvokeargument name="desplegar" value="MBdescripcion"/>
								<cfinvokeargument name="etiquetas" value="Motivo de Bloqueo"/>
								<cfinvokeargument name="filtro" value="a.LGnumero = #Attributes.idlogin# and a.BLQdesbloquear = 0"/>
								<cfinvokeargument name="align" value="left"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="conexion" value="#Attributes.conexion#"/>
								<cfinvokeargument name="keys" value="BLQid"/>
								<cfinvokeargument name="incluyeform" value="false"/>
								<cfinvokeargument name="formName" value="#Attributes.form#"/>
								<cfinvokeargument name="formatos" value="S"/>
								<cfinvokeargument name="mostrar_filtro" value="false"/>
								<cfinvokeargument name="filtrar_automatico" value="false"/>
								<cfinvokeargument name="filtrar_por" value=""/>
								<cfinvokeargument name="maxrows" value="15"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="EmptyListMsg" value="---No hay Motivos de Bloqueo---"/>
								<cfinvokeargument name="checkboxes" value="S"/>
								<cfinvokeargument name="showLink" value="false"/>
								<cfinvokeargument name="inactivecol" value="MBdesbloqueable"/>								
							</cfinvoke>	
							
						</td>
					</tr>
					<tr>
						<td>					
							<strong>Nota: </strong> A los bloqueos inhabilitados no se les permite el desbloqueo por pantalla.
						</td>
					</tr>						
				</table>
				<cf_web_portlet_end> 
				<cf_botones names="Desbloquear" values="Desbloquear">
			</fieldset>
		</td>
	</tr>
</table>
</cfoutput>