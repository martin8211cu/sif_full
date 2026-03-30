<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
			Consola de Administración de Procesos de Interfaz
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	<cfquery name="rsInterfaz" datasource="sifinterfaces">
		select Descripcion, TipoProcesamiento, ManejoDatos
		  from Interfaz
		 where NumeroInterfaz = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NI#">
	</cfquery>
	
	  <cf_web_portlet_start titulo="Consulta de Datos de Entrada y Salida por Procesos de Interfaz">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfinclude template="../parametros/motor.cfm">
			<cfif isdefined("LvarSoloConsultar")>
				<cfset LvarConsola = "consulta-procesos.cfm">
			<cfelse>
				<cfset LvarConsola = "consola-procesos.cfm">
			</cfif>
				
			<form action="<cfoutput>#LvarConsola#</cfoutput>" method="post" name="sql">
				<cfoutput><strong>ID PROCESO: #form.ID#</strong><BR></cfoutput>
				<cfoutput><strong>INTERFAZ: #form.NI# = #rsInterfaz.Descripcion#</strong><BR><BR></cfoutput>

				<cfset GvarTabular = false>
				<cfset GvarIndex = 0>

				<cftry>
					<cfquery name="rsSQL" datasource="sifinterfaces">
						select * from ERR#form.NI# where ID = #form.ID# and IDERR > 0
					</cfquery>
					<cfset LvarExisteERR = rsSQL.recordCount NEQ 0>
				<cfcatch type="database">
					<cfset LvarExisteERR = false>
				</cfcatch>
				</cftry>
				<cfif LvarExisteERR>
					<cfoutput><div style="text-align:left;"><strong>DETALLE DE ERRORES</strong><BR><BR></cfoutput>
					<cfset sbMostrar("ERR#form.NI#",rsSQL)>
					<cfoutput></div></cfoutput>
				</cfif>

				<cfif rsInterfaz.ManejoDatos EQ "T">
					<cftry>
						<cfquery name="rsSQL" datasource="sifinterfaces">
							select * from IE#form.NI# where ID = #form.ID#
						</cfquery>
						<cfoutput><div style="text-align:left;"><strong>DATOS DE ENTRADA</strong><BR><BR></div></cfoutput>
						<cfset sbMostrar("IE#form.NI#",rsSQL)>
	
						<cfquery name="rsSQL" datasource="sifinterfaces">
							select * from ID#form.NI# where ID = #form.ID#
						</cfquery>
						<cfset sbMostrar("ID#form.NI#",rsSQL)>

						<cfquery name="rsSQL" datasource="sifinterfaces">
							select * from IS#form.NI# where ID = #form.ID#
						</cfquery>
						<cfset sbMostrar("IS#form.NI#",rsSQL)>
					<cfcatch type="database">
					</cfcatch>
					</cftry>
				
					<cftry>
						<cfquery name="rsSQL" datasource="sifinterfaces">
							select * from OE#form.NI# where ID = #form.ID#
						</cfquery>
						<cfoutput><div style="text-align:left;"><strong>DATOS DE SALIDA</strong><BR><BR></div></cfoutput>
						<cfset sbMostrar("OE#form.NI#",rsSQL)>

						<cfquery name="rsSQL" datasource="sifinterfaces">
							select * from OD#form.NI# where ID = #form.ID#
						</cfquery>
						<cfset sbMostrar("OD#form.NI#",rsSQL)>

						<cfquery name="rsSQL" datasource="sifinterfaces">
							select * from OS#form.NI# where ID = #form.ID#
						</cfquery>
						<cfset sbMostrar("OS#form.NI#",rsSQL)>
					<cfcatch type="database">
					</cfcatch>
					</cftry>
				<cfelse>
					<cf_web_portlet_start titulo="DATOS DE ENTRADA">
						<cfquery name="rsSQL" datasource="sifinterfaces">
							select XML_E, XML_D, XML_S
							  from InterfazDatosXML
							 where CEcodigo			= #session.CEcodigo#
							   and NumeroInterfaz	= #form.NI#
							   and IdProceso		= #form.ID#
							   and TipoIO = 'I'
						</cfquery>
						<cfoutput>
							<div style="text-align:left;"><strong>XML_IE</strong></div>
							<cfif len(rsSQL.XML_E) EQ 0>
								<BR>
								<strong>******* No hay datos *******</strong>
							<cfelse>
								<textarea style="width:100%" rows="10" readonly="readonly">
#CharsetEncode(rsSQL.XML_E, "utf-8")#
								</textarea>
							</cfif>
							<BR><BR>

							<div style="text-align:left;"><strong>XML_ID</strong></div>
							<cfif len(rsSQL.XML_D) EQ 0>
								<BR>
								<strong>******* No hay datos *******</strong>
							<cfelse>
								<textarea style="width:100%" rows="10" readonly="readonly">
#CharsetEncode(rsSQL.XML_D, "utf-8")#
								</textarea>
							</cfif>
							<BR><BR>

							<div style="text-align:left;"><strong>XML_IS</strong></div>
							<cfif len(rsSQL.XML_S) EQ 0>
								<BR>
								<strong>******* No hay datos *******</strong>
							<cfelse>
								<textarea style="width:100%" rows="10" readonly="readonly">
