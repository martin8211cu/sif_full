<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
			Consola de Administración de Procesos de Interfaz
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
	  <cf_web_portlet titulo="Consulta de Datos de Entrada y Salida por Procesos de Interfaz">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfinclude template="parametros-motor.cfm">
			<cfif isdefined("LvarSoloConsultar")>
				<cfset LvarConsola = "consulta-procesos.cfm">
			<cfelse>
				<cfset LvarConsola = "consola-procesos.cfm">
			</cfif>
				
			<form action="<cfoutput>#LvarConsola#</cfoutput>" method="post" name="sql">
				<cfoutput><strong>ID PROCESO: #form.ID#</strong><BR><BR></cfoutput>

				<cfset GvarIndex = 0>

				<cfoutput><div style="text-align:center;"><strong>DATOS DE ENTRADA</strong><BR><BR></div></cfoutput>
				<cftry>
				<cfcatch type="any">
					<cfquery name="rsSQL" datasource="sifinterfaces">
						select * from IE#form.NI# where ID = #form.ID#
					</cfquery>
					<cfset sbMostrar("IE#form.NI#",rsSQL)>
				</cfcatch>
				</cftry>
				
				<cftry>
					<cfquery name="rsSQL" datasource="sifinterfaces">
						select * from ID#form.NI# where ID = #form.ID#
					</cfquery>
					<cfset sbMostrar("ID#form.NI#",rsSQL)>
				<cfcatch type="any">
				</cfcatch>
				</cftry>
				
				<cfoutput><div style="text-align:center;"><strong>DATOS DE SALIDA</strong><BR><BR></div></cfoutput>
				<cftry>
					<cfquery name="rsSQL" datasource="sifinterfaces">
						select * from OE#form.NI# where ID = #form.ID#
					</cfquery>
					<cfset sbMostrar("OE#form.NI#",rsSQL)>
				<cfcatch type="any">
				</cfcatch>
				</cftry>
				
				<cftry>
					<cfquery name="rsSQL" datasource="sifinterfaces">
						select * from OD#form.NI# where ID = #form.ID#
					</cfquery>
					<cfset sbMostrar("OD#form.NI#",rsSQL)>
				<cfcatch type="any">
				</cfcatch>
				</cftry>
				
				<input type="hidden" name="id" value="#form.id#">
				<input type="hidden" name="ni" value="#form.ni#">
				<input type="hidden" name="sc" value="#form.sc#">
				<input type="hidden" name="msg" value="#form.msg#">
				<input type="hidden" name="cmd" value="V">
				<div style="text-align:center;">
					<input type="submit" name="btnRegresar" value="Regresar">
				</div>
			</form>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>

<cffunction name="sbMostrar" output="true">
	<cfargument name="Tabla" type="string" required="yes">
	<cfargument name="rsSQL" type="query" required="yes">

	<cfset GvarIndex = GvarIndex + 1>
	<cf_web_portlet titulo="TABLA: #Arguments.Tabla#" width="95%">
		<cfif rsSQL.recordCount eq 0>
			<table width="80%" align="center">
				<tr>
					<td align="center" colspan="2">
						<strong>******* La tabla está vacía *******</strong>
					</td>
				</tr>
			</table>
		<cfelseif rsSQL.recordCount eq 1>
			<table width="90%" align="center">
			<cfset LvarCampos = rsSQL.getColumnnames()>
			<cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
				<cfif LvarCampos[i] NEQ "BMUSUCODIGO" AND LvarCampos[i] NEQ "TS_RVERSION">
					<tr>
						<td width="1%" align="right">
							<strong><cfoutput>#LvarCampos[i]#:</cfoutput></strong>
						</td>
						<td >
							<cfoutput>#evaluate("rsSQL.#LvarCampos[i]#")#</cfoutput>
						</td>
						<td >&nbsp;
							
						</td>
					</tr>
				</cfif>
			</cfloop>
			</table>
		<cfelse>
			<cfset LvarDesplegar = "">
			<cfset LvarFormatos	 = "">
			<cfset LvarAjustar	 = "">
			<cfset LvarAlign	 = "">
			<cfset LvarCampos = rsSQL.getColumnnames()>
			<cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
				<cfif LvarCampos[i] NEQ "BMUSUCODIGO" AND LvarCampos[i] NEQ "TS_RVERSION">
					<cfif LvarDesplegar NEQ "">
						<cfset LvarDesplegar = LvarDesplegar 	& ",">
						<cfset LvarFormatos	 = LvarFormatos		& ",">
						<cfset LvarAjustar	 = LvarAjustar 		& ",">
						<cfset LvarAlign	 = LvarAlign 		& ",">
					</cfif>

					<cfset LvarDesplegar = LvarDesplegar 	& LvarCampos[i]>
					<cfset LvarFormatos	 = LvarFormatos		& "S">
					<cfset LvarAjustar	 = LvarAjustar 		& "S">
					<cfset LvarAlign	 = LvarAlign 		& "left">
				</cfif>
			</cfloop>

			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" 		value="#rsSQL#"/>
				<cfinvokeargument name="desplegar" 	value="#LvarDesplegar#"/>
				<cfinvokeargument name="etiquetas" 	value="#LvarDesplegar#"/>
				<cfinvokeargument name="formatos" 	value="#LvarFormatos#"/>
				<cfinvokeargument name="ajustar" 	value="#LvarAjustar#"/>
				<cfinvokeargument name="align" 		value="#LvarAlign#"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="navegacion" value="id=#form.id#&ni=#form.ni#&cmd=V"/>
				<cfinvokeargument name="MaxRows" 	value="10"/>
				<cfinvokeargument name="formName" 	value="frmConsola"/>
				<cfinvokeargument name="PageIndex" 	value="#GvarIndex#"/>
				<cfinvokeargument name="showLink" 	value="false"/>
				<cfinvokeargument name="debug" 		value="N"/>
			</cfinvoke>
		</cfif>
		</cf_web_portlet>
		<BR>
</cffunction>