#CharsetEncode(rsSQL.XML_S, "utf-8")#
								</textarea>
							</cfif>
							<BR><BR>
						</cfoutput>
					<cf_web_portlet_end>
					<BR>
					<cf_web_portlet_start titulo="DATOS DE SALIDA">
						<cfquery name="rsSQL" datasource="sifinterfaces">
							select XML_E, XML_D, XML_S
							  from InterfazDatosXML
							 where CEcodigo			= #session.CEcodigo#
							   and NumeroInterfaz	= #form.NI#
							   and IdProceso		= #form.ID#
							   and TipoIO = 'O'
						</cfquery>
						<cfoutput>
							<div style="text-align:left;"><strong>XML_OE</strong></div>
							<cfif len(rsSQL.XML_E) EQ 0>
								<BR>
								<strong>******* No hay datos *******</strong>
							<cfelse>
								<textarea style="width:100%" rows="10" readonly="readonly">
#CharsetEncode(rsSQL.XML_E, "utf-8")#
								</textarea>
							</cfif>
							<BR><BR>

							<div style="text-align:left;"><strong>XML_OD</strong></div>
							<cfif len(rsSQL.XML_D) EQ 0>
								<BR>
								<strong>******* No hay datos *******</strong>
							<cfelse>
								<textarea style="width:100%" rows="10" readonly="readonly">
#CharsetEncode(rsSQL.XML_D, "utf-8")#
								</textarea>
							</cfif>
							<BR><BR>

							<div style="text-align:left;"><strong>XML_OS</strong></div>
							<cfif len(rsSQL.XML_S) EQ 0>
								<BR>
								<strong>******* No hay datos *******</strong>
							<cfelse>
								<textarea style="width:100%" rows="10" readonly="readonly">
#CharsetEncode(rsSQL.XML_S, "utf-8")#
								</textarea>
							</cfif>
							<BR><BR>
						</cfoutput>
					<cf_web_portlet_end>
					<BR><BR>
				</cfif>
				<input type="hidden" name="id" value="#form.id#">
				<input type="hidden" name="ni" value="#form.ni#">
				<input type="hidden" name="sc" value="#form.sc#">
				<input type="hidden" name="msg" value="#form.msg#">
				<input type="hidden" name="cmd" value="V">
			<cfif GvarTabular>
					<span style="width:400px;">&nbsp;</span>
					<input type="submit" name="btnRegresar" value="Regresar">
			<cfelse>
				<div style="text-align:center;">
					<input type="submit" name="btnRegresar" value="Regresar">
				</div>
			</cfif>
				<BR><BR>
			</form>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>

<cffunction name="sbMostrar" output="true">
	<cfargument name="Tabla" type="string" required="yes">
	<cfargument name="rsSQL" type="query" required="yes">

	<cfset GvarIndex = GvarIndex + 1>
	<cf_web_portlet_start titulo="TABLA: #Arguments.Tabla#">
		<strong>#Tabla#</strong>
		<cfif rsSQL.recordCount eq 0>
			<cfset LvarVacio = true>
			<cfif rsInterfaz.TipoProcesamiento EQ "S">
				<cfset LvarVacio = false>
				<cftry>
					<cfset LvarTipoIO	= mid(Arguments.Tabla,1,1)>
					<cfset LvarNivel	= mid(Arguments.Tabla,2,1)>
					<cfquery name="rsXML" datasource="sifinterfaces">
						select XML_#LvarNivel# as XML
						  from InterfazDatosXML
						 where CEcodigo			= #session.CEcodigo#
						   and NumeroInterfaz	= #form.NI#
						   and IdProceso		= #form.ID#
						   and TipoIO 			= '#LvarTipoIO#'
					</cfquery>
					<cfif len(rsXML.XML) NEQ 0>
						<textarea style="width:100%" rows="10" readonly="readonly">
#CharsetEncode(rsXML.XML, "utf-8")#
						</textarea>
					<cfelse>
						<cfset LvarVacio = true>
					</cfif>
				<cfcatch type="any">
					<cfset LvarVacio = true>
				</cfcatch>
				</cftry>
			</cfif>
			<cfif LvarVacio>
				<table width="80%" align="left">
					<tr>
						<td align="center" colspan="2">
							<strong>******* La tabla está vacía *******</strong>
						</td>
					</tr>
				</table>
			</cfif>
		<cfelseif rsSQL.recordCount eq 1 and MID(Arguments.Tabla,1,3) neq "ERR">
			<cfset LvarCampos = rsSQL.getColumnnames()>
			<table width="90%" align="left">
			<cfloop query="rsSQL">
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
				<tr>
					<td colspan = "3">&nbsp;
						
					</td>
				</tr>
			</cfloop>
			</table>
		<cfelse>
			<cfset GvarTabular = true>
			<cfset LvarDesplegar = "">
			<cfset LvarFormatos	 = "">
			<cfset LvarAjustar	 = "">
			<cfset LvarAlign	 = "">
			<cfset LvarColumnNames = rsSQL.getColumnNames()>
			<cfset LvarCampos = arrayNew(1)>
			<cfloop index="i" from="1" to="#arrayLen(LvarColumnNames)#">
				<cfset LvarCampos[i] = ucase(trim(LvarColumnNames[i]))>
			</cfloop>
			<cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
				<cfif LvarCampos[i] NEQ "BMUSUCODIGO" AND LvarCampos[i] NEQ "TS_RVERSION" AND LvarCampos[i] NEQ "IDERR">
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

			
			<cfif Application.dsinfo.sifinterfaces.type EQ "sybase">
				<cfquery name="rsSQL" dbtype="query">
					select #LvarDesplegar#
					  from rsSQL
				</cfquery>
			</cfif>
			
			<TABLE><TR><td>
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" 		value="#rsSQL#"/>
				<cfinvokeargument name="usaAjax"	value="no"/>

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
				<cfinvokeargument name="width" 		value="800px"/>
			</cfinvoke>
			</td></TR></TABLE>
 		</cfif>
	<cf_web_portlet_end>
	<BR><BR/>
</cffunction>